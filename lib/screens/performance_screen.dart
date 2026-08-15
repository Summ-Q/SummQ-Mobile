import 'package:flutter/material.dart';
import '../theme.dart';

class PerformanceTab extends StatefulWidget {
  const PerformanceTab({super.key});

  @override
  State<PerformanceTab> createState() => _PerformanceTabState();
}

class _PerformanceTabState extends State<PerformanceTab> {
  double level = 0.85;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          children: [
            Text('performance', style: appFont(size: 24, weight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 24),
            Container(
              height: 340,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.navy,
                border: Border.all(color: AppColors.gridBlue, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: CustomPaint(painter: _CandlestickPainter(), child: Container()),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Your level', style: appFont(size: 18, weight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                activeTrackColor: AppColors.green,
                inactiveTrackColor: AppColors.cream,
                thumbColor: AppColors.green,
                overlayColor: AppColors.green.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              ),
              child: Slider(value: level, onChanged: (v) => setState(() => level = v), min: 0, max: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('bad', style: appFont(size: 13, weight: FontWeight.w600, color: AppColors.chartRed)),
                Text('good', style: appFont(size: 13, weight: FontWeight.w600, color: AppColors.yellowLink)),
                Text('very good', style: appFont(size: 13, weight: FontWeight.w600, color: Colors.white)),
                Text('excelent', style: appFont(size: 13, weight: FontWeight.w600, color: AppColors.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Candle {
  final double open, close, high, low;
  const _Candle(this.open, this.close, this.high, this.low);
  bool get isBull => close > open;
}

class _CandlestickPainter extends CustomPainter {
  static const List<_Candle> candles = [
    _Candle(0.10, 0.18, 0.22, 0.08),
    _Candle(0.18, 0.15, 0.20, 0.12),
    _Candle(0.15, 0.24, 0.28, 0.13),
    _Candle(0.24, 0.20, 0.26, 0.17),
    _Candle(0.20, 0.30, 0.33, 0.18),
    _Candle(0.30, 0.27, 0.32, 0.24),
    _Candle(0.27, 0.38, 0.40, 0.25),
    _Candle(0.38, 0.34, 0.42, 0.30),
    _Candle(0.34, 0.50, 0.55, 0.33),
    _Candle(0.50, 0.62, 0.66, 0.48),
    _Candle(0.62, 0.78, 0.82, 0.60),
    _Candle(0.78, 0.72, 0.85, 0.70),
    _Candle(0.72, 0.60, 0.75, 0.58),
    _Candle(0.60, 0.63, 0.65, 0.55),
    _Candle(0.63, 0.58, 0.66, 0.52),
    _Candle(0.58, 0.55, 0.60, 0.50),
    _Candle(0.55, 0.57, 0.59, 0.50),
    _Candle(0.57, 0.50, 0.58, 0.46),
    _Candle(0.50, 0.46, 0.52, 0.40),
    _Candle(0.46, 0.42, 0.48, 0.36),
    _Candle(0.42, 0.44, 0.46, 0.38),
    _Candle(0.44, 0.36, 0.45, 0.32),
    _Candle(0.36, 0.30, 0.38, 0.25),
    _Candle(0.30, 0.24, 0.32, 0.18),
    _Candle(0.24, 0.18, 0.26, 0.12),
    _Candle(0.18, 0.10, 0.20, 0.06),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.gridBlue
      ..strokeWidth = 1;
    const gridCount = 12;
    for (int i = 0; i <= gridCount; i++) {
      final x = size.width / gridCount * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      final y = size.height / gridCount * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final n = candles.length;
    final slotWidth = size.width / n;
    final bodyWidth = slotWidth * 0.55;

    for (int i = 0; i < n; i++) {
      final c = candles[i];
      final cx = slotWidth * i + slotWidth / 2;
      final color = c.isBull ? AppColors.green : AppColors.chartRed;
      final wickPaint = Paint()
        ..color = color
        ..strokeWidth = 2;
      final bodyPaint = Paint()..color = color;

      double yFor(double v) => size.height - (v * size.height);

      canvas.drawLine(Offset(cx, yFor(c.high)), Offset(cx, yFor(c.low)), wickPaint);

      final top = yFor(c.open > c.close ? c.open : c.close);
      final bottom = yFor(c.open > c.close ? c.close : c.open);
      final rect = Rect.fromLTRB(cx - bodyWidth / 2, top, cx + bodyWidth / 2, bottom == top ? top + 2 : bottom);
      canvas.drawRect(rect, bodyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
