import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/status_badge.dart';
import '../widgets/telemetry_strip.dart';
import 'location_detail_screen.dart';

class MapScreen extends StatefulWidget {
  final VoidCallback? onNavigateToDrives;

  const MapScreen({super.key, this.onNavigateToDrives});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedMetric = 'Priority';
  PlotLocation _selectedLocation = ReLeafData.defaultLocation;

  final List<PlotLocation> _locations = ReLeafData.mapLocations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0F241A,
      ), // Deep terrain canvas background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: AppColors.surfaceContainerLowest,
          title: Row(
            children: [
              const Icon(
                Icons.eco,
                color: AppColors.primaryContainer,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'ReLeaf',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.outlineVariant, width: 1),
                ),
                child: Text(
                  'FIELD GIS',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.08 * 11,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.tune,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
              tooltip: 'Filters and configuration',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Field GIS Filters: Showing active catchment telemetry',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxSheetWidth = constraints.maxWidth > 600
              ? 600.0
              : constraints.maxWidth;

          return Stack(
            children: [
              // 1. High-Precision Satellite GIS Canvas
              Positioned.fill(child: _buildMapBackground()),

              // 2. Topographic Contour Isolines & Satellite Coordinate Grid Overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _MapOverlayPainter()),
                ),
              ),

              // 3. Floating Metric Toggle Bar
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Center(child: _buildMetricToggleBar()),
              ),

              // 4. Geospatial Priority Markers (direct children of Stack!)
              ..._locations.map((loc) => _buildMarker(loc, constraints)),

              // 5. Floating Legend Card (Bottom-Left)
              Positioned(bottom: 230, left: 16, child: _buildLegendCard()),

              // 6. Floating Map Controls (Bottom-Right)
              Positioned(bottom: 230, right: 16, child: _buildMapControls()),

              // 7. Slide-Up Bottom Sheet Card
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: maxSheetWidth,
                    child: _buildBottomSheetCard(context),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMapBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Native custom terrain renderer that is ALWAYS immediately visible
        const CustomPaint(painter: _SatelliteTerrainPainter()),

        // Network imagery layer with fallback
        Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBjoe7mQHT_blIX6sHgPLIqYcfEknovKvWpxWZchREw1JNwy2NXTEVAsz0JOa353hv_jGbssAgzQohs6Ikpa6Ej6WY18fdslzgOKZvAqEXVZE6iXi2h8B5gkR_v2qP5RCatgizyPxTrzMD0jvgE-7tNkoNqdFgL7en37n4GDKkjo0adVw6ce8jWToruWmy45OjwI60ocJgA9URo6yjDI7HJvictW0fJjoqRq6gEY5UH6vSESxDyelaH8A',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildMetricToggleBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ['Priority', 'NDVI', 'Rainfall'].map((metric) {
            final isSelected = _selectedMetric == metric;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMetric = metric;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      metric.toUpperCase(),
                      style: AppTypography.labelMd.copyWith(
                        color: isSelected
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMarker(PlotLocation loc, BoxConstraints constraints) {
    final isSelected = _selectedLocation.id == loc.id;

    Color badgeColor;
    switch (loc.tier) {
      case PriorityTier.high:
        badgeColor = AppColors.alertDegraded;
        break;
      case PriorityTier.medium:
        badgeColor = AppColors.tertiaryContainer;
        break;
      case PriorityTier.low:
        badgeColor = AppColors.primaryContainer;
        break;
    }

    final posX = (constraints.maxWidth * loc.relativeX - 44).clamp(
      12.0,
      constraints.maxWidth - 100,
    );
    final posY = (constraints.maxHeight * loc.relativeY - 30).clamp(
      70.0,
      constraints.maxHeight - 270,
    );

    return Positioned(
      left: posX,
      top: posY,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLocation = loc;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected && loc.tier == PriorityTier.high) ...[
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.alertDegraded.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.alertDegraded.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        loc.priorityScore.toString(),
                        style: AppTypography.labelLg.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.outlineVariant, width: 0.8),
              ),
              child: Text(
                loc.shortName,
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PRIORITY INDEX',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          _legendRow(AppColors.primaryContainer, 'Low (<40)'),
          const SizedBox(height: 4),
          _legendRow(AppColors.tertiaryContainer, 'Medium (40–70)'),
          const SizedBox(height: 4),
          _legendRow(AppColors.alertDegraded, 'High (>70)'),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelMd.copyWith(color: AppColors.onSurface),
        ),
      ],
    );
  }

  Widget _buildMapControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _controlButton(Icons.my_location, 'Recenter map', () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Map recentered to Western Ghats catchment'),
            ),
          );
        }),
        const SizedBox(height: 8),
        _controlButton(Icons.layers, 'Layers', () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Toggled Multi-Spectral Sentinel-2 Layer'),
            ),
          );
        }),
      ],
    );
  }

  Widget _controlButton(IconData icon, String tooltip, VoidCallback onTap) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }

  Widget _buildBottomSheetCard(BuildContext context) {
    final loc = _selectedLocation;
    Color scoreColor;
    switch (loc.tier) {
      case PriorityTier.high:
        scoreColor = AppColors.alertDegraded;
        break;
      case PriorityTier.medium:
        scoreColor = AppColors.tertiaryContainer;
        break;
      case PriorityTier.low:
        scoreColor = AppColors.primaryContainer;
        break;
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          top: BorderSide(color: AppColors.surfaceContainerHighest, width: 1),
          left: BorderSide(color: AppColors.surfaceContainerHighest, width: 1),
          right: BorderSide(color: AppColors.surfaceContainerHighest, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag grab handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(label: loc.statusLabel, tier: loc.tier),
                    const SizedBox(height: 6),
                    Text(
                      loc.name,
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'High Degradation • Severe Erosion',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    loc.priorityScore.toString(),
                    style: AppTypography.metricDisplay.copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),
                  Text(
                    'RESTORATION PRIORITY',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Telemetry Strip & Secondary Metrics
          TelemetryStrip(
            value: loc.priorityScore / 100.0,
            activeColor: scoreColor,
          ),
          const SizedBox(height: 10),

          // Secondary Metrics - Resilient against small screen widths
          Row(
            children: [
              Expanded(
                child: _metricPill(
                  Icons.trending_down,
                  'NDVI:',
                  loc.ndviChange,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '•',
                  style: TextStyle(color: AppColors.outlineVariant),
                ),
              ),
              Expanded(
                child: _metricPill(
                  Icons.landscape_outlined,
                  'Slope:',
                  loc.slope,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '•',
                  style: TextStyle(color: AppColors.outlineVariant),
                ),
              ),
              Expanded(
                child: _metricPill(
                  Icons.water_drop_outlined,
                  'Runoff:',
                  loc.runoff,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LocationDetailScreen(
                      location: loc,
                      onViewDrives: widget.onNavigateToDrives,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Details',
                    style: AppTypography.labelLg.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricPill(IconData icon, String title, String val) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.outline),
          const SizedBox(width: 4),
          Text(
            '$title ',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            val,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rich realistic native satellite GIS terrain painter (Sahyadri / Western Ghats terrain)
class _SatelliteTerrainPainter extends CustomPainter {
  const _SatelliteTerrainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Deep forest terrain gradient base
    final baseGradient = RadialGradient(
      center: const Alignment(-0.2, -0.1),
      radius: 1.2,
      colors: const [
        Color(0xFF264C38), // Lush high plateau
        Color(0xFF1E3F2E), // Dense canopy forest
        Color(0xFF132D20), // Deep valleys
        Color(0xFF0C1D14), // Mountain shadows
      ],
    );
    canvas.drawRect(rect, Paint()..shader = baseGradient.createShader(rect));

    // 2. Mountain Ridges (topographical relief bands)
    final ridgePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF326048).withValues(alpha: 0.5),
          const Color(0xFF1B3D2C).withValues(alpha: 0.2),
          const Color(0xFF0F261B).withValues(alpha: 0.7),
        ],
      ).createShader(rect);

    // North-South mountain ridge
    final ridgePath = Path()
      ..moveTo(size.width * 0.1, 0)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.2,
        size.width * 0.05,
        size.height * 0.5,
        size.width * 0.35,
        size.height * 0.8,
      )
      ..lineTo(size.width * 0.45, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(ridgePath, ridgePaint);

    // Eastern slope relief
    final eastSlope = Path()
      ..moveTo(size.width * 0.6, 0)
      ..cubicTo(
        size.width * 0.85,
        size.height * 0.3,
        size.width * 0.55,
        size.height * 0.6,
        size.width,
        size.height * 0.85,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(
      eastSlope,
      Paint()..color = const Color(0xFF2E5941).withValues(alpha: 0.45),
    );

    // 3. Mulshi Reservoir Water Body (Realistic satellite lake geometry)
    final waterPaint = Paint()
      ..color =
          const Color(0xFF23444B) // Deep satellite lake water
      ..style = PaintingStyle.fill;

    final lakeShorePaint = Paint()
      ..color = const Color(0xFF3C666E).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final lakePath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.25)
      ..cubicTo(
        size.width * 0.48,
        size.height * 0.28,
        size.width * 0.55,
        size.height * 0.36,
        size.width * 0.42,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.52,
        size.width * 0.45,
        size.height * 0.60,
        size.width * 0.52,
        size.height * 0.55,
      )
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.50,
        size.width * 0.68,
        size.height * 0.65,
        size.width * 0.58,
        size.height * 0.72,
      )
      ..cubicTo(
        size.width * 0.46,
        size.height * 0.78,
        size.width * 0.32,
        size.height * 0.65,
        size.width * 0.30,
        size.height * 0.50,
      )
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.38,
        size.width * 0.30,
        size.height * 0.26,
        size.width * 0.35,
        size.height * 0.25,
      )
      ..close();

    canvas.drawPath(lakePath, waterPaint);
    canvas.drawPath(lakePath, lakeShorePaint);

    // River tributaries
    final streamPaint = Paint()
      ..color = const Color(0xFF355E67)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final stream1 = Path()
      ..moveTo(size.width * 0.05, size.height * 0.15)
      ..cubicTo(
        size.width * 0.15,
        size.height * 0.18,
        size.width * 0.25,
        size.height * 0.22,
        size.width * 0.35,
        size.height * 0.25,
      );
    canvas.drawPath(stream1, streamPaint);

    final stream2 = Path()
      ..moveTo(size.width * 0.85, size.height * 0.75)
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.72,
        size.width * 0.65,
        size.height * 0.70,
        size.width * 0.58,
        size.height * 0.72,
      );
    canvas.drawPath(stream2, streamPaint);

    // 4. Subtle satellite scan line texture
    final scanLinePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 6) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanLinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Grid
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    const step = 90.0;
    for (double x = 0; x < size.width; x += step) {
      _drawDashedLine(
        canvas,
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
        3,
        5,
      );
    }
    for (double y = 0; y < size.height; y += step) {
      _drawDashedLine(
        canvas,
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
        3,
        5,
      );
    }

    // Coordinates stamps
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    void drawCoord(String text, double x, double y) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 9,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }

    drawCoord('18°32\'15"N', 8, 80);
    drawCoord('73°30\'45"E', 8, 92);
    drawCoord('WGS84 // UTM-43N', size.width - 95, 80);

    // 2. Contour Isolines
    final contourPaint1 = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final p1 = Path()
      ..moveTo(-30, size.height * 0.28)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.22,
        size.width * 0.5,
        size.height * 0.35,
        size.width + 30,
        size.height * 0.24,
      );
    canvas.drawPath(p1, contourPaint1);

    final p2 = Path()
      ..moveTo(-30, size.height * 0.38)
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.32,
        size.width * 0.6,
        size.height * 0.44,
        size.width + 30,
        size.height * 0.34,
      );
    canvas.drawPath(p2, contourPaint1);

    final p3 = Path()
      ..moveTo(-30, size.height * 0.48)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.44,
        size.width * 0.68,
        size.height * 0.54,
        size.width + 30,
        size.height * 0.46,
      );
    canvas.drawPath(p3, contourPaint1);

    final p4 = Path()
      ..moveTo(-30, size.height * 0.62)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.56,
        size.width * 0.75,
        size.height * 0.66,
        size.width + 30,
        size.height * 0.58,
      );
    canvas.drawPath(p4, contourPaint1);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final steps = (distance / (dashWidth + dashSpace)).floor();
    final unitX = dx / distance;
    final unitY = dy / distance;

    for (int i = 0; i < steps; i++) {
      final startDist = i * (dashWidth + dashSpace);
      final start = Offset(
        p1.dx + unitX * startDist,
        p1.dy + unitY * startDist,
      );
      final endDist = startDist + dashWidth;
      final end = Offset(p1.dx + unitX * endDist, p1.dy + unitY * endDist);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
