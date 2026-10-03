import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';

class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  List<PlotLocation> _areas = List.from(ReLeafData.mapLocations);
  List<RestorationDrive> _drives = List.from(ReLeafData.drives);
  UserProfile _userProfile = ReLeafData.currentUser;
  List<VolunteerRegistration> _registrations = [];
  List<NotificationItem> _notifications = [];
  MethodologyData? _methodology;

  String? _authenticatedEmail = 'aditi.sharma@releaf.org';
  bool _isAuthenticated = true;

  // Active filter state
  PriorityTier? filterTier;
  String? filterIntervention;
  double? filterMaxDistanceKm;

  // Getters
  List<PlotLocation> get allAreas => _areas;
  List<RestorationDrive> get allDrives => _drives;
  UserProfile get userProfile => _userProfile;
  List<VolunteerRegistration> get registrations => _registrations;
  List<NotificationItem> get notifications => _notifications;
  MethodologyData? get methodology => _methodology;
  bool get isAuthenticated => _isAuthenticated;
  String? get authenticatedEmail => _authenticatedEmail;

  List<PlotLocation> get filteredAreas {
    return _areas.where((area) {
      if (filterTier != null && area.tier != filterTier) return false;
      if (filterIntervention != null &&
          filterIntervention != 'All' &&
          area.interventionType != filterIntervention) {
        return false;
      }
      if (filterMaxDistanceKm != null &&
          area.distanceKm > filterMaxDistanceKm!) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> init() async {
    if (_initialized) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/mock_data.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      if (data.containsKey('areas')) {
        _areas = (data['areas'] as List<dynamic>)
            .map((e) => PlotLocation.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data.containsKey('drives')) {
        _drives = (data['drives'] as List<dynamic>)
            .map((e) => RestorationDrive.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data.containsKey('profiles')) {
        final profiles = data['profiles'] as Map<String, dynamic>;
        final vol = profiles['volunteer'] as Map<String, dynamic>?;
        if (vol != null) {
          _userProfile = UserProfile.fromJson(vol);
        }
      }

      if (data.containsKey('registrations')) {
        _registrations = (data['registrations'] as List<dynamic>)
            .map((e) =>
                VolunteerRegistration.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data.containsKey('notifications')) {
        _notifications = (data['notifications'] as List<dynamic>)
            .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data.containsKey('methodology')) {
        _methodology = MethodologyData.fromJson(
            data['methodology'] as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('MockDataService using default in-memory seed data ($e)');
      _setupDefaultFallback();
    }
    _initialized = true;
    notifyListeners();
  }

  void _setupDefaultFallback() {
    _registrations = [
      const VolunteerRegistration(
        id: 'reg-1',
        driveId: 'restore-pune-hills',
        userName: 'Aditi Sharma',
        userRole: 'Field Volunteer',
        status: 'Checked In',
        registeredAt: '2026-10-01',
      ),
      const VolunteerRegistration(
        id: 'reg-2',
        driveId: 'restore-pune-hills',
        userName: 'Rahul Deshmukh',
        userRole: 'Sapling Lead',
        status: 'Checked In',
        registeredAt: '2026-10-02',
      ),
      const VolunteerRegistration(
        id: 'reg-3',
        driveId: 'restore-pune-hills',
        userName: 'Priya Patil',
        userRole: 'Field Volunteer',
        status: 'Pending',
        registeredAt: '2026-10-02',
      ),
    ];

    _notifications = [
      const NotificationItem(
        id: 'notif-1',
        title: 'Drive Reminder: Sinhagad Ridge',
        message: 'Field restoration assembly starts tomorrow at 07:00 AM.',
        timeAgo: '2h ago',
        type: 'drive',
      ),
      const NotificationItem(
        id: 'notif-2',
        title: 'Sentinel-2 Telemetry Verified',
        message: 'Sector 18-B registered +4.2% canopy index recovery.',
        timeAgo: '1d ago',
        type: 'satellite',
      ),
    ];
  }

  PlotLocation? getAreaById(String id) {
    try {
      return _areas.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  List<RestorationDrive> getDrivesForArea(String areaId) {
    return _drives.where((d) => d.linkedAreaId == areaId).toList();
  }

  void setFilters({
    PriorityTier? tier,
    String? intervention,
    double? maxDistanceKm,
  }) {
    filterTier = tier;
    filterIntervention = intervention;
    filterMaxDistanceKm = maxDistanceKm;
    notifyListeners();
  }

  void resetFilters() {
    filterTier = null;
    filterIntervention = null;
    filterMaxDistanceKm = null;
    notifyListeners();
  }

  // Drive interactions
  bool joinDrive(String driveId) {
    final driveIndex = _drives.indexWhere((d) => d.id == driveId);
    if (driveIndex == -1) return false;

    final drive = _drives[driveIndex];
    if (drive.volunteersRegistered >= drive.volunteersCapacity) return false;

    _drives[driveIndex] = drive.copyWith(
      volunteersRegistered: drive.volunteersRegistered + 1,
    );

    _registrations.insert(
      0,
      VolunteerRegistration(
        id: 'reg-${DateTime.now().millisecondsSinceEpoch}',
        driveId: driveId,
        userName: _userProfile.name,
        userRole: _userProfile.role == 'ngo' ? 'Organizer' : 'Field Volunteer',
        status: 'Registered',
        registeredAt: 'Today',
      ),
    );

    _userProfile = _userProfile.copyWith(
      drivesJoined: _userProfile.drivesJoined + 1,
    );

    notifyListeners();
    return true;
  }

  void createDrive(RestorationDrive drive) {
    _drives.insert(0, drive);
    notifyListeners();
  }

  void updateRegistrationStatus(String regId, String newStatus) {
    final idx = _registrations.indexWhere((r) => r.id == regId);
    if (idx != -1) {
      _registrations[idx] = _registrations[idx].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void closeDrive(String driveId) {
    final idx = _drives.indexWhere((d) => d.id == driveId);
    if (idx != -1) {
      _drives[idx] = _drives[idx].copyWith(isClosed: true);
      notifyListeners();
    }
  }

  void logImpact({
    required String driveTitle,
    required int saplings,
    required int hours,
    required String species,
  }) {
    final newHistory = List<CompletedDrive>.from(_userProfile.history)
      ..insert(
        0,
        CompletedDrive(
          title: driveTitle,
          date: 'Just now',
          plants: saplings,
          hours: hours,
        ),
      );

    _userProfile = _userProfile.copyWith(
      plantsContributed: _userProfile.plantsContributed + saplings,
      volunteerHours: _userProfile.volunteerHours + hours,
      history: newHistory,
    );

    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Impact Logged: $driveTitle',
        message: 'Successfully recorded $saplings native saplings and $hours field hours.',
        timeAgo: 'Just now',
        type: 'satellite',
      ),
    );

    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? chapter,
    String? avatarUrl,
    String? role,
    String? roleLabel,
  }) {
    _userProfile = _userProfile.copyWith(
      name: name,
      chapter: chapter,
      avatarUrl: avatarUrl,
      role: role,
      roleLabel: roleLabel,
    );
    notifyListeners();
  }

  void setRole(String role) {
    final isNgo = role.toLowerCase() == 'ngo';
    _userProfile = _userProfile.copyWith(
      role: role,
      roleLabel: isNgo
          ? 'Restoration Coordinator • Western Ghats Ecological Trust'
          : 'Field Volunteer • Western Ghats Chapter',
    );
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].copyWith(read: true);
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    _notifications = _notifications.map((n) => n.copyWith(read: true)).toList();
    notifyListeners();
  }

  void login(String email) {
    _authenticatedEmail = email;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _authenticatedEmail = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
