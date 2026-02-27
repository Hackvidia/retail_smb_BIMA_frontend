import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/dashboard_card_container.dart';

enum InsightWidgetVariant {
  financialDiary,
  outOfTrend,
  priceChange,
  demandTrend,
  transactionTrend,
}

class FinancialDiaryData {
  final double progress; // 0.0 - 1.0
  final String percentText;
  final String deltaText;
  final String costText;
  final String profitText;

  const FinancialDiaryData({
    required this.progress,
    required this.percentText,
    required this.deltaText,
    required this.costText,
    required this.profitText,
  });
}

class TrendTableRowData {
  final String item;
  final String stockLevel;
  final String status;
  final Color statusColor;

  const TrendTableRowData({
    required this.item,
    required this.stockLevel,
    required this.status,
    required this.statusColor,
  });
}

class PriceChangeRowData {
  final String item;
  final String changeText;
  final bool isUp;

  const PriceChangeRowData({
    required this.item,
    required this.changeText,
    required this.isUp,
  });
}

class DemandTrendData {
  final String item;
  final String changeText;
  final bool isUp;
  final List<double> points;
  final List<String> labels;

  const DemandTrendData({
    required this.item,
    required this.changeText,
    required this.isUp,
    required this.points,
    required this.labels,
  });
}

class TransactionTrendData {
  final List<double> bars;
  final List<String> labels;

  const TransactionTrendData({
    required this.bars,
    required this.labels,
  });
}

class InsightSectionWidget extends StatelessWidget {
  final InsightWidgetVariant variant;
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;
  final FinancialDiaryData? financialDiaryData;
  final List<TrendTableRowData> outOfTrendRows;
  final List<PriceChangeRowData> priceChanges;
  final DemandTrendData? demandTrendData;
  final TransactionTrendData? transactionTrendData;

  const InsightSectionWidget.financialDiary({
    super.key,
    required this.financialDiaryData,
    this.title = 'Financial Diary',
    this.showSeeAll = true,
    this.onSeeAllTap,
  }) : variant = InsightWidgetVariant.financialDiary,
       outOfTrendRows = const [],
       priceChanges = const [],
       demandTrendData = null,
       transactionTrendData = null;

  const InsightSectionWidget.outOfTrend({
    super.key,
    required this.outOfTrendRows,
    this.title = 'Out of Trend!',
    this.showSeeAll = true,
    this.onSeeAllTap,
  }) : variant = InsightWidgetVariant.outOfTrend,
       financialDiaryData = null,
       priceChanges = const [],
       demandTrendData = null,
       transactionTrendData = null;

  const InsightSectionWidget.priceChange({
    super.key,
    required this.priceChanges,
    this.title = 'Price Change',
    this.showSeeAll = true,
    this.onSeeAllTap,
  }) : variant = InsightWidgetVariant.priceChange,
       financialDiaryData = null,
       outOfTrendRows = const [],
       demandTrendData = null,
       transactionTrendData = null;

  const InsightSectionWidget.demandTrend({
    super.key,
    required this.demandTrendData,
    this.title = 'Demand Trend',
    this.showSeeAll = true,
    this.onSeeAllTap,
  }) : variant = InsightWidgetVariant.demandTrend,
       financialDiaryData = null,
       outOfTrendRows = const [],
       priceChanges = const [],
       transactionTrendData = null;

  const InsightSectionWidget.transactionTrend({
    super.key,
    required this.transactionTrendData,
    this.title = 'Transaction Trend',
    this.showSeeAll = true,
    this.onSeeAllTap,
  }) : variant = InsightWidgetVariant.transactionTrend,
       financialDiaryData = null,
       outOfTrendRows = const [],
       priceChanges = const [],
       demandTrendData = null;

  @override
  Widget build(BuildContext context) {
    return DashboardCardContainer(
      title: title,
      showSeeAll: showSeeAll,
      onSeeAllTap: onSeeAllTap,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (variant) {
      case InsightWidgetVariant.financialDiary:
        if (financialDiaryData == null) return const SizedBox.shrink();
        return _FinancialDiaryContent(data: financialDiaryData!);
      case InsightWidgetVariant.outOfTrend:
        return _OutOfTrendContent(rows: outOfTrendRows);
      case InsightWidgetVariant.priceChange:
        return _PriceChangeContent(rows: priceChanges);
      case InsightWidgetVariant.demandTrend:
        if (demandTrendData == null) return const SizedBox.shrink();
        return _DemandTrendContent(data: demandTrendData!);
      case InsightWidgetVariant.transactionTrend:
        if (transactionTrendData == null) return const SizedBox.shrink();
        return _TransactionTrendContent(data: transactionTrendData!);
    }
  }
}

class _FinancialDiaryContent extends StatelessWidget {
  final FinancialDiaryData data;

  const _FinancialDiaryContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(140, 140),
                  painter: _DonutChartPainter(progress: data.progress),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.percentText,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF101828),
                      ),
                    ),
                    Text(
                      data.deltaText,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF475467),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendDot(label: data.costText, color: const Color(0xFFEAECF0)),
                const SizedBox(height: 12),
                _LegendDot(label: data.profitText, color: AppColors.primaryBimaBase),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 2.2,
              color: Color(0xCC000000),
            ),
          ),
        ),
      ],
    );
  }
}

class _OutOfTrendContent extends StatelessWidget {
  final List<TrendTableRowData> rows;

