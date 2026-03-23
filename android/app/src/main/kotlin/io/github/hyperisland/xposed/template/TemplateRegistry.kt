package io.github.hyperisland.xposed

import android.content.Context
import android.os.Bundle
import io.github.hyperisland.xposed.templates.GenericProgressIslandNotification
import io.github.hyperisland.xposed.templates.NotificationIslandNotification
import de.robv.android.xposed.XposedBridge

/**
 * 模板注册表。
 *
 * 将模板 ID 映射到对应的 [IslandTemplate] 实现；
 * 未知 ID 时自动降级到 [GenericProgressIslandNotification]。
 *
 * 新增模板只需在 [registry] 中添加一行，不改动 Hook 代码。
 */
object TemplateRegistry {

    private val registry: Map<String, IslandTemplate> = listOf<IslandTemplate>(
        GenericProgressIslandNotification,
        NotificationIslandNotification,
    ).associateBy { it.id }

    fun dispatch(
        templateId: String,
        context: Context,
        extras: Bundle,
        data: NotifData,
    ) {
        val template = registry[templateId]
        if (template == null) {
            XposedBridge.log(
                "HyperIsland[Registry]: unknown template '$templateId', skipped"
            )
            return
        }
        // 读取黑白名单开关（独立，白名单优先）
        fun readBool(key: String): Boolean = try {
            val uri = android.net.Uri.parse("content://io.github.hyperisland.settings/$key")
            context.contentResolver.query(uri, null, null, null, null)
                ?.use { if (it.moveToFirst()) it.getInt(0) != 0 else false } ?: false
        } catch (_: Exception) { false }

        val whitelistEnabled = readBool("pref_app_whitelist_enabled")
        val blacklistEnabled = readBool("pref_app_blacklist_enabled")

        // 白名单优先：命中→强制展开；未命中→null（继续判断黑名单）
        val filteredData = if (whitelistEnabled) {
            val result = WhitelistFilter.applyTo(context, data)
            if (result != null) {
                template.inject(context, extras, result)
                return
            }
            // 白名单未命中，继续黑名单判断
            if (blacklistEnabled) BlacklistFilter.applyTo(context, data) ?: return else data
        } else if (blacklistEnabled) {
            BlacklistFilter.applyTo(context, data) ?: return
        } else {
            data
        }
        template.inject(context, extras, filteredData)
    }
}
