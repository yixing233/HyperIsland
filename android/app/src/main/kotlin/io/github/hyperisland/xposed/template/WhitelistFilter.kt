package io.github.hyperisland.xposed

import android.app.ActivityManager
import android.content.Context
import de.robv.android.xposed.XposedBridge

/**
 * 应用白名单过滤器。
 * 在通知进入模板前检查前台应用是否在白名单中：
 *  - 命中 → 强制开启焦点通知浮动，返回修改后的 [NotifData]
 *  - 未命中 → 返回 null（让调用方继续判断黑名单或正常通过）
 *  - 白名单为空 → 返回 null（不干预）
 */
object WhitelistFilter {

    fun applyTo(context: Context, data: NotifData): NotifData? {
        val cr = context.contentResolver

        val whitelistStr = try {
            val uri = android.net.Uri.parse("content://io.github.hyperisland.settings/pref_app_whitelist")
            cr.query(uri, null, null, null, null)?.use { if (it.moveToFirst()) it.getString(0) else "" } ?: ""
        } catch (_: Exception) { "" }

        if (whitelistStr.isEmpty()) return null

        val foregroundApp = try {
            val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            @Suppress("DEPRECATION")
            am.getRunningTasks(1).firstOrNull()?.topActivity?.packageName ?: ""
        } catch (e: Exception) {
            XposedBridge.log("HyperIsland[Whitelist]: getRunningTasks failed: ${e.message}")
            ""
        }

        val isWhitelisted = foregroundApp.isNotEmpty() && whitelistStr.split(",").contains(foregroundApp)
        XposedBridge.log("HyperIsland[Whitelist]: foreground=$foregroundApp, isWhitelisted=$isWhitelisted")

        if (isWhitelisted) {
            XposedBridge.log("HyperIsland[Whitelist]: $foregroundApp forced float")
            return data.copy(firstFloat = "on", enableFloatMode = "on")
        }

        // 未命中：返回 null，让调用方继续处理（黑名单或正常通过）
        XposedBridge.log("HyperIsland[Whitelist]: $foregroundApp not in whitelist, passing through")
        return null
    }
}
