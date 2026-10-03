/// Models, JSON serialization, and seed data for ReLeaf ecosystem restoration
library;

enum PriorityTier {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case PriorityTier.low:
        return 'Low (<40)';
      case PriorityTier.medium:
        return 'Medium (40–70)';
      case PriorityTier.high:
        return 'High (>70)';
    }
  }

  static PriorityTier fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'high':
        return PriorityTier.high;
      case 'medium':
        return PriorityTier.medium;
      case 'low':
      default:
        return PriorityTier.low;
    }
  }
}

class ScoreFactor {
  final String name;
  final String value;
  final String severity; // high, medium, low
  final String description;

  const ScoreFactor({
    required this.name,
    required this.value,
    required this.severity,
    required this.description,
  });

  factory ScoreFactor.fromJson(Map<String, dynamic> json) {
    return ScoreFactor(
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
      severity: json['severity'] as String? ?? 'medium',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
    'severity': severity,
    'description': description,
  };
}

class PlotLocation {
  final String id;
  final String name;
  final String shortName;
  final String sector;
  final int priorityScore;
  final PriorityTier tier;
  final String statusLabel;
  final String ndviChange;
  final String slope;
  final String runoff;
  final String rainfallAnomaly;
  final String forestCoverChange;
  final String topsoilLossRate;
  final String ndviDeltaText;
  final String recommendedActionTitle;
  final String recommendedActionDesc;
  final String description;
  final String interventionType;
  final double relativeX;
  final double relativeY;
  final int distanceKm;
  final String beforeImageUrl;
  final String afterImageUrl;
  final List<ScoreFactor> scoreFactors;

  const PlotLocation({
    required this.id,
    required this.name,
    required this.shortName,
    required this.sector,
    required this.priorityScore,
    required this.tier,
    required this.statusLabel,
    required this.ndviChange,
    required this.slope,
    required this.runoff,
    required this.rainfallAnomaly,
    required this.forestCoverChange,
    required this.topsoilLossRate,
    required this.ndviDeltaText,
    required this.recommendedActionTitle,
    required this.recommendedActionDesc,
    required this.description,
    this.interventionType = 'Erosion Control',
    required this.relativeX,
    required this.relativeY,
    this.distanceKm = 14,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.scoreFactors = const [],
  });

