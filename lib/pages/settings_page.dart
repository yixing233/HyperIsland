import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/config_io_controller.dart';
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

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
    );
  }

  Future<void> _exportToFile() async {
    try {
      final path = await ConfigIOController.exportToFile();
      _showSnack('已导出到：$path');
    } catch (e) {
      _showSnack('导出失败：$e');
    }
  }

  Future<void> _exportToClipboard() async {
    try {
      await ConfigIOController.exportToClipboard();
      _showSnack('配置已复制到剪贴板');
    } catch (e) {
      _showSnack('导出失败：$e');
    }
  }

  Future<void> _importFromFile() async {
    try {
      final count = await ConfigIOController.importFromFile();
      _showSnack('导入成功，共 $count 项配置，请重启应用生效');
    } catch (e) {
      _showSnack('导入失败：$e');
    }
  }

  Future<void> _importFromClipboard() async {
    try {
      final count = await ConfigIOController.importFromClipboard();
      _showSnack('导入成功，共 $count 项配置，请重启应用生效');
    } catch (e) {
      _showSnack('导入失败：$e');
    }
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
                  const SectionLabel('配置'),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16))),
                          leading: const Icon(Icons.upload_file_outlined),
                          title: const Text('导出到文件'),
                          subtitle: const Text('将配置保存为 JSON 文件'),
                          onTap: _exportToFile,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          leading: const Icon(Icons.copy_outlined),
                          title: const Text('导出到剪贴板'),
                          subtitle: const Text('将配置复制为 JSON 文本'),
                          onTap: _exportToClipboard,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          leading: const Icon(Icons.download_outlined),
                          title: const Text('从文件导入'),
                          subtitle: const Text('从 JSON 文件恢复配置'),
                          onTap: _importFromFile,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16))),
                          leading: const Icon(Icons.paste_outlined),
                          title: const Text('从剪贴板导入'),
                          subtitle: const Text('从剪贴板中的 JSON 文本恢复配置'),
                          onTap: _importFromClipboard,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionLabel('关于'),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                  bottom: Radius.circular(16))),
                          leading: const Icon(Icons.code),
                          title: const Text('GitHub'),
                          subtitle: const Text('1812z/HyperIsland'),
                          trailing: const Icon(Icons.open_in_new, size: 18),
                          onTap: () => launchUrl(
                            Uri.parse('https://github.com/1812z/HyperIsland'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    color: cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      leading: const Icon(Icons.group_outlined),
                      title: const Text('QQ 交流群'),
                      subtitle: const Text('1045114341'),
                      trailing: const Icon(Icons.copy, size: 18),
                      onTap: () {
                        Clipboard.setData(
                            const ClipboardData(text: '1045114341'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('群号已复制到剪贴板'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
