package io.github.hyperisland.xposed.renderer

import android.content.Context
import android.os.Bundle
import android.util.Log
import io.github.d4viddf.hyperisland_kit.HyperPicture
import io.github.hyperisland.xposed.hook.FocusNotifStatusBarIconHook
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
    override val focusCustomizationSlots: Set<String> = setOf(
        "focus_title",
        "focus_content",
        "focus_pic_profile",
        "focus_app_icon_pkg",
        "chat_title_color",
        "chat_title_color_dark",
        "chat_content_color",
        "chat_content_color_dark",
    )

    override fun render(context: Context, extras: Bundle, vm: IslandViewModel) {
        try {
            val islandIconKey = "key_${vm.templateId}_island"
            val profileKey = "key_${vm.templateId}_profile"

            val builder = io.github.d4viddf.hyperisland_kit.HyperIslandNotification.Builder(
                context,
                vm.templateId,
                vm.focusTitle,
            )

            builder.addPicture(HyperPicture(islandIconKey, vm.islandIcon))
            builder.addPicture(HyperPicture(profileKey, vm.focusPicProfileIcon ?: vm.focusIcon))
            builder.setChatInfo(
                title = vm.focusTitle,
                content = vm.focusContent,
                pictureKey = profileKey,
                appPkg = vm.focusAppIconPkg,
                titleColor = vm.chatTitleColor ?: "#000000",
                titleColorDark = vm.chatTitleColorDark ?: "#FFFFFF",
                contentColor = vm.chatContentColor ?: "#666666",
                contentColorDark = vm.chatContentColorDark ?: "#B3B3B3",
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
            if (vm.showRightSide) {
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
            } else {
                builder.setBigIslandInfo(left = leftSide)
            }

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
