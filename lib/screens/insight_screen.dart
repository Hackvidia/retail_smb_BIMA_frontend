import 'package:flutter/material.dart';
import 'package:retail_smb/services/financial_diary_service.dart';
import 'package:retail_smb/state/app_session_state.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/app_bottom_navigation_bar.dart';
import 'package:retail_smb/widgets/insight_section_widget.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  final FinancialDiaryService _financialDiaryService = FinancialDiaryService();

  bool _isLoading = true;
  FinancialDiaryData? _financialDiary;
  List<TrendTableRowData> _outOfTrendRows = const [];
  List<TrendTableRowData> _stockOverviewRows = const [];
  String _headlineTitle = "Let's see how your shop is doing this week";

  @override
  void initState() {
    super.initState();
    _loadOverview();
  }

  Future<void> _loadOverview() async {
    try {
      await AppSessionState.instance.hydrate();
      final token = AppSessionState.instance.authToken;
      if (token == null || token.trim().isEmpty) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        return;
      }

      final data =
          await _financialDiaryService.fetchOverview(token: token.trim());
      if (!mounted) return;
      if (data == null) {
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _headlineTitle = data.headlineTitle;
        _financialDiary = FinancialDiaryData(
          progress: data.progressPercent / 100,
          percentText: '${data.progressPercent}%',
          deltaText: data.deltaText,
          costText: data.costText,
          profitText: data.profitText,
        );
        _outOfTrendRows = data.outOfTrendRows
            .map(
              (row) => TrendTableRowData(
                item: row.itemName.isEmpty ? '-' : row.itemName,
                stockLevel: row.stockLevel.isEmpty ? '-' : row.stockLevel,
                status: row.status.isEmpty ? '-' : row.status,
                statusColor: _statusColor(row.status),
              ),
            )
            .toList();
        _stockOverviewRows = data.stockOverviewRows
            .map(
              (row) => TrendTableRowData(
                item: row.itemName.isEmpty ? '-' : row.itemName,
                stockLevel: row.stockLevel.isEmpty ? '-' : row.stockLevel,
                status: _normalizeStatusLabel(row.status),
                statusColor: _statusColor(row.status),
              ),
            )
            .toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
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
                    if (_financialDiary != null)
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
                    InsightSectionWidget.outOfTrend(
                      title: 'Stock Overview',
                      outOfTrendRows: _stockOverviewRows,
                      onSeeAllTap: () => _showMessage('See all Stock Overview'),
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
                  constraints: const BoxConstraints(minHeight: 58),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBimaDarker,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _headlineTitle,
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

  String _normalizeStatusLabel(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'on_track' || normalized == 'on track') {
      return 'On Track';
    }
    if (normalized == 'running_low' || normalized == 'running low') {
      return 'Running Low';
    }
    if (normalized == 'out_of_stock' || normalized == 'out of stock') {
      return 'Out of Stock';
    }
    return status.isEmpty ? '-' : status;
  }

  Color _statusColor(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'take it out' ||
        normalized == 'out_of_stock' ||
        normalized == 'out of stock') {
      return AppColors.systemErrorRedBase;
    }
    if (normalized == 'good point!' ||
        normalized == 'running_low' ||
        normalized == 'running low') {
      return AppColors.systemWarningYellowLighter;
    }
    return AppColors.primaryBimaBase;
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
