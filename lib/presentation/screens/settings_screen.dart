import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/core/database/dao_providers.dart';
import 'package:vitalpet/core/database/export_service.dart';
import 'package:vitalpet/features/notifications/notification_scheduler_provider.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// App settings: reminder, calm mode, health, export, deletion, companions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);
    final pet = petAsync.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // ── Reminders ────────────────────────────────────────────
          const _SectionHeader(label: 'Reminders'),
          ListTile(
            leading: const Icon(Icons.alarm_outlined),
            title: const Text('Reminder time'),
            subtitle: const Text('Daily check-in nudge'),
            trailing: const Icon(Icons.chevron_right),
            onTap: pet == null
                ? null
                : () => _pickReminderTime(context, ref, pet),
          ),

          const Divider(indent: 16, endIndent: 16),

          // ── Pet & Mood ────────────────────────────────────────────
          const _SectionHeader(label: 'Pet & Mood'),
          SwitchListTile(
            secondary: const Icon(Icons.spa_outlined),
            title: const Text('Calm Mode'),
            subtitle: Text(
              pet?.calmMode == true
                  ? 'Loss-aversion framing hidden'
                  : 'Streak-focused, no scary warnings',
              style: AppTextStyles.bodyMedium,
            ),
            value: pet?.calmMode ?? false,
            activeThumbColor: AppColors.primary,
            onChanged: petAsync.isLoading || pet == null
                ? null
                : (enabled) => ref
                      .read(petProvider.notifier)
                      .setCalmMode(enabled: enabled),
          ),

          const Divider(indent: 16, endIndent: 16),

          // ── Health platform ───────────────────────────────────────
          const _SectionHeader(label: 'Health'),
          const _HealthConnectionTile(),

          const Divider(indent: 16, endIndent: 16),

          // ── Your companions ───────────────────────────────────────
          const _SectionHeader(label: 'Your companions'),
          const _CompanionsSection(),

          const Divider(indent: 16, endIndent: 16),

          // ── Data ──────────────────────────────────────────────────
          const _SectionHeader(label: 'Data'),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Export my data'),
            subtitle: const Text('Save a JSON copy of your health log'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportData(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppColors.danger),
            title: const Text(
              'Delete all data',
              style: TextStyle(color: AppColors.danger),
            ),
            subtitle: Text(
              pet?.deletionScheduledAt != null
                  ? _deletionCountdown(pet!.deletionScheduledAt!)
                  : '7-day recovery window',
              style: AppTextStyles.bodyMedium,
            ),
            onTap: pet == null
                ? null
                : () => pet.deletionScheduledAt != null
                      ? _cancelDeletion(context, ref)
                      : _confirmDeletion(context, ref),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Reminder time picker ─────────────────────────────────────────────────

  Future<void> _pickReminderTime(
    BuildContext context,
    WidgetRef ref,
    PetState pet,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
      helpText: 'Set your daily reminder',
    );
    if (picked == null) return;

    await ref
        .read(notificationSchedulerProvider)
        .schedulePrimary(
          petName: pet.name,
          petStateIndex: pet.stateIndex,
          time: picked,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for ${picked.format(context)}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  // ── Export ────────────────────────────────────────────────────────────────

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(exportServiceProvider).shareExport();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export failed — please try again.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  // ── Deletion ──────────────────────────────────────────────────────────────

  Future<void> _confirmDeletion(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all data?'),
        content: const Text(
          'You have 7 days to change your mind.\n\n'
          'After that, your health log and pet history will be permanently '
          'deleted and cannot be recovered.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Start countdown'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(petProvider.notifier).scheduleDeletion();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deletion scheduled. You have 7 days to cancel.'),
          ),
        );
      }
    }
  }

  Future<void> _cancelDeletion(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel deletion?'),
        content: const Text(
          'Your data and pet will be kept. '
          'You can delete again any time from Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Keep my data'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(petProvider.notifier).cancelDeletion();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deletion cancelled — your data is safe.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  String _deletionCountdown(String scheduledAtIso) {
    final scheduledAt = DateTime.parse(scheduledAtIso);
    final deadline = scheduledAt.add(const Duration(days: 7));
    final remaining = deadline.difference(DateTime.now().toUtc());
    final days = remaining.inDays.clamp(0, 7);
    return 'Scheduled — $days ${days == 1 ? 'day' : 'days'} remaining. Tap to cancel.';
  }
}

// ── Health connection tile ─────────────────────────────────────────────────

class _HealthConnectionTile extends ConsumerStatefulWidget {
  const _HealthConnectionTile();

  @override
  ConsumerState<_HealthConnectionTile> createState() =>
      _HealthConnectionTileState();
}

class _HealthConnectionTileState extends ConsumerState<_HealthConnectionTile> {
  @override
  Widget build(BuildContext context) {
    return const SwitchListTile(
      secondary: Icon(Icons.monitor_heart_outlined),
      title: Text('Health platform'),
      subtitle: Text(
        'Disabled in this build (no special permissions requested)',
        style: AppTextStyles.bodyMedium,
      ),
      value: false,
      activeThumbColor: AppColors.primary,
      onChanged: null,
    );
  }
}

// ── Your companions section ────────────────────────────────────────────────

class _CompanionsSection extends ConsumerWidget {
  const _CompanionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveDao = ref.watch(petArchiveDaoProvider);

    return FutureBuilder<List<PetArchiveData>>(
      future: archiveDao.getArchive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final archive = snapshot.data ?? [];
        if (archive.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'No companions yet — your current pet will appear here '
              'when its journey ends.',
              style: AppTextStyles.bodyMedium,
            ),
          );
        }

        return Column(
          children: archive.map((pet) => _CompanionTile(pet: pet)).toList(),
        );
      },
    );
  }
}

class _CompanionTile extends StatelessWidget {
  const _CompanionTile({required this.pet});

  final PetArchiveData pet;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _PetAvatar(species: pet.species),
      title: Text(pet.name, style: AppTextStyles.labelLarge),
      subtitle: Text(
        '${pet.lifespanDays} ${pet.lifespanDays == 1 ? 'day' : 'days'} '
        '· ${pet.totalCheckins} check-ins',
        style: AppTextStyles.bodyMedium,
      ),
      onTap: () => _showLegacyMessage(context, pet.name),
    );
  }

  void _showLegacyMessage(BuildContext context, String name) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(
          'Every check-in $name inspired is still in your health history.\n\n'
          'That mattered.',
          style: AppTextStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  const _PetAvatar({required this.species});

  final String species;

  @override
  Widget build(BuildContext context) {
    // Circular avatar showing the thriving (state 1) pet.
    return ClipOval(
      child: SizedBox(
        width: 44,
        height: 44,
        child: Image.asset(
          'assets/images/pets/${species}_1.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.pets, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textTertiary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
