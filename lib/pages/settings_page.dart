import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../widgets/section_label.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = SettingsController();
    _ctrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onResumeNotificationChanged(bool value) async {
    await _ctrl.setResumeNotification(value);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请重启作用域应用以使设置生效'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _onUseHookAppIconChanged(bool value) async {
    await _ctrl.setUseHookAppIcon(value);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请重启作用域应用以使设置生效'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _onRoundIconChanged(bool value) async {
    await _ctrl.setRoundIcon(value);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('设置'),
            backgroundColor: cs.surface,
            centerTitle: false,
          ),
          if (_ctrl.loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SectionLabel('行为'),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      title: const Text('下载管理器暂停后保留焦点通知'),
                      subtitle: const Text('显示一条通知，点击以继续下载，可能导致状态不同步'),
                      value: _ctrl.resumeNotification,
                      onChanged: _onResumeNotificationChanged,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionLabel('外观'),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          title: const Text('使用应用图标'),
                          subtitle: const Text('下载管理器通知使用应用图标'),
                          value: _ctrl.useHookAppIcon,
                          onChanged: _onUseHookAppIconChanged,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          title: const Text('图标圆角'),
                          subtitle: const Text('为通知图标添加圆角效果'),
                          value: _ctrl.roundIcon,
                          onChanged: _onRoundIconChanged,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
