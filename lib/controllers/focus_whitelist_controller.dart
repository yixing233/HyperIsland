import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _channel = MethodChannel('io.github.hyperisland/test');
const kPrefAppWhitelist = 'pref_app_whitelist';
const kPrefAppBlacklist = 'pref_app_blacklist';

class FocusAppInfo {
  final String packageName;
  final String appName;
  final Uint8List icon;
  final bool isSystem;

  const FocusAppInfo({
    required this.packageName,
    required this.appName,
    required this.icon,
    this.isSystem = false,
  });
}

class FocusWhitelistController extends ChangeNotifier {
  List<FocusAppInfo> _allApps = [];
  List<FocusAppInfo> _sortedApps = [];
  Set<String> whitelistedPackages = {};
  bool loading = true;
  String _searchQuery = '';
  bool showSystemApps = false;

  FocusWhitelistController() {
    _load();
  }

  List<FocusAppInfo> get filteredApps {
    Iterable<FocusAppInfo> source = showSystemApps
        ? _sortedApps
        : _sortedApps.where(
            (a) => !a.isSystem || whitelistedPackages.contains(a.packageName));
    final q = _searchQuery.toLowerCase().trim();
    if (q.isNotEmpty) {
      source = source.where((a) =>
          a.appName.toLowerCase().contains(q) ||
          a.packageName.toLowerCase().contains(q));
    }
    return source.toList();
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    loading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final csv = prefs.getString(kPrefAppWhitelist) ?? '';
      whitelistedPackages =
          csv.isEmpty ? {} : csv.split(',').where((s) => s.isNotEmpty).toSet();

      final rawList = await _channel
              .invokeMethod<List<dynamic>>(
                  'getInstalledApps', {'includeSystem': true}) ??
          [];
      const excludedPackages = {
        'com.android.providers.downloads',
        'com.xiaomi.android.app.downloadmanager',
        'com.android.systemui',
      };
      _allApps = rawList
          .map((raw) {
            final map = Map<String, dynamic>.from(raw as Map);
            return FocusAppInfo(
              packageName: map['packageName'] as String,
              appName: map['appName'] as String,
              icon: Uint8List.fromList((map['icon'] as List).cast<int>()),
              isSystem: map['isSystem'] as bool? ?? false,
            );
          })
          .where((a) => !excludedPackages.contains(a.packageName))
          .toList();
      _resort();
    } catch (e) {
      debugPrint('FocusWhitelistController._load error: $e');
    }

    loading = false;
    notifyListeners();
  }

  void _resort() {
    _sortedApps = List<FocusAppInfo>.from(_allApps)
      ..sort((a, b) {
        final aOn = whitelistedPackages.contains(a.packageName);
        final bOn = whitelistedPackages.contains(b.packageName);
        if (aOn != bOn) return aOn ? -1 : 1;
        return a.appName.compareTo(b.appName);
      });
  }

  Future<void> toggle(String packageName) async {
    if (whitelistedPackages.contains(packageName)) {
      whitelistedPackages.remove(packageName);
    } else {
      whitelistedPackages.add(packageName);
      // 互斥：从黑名单中移除
      final prefs = await SharedPreferences.getInstance();
      final blacklistStr = prefs.getString(kPrefAppBlacklist) ?? '';
      final blacklist = blacklistStr.isEmpty ? <String>{} : blacklistStr.split(',').where((s) => s.isNotEmpty).toSet();
      if (blacklist.remove(packageName)) {
        await prefs.setString(kPrefAppBlacklist, blacklist.join(','));
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefAppWhitelist, whitelistedPackages.join(','));
    _resort();
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    _resort();
    notifyListeners();
  }

  void setShowSystemApps(bool value) {
    showSystemApps = value;
    _resort();
    notifyListeners();
  }

  Future<void> enableAll() async {
    for (final a in filteredApps) {
      whitelistedPackages.add(a.packageName);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefAppWhitelist, whitelistedPackages.join(','));
    notifyListeners();
  }

  Future<void> disableAll() async {
    for (final a in filteredApps) {
      whitelistedPackages.remove(a.packageName);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefAppWhitelist, whitelistedPackages.join(','));
    notifyListeners();
  }
}
