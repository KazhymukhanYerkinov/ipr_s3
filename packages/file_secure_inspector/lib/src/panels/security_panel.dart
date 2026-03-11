import 'dart:convert';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

class SecurityPanel extends StatefulWidget {
  const SecurityPanel({super.key});

  @override
  State<SecurityPanel> createState() => _SecurityPanelState();
}

class _SecurityPanelState extends State<SecurityPanel> {
  bool _loading = true;
  String? _error;

  bool _pinSet = false;
  bool _encryptionKeyExists = false;
  int _encryptedFilesCount = 0;
  int _hiveBoxesOpen = 0;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await serviceManager.callServiceExtensionOnMainIsolate(
        'ext.filesecure.getSecurityStatus',
      );

      final data = response.json ?? {};
      final Map<String, dynamic> result;
      if (data['result'] is String) {
        result = jsonDecode(data['result'] as String) as Map<String, dynamic>;
      } else if (data['result'] is Map) {
        result = Map<String, dynamic>.from(data['result'] as Map);
      } else {
        result = data;
      }

      setState(() {
        _pinSet = result['pinSet'] as bool? ?? false;
        _encryptionKeyExists = result['encryptionKeyExists'] as bool? ?? false;
        _encryptedFilesCount = result['encryptedFilesCount'] as int? ?? 0;
        _hiveBoxesOpen = result['hiveBoxesOpen'] as int? ?? 0;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 12),
            Text(
              'Failed to fetch security status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_error!, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _fetchStatus,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchStatus,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Security Overview', onRefresh: _fetchStatus),
          const SizedBox(height: 12),
          _StatusCard(
            icon: Icons.lock_outline,
            title: 'PIN Code',
            subtitle: _pinSet ? 'PIN is set (SHA-256 hash)' : 'PIN not set',
            status: _pinSet,
          ),
          const SizedBox(height: 8),
          _StatusCard(
            icon: Icons.key,
            title: 'AES-256 Encryption Key',
            subtitle:
                _encryptionKeyExists
                    ? 'Key stored in Secure Storage'
                    : 'Key not generated',
            status: _encryptionKeyExists,
          ),
          const SizedBox(height: 8),
          _StatusCard(
            icon: Icons.folder_special_outlined,
            title: 'Encrypted Files',
            subtitle: '$_encryptedFilesCount file(s) in encrypted storage',
            status: _encryptedFilesCount > 0,
          ),
          const SizedBox(height: 8),
          _StatusCard(
            icon: Icons.storage_outlined,
            title: 'Hive Encrypted Boxes',
            subtitle: '$_hiveBoxesOpen box(es) open with AES cipher',
            status: _hiveBoxesOpen > 0,
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Security Checklist'),
          const SizedBox(height: 12),
          _ChecklistTile(
            label: 'Encryption key in flutter_secure_storage',
            checked: _encryptionKeyExists,
          ),
          _ChecklistTile(label: 'PIN stored as SHA-256 hash', checked: _pinSet),
          _ChecklistTile(
            label: 'Hive boxes use HiveAesCipher',
            checked: _hiveBoxesOpen > 0,
          ),
          const _ChecklistTile(
            label: 'SecureLogger masks JWT/email/Bearer',
            checked: true,
          ),
          const _ChecklistTile(
            label: 'HTTPS-only (SecurityInterceptor)',
            checked: true,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onRefresh;

  const _SectionHeader({required this.title, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (onRefresh != null)
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: onRefresh,
            tooltip: 'Refresh',
          ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool status;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = status ? Colors.green : Colors.orange;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: Icon(
          status ? Icons.check_circle : Icons.warning_amber_rounded,
          color: color,
        ),
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  final String label;
  final bool checked;

  const _ChecklistTile({required this.label, required this.checked});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(
        checked ? Icons.check_box : Icons.check_box_outline_blank,
        color: checked ? Colors.green : Colors.grey,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          decoration: checked ? TextDecoration.lineThrough : null,
          color: checked ? Colors.grey : null,
        ),
      ),
    );
  }
}
