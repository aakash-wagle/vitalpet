import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Settings screen: reminder time, calm mode, health connection, export, delete.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Reminder Time'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO: time picker
          ),
          SwitchListTile(
            title: const Text('Calm Mode'),
            value: false,
            onChanged: (v) {}, // TODO: implement
          ),
          ListTile(
            title: const Text('Health Connection'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO: HealthKit permissions
          ),
          ListTile(
            title: const Text('Export Data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO: DATA_EXPORT audit event
          ),
          ListTile(
            title: const Text('Delete All Data'),
            textColor: Theme.of(context).colorScheme.error,
            onTap: () {}, // TODO: DELETE_INITIATED flow
          ),
        ],
      ),
    );
  }
}