  const _OutOfTrendContent({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InsightTableHeader(),
        const SizedBox(height: 8),
        ...rows.map(
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _tableText(row.item, FontWeight.w500)),
                Expanded(
                  child: Text(
                    row.stockLevel,
                    textAlign: TextAlign.center,
                    style: _tableStyle(FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: row.statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(child: _tableText(row.status, FontWeight.w400)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Text _tableText(String value, FontWeight weight) {
    return Text(value, style: _tableStyle(weight));
  }

  TextStyle _tableStyle(FontWeight weight) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: 10,
      fontWeight: weight,
      height: 1.5,
      color: const Color(0xCC000000),
    );
  }
}

class _InsightTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.brand25,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          Expanded(child: _HeaderLabel(text: 'Item', align: TextAlign.left)),
          Expanded(child: _HeaderLabel(text: 'Stock Level', align: TextAlign.center)),
          Expanded(child: _HeaderLabel(text: 'Status', align: TextAlign.right)),
        ],
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _HeaderLabel({required this.text, required this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Color(0xCC000000),
      ),
    );
  }
}

class _PriceChangeContent extends StatelessWidget {
  final List<PriceChangeRowData> rows;

  const _PriceChangeContent({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.primaryBimaLighter),
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          return Container(
            padding: const EdgeInsets.only(bottom: 10),
            margin: EdgeInsets.only(bottom: index == rows.length - 1 ? 0 : 10),
            decoration: BoxDecoration(
              border: index == rows.length - 1
                  ? null
                  : const Border(
                      bottom: BorderSide(color: AppColors.neutralGreyBase),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.item,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.neutralBlackLighter,
                    ),
                    children: [
                      TextSpan(
                        text: '${row.changeText} ',
                        style: TextStyle(
                          color: row.isUp
                              ? AppColors.systemErrorRedBase
                              : AppColors.systemGreenLight,
                        ),
                      ),
                      const TextSpan(text: 'since last week'),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _DemandTrendContent extends StatelessWidget {
  final DemandTrendData data;

  const _DemandTrendContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.primaryBimaLighter),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.item,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Colors.black,
            ),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.neutralBlackLighter,
              ),
              children: [
                TextSpan(
                  text: '${data.changeText} ',
                  style: TextStyle(
                    color: data.isUp
                        ? AppColors.systemErrorRedBase
                        : AppColors.systemGreenLight,
                  ),
                ),
                const TextSpan(text: 'since last week'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 86,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(points: data.points),
              child: Padding(
                padding: const EdgeInsets.only(left: 22, right: 6, bottom: 2),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: data.labels
                        .map(
                          (label) => Text(
                            label,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 6,
                              color: Color(0x99000000),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTrendContent extends StatelessWidget {
  final TransactionTrendData data;

  const _TransactionTrendContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.primaryBimaLighter),
      ),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: CustomPaint(
        painter: _BarChartPainter(bars: data.bars),
        child: Padding(
          padding: const EdgeInsets.only(left: 22, right: 6, bottom: 2),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: data.labels
                  .map(
                    (label) => Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 6,
                        color: Color(0x99000000),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double progress;

  const _DonutChartPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = const Color(0xFFEAECF0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    final valuePaint = Paint()
      ..color = AppColors.primaryBimaBase
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, bgPaint);
    canvas.drawArc(rect, -math.pi / 2, (math.pi * 2) * progress, false, valuePaint);
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;

  const _LineChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final chartTop = 6.0;
    final chartBottom = size.height - 12;
    final chartLeft = 18.0;
    final chartRight = size.width - 4;
    final chartHeight = chartBottom - chartTop;
    final chartWidth = chartRight - chartLeft;

    final gridPaint = Paint()..color = const Color(0x22000000);
    for (var i = 0; i <= 5; i++) {
      final y = chartTop + chartHeight * (i / 5);
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);
    }

    final axisPaint = Paint()
      ..color = const Color(0x55000000)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      axisPaint,
    );
    canvas.drawLine(Offset(chartLeft, chartTop), Offset(chartLeft, chartBottom), axisPaint);

    if (points.isEmpty) return;
    final maxValue = points.reduce(math.max);
    final minValue = points.reduce(math.min);
    final range = (maxValue - minValue) == 0 ? 1.0 : (maxValue - minValue);

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chartLeft + (chartWidth * i / (points.length - 1));
      final normalized = (points[i] - minValue) / range;
      final y = chartBottom - normalized * chartHeight;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.systemErrorRedBase
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> bars;

  const _BarChartPainter({required this.bars});

  @override
  void paint(Canvas canvas, Size size) {
    final chartTop = 8.0;
    final chartBottom = size.height - 12;
    final chartLeft = 18.0;
    final chartRight = size.width - 4;
    final chartHeight = chartBottom - chartTop;
    final chartWidth = chartRight - chartLeft;

    final gridPaint = Paint()..color = const Color(0x22000000);
    for (var i = 0; i <= 5; i++) {
      final y = chartTop + chartHeight * (i / 5);
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);
    }

    final axisPaint = Paint()
      ..color = const Color(0x55000000)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      axisPaint,
    );
    canvas.drawLine(Offset(chartLeft, chartTop), Offset(chartLeft, chartBottom), axisPaint);

    if (bars.isEmpty) return;
    final maxBar = bars.reduce(math.max);
    final section = chartWidth / bars.length;
    final barWidth = section * 0.28;

    for (var i = 0; i < bars.length; i++) {
      final normalized = maxBar == 0 ? 0.0 : bars[i] / maxBar;
      final h = normalized * (chartHeight - 4);
      final x = chartLeft + section * i + (section - barWidth) / 2;
      final y = chartBottom - h;
      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, h),
        Paint()..color = AppColors.primaryBimaBase,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.bars != bars;
  }
}
