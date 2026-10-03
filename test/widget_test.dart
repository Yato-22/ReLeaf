import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:releaf/main.dart';
import 'package:releaf/models/models.dart';
import 'package:releaf/screens/drive_detail_screen.dart';
import 'package:releaf/screens/edit_profile_screen.dart';
import 'package:releaf/screens/impact_detail_screen.dart';
import 'package:releaf/screens/location_detail_screen.dart';
import 'package:releaf/screens/map_screen.dart';
import 'package:releaf/screens/restoration_drives_screen.dart';
import 'package:releaf/screens/settings_screen.dart';
import 'package:releaf/screens/user_profile_screen.dart';
import 'package:releaf/services/mock_data_service.dart';

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

  testWidgets('UserProfileScreen renders on 360 width without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(home: UserProfileScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('ReLeaf'), findsOneWidget);
    expect(find.text('DRIVES JOINED'), findsOneWidget);
  });

  testWidgets('UserProfileScreen in NGO mode renders on 360 width without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    MockDataService().setRole('ngo');
    addTearDown(() => MockDataService().setRole('volunteer'));

    await tester.pumpWidget(
      const MaterialApp(home: UserProfileScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('NGO PORTAL'), findsOneWidget);
    expect(find.text('Create Drive'), findsOneWidget);
  });

  testWidgets('EditProfileScreen renders on 360 width without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(home: EditProfileScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('EDIT PROFILE CREDENTIALS'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('ImpactDetailScreen renders on 360 width without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(home: ImpactDetailScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('VERIFIED SATELLITE IMPACT'), findsOneWidget);
    expect(find.text('Proof of Ecological Yield'), findsOneWidget);
  });

  testWidgets('SettingsScreen renders on 360 width without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(home: SettingsScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('PREFERENCES & SYSTEM SETTINGS'), findsOneWidget);
  });

  testWidgets('DriveDetailScreen renders on 360 width without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    for (final drive in ReLeafData.drives) {
      await tester.pumpWidget(
        MaterialApp(home: DriveDetailScreen(drive: drive)),
      );
      await tester.pumpAndSettle();

      expect(find.text(drive.title), findsOneWidget);
    }
  });
}