  factory PlotLocation.fromJson(Map<String, dynamic> json) {
    return PlotLocation(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortName: json['shortName'] as String? ?? '',
      sector: json['sector'] as String? ?? '',
      priorityScore: json['priorityScore'] as int? ?? 50,
      tier: PriorityTier.fromString(json['tier'] as String?),
      statusLabel: json['statusLabel'] as String? ?? 'Monitored',
      ndviChange: json['ndviChange'] as String? ?? '0%',
      slope: json['slope'] as String? ?? '0°',
      runoff: json['runoff'] as String? ?? 'Normal',
      rainfallAnomaly: json['rainfallAnomaly'] as String? ?? '0%',
      forestCoverChange: json['forestCoverChange'] as String? ?? '0%',
      topsoilLossRate: json['topsoilLossRate'] as String? ?? '0 t/ha/yr',
      ndviDeltaText: json['ndviDeltaText'] as String? ?? '',
      recommendedActionTitle: json['recommendedActionTitle'] as String? ?? '',
      recommendedActionDesc: json['recommendedActionDesc'] as String? ?? '',
      description: json['description'] as String? ?? '',
      interventionType: json['interventionType'] as String? ?? 'Erosion Control',
      relativeX: (json['relativeX'] as num?)?.toDouble() ?? 0.5,
      relativeY: (json['relativeY'] as num?)?.toDouble() ?? 0.5,
      distanceKm: json['distanceKm'] as int? ?? 15,
      beforeImageUrl: json['beforeImageUrl'] as String? ?? '',
      afterImageUrl: json['afterImageUrl'] as String? ?? '',
      scoreFactors: (json['scoreFactors'] as List<dynamic>?)
              ?.map((e) => ScoreFactor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'shortName': shortName,
    'sector': sector,
    'priorityScore': priorityScore,
    'tier': tier.name,
    'statusLabel': statusLabel,
    'ndviChange': ndviChange,
    'slope': slope,
    'runoff': runoff,
    'rainfallAnomaly': rainfallAnomaly,
    'forestCoverChange': forestCoverChange,
    'topsoilLossRate': topsoilLossRate,
    'ndviDeltaText': ndviDeltaText,
    'recommendedActionTitle': recommendedActionTitle,
    'recommendedActionDesc': recommendedActionDesc,
    'description': description,
    'interventionType': interventionType,
    'relativeX': relativeX,
    'relativeY': relativeY,
    'distanceKm': distanceKm,
    'beforeImageUrl': beforeImageUrl,
    'afterImageUrl': afterImageUrl,
    'scoreFactors': scoreFactors.map((e) => e.toJson()).toList(),
  };
}

class RestorationDrive {
  final String id;
  final String title;
  final String locationName;
  final String sectorTag;
  final String linkedAreaId;
  final String dateTime;
  final String dateBadge;
  final String ngoName;
  final bool isNgoVerified;
  final int volunteersRegistered;
  final int volunteersCapacity;
  final int nativePlantsTarget;
  final int priorityScore;
  final String priorityLevel;
  final String recommendedIntervention;
  final String description;
  final String meetingPoint;
  final String coordinates;
  final String imageUrl;
  final bool isClosed;

  const RestorationDrive({
    required this.id,
    required this.title,
    required this.locationName,
    required this.sectorTag,
    this.linkedAreaId = 'mulshi-watershed',
    required this.dateTime,
    required this.dateBadge,
    required this.ngoName,
    required this.isNgoVerified,
    required this.volunteersRegistered,
    required this.volunteersCapacity,
    required this.nativePlantsTarget,
    required this.priorityScore,
    required this.priorityLevel,
    required this.recommendedIntervention,
    required this.description,
    required this.meetingPoint,
    required this.coordinates,
    required this.imageUrl,
    this.isClosed = false,
  });

  double get quotaProgress => volunteersCapacity > 0
      ? (volunteersRegistered / volunteersCapacity).clamp(0.0, 1.0)
      : 0.0;
  int get quotaPercent => volunteersCapacity > 0
      ? ((volunteersRegistered / volunteersCapacity) * 100).round()
      : 0;

  factory RestorationDrive.fromJson(Map<String, dynamic> json) {
    return RestorationDrive(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      locationName: json['locationName'] as String? ?? '',
      sectorTag: json['sectorTag'] as String? ?? '',
      linkedAreaId: json['linkedAreaId'] as String? ?? 'mulshi-watershed',
      dateTime: json['dateTime'] as String? ?? '',
      dateBadge: json['dateBadge'] as String? ?? '',
      ngoName: json['ngoName'] as String? ?? '',
      isNgoVerified: json['isNgoVerified'] as bool? ?? true,
      volunteersRegistered: json['volunteersRegistered'] as int? ?? 0,
      volunteersCapacity: json['volunteersCapacity'] as int? ?? 50,
      nativePlantsTarget: json['nativePlantsTarget'] as int? ?? 500,
      priorityScore: json['priorityScore'] as int? ?? 50,
      priorityLevel: json['priorityLevel'] as String? ?? 'Medium',
      recommendedIntervention: json['recommendedIntervention'] as String? ?? '',
      description: json['description'] as String? ?? '',
      meetingPoint: json['meetingPoint'] as String? ?? '',
      coordinates: json['coordinates'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isClosed: json['isClosed'] as bool? ?? false,
    );
  }

  RestorationDrive copyWith({
    int? volunteersRegistered,
    bool? isClosed,
  }) {
    return RestorationDrive(
      id: id,
      title: title,
      locationName: locationName,
      sectorTag: sectorTag,
      linkedAreaId: linkedAreaId,
      dateTime: dateTime,
      dateBadge: dateBadge,
      ngoName: ngoName,
      isNgoVerified: isNgoVerified,
      volunteersRegistered: volunteersRegistered ?? this.volunteersRegistered,
      volunteersCapacity: volunteersCapacity,
      nativePlantsTarget: nativePlantsTarget,
      priorityScore: priorityScore,
      priorityLevel: priorityLevel,
      recommendedIntervention: recommendedIntervention,
      description: description,
      meetingPoint: meetingPoint,
      coordinates: coordinates,
      imageUrl: imageUrl,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}

class CompletedDrive {
  final String title;
  final String date;
  final int plants;
  final int hours;

  const CompletedDrive({
    required this.title,
    required this.date,
    this.plants = 10,
    this.hours = 3,
  });

  factory CompletedDrive.fromJson(Map<String, dynamic> json) {
    return CompletedDrive(
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      plants: json['plants'] as int? ?? 10,
      hours: json['hours'] as int? ?? 3,
    );
  }
}

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String role; // 'volunteer' or 'ngo'
  final String roleLabel;
  final String avatarUrl;
  final String chapter;
  final int drivesJoined;
  final int plantsContributed;
  final int volunteerHours;
  final String canopyDelta;
  final String canopySubtext;
  final String verificationBadge;
  final List<CompletedDrive> history;

  const UserProfile({
    this.id = 'user-1',
    this.email = 'aditi.sharma@releaf.org',
    required this.name,
    this.role = 'volunteer',
    required this.roleLabel,
    required this.avatarUrl,
    this.chapter = 'Western Ghats Chapter',
    required this.drivesJoined,
    required this.plantsContributed,
    required this.volunteerHours,
    required this.canopyDelta,
    required this.canopySubtext,
    required this.verificationBadge,
    required this.history,
  });

  bool get isNgo => role.toLowerCase() == 'ngo';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'user-1',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'volunteer',
      roleLabel: json['roleLabel'] as String? ?? 'Field Volunteer',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      chapter: json['chapter'] as String? ?? 'Western Ghats Chapter',
      drivesJoined: json['drivesJoined'] as int? ?? 0,
      plantsContributed: json['plantsContributed'] as int? ?? 0,
      volunteerHours: json['volunteerHours'] as int? ?? 0,
      canopyDelta: json['canopyDelta'] as String? ?? '+0%',
      canopySubtext: json['canopySubtext'] as String? ?? '',
      verificationBadge: json['verificationBadge'] as String? ?? '',
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => CompletedDrive.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  UserProfile copyWith({
    String? name,
    String? chapter,
    String? avatarUrl,
    String? role,
    String? roleLabel,
    int? drivesJoined,
    int? plantsContributed,
    int? volunteerHours,
    List<CompletedDrive>? history,
  }) {
    return UserProfile(
      id: id,
      email: email,
      name: name ?? this.name,
      role: role ?? this.role,
      roleLabel: roleLabel ?? this.roleLabel,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      chapter: chapter ?? this.chapter,
      drivesJoined: drivesJoined ?? this.drivesJoined,
      plantsContributed: plantsContributed ?? this.plantsContributed,
      volunteerHours: volunteerHours ?? this.volunteerHours,
      canopyDelta: canopyDelta,
      canopySubtext: canopySubtext,
      verificationBadge: verificationBadge,
      history: history ?? this.history,
    );
  }
}

class VolunteerRegistration {
  final String id;
  final String driveId;
  final String userName;
  final String userRole;
  final String status; // 'Checked In', 'Pending'
  final String registeredAt;

  const VolunteerRegistration({
    required this.id,
    required this.driveId,
    required this.userName,
    required this.userRole,
    required this.status,
    required this.registeredAt,
  });

  factory VolunteerRegistration.fromJson(Map<String, dynamic> json) {
    return VolunteerRegistration(
      id: json['id'] as String? ?? '',
      driveId: json['driveId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userRole: json['userRole'] as String? ?? 'Field Volunteer',
      status: json['status'] as String? ?? 'Pending',
      registeredAt: json['registeredAt'] as String? ?? '',
    );
  }

  VolunteerRegistration copyWith({String? status}) {
    return VolunteerRegistration(
      id: id,
      driveId: driveId,
      userName: userName,
      userRole: userRole,
      status: status ?? this.status,
      registeredAt: registeredAt,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final String type; // 'drive', 'satellite', 'system'
  final bool read;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.read = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? '',
      type: json['type'] as String? ?? 'drive',
      read: json['read'] as bool? ?? false,
    );
  }

  NotificationItem copyWith({bool? read}) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      timeAgo: timeAgo,
      type: type,
      read: read ?? this.read,
    );
  }
}

class MethodologySource {
  final String name;
  final String resolution;
  final String bands;
  final String frequency;

  const MethodologySource({
    required this.name,
    required this.resolution,
    required this.bands,
    required this.frequency,
  });

  factory MethodologySource.fromJson(Map<String, dynamic> json) {
    return MethodologySource(
      name: json['name'] as String? ?? '',
      resolution: json['resolution'] as String? ?? '',
      bands: json['bands'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
    );
  }
}

class MethodologyWeight {
  final String factor;
  final int percentage;
  final String rationale;

  const MethodologyWeight({
    required this.factor,
    required this.percentage,
    required this.rationale,
  });

  factory MethodologyWeight.fromJson(Map<String, dynamic> json) {
    return MethodologyWeight(
      factor: json['factor'] as String? ?? '',
      percentage: json['percentage'] as int? ?? 0,
      rationale: json['rationale'] as String? ?? '',
    );
  }
}

class MethodologyData {
  final String title;
  final String lastUpdated;
  final String calibrationVersion;
  final List<MethodologySource> sources;
  final List<MethodologyWeight> weights;

  const MethodologyData({
    required this.title,
    required this.lastUpdated,
    required this.calibrationVersion,
    required this.sources,
    required this.weights,
  });

  factory MethodologyData.fromJson(Map<String, dynamic> json) {
    return MethodologyData(
      title: json['title'] as String? ?? '',
      lastUpdated: json['lastUpdated'] as String? ?? '',
      calibrationVersion: json['calibrationVersion'] as String? ?? '',
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => MethodologySource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      weights: (json['weights'] as List<dynamic>?)
              ?.map((e) => MethodologyWeight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

abstract final class ReLeafData {
  static const PlotLocation defaultLocation = PlotLocation(
    id: 'mulshi-watershed',
    name: 'Mulshi Watershed, Western Ghats',
    shortName: 'Mulshi Basin',
    sector: 'SECTOR 18-B • MONITORED PLOT',
    priorityScore: 87,
    tier: PriorityTier.high,
    statusLabel: 'Degraded • Priority Flag',
    ndviChange: '-21%',
    slope: '32°',
    runoff: 'Critical',
    rainfallAnomaly: '-16%',
    forestCoverChange: '-12%',
    topsoilLossRate: '4.2 t/ha/yr',
    ndviDeltaText: 'NDVI 0.68 → 0.47',
    recommendedActionTitle: 'Erosion Control + Native Vegetation Restoration',
    recommendedActionDesc:
        'Contour stone bunding paired with native broadleaf sapling plantation to halt gully progression.',
    description:
        'Zone classified under Tier-1 critically degraded catchment. Accelerated seasonal gully runoff requires rapid ecological stabilization.',
    interventionType: 'Erosion Control',
    relativeX: 0.48,
    relativeY: 0.38,
    distanceKm: 14,
    beforeImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA5Yv5u3uunLvW66r0BBMXHuddswHnLzLabq2eslC_RSdJZVa3B6pTr5zG7XwTgkNvsVsBeopNgRTiC6ltDaulTgw-NWyzaWLTP1zuBxTclfd3kuoF3mg-3vHBdcG4iH7a9NtPxhoWpdIPlSXiKnt2-CORW10HL8JSZloTr8h7ldADqpKR8AVj59KqP_peRV3Lc8E3hBukMU0uhezPf2cghTgMdmnmD4OFlNLbuOEL92y_xM-LsNNJLyw',
    afterImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBit5tAUs2gYg_OHF_OR4A1w71wcGccVkwNa0RkXH2BFH8j5M5v9bdV7BBTDCazo-3wG8pLsCryxq9wVO2pfu2jX1Nbqu0UuNIk7y30lF0UQ7d2ilXogAb9fmtitN1lw-txzbwvn0dvNAACrJxKNPAuNsilR7348IMn4Mh3l94HypVx83PygFwKhk8ZQEC1AN-CS18mFaRLhpGMFOMG2je02nMnvG2qrqt2M5XdOOBkvcSDzjkET4Wz3g',
    scoreFactors: [
      ScoreFactor(
        name: 'Canopy Density Loss (ΔNDVI)',
        value: '-21%',
        severity: 'high',
        description:
            'Optical reflectance shows steady degradation of native broadleaf cover across 45 hectares.',
      ),
      ScoreFactor(
        name: 'Slope & Runoff Incline',
        value: '32° / Critical',
        severity: 'high',
        description:
            'Steep volcanic basalt gradient accelerates torrential monsoon sheetwash into the reservoir.',
      ),
      ScoreFactor(
        name: 'Topsoil Erosion Rate',
        value: '4.2 t/ha/yr',
        severity: 'high',
        description: 'Active rill and gully formation stripping fertile humus layer.',
      ),
      ScoreFactor(
        name: 'Monsoon Precipitation Deficit',
        value: '-16%',
        severity: 'medium',
        description:
            'Sub-surface aquifers under-recharged leading to prolonged dry-season stress.',
      ),
    ],
  );

  static const List<PlotLocation> mapLocations = [
    defaultLocation,
    PlotLocation(
      id: 'varasgaon-ridge',
      name: 'Varasgaon Ridge Catchment',
      shortName: 'Varasgaon Ridge',
      sector: 'SECTOR 12-C • BUFFER ZONE',
      priorityScore: 58,
      tier: PriorityTier.medium,
      statusLabel: 'Moderate Degradation',
      ndviChange: '-11%',
      slope: '22°',
      runoff: 'Moderate',
      rainfallAnomaly: '-8%',
      forestCoverChange: '-6%',
      topsoilLossRate: '2.1 t/ha/yr',
      ndviDeltaText: 'NDVI 0.61 → 0.54',
      recommendedActionTitle: 'Assisted Natural Regeneration',
      recommendedActionDesc:
          'Brushwood dams and enrichment planting along drainage lines.',
      description:
          'Buffer zone showing early signs of canopy thinning along exposed ridges.',
      interventionType: 'Assisted Natural Regeneration',
      relativeX: 0.24,
      relativeY: 0.22,
      distanceKm: 28,
      beforeImageUrl: '',
      afterImageUrl: '',
      scoreFactors: [
        ScoreFactor(
          name: 'Canopy Density Loss (ΔNDVI)',
          value: '-11%',
          severity: 'medium',
          description:
              'Moderate crown thinning noted along windward ridge slopes.',
        ),
      ],
    ),
    PlotLocation(
      id: 'tamhini-north',
      name: 'Tamhini North Wildlife Sanctuary',
      shortName: 'Tamhini North',
      sector: 'SECTOR 04-A • CORE SANCTUARY',
      priorityScore: 32,
      tier: PriorityTier.low,
      statusLabel: 'Healthy / Stable',
      ndviChange: '+2%',
      slope: '18°',
      runoff: 'Stable',
      rainfallAnomaly: '+4%',
      forestCoverChange: '+1%',
      topsoilLossRate: '0.8 t/ha/yr',
      ndviDeltaText: 'NDVI 0.76 → 0.78',
      recommendedActionTitle: 'Continuous Canopy Monitoring',
      recommendedActionDesc:
          'Routine satellite telemetry pass and firebreak maintenance.',
      description:
          'Dense contiguous evergreen rainforest canopy maintaining optimal biomass equilibrium.',
      interventionType: 'Canopy Protection',
      relativeX: 0.82,
      relativeY: 0.31,
      distanceKm: 45,
      beforeImageUrl: '',
      afterImageUrl: '',
      scoreFactors: [
        ScoreFactor(
          name: 'Canopy Density (NDVI)',
          value: '+2%',
          severity: 'low',
          description:
              'Evergreen forest core exhibiting healthy multi-tier canopy closure.',
        ),
      ],
    ),
  ];

  static const List<RestorationDrive> drives = [
    RestorationDrive(
      id: 'restore-pune-hills',
      title: 'Restore Pune Hills',
      locationName: 'Sinhagad Ridge, Pune',
      sectorTag: 'Sector 4B · Watershed',
      linkedAreaId: 'mulshi-watershed',
      dateTime: 'Sat, 28 Oct • 07:00 AM',
      dateBadge: '28 Oct',
      ngoName: 'Western Ghats Ecological Trust',
      isNgoVerified: true,
      volunteersRegistered: 36,
      volunteersCapacity: 50,
      nativePlantsTarget: 500,
      priorityScore: 87,
      priorityLevel: 'High',
      recommendedIntervention:
          'Contour bunding & indigenous ficus planting to stabilize degraded slopes and prevent runoff into the reservoir.',
      description:
          'Field tools, sapling bundles, and geo-tagging monitors will be distributed upon check-in. Participants must assemble at designated slope coordinates for the mandatory briefing on native root depth calibration and soil moisture barriers. Hydration refilling stations and medical support kits are stationed at 200-meter field intervals along the primary gradient.',
      meetingPoint: 'Basecamp 2, Sinhagad Ghat Road',
      coordinates: '18.3664° N, 73.7558° E',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBHkscOaV0TQVfYKHRZKMAVFJq5OxB6Y55ZmxawvWuWC1-1TAaOE83rG96lP445TaCC8t2T4b31rcAsWxCP-QUoy7J9x5fT5fUuZhFchemW0fRM8Dp1XhA11cyrz-OHRYcEwyF1y8Ty5TJzUIANQ7Ej7X3Lf5EXKLLmKbt1M-xq8vz1lvgblbohsyTCrMDsTzPqsgw7il2ByqDczkQxE9ryzyWAINvmu-0sE-FlKbV-zSzWl3DpXUea6Q',
    ),
    RestorationDrive(
      id: 'mulshi-watershed-contour',
      title: 'Mulshi Watershed Contour Planting',
      locationName: 'Mulshi Valley, Maharashtra',
      sectorTag: 'Sector 18B · Catchment',
      linkedAreaId: 'mulshi-watershed',
      dateTime: 'Sun, 05 Nov • 06:30 AM',
      dateBadge: '05 Nov',
      ngoName: 'Sahyadri Bio-Shield',
      isNgoVerified: true,
      volunteersRegistered: 42,
      volunteersCapacity: 60,
      nativePlantsTarget: 650,
      priorityScore: 87,
      priorityLevel: 'High',
      recommendedIntervention:
          'Terraced contour trenches on red volcanic soil with native broadleaf seedlings to arrest topsoil runoff.',
      description:
          'Comprehensive contour trenching and native tree planting session targeting critically eroded ridge paths. Heavy work equipment and safety boots provided.',
      meetingPoint: 'Mulshi Dam Overlook Base, Gate 3',
      coordinates: '18.5022° N, 73.5147° E',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCXgqxz2NyYtP4uwu7R0ISK1OJuLyTgLXU8u0UFZmyqM05s8uP7mrfhNm0baiJdZIXj3hCMWIt5zG2BLHJ5TBeOz9QLnRsLb8l6X2bTtNcIJt87Kn_hfBrayx4EiSYUIsAHKtPOGGldCgWtkwxzbD78UJVsH4o92BoCMTVyucXfZx5w9YwKlnLGgHu_4MM0xrfmcMMZisn8HcdyV27n8gFmRF5VbNO3oG9_YBcPnkgtzzqXqjT08N2AAA',
    ),
    RestorationDrive(
      id: 'tamhini-riparian-corridor',
      title: 'Tamhini Riparian Corridor',
      locationName: 'Tamhini Wildlife Sanctuary',
      sectorTag: 'Sector 04A · Stream Bank',
      linkedAreaId: 'tamhini-north',
      dateTime: 'Sat, 11 Nov • 08:00 AM',
      dateBadge: '11 Nov',
      ngoName: 'Clean Streams India',
      isNgoVerified: true,
      volunteersRegistered: 18,
      volunteersCapacity: 30,
      nativePlantsTarget: 300,
      priorityScore: 64,
      priorityLevel: 'Medium',
      recommendedIntervention:
          'Riparian buffer restoration using coir root pouches and wetland riparian shrubs along riverbanks.',
      description:
          'Riverbank stabilization drive focusing on wetland plant species and erosion barriers along natural streams feeding Kundalika basin.',
      meetingPoint: 'Tamhini Forest Checkpost, Trailhead 1',
      coordinates: '18.4520° N, 73.4215° E',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBneKao5WJ_lO0dSX4eayD_M3PwkiVIOKjqUtQ4OgbCFJjGBmcmmQIuUWWU9DyJWNCwal8IctUb-2ta1RCco1nuoxSggF_Nnq5jwgtv03m8rcs_fVu8tjd4NxQmrCO7fuazAqMEQHaOl3nTe6WkHDCeAb5p61cUXvq4F_qTplyRSCDFGlGdoLluMWq9n6m_mqHLplB2rz_C04SUooG78M0Hteq1pEw62LiONmGZMLgxcL5hhcME2sPQ7g',
    ),
  ];

  static const UserProfile currentUser = UserProfile(
    id: 'user-volunteer-1',
    email: 'aditi.sharma@releaf.org',
    name: 'Aditi Sharma',
    role: 'volunteer',
    roleLabel: 'Field Volunteer • Western Ghats Chapter',
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAbXpqa5m9gq4Os5CQq3NEHC8DKGBnfnyLtfoFWMeqJKRq3mS2R9T68YWnb87pMci22-z6KhVM_gqZwro4Tb5xRIuFYKaOfqBQdUehZnP-AzIjOkYsaClI7m9B8Vk_hSzykC9msuOfMsvuO-9EpAP5X9woZ9XTm1NHzJbY3WbainTXD2_ftuBCuxRzEepvYZPucLydNxA8kq0e4RsWyNoCuSV91QmzPfVTCn5BuCieJvSzci7vy5Y4mvA',
    drivesJoined: 12,
    plantsContributed: 84,
    volunteerHours: 18,
    canopyDelta: '+14%',
    canopySubtext: "Average vegetation recovery across drives you've joined",
    verificationBadge: 'Sentinel-2 Surface Reflectance Verified',
    history: [
      CompletedDrive(
        title: 'Sinhagad Ridge Reforestation',
        date: '14 Aug 2024',
        plants: 18,
        hours: 4,
      ),
      CompletedDrive(
        title: 'Mulshi Riparian Buffer Planting',
        date: '22 Jul 2024',
        plants: 24,
        hours: 5,
      ),
      CompletedDrive(
        title: 'Pashan Lake Wetland Re-wilding',
        date: '05 Jun 2024',
        plants: 12,
        hours: 3,
      ),
    ],
  );
}
