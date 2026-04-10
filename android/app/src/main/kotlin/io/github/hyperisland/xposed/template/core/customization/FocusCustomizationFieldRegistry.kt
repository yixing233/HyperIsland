package io.github.hyperisland.xposed.template.core.customization

import android.graphics.drawable.Icon
import io.github.hyperisland.xposed.template.core.contracts.IslandTemplate
import io.github.hyperisland.xposed.template.core.models.IslandViewModel
import io.github.hyperisland.xposed.template.core.models.NotifData
import org.json.JSONObject

data class FocusCustomizationApplyEnv(
    val data: NotifData,
    val vars: Map<String, String>,
    val resolveExpr: (String, Map<String, String>) -> String,
    val normalizeColor: (String) -> String?,
    val roundIcon: (Icon?) -> Icon?,
    val resolveSourceIcon: (String, NotifData) -> Icon?,
)

object FocusCustomizationFieldKeys {
    const val focusTitleExpr = "focus_title_expr"
    const val focusContentExpr = "focus_content_expr"
    const val focusIconMode = "focus_icon_mode"
    const val focusPicProfileMode = "focus_pic_profile_mode"
    const val focusAppIconPkg = "focus_app_icon_pkg"
    const val chatTitleColor = "chat_title_color"
    const val chatTitleColorDark = "chat_title_color_dark"
    const val chatContentColor = "chat_content_color"
    const val chatContentColorDark = "chat_content_color_dark"
    const val progressColor = "progress_color"
}

class FocusCustomizationFieldSpec(
    val slot: String,
    val key: String,
    val label: String,
    val type: String,
    private val defaultProvider: (IslandTemplate?) -> String = { "" },
    private val required: Boolean = false,
    private val optionsProvider: (IslandTemplate?) -> List<Map<String, String>> = { emptyList() },
    private val min: Int? = null,
    private val max: Int? = null,
    private val fallbackWhenEmpty: Boolean = false,
    private val applier: (String, FocusCustomizationApplyEnv, IslandViewModel) -> IslandViewModel,
) {
    fun toSchemaField(template: IslandTemplate?): Map<String, Any?> {
        val options = optionsProvider(template)
        return linkedMapOf<String, Any?>(
            "key" to key,
            "label" to label,
            "type" to type,
            "defaultValue" to defaultProvider(template),
            "required" to required,
            "options" to options.takeIf { it.isNotEmpty() },
            "min" to min,
            "max" to max,
        ).filterValues { it != null }
    }

    fun apply(config: JSONObject, template: IslandTemplate?, env: FocusCustomizationApplyEnv, vm: IslandViewModel): IslandViewModel {
        val def = defaultProvider(template)
        val raw = config.optString(key, def).trim()
        val value = if (fallbackWhenEmpty && raw.isEmpty()) def else raw
        return applier(value, env, vm)
    }
}

object FocusCustomizationFieldRegistry {
    const val SLOT_FOCUS_TITLE = "focus_title"
    const val SLOT_FOCUS_CONTENT = "focus_content"
    const val SLOT_FOCUS_ICON = "focus_icon"
    const val SLOT_FOCUS_PIC_PROFILE = "focus_pic_profile"
    const val SLOT_FOCUS_APP_ICON_PKG = "focus_app_icon_pkg"
    const val SLOT_CHAT_TITLE_COLOR = "chat_title_color"
    const val SLOT_CHAT_TITLE_COLOR_DARK = "chat_title_color_dark"
    const val SLOT_CHAT_CONTENT_COLOR = "chat_content_color"
    const val SLOT_CHAT_CONTENT_COLOR_DARK = "chat_content_color_dark"
    const val SLOT_PROGRESS_COLOR = "progress_color"

    val focusTitleExpr = FocusCustomizationFieldSpec(
        slot = SLOT_FOCUS_TITLE,
        key = FocusCustomizationFieldKeys.focusTitleExpr,
        label = FocusCustomizationFieldKeys.focusTitleExpr,
        type = "text_expr",
        defaultProvider = { it?.defaultFocusTitleExpr ?: "${'$'}{focus_title}" },
        required = true,
        fallbackWhenEmpty = true,
        applier = { value, env, vm ->
            val title = env.resolveExpr(value, env.vars).ifEmpty { vm.focusTitle }
            vm.copy(focusTitle = title)
        },
    )

    val focusContentExpr = FocusCustomizationFieldSpec(
        slot = SLOT_FOCUS_CONTENT,
        key = FocusCustomizationFieldKeys.focusContentExpr,
        label = FocusCustomizationFieldKeys.focusContentExpr,
        type = "text_expr",
        defaultProvider = { it?.defaultFocusContentExpr ?: "${'$'}{focus_content}" },
        required = true,
        fallbackWhenEmpty = true,
        applier = { value, env, vm ->
            val content = env.resolveExpr(value, env.vars).ifEmpty { vm.focusContent }
            vm.copy(focusContent = content)
        },
    )

