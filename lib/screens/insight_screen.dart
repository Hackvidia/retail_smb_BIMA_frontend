import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/app_bottom_navigation_bar.dart';
import 'package:retail_smb/widgets/insight_section_widget.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  bool _isLoading = true;
  FinancialDiaryData? _financialDiary;
  List<TrendTableRowData> _outOfTrendRows = const [];
  List<PriceChangeRowData> _priceChanges = const [];
  DemandTrendData? _demandTrend;
  TransactionTrendData? _transactionTrend;

  @override
  void initState() {
    super.initState();
    _loadDummyBackendData();
  }

  Future<void> _loadDummyBackendData() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;
    setState(() {
      _financialDiary = const FinancialDiaryData(
        progress: 0.52,
        percentText: '52%',
        deltaText: 'Rp +1,09 M',
        costText: 'Cost (Rp 12,46M)',
        profitText: 'Profit (Rp 13,54M)',
      );
      _outOfTrendRows = const [
        TrendTableRowData(
          item: 'Aqua',
          stockLevel: '20 Cartons',
          status: 'Take it Out',
          statusColor: AppColors.systemErrorRedBase,
        ),
        TrendTableRowData(
          item: 'Indomie\nGoreng',
          stockLevel: '8 Cartons',
          status: 'Good\nPoint!',
          statusColor: AppColors.systemWarningYellowLighter,
        ),
        TrendTableRowData(
          item: 'Teh Botol',
          stockLevel: '10 Cartons',
          status: 'Good\nPoint!',
          statusColor: AppColors.systemWarningYellowLighter,
        ),
      ];
      _priceChanges = const [
        PriceChangeRowData(
          item: 'Indomie Goreng',
          changeText: '+5% (+Rp 700)',
          isUp: true,
        ),
        PriceChangeRowData(
          item: 'Aqua 600ml',
          changeText: '-5% (-Rp 500)',
          isUp: false,
        ),
      ];
      _demandTrend = const DemandTrendData(
        item: 'Indomie Goreng',
        changeText: '+15% (+115pcs)',
        isUp: true,
        points: [
          8,
          8.5,
          9,
          9.2,
          10,
          10.5,
          11,
          12,
          15,
          19,
          24,
          28,
          34,
          42,
          40,
          48,
          52,
          58,
          54,
          70,
        ],
        labels: ['Jul 14', 'Jul 15', 'Jul 16', 'Jul 17', 'Jul 18', 'Jul 19'],
      );
      _transactionTrend = const TransactionTrendData(
        bars: [38, 65, 54, 48],
        labels: ['4 weeks ago', '3 weeks ago', '2 weeks ago', 'This week'],
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBimaLighter,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(27, 18, 27, 120),
                child: Column(
                  children: [
                    _buildSpeechBubbleRow(),
                    const SizedBox(height: 14),
                    InsightSectionWidget.financialDiary(
                      financialDiaryData: _financialDiary!,
                      onSeeAllTap: () =>
                          _showMessage('See all Financial Diary'),
                    ),
                    const SizedBox(height: 12),
                    InsightSectionWidget.outOfTrend(
                      outOfTrendRows: _outOfTrendRows,
                      onSeeAllTap: () => _showMessage('See all Out of Trend'),
                    ),
                    const SizedBox(height: 12),
                    InsightSectionWidget.priceChange(
                      priceChanges: _priceChanges,
                      onSeeAllTap: () => _showMessage('See all Price Change'),
                    ),
                    const SizedBox(height: 12),
                    InsightSectionWidget.demandTrend(
                      demandTrendData: _demandTrend!,
                      onSeeAllTap: () => _showMessage('See all Demand Trend'),
                    ),
                    const SizedBox(height: 12),
                    InsightSectionWidget.transactionTrend(
                      transactionTrendData: _transactionTrend!,
                      onSeeAllTap: () =>
                          _showMessage('See all Transaction Trend'),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-screen');
            return;
          }
          if (index == 2) {
            _showMessage('Profile is not available yet');
          }
        },
      ),
    );
  }

  Widget _buildSpeechBubbleRow() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/bima-icon.png',
            width: 60,
            height: 50,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBimaDarker,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Let's see how your shop is doing this week",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: AppColors.neutralWhiteLighter,
                    ),
                  ),
                ),
                Positioned(
                  left: -8,
                  bottom: 7,
                  child: CustomPaint(
                    size: const Size(12, 12),
                    painter: _SpeechTailPainter(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SpeechTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primaryBimaDarker;
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
