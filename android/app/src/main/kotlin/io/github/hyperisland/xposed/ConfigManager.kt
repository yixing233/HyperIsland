package io.github.hyperisland.xposed

import android.os.Build
import android.os.FileObserver
import de.robv.android.xposed.XposedBridge
import org.json.JSONObject
import java.io.File

/**
 * 基于 JSON 文件的配置管理器。
 *
 * 架构：
 *   - App 进程（SettingsProvider）在每次 SharedPreferences 变更时，将全量配置序列化
 *     为 JSON 写入 [CONFIG_FILE]，并调用 setReadable(true, false) 使其世界可读。
 *   - Hook 进程（SystemUI / XMSF / 下载管理器）通过本管理器直接读取该 JSON 文件，
 *     用 [FileObserver] 监控父目录的 CLOSE_WRITE 事件实现热重载。
 *
 * 好处：
 *   - 不依赖 XSharedPreferences 的 IPC 机制（Zygisk 模式下模块后台不运行时 XSP 返回空）
 *   - 不依赖 ContentProvider（不需要 App 后台保活）
 *   - FileObserver 监控目录而非文件本身，文件不存在时也能感知到首次创建
 */
object ConfigManager {

    private const val PACKAGE_NAME   = "io.github.hyperisland"
    private const val CONFIG_FILE_NAME = "hyperisland_config.json"
    private const val FLUTTER_KEY_PREFIX = "flutter."

    /** Hook 进程侧使用的固定路径（/data/data/[pkg]/files/ 在 App 安装时由系统创建）。 */
    private val CONFIG_DIR  = File("/data/data/$PACKAGE_NAME/files")
    private val CONFIG_FILE = File(CONFIG_DIR, CONFIG_FILE_NAME)

    @Volatile private var config: Map<String, Any?> = emptyMap()
    @Volatile private var fileObserver: FileObserver? = null

    private val changeListeners = mutableListOf<() -> Unit>()

    /**
     * 初始化：读取现有配置文件并启动目录监控。幂等。
     * 应在目标进程的 Application.onCreate 阶段调用。
     */
    @Synchronized
    fun init() {
        if (fileObserver != null) return
        readConfig()
        startWatching()
    }

    /** 注册配置变化回调，文件每次更新后触发（调用方负责只注册一次）。 */
    @Synchronized
    fun addChangeListener(listener: () -> Unit) {
        changeListeners += listener
    }

    // ── 类型化读取 ──────────────────────────────────────────────────────────────

    fun getBoolean(key: String, default: Boolean): Boolean =
        when (val v = config[fk(key)]) {
            is Boolean -> v
            is Int     -> v != 0
            is Long    -> v != 0L
            else       -> default
        }

    fun getString(key: String, default: String = ""): String =
        (config[fk(key)] as? String) ?: default

    fun getInt(key: String, default: Int): Int =
        when (val v = config[fk(key)]) {
            is Int    -> v
            is Long   -> v.toInt()
            is Double -> v.toInt()
            else      -> default
        }

    fun contains(key: String): Boolean = config.containsKey(fk(key))

    // ── 内部实现 ────────────────────────────────────────────────────────────────

    private fun fk(key: String) = "$FLUTTER_KEY_PREFIX$key"

    private fun readConfig() {
        if (!CONFIG_FILE.exists()) {
            XposedBridge.log("HyperIsland[ConfigManager]: config file not found: ${CONFIG_FILE.absolutePath}")
            return
        }
        if (!CONFIG_FILE.canRead()) {
            XposedBridge.log("HyperIsland[ConfigManager]: config file not readable (permissions?): ${CONFIG_FILE.absolutePath}")
            return
        }
        try {
            val json = JSONObject(CONFIG_FILE.readText())
            val map = mutableMapOf<String, Any?>()
            for (key in json.keys()) {
                map[key] = json.get(key)
            }
            config = map
            XposedBridge.log("HyperIsland[ConfigManager]: loaded ${map.size} keys from ${CONFIG_FILE.absolutePath}")
        } catch (e: Exception) {
            XposedBridge.log("HyperIsland[ConfigManager]: parse error: ${e.message}")
        }
    }

    private fun reload() {
        readConfig()
        val ls = synchronized(this) { changeListeners.toList() }
        ls.forEach { runCatching { it() } }
        XposedBridge.log("HyperIsland[ConfigManager]: reloaded via FileObserver")
    }

    /**
     * 监控父目录的 CLOSE_WRITE 事件，过滤到 [CONFIG_FILE_NAME]。
     * 监控目录而非文件：即使 config 文件尚不存在（App 首次运行前），
     * 目录已存在，文件创建时同样能触发热重载。
     */
    private fun startWatching() {
        if (!CONFIG_DIR.exists()) {
            XposedBridge.log("HyperIsland[ConfigManager]: files dir not found: ${CONFIG_DIR.absolutePath}")
            return
        }
        val obs = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            object : FileObserver(CONFIG_DIR, CLOSE_WRITE) {
                override fun onEvent(event: Int, path: String?) {
                    if (path == CONFIG_FILE_NAME) reload()
                }
            }
        } else {
            @Suppress("DEPRECATION")
            object : FileObserver(CONFIG_DIR.absolutePath, CLOSE_WRITE) {
                override fun onEvent(event: Int, path: String?) {
                    if (path == CONFIG_FILE_NAME) reload()
                }
            }
        }
        obs.startWatching()
        fileObserver = obs
        XposedBridge.log("HyperIsland[ConfigManager]: watching ${CONFIG_DIR.absolutePath}/$CONFIG_FILE_NAME")
    }
}
