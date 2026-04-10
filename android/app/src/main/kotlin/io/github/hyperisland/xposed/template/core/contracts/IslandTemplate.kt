package io.github.hyperisland.xposed.template.core.contracts

import android.content.Context
import android.os.Bundle
import io.github.hyperisland.xposed.template.core.models.NotifData

data class TemplatePlaceholder(
    val key: String,
    val label: String,
)

/**
 * 灵动岛通知模板接口。
 *
 * 新增模板步骤：
 *  1. 创建 object 实现此接口，id 与 Flutter 侧常量对应
 *  2. 在 TemplateRegistry.registry 中添加一行
 */
interface IslandTemplate {
    /** 唯一标识符，与 Flutter 侧 kTemplate* 常量对应。 */
    val id: String

    /** 模板允许的焦点自定义槽位能力。 */
    val focusCustomizationSlots: Set<String>
        get() = setOf("focus_title", "focus_content", "focus_icon")

    /** 模板可向用户暴露的表达式占位符。 */
    val expressionPlaceholders: List<TemplatePlaceholder>
        get() = listOf(
            TemplatePlaceholder("title", "通知标题"),
            TemplatePlaceholder("subtitle", "通知正文"),
            TemplatePlaceholder("subtitle_or_title", "正文(空则标题)"),
            TemplatePlaceholder("pkg", "包名"),
            TemplatePlaceholder("channel_id", "渠道ID"),
        )

    /** 焦点标题默认表达式。 */
    val defaultFocusTitleExpr: String
        get() = "${'$'}{focus_title}"

    /** 焦点正文默认表达式。 */
    val defaultFocusContentExpr: String
        get() = "${'$'}{focus_content}"

    /** 超级岛左侧默认表达式。 */
    val defaultIslandLeftExpr: String
        get() = "${'$'}{left_title}"

    /** 超级岛右侧默认表达式。 */
    val defaultIslandRightExpr: String
        get() = "${'$'}{right_title}"

    /** 将通知数据注入 extras，使其触发灵动岛展示。 */
    fun inject(context: Context, extras: Bundle, data: NotifData)
}
