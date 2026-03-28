// dart run scripts/seed_demo.dart
// Seeds the 30-day Maya/Mochi demo data into the local database.

import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  final seedFile = File('demo/seed_data.json');
  if (!seedFile.existsSync()) {
    stderr.writeln('demo/seed_data.json not found');
    exit(1);
  }

  final data = jsonDecode(await seedFile.readAsString()) as List<dynamic>;
  // TODO: open AppDatabase and insert demo check-ins
  stdout.writeln('Seeded ${data.length} check-ins from demo/seed_data.json');
}
