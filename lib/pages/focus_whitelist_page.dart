import 'package:flutter/material.dart';
import '../controllers/focus_whitelist_controller.dart';
import '../l10n/app_localizations.dart';

class FocusWhitelistPage extends StatefulWidget {
  const FocusWhitelistPage({super.key});

  @override
  State<FocusWhitelistPage> createState() => _FocusWhitelistPageState();
}

class _FocusWhitelistPageState extends State<FocusWhitelistPage> {
  late final FocusWhitelistController _ctrl;
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl = FocusWhitelistController();
    _ctrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void deactivate() {
    _searchFocus.unfocus();
    super.deactivate();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final apps = _ctrl.filteredApps;
    final enabledCount = _ctrl.whitelistedPackages.length;

    return Scaffold(
      backgroundColor: cs.surface,
      body: RefreshIndicator(
        onRefresh: _ctrl.refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              backgroundColor: cs.surface,
              centerTitle: false,
              title: Text(l10n.navFocusWhitelist),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    switch (value) {
                      case 'toggle_system':
                        _ctrl.setShowSystemApps(!_ctrl.showSystemApps);
                      case 'refresh':
                        await _ctrl.refresh();
                      case 'enable_all':
                        await _ctrl.enableAll();
                      case 'disable_all':
                        await _ctrl.disableAll();
                    }
                  },
                  itemBuilder: (ctx) {
                    final ml = AppLocalizations.of(ctx)!;
                    return [
                      CheckedPopupMenuItem<String>(
                        value: 'toggle_system',
                        checked: _ctrl.showSystemApps,
                        child: Text(ml.showSystemApps),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'refresh',
                        child: Text(ml.refreshList),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'enable_all',
                        child: Text(ml.enableAll),
                      ),
                      PopupMenuItem<String>(
                        value: 'disable_all',
                        child: Text(ml.disableAll),
                      ),
                    ];
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SearchBar(
                  controller: _searchCtrl,
                  focusNode: _searchFocus,
                  hintText: l10n.searchApps,
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_searchCtrl.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _ctrl.setSearch('');
                        },
                      ),
                  ],
                  onChanged: (v) {
                    _ctrl.setSearch(v);
                    setState(() {});
                  },
                ),
              ),
            ),
            if (_ctrl.loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (apps.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    l10n.noAppsFound,
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Card(
                      elevation: 0,
                      color: cs.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                              child: Text(
                                enabledCount == 0
                                    ? l10n.whitelistedAppsCountNone
                                    : (_ctrl.showSystemApps
                                        ? l10n.whitelistedAppsCountWithSystem(
                                            enabledCount)
                                        : l10n.whitelistedAppsCount(
                                            enabledCount)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: cs.primary),
                              ),
                            ),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                            ...apps.asMap().entries.map((entry) {
                              final i = entry.key;
                              final app = entry.value;
                              final enabled = _ctrl.whitelistedPackages
                                  .contains(app.packageName);
                              return _AppTile(
                                app: app,
                                enabled: enabled,
                                isLast: i == apps.length - 1,
                                onChanged: (_) =>
                                    _ctrl.toggle(app.packageName),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  const _AppTile({
    required this.app,
    required this.enabled,
    required this.isLast,
    required this.onChanged,
  });

  final FocusAppInfo app;
  final bool enabled;
  final bool isLast;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: isLast
              ? const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)))
              : null,
          onTap: () => onChanged(!enabled),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(app.icon, width: 40, height: 40,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.android, size: 40)),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.appName,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.packageName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Checkbox(value: enabled, onChanged: onChanged),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            indent: 74,
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
      ],
    );
  }
}
