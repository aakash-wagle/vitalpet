import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vitalpet/main.dart';

void main() {
  testWidgets('VitalPet app smoke test — router is present',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: VitalPetApp()),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