    val focusIconMode = FocusCustomizationFieldSpec(
        slot = SLOT_FOCUS_ICON,
        key = FocusCustomizationFieldKeys.focusIconMode,
        label = FocusCustomizationFieldKeys.focusIconMode,
        type = "select",
        defaultProvider = { "auto" },
        required = true,
        optionsProvider = { iconSourceOptions() },
        fallbackWhenEmpty = true,
        applier = { value, env, vm ->
            val icon = when (value) {
                "notif_small" -> env.data.notifIcon
                "notif_large" -> env.data.largeIcon ?: env.data.notifIcon
                "app_icon" -> env.data.appIconRaw
                else -> null
            }
            val rounded = env.roundIcon(icon)
            if (rounded != null) vm.copy(focusIcon = rounded) else vm
        },
    )

    val focusPicProfileMode = FocusCustomizationFieldSpec(
        slot = SLOT_FOCUS_PIC_PROFILE,
        key = FocusCustomizationFieldKeys.focusPicProfileMode,
        label = FocusCustomizationFieldKeys.focusPicProfileMode,
        type = "select",
        defaultProvider = { "auto" },
        required = true,
        optionsProvider = { iconSourceOptions() },
        fallbackWhenEmpty = true,
        applier = { value, env, vm ->
            val icon = env.resolveSourceIcon(value, env.data)
            if (icon == null) vm
            else vm.copy(rendererIconSlots = vm.rendererIconSlots + (SLOT_FOCUS_PIC_PROFILE to icon))
        },
    )

    val focusAppIconPkg = FocusCustomizationFieldSpec(
        slot = SLOT_FOCUS_APP_ICON_PKG,
        key = FocusCustomizationFieldKeys.focusAppIconPkg,
        label = FocusCustomizationFieldKeys.focusAppIconPkg,
        type = "text",
        applier = { value, env, vm ->
            vm.copy(rendererStringSlots = vm.rendererStringSlots + (SLOT_FOCUS_APP_ICON_PKG to value.ifEmpty { env.data.pkg }))
        },
    )

    val chatTitleColor = colorField(
        slot = SLOT_CHAT_TITLE_COLOR,
        key = FocusCustomizationFieldKeys.chatTitleColor,
        label = FocusCustomizationFieldKeys.chatTitleColor,
        defaultValue = "#000000",
        applier = { color, vm ->
            if (color == null) vm
            else vm.copy(rendererStringSlots = vm.rendererStringSlots + (SLOT_CHAT_TITLE_COLOR to color))
        },
    )

    val chatTitleColorDark = colorField(
        slot = SLOT_CHAT_TITLE_COLOR_DARK,
        key = FocusCustomizationFieldKeys.chatTitleColorDark,
        label = FocusCustomizationFieldKeys.chatTitleColorDark,
        defaultValue = "#FFFFFF",
        applier = { color, vm ->
            if (color == null) vm
            else vm.copy(rendererStringSlots = vm.rendererStringSlots + (SLOT_CHAT_TITLE_COLOR_DARK to color))
        },
    )

    val chatContentColor = colorField(
        slot = SLOT_CHAT_CONTENT_COLOR,
        key = FocusCustomizationFieldKeys.chatContentColor,
        label = FocusCustomizationFieldKeys.chatContentColor,
        defaultValue = "#666666",
        applier = { color, vm ->
            if (color == null) vm
            else vm.copy(rendererStringSlots = vm.rendererStringSlots + (SLOT_CHAT_CONTENT_COLOR to color))
        },
    )

    val chatContentColorDark = colorField(
        slot = SLOT_CHAT_CONTENT_COLOR_DARK,
        key = FocusCustomizationFieldKeys.chatContentColorDark,
        label = FocusCustomizationFieldKeys.chatContentColorDark,
        defaultValue = "#B3B3B3",
        applier = { color, vm ->
            if (color == null) vm
            else vm.copy(rendererStringSlots = vm.rendererStringSlots + (SLOT_CHAT_CONTENT_COLOR_DARK to color))
        },
    )

    val progressColor = colorField(
        slot = SLOT_PROGRESS_COLOR,
        key = FocusCustomizationFieldKeys.progressColor,
        label = FocusCustomizationFieldKeys.progressColor,
        defaultValue = "",
        applier = { color, vm -> vm.copy(progressColor = color) },
    )

    private fun colorField(
        slot: String,
        key: String,
        label: String,
        defaultValue: String,
        applier: (String?, IslandViewModel) -> IslandViewModel,
    ) = FocusCustomizationFieldSpec(
        slot = slot,
        key = key,
        label = label,
        type = "color",
        defaultProvider = { defaultValue },
        applier = { value, env, vm ->
            applier(env.normalizeColor(value), vm)
        },
    )

    private fun iconSourceOptions(): List<Map<String, String>> = listOf(
        mapOf("value" to "auto", "label" to "auto"),
        mapOf("value" to "notif_small", "label" to "notif_small"),
        mapOf("value" to "notif_large", "label" to "notif_large"),
        mapOf("value" to "app_icon", "label" to "app_icon"),
    )
}
