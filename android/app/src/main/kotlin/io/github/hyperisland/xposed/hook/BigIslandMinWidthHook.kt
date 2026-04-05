package io.github.hyperisland.xposed.hook

import io.github.hyperisland.xposed.ConfigManager
import io.github.hyperisland.xposed.log
import io.github.libxposed.api.XposedModuleInterface.PackageLoadedParam
import io.github.libxposed.api.XposedModule

object BigIslandMinWidthHook {

    private const val TAG = "HyperIsland[BigIslandWidthHook]"
    private const val DEFAULT_MIN_WIDTH_DP = 120
    private const val DEFAULT_MAX_WIDTH_DP = 400

    @Volatile private var observerRegistered = false

    fun ensureObserver(module: XposedModule) {
        if (observerRegistered) return
        ConfigManager.init(module)
        ConfigManager.addChangeListener {
            module.log("$TAG: settings changed via Observer, cache cleared")
        }
        observerRegistered = true
        module.log("$TAG: ConfigManager Observer registered")
    }

    private var hookedContentView = false
    private var hookedSetMaxWidth = false

    fun init(module: XposedModule, param: PackageLoadedParam) {
        module.log("$TAG: initializing for ${param.packageName}")
        hookContentViewClasses(module, param.defaultClassLoader)
        hookDynamicClassLoaders(module)
    }

    private fun hookContentViewClasses(module: XposedModule, classLoader: ClassLoader) {
        if (hookedContentView && hookedSetMaxWidth) return
        val className = "miui.systemui.dynamicisland.window.content.DynamicIslandBaseContentView"
        try {
            val clazz = classLoader.loadClass(className)
            
            if (!hookedContentView) {
                val calculateMethod = clazz.declaredMethods.firstOrNull { it.name == "calculateBigIslandWidth" }
                if (calculateMethod != null) {
                    module.hook(calculateMethod).intercept { chain ->
                        val result = chain.proceed()
                        try {
                            val view = chain.thisObject as? android.view.View
                            if (view == null) return@intercept result
                            
                            ensureObserver(module)
                            
                            val minWidthDp = ConfigManager.getInt("pref_big_island_min_width", DEFAULT_MIN_WIDTH_DP).coerceIn(60, 300)
                            val density = view.context.resources.displayMetrics.density
                            val minWidthPx = (minWidthDp).toInt()
                            
                            val bigIslandMinWidthField = clazz.getDeclaredField("bigIslandMinWidth")
                            bigIslandMinWidthField.isAccessible = true
                            bigIslandMinWidthField.set(view, minWidthPx)
                            
                            module.log("$TAG: minWidth config=$minWidthDp dp, density=$density, set=$minWidthPx px")
                        } catch (e: Exception) {
                            module.log("$TAG: error setting minWidth: ${e.message}")
                        }
                        result
                    }
                    hookedContentView = true
                    module.log("$TAG: hooked calculateBigIslandWidth on $className")
                }
            }
            
            if (!hookedSetMaxWidth) {
                val setMaxWidthMethod = clazz.declaredMethods.firstOrNull { it.name == "setMaxWidth" }
                if (setMaxWidthMethod != null) {
                    module.hook(setMaxWidthMethod).intercept { chain ->
                        ensureObserver(module)
                        
                        val maxWidthDp = ConfigManager.getInt("pref_big_island_max_width", DEFAULT_MAX_WIDTH_DP).coerceIn(20, 600)
                        val view = chain.thisObject as? android.view.View
                        val density = view?.context?.resources?.displayMetrics?.density ?: 1f
                        val maxWidthPx = maxWidthDp
                        
                        val maxWidthField = clazz.getDeclaredField("maxWidth")
                        maxWidthField.isAccessible = true
                        maxWidthField.set(view, maxWidthPx)
                        
                        module.log("$TAG: maxWidth config=$maxWidthDp dp, density=$density, set=$maxWidthPx px")
                        
                        return@intercept null
                    }
                    hookedSetMaxWidth = true
                    module.log("$TAG: hooked setMaxWidth on $className")
                }
            }
        } catch (e: Exception) {
            module.log("$TAG: failed to hook $className: ${e.message}")
        }
    }

    private fun hookDynamicClassLoaders(module: XposedModule) {
        val classLoaders = arrayOf(
            "dalvik.system.BaseDexClassLoader",
            "dalvik.system.PathClassLoader",
            "dalvik.system.DexClassLoader",
            "dalvik.system.DelegateLastClassLoader"
        )
        for (clName in classLoaders) {
            try {
                val clazz = Class.forName(clName)
                for (ctor in clazz.declaredConstructors) {
                    try {
                        module.hook(ctor).intercept { chain ->
                            val result = chain.proceed()
                            val cl = chain.thisObject as? ClassLoader
                            if (cl != null && (!hookedContentView || !hookedSetMaxWidth)) {
                                hookContentViewClasses(module, cl)
                            }
                            result
                        }
                    } catch (_: Exception) {}
                }
            } catch (_: Exception) {}
        }
    }
}