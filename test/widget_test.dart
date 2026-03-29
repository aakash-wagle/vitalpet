import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/core/database/app_database.dart';
import 'package:vitalpet/core/database/database_provider.dart';
import 'package:vitalpet/main.dart';

void main() {
  testWidgets('VitalPet app renders MaterialApp smoke test',
      (WidgetTester tester) async {
    final db = openEncryptedDatabase('test_key_00000000000000000000000000000000');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWith((_) => db)],
        child: const VitalPetApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
