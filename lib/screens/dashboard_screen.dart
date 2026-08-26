import 'dart:math' as math;

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: <Widget>[
          Text(
            'Analytics overview',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Real-time performance across your content and live audience.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          const _MetricGrid(),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Real-time engagement', value: 'Live'),
          const SizedBox(height: 12),
          const _EngagementChartCard(),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Live stream', value: 'Healthy'),
          const SizedBox(height: 12),
          const _LiveStreamCard(),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Engagement', value: 'Last 30 days'),
          const SizedBox(height: 12),
          const _EngagementBreakdownCard(),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    return GridView.count(
      crossAxisCount: wide ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: wide ? 1.15 : 1.05,
      children: const <Widget>[
        _MetricCard('Views', '128.4K', '+18.6%', Icons.visibility_rounded),
        _MetricCard('Watch time', '2,846h', '+12.4%', Icons.schedule_rounded),
        _MetricCard('Followers', '4,892', '+8.2%', Icons.person_add_alt_1_rounded),
        _MetricCard('Engagement', '9.8%', '+1.7%', Icons.auto_graph_rounded),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(this.label, this.value, this.change, this.icon);

  final String label;
  final String value;
  final String change;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: scheme.primary),
            const Spacer(),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(
              change,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EngagementChartCard extends StatelessWidget {
  const _EngagementChartCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: SizedBox(
          height: 210,
          child: CustomPaint(
            painter: _EngagementChartPainter(
              color: Theme.of(context).colorScheme.primary,
              gridColor: Theme.of(context).dividerColor,
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('Now', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EngagementChartPainter extends CustomPainter {
  const _EngagementChartPainter({required this.color, required this.gridColor});

  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final values = <double>[0.28, 0.34, 0.31, 0.48, 0.42, 0.61, 0.57, 0.76, 0.69, 0.88, 0.82];
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = color;
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EngagementChartPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.gridColor != gridColor;
  }
}

class _LiveStreamCard extends StatelessWidget {
  const _LiveStreamCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.sensors_rounded, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Creator session',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text('1,284 viewers watching now'),
                ],
              ),
            ),
            Text(
              'LIVE',
              style: TextStyle(
                color: scheme.error,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EngagementBreakdownCard extends StatelessWidget {
  const _EngagementBreakdownCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const <Widget>[
            _BreakdownRow('Likes', '12.8K', 0.86),
            SizedBox(height: 16),
            _BreakdownRow('Comments', '3.4K', 0.58),
            SizedBox(height: 16),
            _BreakdownRow('Shares', '1.9K', 0.42),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow(this.label, this.value, this.progress);

  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: math.max(0, math.min(1, progress)),
          minHeight: 8,
          backgroundColor: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(99),
        ),
      ],
    );
  }
}
