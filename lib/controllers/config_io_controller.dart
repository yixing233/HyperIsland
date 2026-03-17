import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigIOController {
  /// 将所有 pref_ 开头的设置序列化为 JSON 字符串。
  static Future<String> exportToJson() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('pref_'));
    final Map<String, dynamic> settings = {};
    for (final key in keys) {
      settings[key] = prefs.get(key);
    }
    return const JsonEncoder.withIndent('  ').convert({
      'version': 1,
      'settings': settings,
    });
  }

  /// 从 JSON 字符串恢复所有设置，返回写入的条目数。
  static Future<int> importFromJson(String json) async {
    final dynamic decoded = jsonDecode(json);
    if (decoded is! Map) throw const FormatException('配置格式无效');
    final settings = decoded['settings'];
    if (settings is! Map) throw const FormatException('配置格式无效');
    final prefs = await SharedPreferences.getInstance();
    int count = 0;
    for (final entry in settings.entries) {
      final key = entry.key as String;
      final value = entry.value;
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
      count++;
    }
    return count;
  }

  /// 导出到 app 外部存储目录，返回文件路径。
  static Future<String> exportToFile() async {
    final json = await exportToJson();
    final dir = await getExternalStorageDirectory();
    if (dir == null) throw Exception('无法获取存储目录');
    final file = File('${dir.path}/hyperisland_config.json');
    await file.writeAsString(json);
    return file.path;
  }

  /// 导出到剪贴板。
  static Future<void> exportToClipboard() async {
    final json = await exportToJson();
    await Clipboard.setData(ClipboardData(text: json));
  }

  /// 从用户选择的 JSON 文件导入，返回写入的条目数。
  static Future<int> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: false,
      withReadStream: false,
    );
    if (result == null || result.files.isEmpty) {
      throw Exception('未选择文件');
    }
    final path = result.files.first.path;
    if (path == null) throw Exception('无法获取文件路径');
    final json = await File(path).readAsString();
    return importFromJson(json);
  }

  /// 从剪贴板导入，返回写入的条目数。
  static Future<int> importFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null || data!.text!.isEmpty) {
      throw Exception('剪贴板为空');
    }
    return importFromJson(data.text!);
  }
}
