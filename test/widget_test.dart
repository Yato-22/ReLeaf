import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:releaf/main.dart';
import 'package:releaf/models/models.dart';
import 'package:releaf/screens/location_detail_screen.dart';
import 'package:releaf/screens/map_screen.dart';
import 'package:releaf/screens/restoration_drives_screen.dart';

void main() {
  testWidgets('ReLeafApp smoke test - loads onboarding and brand', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ReLeafApp());
    await tester.pump();

    expect(find.text('ReLeaf'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('See where restoration is needed most'), findsOneWidget);
  });

  testWidgets(
    'RestorationDrivesScreen renders without color/decoration assertion failure',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RestorationDrivesScreen()),
      );
      await tester.pump();

      expect(find.text('NEAR ME'), findsOneWidget);
      expect(find.text('Restore Pune Hills'), findsOneWidget);
    },
  );

  testWidgets('LocationDetailScreen renders priority header without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: LocationDetailScreen(location: ReLeafData.defaultLocation),
      ),
    );
    await tester.pump();

    expect(find.text('RESTORATION PRIORITY'), findsOneWidget);
    expect(find.text('IMMEDIATE ACTION REQUIRED'), findsOneWidget);
  });

  testWidgets(
    'MapScreen renders native satellite terrain and markers without exception',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: MapScreen()));
      await tester.pump();

      // Verify map screen markers, toggle bar, and bottom sheet render
      expect(find.text('PRIORITY'), findsOneWidget);
      expect(find.text('NDVI'), findsOneWidget);
      expect(find.text('RAINFALL'), findsOneWidget);
      expect(find.text('Mulshi Basin'), findsOneWidget);
      expect(find.text('View Details'), findsOneWidget);
    },
  );
}
