import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'email_auth_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'badge': 'ACTION 01 // GEOSPATIAL RADAR',
      'title': 'High-Precision Satellite Map',
      'description':
          'Detect active canopy thinning and vegetation moisture stress using ESA Sentinel-2 multi-spectral radar across Western Ghats catchments.',
      'icon': Icons.radar,
      'stats': [
        {'label': 'RESOLUTION', 'val': '10m GSD'},
        {'label': 'ORBIT INTERVAL', 'val': '5 Days'},
        {'label': 'SPECTRAL BAND', 'val': 'NIR / Red (NDVI)'},
      ],
    },
    {
      'badge': 'ACTION 02 // BIOPHYSICAL REASONING',
      'title': 'Why this score, not just numbers',
      'description':
          'Deconstruct degradation priority scores into measurable biophysical factors: topsoil loss rates, steep slope sheetwash risk, and seasonal drought deficits.',
      'icon': Icons.insights_outlined,
      'stats': [
        {'label': 'SLOPE SENSITIVITY', 'val': 'SRTM 30m'},
        {'label': 'EROSION HAZARD', 'val': '4.2 t/ha/yr'},
        {'label': 'PRECIPITATION', 'val': 'CHIRPS Delta'},
      ],
    },
    {
      'badge': 'ACTION 03 // COMMUNITY RE-WILDING',
      'title': 'Join Verified Restoration Drives',
      'description':
          'Mobilize with vetted ecological NGOs on targeted parcels. Plant indigenous broadleaf species and track post-drive canopy recovery via orbital telemetry.',
      'icon': Icons.forest_outlined,
      'stats': [
        {'label': 'VERIFIED NGOS', 'val': 'Tier-1 Certified'},
        {'label': 'RESTORED SPECIES', 'val': 'Indigenous Ficus'},
        {'label': 'MONITORING', 'val': 'Cryptographic Impact'},
      ],
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToEmailAuth();
    }
  }

  void _goToEmailAuth() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const EmailAuthScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'RELEAF ORIENTATION',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _goToEmailAuth,
            child: Text(
              'Skip',
              style: AppTypography.labelLg.copyWith(
                color: AppColors.primaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.outlineVariant,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                page['badge'] as String,
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.primaryContainer,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Hero Graphic Card
                            Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.outlineVariant,
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Grid isoline lines
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: _CardGridPainter(),
                                    ),
                                  ),
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer
                                          .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primaryContainer,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      page['icon'] as IconData,
                                      size: 36,
                                      color: AppColors.primaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Title & Description
                            Text(
                              page['title'] as String,
                              style: AppTypography.headlineLg.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              page['description'] as String,
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Mini telemetry stats
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.outlineVariant,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: (page['stats']
                                        as List<Map<String, String>>)
                                    .map((s) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s['label']!,
                                        style: AppTypography.labelMd.copyWith(
                                          fontSize: 9,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        s['val']!,
                                        style: AppTypography.labelLg.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryContainer,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Dots
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dots Indicator
                      Row(
                        children: List.generate(_pages.length, (i) {
                          final isSelected = _currentPage == i;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 6),
                            width: isSelected ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryContainer
                                  : AppColors.outlineVariant,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),

                      // Next / Complete Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: _nextPage,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: AppTypography.labelLg.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.4)
      ..strokeWidth = 0.8;

    const step = 24.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
