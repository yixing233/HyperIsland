package io.github.hyperisland.xposed.renderer

import android.content.Context
import android.os.Bundle
import android.util.Log
import io.github.d4viddf.hyperisland_kit.HyperPicture
import io.github.hyperisland.xposed.hook.FocusNotifStatusBarIconHook
import io.github.hyperisland.xposed.template.core.customization.FocusCustomizationFieldRegistry
import io.github.hyperisland.xposed.template.core.customization.FocusCustomizationFieldSpec
import io.github.hyperisland.xposed.template.core.models.IslandViewModel

/**
 * IM图文组件 + 进度组件2 渲染器。
 *
 * 展开态使用 chatInfo + progressInfo：
 * - picProfile: 头像图标资源
 * - appiconPkg: 应用包名（可自定义）
 * - title/content: 主次文本
 * - progressInfo: 进度条
 */
object ImageTextWithProgressRenderer : IslandRenderer {

    const val RENDERER_ID = "image_text_with_progress"

    override val id = RENDERER_ID
    override val focusCustomizationFields: List<FocusCustomizationFieldSpec> = listOf(
        FocusCustomizationFieldRegistry.focusTitleExpr,
        FocusCustomizationFieldRegistry.focusContentExpr,
        FocusCustomizationFieldRegistry.focusPicProfileMode,
        FocusCustomizationFieldRegistry.focusAppIconPkg,
        FocusCustomizationFieldRegistry.chatTitleColor,
        FocusCustomizationFieldRegistry.chatTitleColorDark,
        FocusCustomizationFieldRegistry.chatContentColor,
        FocusCustomizationFieldRegistry.chatContentColorDark,
    )

    override fun render(context: Context, extras: Bundle, vm: IslandViewModel) {
        try {
            val islandIconKey = "key_${vm.templateId}_island"
            val profileKey = "key_${vm.templateId}_profile"
            val profileIcon = vm.rendererIconSlots[FocusCustomizationFieldRegistry.SLOT_FOCUS_PIC_PROFILE] ?: vm.focusIcon
            val appPkg = vm.rendererStringSlots[FocusCustomizationFieldRegistry.SLOT_FOCUS_APP_ICON_PKG]
            val titleColor = vm.rendererStringSlots[FocusCustomizationFieldRegistry.SLOT_CHAT_TITLE_COLOR] ?: "#000000"
            val titleColorDark = vm.rendererStringSlots[FocusCustomizationFieldRegistry.SLOT_CHAT_TITLE_COLOR_DARK] ?: "#FFFFFF"
            val contentColor = vm.rendererStringSlots[FocusCustomizationFieldRegistry.SLOT_CHAT_CONTENT_COLOR] ?: "#666666"
            val contentColorDark = vm.rendererStringSlots[FocusCustomizationFieldRegistry.SLOT_CHAT_CONTENT_COLOR_DARK] ?: "#B3B3B3"

            val builder = io.github.d4viddf.hyperisland_kit.HyperIslandNotification.Builder(
                context,
                vm.templateId,
                vm.focusTitle,
            )

            builder.addPicture(HyperPicture(islandIconKey, vm.islandIcon))
            builder.addPicture(HyperPicture(profileKey, profileIcon))
            builder.setChatInfo(
                title = vm.focusTitle,
                content = vm.focusContent,
                pictureKey = profileKey,
                appPkg = appPkg,
                titleColor = titleColor,
                titleColorDark = titleColorDark,
                contentColor = contentColor,
                contentColorDark = contentColorDark,
            )

            builder.setIslandFirstFloat(vm.firstFloat)
            builder.setEnableFloat(vm.enableFloat)
            builder.setShowNotification(vm.showNotification)
            builder.setIslandConfig(timeout = vm.timeoutSecs)

            builder.setSmallIsland(islandIconKey)

            val leftSide = if (!vm.showIslandIcon) {
                io.github.d4viddf.hyperisland_kit.models.ImageTextInfoLeft(
                    type = 1,
                    textInfo = io.github.d4viddf.hyperisland_kit.models.TextInfo(
                        title = vm.leftTitle,
                        narrowFont = vm.showLeftNarrowFont,
                        showHighlightColor = vm.showLeftHighlightColor,
                    ),
                )
            } else {
                io.github.d4viddf.hyperisland_kit.models.ImageTextInfoLeft(
                    type = 1,
                    picInfo = io.github.d4viddf.hyperisland_kit.models.PicInfo(type = 1, pic = islandIconKey),
                    textInfo = io.github.d4viddf.hyperisland_kit.models.TextInfo(
                        title = vm.leftTitle,
                        narrowFont = vm.showLeftNarrowFont,
                        showHighlightColor = vm.showLeftHighlightColor,
                    ),
                )
            }
            builder.setBigIslandInfo(
                left = leftSide,
                right = io.github.d4viddf.hyperisland_kit.models.ImageTextInfoRight(
                    type = 2,
                    textInfo = io.github.d4viddf.hyperisland_kit.models.TextInfo(
                        title = vm.rightTitle,
                        narrowFont = vm.showRightNarrowFont,
                        showHighlightColor = vm.showRightHighlightColor,
                    ),
                ),
            )

            val resourceBundle = builder.buildResourceBundle()
            extras.putAll(resourceBundle)
            flattenActionsToExtras(resourceBundle, extras)

            var jsonParam = fixTextButtonJson(builder.buildJsonParam())
            jsonParam = injectUpdatable(jsonParam, vm.updatable)
            jsonParam = injectHighlightColor(jsonParam, vm.highlightColor)
            jsonParam = injectOuterGlow(jsonParam, vm.outerGlow)
            extras.putString("miui.focus.param", jsonParam)

            if (vm.setFocusProxy && vm.showNotification) {
                extras.putBoolean("hyperisland_focus_proxy", true)
            }
            if (vm.preserveStatusBarSmallIcon && vm.showNotification) {
                extras.putBoolean("hyperisland_preserve_status_bar_small_icon", true)
                FocusNotifStatusBarIconHook.markDirectProxyPosted(vm.timeoutSecs)
            }

            Log.d("HyperIsland", "HyperIsland[$RENDERER_ID]: rendered template=${vm.templateId}")
        } catch (e: Exception) {
            Log.d("HyperIsland", "HyperIsland[$RENDERER_ID]: render error: ${e.message}")
        }
    }
}
