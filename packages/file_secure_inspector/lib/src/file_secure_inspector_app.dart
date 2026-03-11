import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:file_secure_inspector/src/panels/command_panel.dart';
import 'package:file_secure_inspector/src/panels/security_panel.dart';
import 'package:flutter/material.dart';

class FileSecureInspectorApp extends StatelessWidget {
  const FileSecureInspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(child: _InspectorBody());
  }
}

class _InspectorBody extends StatefulWidget {
  const _InspectorBody();

  @override
  State<_InspectorBody> createState() => _InspectorBodyState();
}

class _InspectorBodyState extends State<_InspectorBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    Tab(icon: Icon(Icons.shield_outlined), text: 'Security'),
    Tab(icon: Icon(Icons.history), text: 'Commands'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [SecurityPanel(), CommandPanel()],
          ),
        ),
      ],
    );
  }
}
