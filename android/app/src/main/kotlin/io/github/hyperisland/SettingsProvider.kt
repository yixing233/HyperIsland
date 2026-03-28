package io.github.hyperisland

import android.content.ContentProvider
import android.content.ContentValues
import android.content.Context
import android.content.SharedPreferences
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import org.json.JSONObject
import java.io.File

/**
 * 双职责：
 *  1. 向其他进程暴露模块设置（ContentProvider，供旧版调用路径兼容）。
 *  2. 在每次设置变化时，将全量配置序列化为 JSON 写入
 *     [CONFIG_FILE_NAME]，并设为世界可读，使 ConfigManager（Hook 端）
 *     无需 App 后台运行即可实时读取配置。
 */
class SettingsProvider : ContentProvider() {

    companion object {
        const val AUTHORITY = "io.github.hyperisland.settings"
        private const val CONFIG_FILE_NAME = "hyperisland_config.json"
    }

    private val prefs by lazy {
        context!!.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
    }

    // 必须持有强引用，否则 SharedPreferences 内部弱引用会被 GC 回收
    private val prefsListener = SharedPreferences.OnSharedPreferenceChangeListener { _, changedKey ->
        // 1. 通知旧版 ContentObserver（兼容性保留）
        val resolver = context?.contentResolver ?: return@OnSharedPreferenceChangeListener
        resolver.notifyChange(Uri.parse("content://$AUTHORITY/"), null, false)
        val segment = changedKey?.removePrefix("flutter.")?.takeIf { it.isNotBlank() }
        if (segment != null) {
            resolver.notifyChange(Uri.parse("content://$AUTHORITY/$segment"), null, false)
        }
        // 2. 写 JSON 文件供 ConfigManager（FileObserver）热重载
        writeConfigFile()
    }

    override fun onCreate(): Boolean {
        prefs.registerOnSharedPreferenceChangeListener(prefsListener)
        // App 启动时立即写一次，保证 Hook 端即使在 App 关闭期间也能读到最新配置
        writeConfigFile()
        return true
    }

    // ── JSON 配置文件写入 ──────────────────────────────────────────────────────

    /**
     * 将 FlutterSharedPreferences 的全部键值序列化为 JSON，
     * 写入 filesDir/[CONFIG_FILE_NAME] 并设为世界可读。
     *
     * Hook 端（ConfigManager）通过 FileObserver 监控同一文件，
     * 文件 CLOSE_WRITE 时自动重载配置，无需模块后台运行。
     */
    private fun writeConfigFile() {
        try {
            val ctx = context ?: return
            val json = JSONObject()
            for ((key, value) in prefs.all) {
                when (value) {
                    is Boolean -> json.put(key, value)
                    is Int     -> json.put(key, value)
                    is Long    -> json.put(key, value)
                    is Float   -> json.put(key, value.toDouble())
                    is String  -> json.put(key, value)
                    is Set<*>  -> json.put(key, value.joinToString(","))
                    else       -> if (value != null) json.put(key, value.toString())
                }
            }
            val file = File(ctx.filesDir, CONFIG_FILE_NAME)
            file.writeText(json.toString())
            // 使 Hook 进程（SystemUI 等系统进程）可以直接读取，无需 App 后台
            file.setReadable(true, false)
        } catch (_: Exception) {
            // 写文件失败不应影响 App 正常运行
        }
    }

    // ── ContentProvider 查询（兼容性保留） ────────────────────────────────────

    override fun query(
        uri: Uri, projection: Array<String>?, selection: String?,
        selectionArgs: Array<String>?, sortOrder: String?
    ): Cursor {
        val segment = uri.lastPathSegment ?: return MatrixCursor(arrayOf("value"))
        val flutterKey = "flutter.$segment"
        val cursor = MatrixCursor(arrayOf("value"))

        if (segment == "pref_generic_whitelist" ||
            segment == "pref_app_blacklist" ||
            segment == "pref_ai_url" ||
            segment == "pref_ai_api_key" ||
            segment == "pref_ai_model" ||
            segment.startsWith("pref_channels_") ||
            segment.startsWith("pref_channel_template_") ||
            segment.startsWith("pref_channel_icon_") ||
            segment.startsWith("pref_channel_focus_icon_") ||
            segment.startsWith("pref_channel_focus_") ||
            segment.startsWith("pref_channel_preserve_small_icon_") ||
            segment.startsWith("pref_channel_first_float_") ||
            segment.startsWith("pref_channel_enable_float_") ||
            segment.startsWith("pref_channel_timeout_") ||
            segment.startsWith("pref_channel_marquee_") ||
            segment.startsWith("pref_channel_renderer_")) {
            cursor.newRow().add(prefs.getString(flutterKey, "") ?: "")
            return cursor
        }

        if (segment == "pref_marquee_speed") {
            val speed = try {
                prefs.getInt(flutterKey, 100)
            } catch (_: ClassCastException) {
                try { prefs.getLong(flutterKey, 100L).toInt() } catch (_: Exception) { 100 }
            }
            cursor.newRow().add(speed.coerceIn(20, 500))
            return cursor
        }

        val value = if (prefs.contains(flutterKey)) {
            try { if (prefs.getBoolean(flutterKey, true)) 1 else 0 }
            catch (_: ClassCastException) { 1 }
        } else {
            if (segment == "pref_marquee_feature" ||
                segment == "pref_unlock_all_focus" ||
                segment == "pref_unlock_focus_auth" ||
                segment == "pref_default_first_float" ||
                segment == "pref_default_enable_float" ||
                segment == "pref_default_marquee" ||
                segment == "pref_default_preserve_small_icon" ||
                segment == "pref_ai_enabled") 0 else 1
        }
        cursor.newRow().add(value)
        return cursor
    }

    override fun getType(uri: Uri): String? = null
    override fun insert(uri: Uri, values: ContentValues?): Uri? = null
    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?) = 0
    override fun update(uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<String>?) = 0
}
