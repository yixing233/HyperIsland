package io.github.hyperisland.xposed

import android.content.SharedPreferences
import android.util.Log
import io.github.libxposed.api.XposedModule

/**
 * API 101 的 [XposedModule.log] 需要 (priority, tag, message) 三参数。
 * 此扩展函数提供单参简写，统一使用 DEBUG 级别和 "HyperIsland" 标签。
 */
fun XposedModule.log(message: String) =
    log(Log.DEBUG, "HyperIsland", message)

/**
 * 基于 XposedService.getRemotePreferences 的配置管理器（API 101 版本）。
 *
 * 架构：
 *   - Flutter 的 shared_preferences 插件将全量配置以 "flutter." 前缀写入模块 App 进程的
 *     FlutterSharedPreferences.xml。
 *   - Hook 进程（SystemUI / XMSF / 下载管理器）通过 XposedService.getRemotePreferences()
 *     跨进程读取该文件，并注册 OnSharedPreferenceChangeListener 实现热重载。
 *
 * 好处：
 *   - 直接使用 API 101 原生远程 Prefs，无需文件读写或 FileObserver
 *   - Prefs 变更时回调自动触发，无需 App 后台保活
 *   - 与 Flutter 端配置修改行为完全兼容
 */
object ConfigManager {

    private const val FLUTTER_KEY_PREFIX = "flutter."
    private const val PREFS_GROUP = "FlutterSharedPreferences"

    @Volatile private var prefs: SharedPreferences? = null
    @Volatile private var initialized = false

    private val changeListeners = mutableListOf<() -> Unit>()

    private val prefsListener = SharedPreferences.OnSharedPreferenceChangeListener { _, _ ->
        notifyListeners()
    }

    /**
     * 初始化：直接通过 [XposedModule.getRemotePreferences] 同步获取远程 SharedPreferences。
     * 幂等，多次调用只执行一次。
     */
    @Synchronized
    fun init(module: XposedModule) {
        if (initialized) return
        initialized = true

        val p = module.getRemotePreferences(PREFS_GROUP)
        p.registerOnSharedPreferenceChangeListener(prefsListener)
        prefs = p
        module.log("HyperIsland[ConfigManager]: remote prefs '$PREFS_GROUP' loaded")
        notifyListeners()
    }

    /** 注册配置变化回调，Prefs 每次变更后触发（调用方负责只注册一次）。 */
    @Synchronized
    fun addChangeListener(listener: () -> Unit) {
        changeListeners += listener
    }

    // ── 类型化读取 ──────────────────────────────────────────────────────────────

    fun getBoolean(key: String, default: Boolean): Boolean =
        try { prefs?.getBoolean(fk(key), default) ?: default }
        catch (_: ClassCastException) { default }

    fun getString(key: String, default: String = ""): String =
        try { prefs?.getString(fk(key), default) ?: default }
        catch (_: ClassCastException) { default }

    /**
     * Flutter 的 int 在 Android SharedPreferences 中以 Long 存储，
     * 优先用 getLong 读取再转换，若类型不符再尝试 getInt。
     */
    fun getInt(key: String, default: Int): Int =
        try { prefs?.getLong(fk(key), default.toLong())?.toInt() ?: default }
        catch (_: ClassCastException) {
            try { prefs?.getInt(fk(key), default) ?: default }
            catch (_: ClassCastException) { default }
        }

    fun contains(key: String): Boolean =
        prefs?.contains(fk(key)) ?: false

    // ── 内部实现 ────────────────────────────────────────────────────────────────

    private fun fk(key: String) = "$FLUTTER_KEY_PREFIX$key"

    private fun notifyListeners() {
        val ls = synchronized(this) { changeListeners.toList() }
        ls.forEach { runCatching { it() } }
    }
}
