/// Models and sample seed data for ReLeaf ecosystem restoration
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
  final double relativeX;
  final double relativeY;
  final String beforeImageUrl;
  final String afterImageUrl;

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
    required this.relativeX,
    required this.relativeY,
    required this.beforeImageUrl,
    required this.afterImageUrl,
  });
}

class RestorationDrive {
  final String id;
  final String title;
  final String locationName;
  final String sectorTag;
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

  const RestorationDrive({
    required this.id,
    required this.title,
    required this.locationName,
    required this.sectorTag,
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
  });

  double get quotaProgress => volunteersRegistered / volunteersCapacity;
  int get quotaPercent =>
      ((volunteersRegistered / volunteersCapacity) * 100).round();
}

class CompletedDrive {
  final String title;
  final String date;

  const CompletedDrive({required this.title, required this.date});
}

class UserProfile {
  final String name;
  final String role;
  final String avatarUrl;
  final int drivesJoined;
  final int plantsContributed;
  final int volunteerHours;
  final String canopyDelta;
  final String canopySubtext;
  final String verificationBadge;
  final List<CompletedDrive> history;

  const UserProfile({
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.drivesJoined,
    required this.plantsContributed,
    required this.volunteerHours,
    required this.canopyDelta,
    required this.canopySubtext,
    required this.verificationBadge,
    required this.history,
  });
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
    recommendedActionDesc: 'Contour stone bunding paired with native broadleaf sapling plantation to halt gully progression.',
    description: 'Zone classified under Tier-1 critically degraded catchment. Accelerated seasonal gully runoff requires rapid ecological stabilization.',
    relativeX: 0.48,
    relativeY: 0.38,
    beforeImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA5Yv5u3uunLvW66r0BBMXHuddswHnLzLabq2eslC_RSdJZVa3B6pTr5zG7XwTgkNvsVsBeopNgRTiC6ltDaulTgw-NWyzaWLTP1zuBxTclfd3kuoF3mg-3vHBdcG4iH7a9NtPxhoWpdIPlSXiKnt2-CORW10HL8JSZloTr8h7ldADqpKR8AVj59KqP_peRV3Lc8E3hBukMU0uhezPf2cghTgMdmnmD4OFlNLbuOEL92y_xM-LsNNJLyw',
    afterImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBit5tAUs2gYg_OHF_OR4A1w71wcGccVkwNa0RkXH2BFH8j5M5v9bdV7BBTDCazo-3wG8pLsCryxq9wVO2pfu2jX1Nbqu0UuNIk7y30lF0UQ7d2ilXogAb9fmtitN1lw-txzbwvn0dvNAACrJxKNPAuNsilR7348IMn4Mh3l94HypVx83PygFwKhk8ZQEC1AN-CS18mFaRLhpGMFOMG2je02nMnvG2qrqt2M5XdOOBkvcSDzjkET4Wz3g',
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
      description: 'Buffer zone showing early signs of canopy thinning along exposed ridges.',
      relativeX: 0.24,
      relativeY: 0.22,
      beforeImageUrl: '',
      afterImageUrl: '',
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
      description: 'Dense contiguous evergreen rainforest canopy maintaining optimal biomass equilibrium.',
      relativeX: 0.82,
      relativeY: 0.31,
      beforeImageUrl: '',
      afterImageUrl: '',
    ),
  ];

  static const List<RestorationDrive> drives = [
    RestorationDrive(
      id: 'restore-pune-hills',
      title: 'Restore Pune Hills',
      locationName: 'Sinhagad Ridge, Pune',
      sectorTag: 'Sector 4B · Watershed',
      dateTime: 'Sat, 28 Oct • 07:00 AM',
      dateBadge: '24 Sept',
      ngoName: 'Western Ghats Ecological Trust',
      isNgoVerified: true,
      volunteersRegistered: 36,
      volunteersCapacity: 50,
      nativePlantsTarget: 500,
      priorityScore: 87,
      priorityLevel: 'High',
      recommendedIntervention: 'Contour bunding & indigenous ficus planting to stabilize degraded slopes and prevent runoff into the reservoir.',
      description: 'Field tools, sapling bundles, and geo-tagging monitors will be distributed upon check-in. Participants must assemble at designated slope coordinates for the mandatory briefing on native root depth calibration and soil moisture barriers. Hydration refilling stations and medical support kits are stationed at 200-meter field intervals along the primary gradient.',
      meetingPoint: 'Basecamp 2, Sinhagad Ghat Road',
      coordinates: '18.3664° N, 73.7558° E',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBHkscOaV0TQVfYKHRZKMAVFJq5OxB6Y55ZmxawvWuWC1-1TAaOE83rG96lP445TaCC8t2T4b31rcAsWxCP-QUoy7J9x5fT5fUuZhFchemW0fRM8Dp1XhA11cyrz-OHRYcEwyF1y8Ty5TJzUIANQ7Ej7X3Lf5EXKLLmKbt1M-xq8vz1lvgblbohsyTCrMDsTzPqsgw7il2ByqDczkQxE9ryzyWAINvmu-0sE-FlKbV-zSzWl3DpXUea6Q',
    ),
    RestorationDrive(
      id: 'mulshi-watershed-contour',
      title: 'Mulshi Watershed Contour Planting',
      locationName: 'Mulshi Valley, Maharashtra',
      sectorTag: 'Sector 18B · Catchment',
      dateTime: 'Sun, 05 Nov • 06:30 AM',
      dateBadge: '05 Nov',
      ngoName: 'Sahyadri Bio-Shield',
      isNgoVerified: true,
      volunteersRegistered: 42,
      volunteersCapacity: 60,
      nativePlantsTarget: 650,
      priorityScore: 87,
      priorityLevel: 'High',
      recommendedIntervention: 'Terraced contour trenches on red volcanic soil with native broadleaf seedlings to arrest topsoil runoff.',
      description: 'Comprehensive contour trenching and native tree planting session targeting critically eroded ridge paths. Heavy work equipment and safety boots provided.',
      meetingPoint: 'Mulshi Dam Overlook Base, Gate 3',
      coordinates: '18.5022° N, 73.5147° E',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCXgqxz2NyYtP4uwu7R0ISK1OJuLyTgLXU8u0UFZmyqM05s8uP7mrfhNm0baiJdZIXj3hCMWIt5zG2BLHJ5TBeOz9QLnRsLb8l6X2bTtNcIJt87Kn_hfBrayx4EiSYUIsAHKtPOGGldCgWtkwxzbD78UJVsH4o92BoCMTVyucXfZx5w9YwKlnLGgHu_4MM0xrfmcMMZisn8HcdyV27n8gFmRF5VbNO3oG9_YBcPnkgtzzqXqjT08N2AAA',
    ),
    RestorationDrive(
      id: 'tamhini-riparian-corridor',
      title: 'Tamhini Riparian Corridor',
      locationName: 'Tamhini Wildlife Sanctuary',
      sectorTag: 'Sector 04A · Stream Bank',
      dateTime: 'Sat, 11 Nov • 08:00 AM',
      dateBadge: '11 Nov',
      ngoName: 'Clean Streams India',
      isNgoVerified: true,
      volunteersRegistered: 18,
      volunteersCapacity: 30,
      nativePlantsTarget: 300,
      priorityScore: 64,
      priorityLevel: 'Medium',
      recommendedIntervention: 'Riparian buffer restoration using coir root pouches and wetland riparian shrubs along riverbanks.',
      description: 'Riverbank stabilization drive focusing on wetland plant species and erosion barriers along natural streams feeding Kundalika basin.',
      meetingPoint: 'Tamhini Forest Checkpost, Trailhead 1',
      coordinates: '18.4520° N, 73.4215° E',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBneKao5WJ_lO0dSX4eayD_M3PwkiVIOKjqUtQ4OgbCFJjGBmcmmQIuUWWU9DyJWNCwal8IctUb-2ta1RCco1nuoxSggF_Nnq5jwgtv03m8rcs_fVu8tjd4NxQmrCO7fuazAqMEQHaOl3nTe6WkHDCeAb5p61cUXvq4F_qTplyRSCDFGlGdoLluMWq9n6m_mqHLplB2rz_C04SUooG78M0Hteq1pEw62LiONmGZMLgxcL5hhcME2sPQ7g',
    ),
  ];

  static const UserProfile currentUser = UserProfile(
    name: 'Aditi Sharma',
    role: 'Field Volunteer • Western Ghats Chapter',
    avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAbXpqa5m9gq4Os5CQq3NEHC8DKGBnfnyLtfoFWMeqJKRq3mS2R9T68YWnb87pMci22-z6KhVM_gqZwro4Tb5xRIuFYKaOfqBQdUehZnP-AzIjOkYsaClI7m9B8Vk_hSzykC9msuOfMsvuO-9EpAP5X9woZ9XTm1NHzJbY3WbainTXD2_ftuBCuxRzEepvYZPucLydNxA8kq0e4RsWyNoCuSV91QmzPfVTCn5BuCieJvSzci7vy5Y4mvA',
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
      ),
      CompletedDrive(
        title: 'Mulshi Riparian Buffer Planting',
        date: '22 Jul 2024',
      ),
      CompletedDrive(
        title: 'Pashan Lake Wetland Re-wilding',
        date: '05 Jun 2024',
      ),
    ],
  );
}
