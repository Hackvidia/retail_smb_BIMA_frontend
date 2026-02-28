import 'package:flutter/material.dart';
import 'package:retail_smb/models/starter_screen_args.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/app_bottom_navigation_bar.dart';
import 'package:retail_smb/widgets/quick_action_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToAction(String title) {
    if (title == 'Add Data') {
      Navigator.pushNamed(
        context,
        '/starter-app',
        arguments: const StarterScreenArgs(mode: StarterEntryMode.returning),
      );
      return;
    }
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _DummyActionScreen(title: title)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBimaLighter,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 14, 26, 120),
          child: Column(
            children: [
              _buildLevelBanner(),
              const SizedBox(height: 20),
              _buildSpeechBubbleRow(),
              const SizedBox(height: 14),
              DashboardSectionWidget.quickAction(
                quickActions: [
                  QuickActionMenuItem(
                    title: 'Add Data',
                    assetPath: 'assets/images/bima-icon.png',
                    onTap: () => _navigateToAction('Add Data'),
                  ),
                  QuickActionMenuItem(
                    title: 'Activity',
                    assetPath: 'assets/images/sm-icon.png',
                    onTap: () => _navigateToAction('Activity'),
                  ),
                  QuickActionMenuItem(
                    title: 'One Tap Order',
                    assetPath: 'assets/images/puzzle-piece-icon.png',
                    onTap: () => _navigateToAction('One Tap Order'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const DashboardSectionWidget.businessHealth(
                businessHealthItems: [
                  BusinessHealthItem(
                    prefixText: 'You order the most often ',
                    highlightedText: 'Indomie goreng',
                    markerColor: AppColors.systemGreenBase,
                  ),
                  BusinessHealthItem(
                    prefixText: 'You almost forgot to order ',
                    highlightedText: 'Indomie goreng',
                    markerColor: AppColors.systemWarningYellowLighter,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DashboardSectionWidget.prioritazionAction(
                prioritazionAction: PrioritazionActionData(
                  itemName: 'Indomie 3 Boxes',
                  actionText: 'order tomorrow',
                  dateText: 'Friday: 30 Jan 2026',
                  onPrimaryTap: () => _showActionMessage('Snooze clicked'),
                  onSecondaryTap: () => _showActionMessage('Chat clicked'),
                ),
                onSeeAllTap: () => _showActionMessage('See all prioritazion'),
              ),
              const SizedBox(height: 12),
              DashboardSectionWidget.stockOverview(
                onSeeAllTap: () => _showActionMessage('See all stock overview'),
                overviewRows: const [
                  OverviewRowData(
                    item: 'Aqua',
                    value: '20 Cartons',
                    status: 'On Track',
                    statusColor: AppColors.primaryBimaBase,
                  ),
                  OverviewRowData(
                    item: 'Indomie\nGoreng',
                    value: '8 Cartons',
                    status: 'Running\nLow',
                    statusColor: AppColors.systemWarningYellowLighter,
                  ),
                  OverviewRowData(
                    item: 'Teh Botol',
                    value: '0 Cartons',
                    status: 'Out of\nStock',
                    statusColor: AppColors.systemErrorRedBase,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DashboardSectionWidget.weeklySales(
                onSeeAllTap: () => _showActionMessage('See all weekly sales'),
                overviewRows: const [
                  OverviewRowData(
                    item: 'Aqua',
                    value: '20 Cartons',
                    status: 'On Track',
                    statusColor: AppColors.primaryBimaBase,
                  ),
                  OverviewRowData(
                    item: 'Indomie\nGoreng',
                    value: '8 Cartons',
                    status: 'Running\nLow',
                    statusColor: AppColors.systemWarningYellowLighter,
                  ),
                  OverviewRowData(
                    item: 'Teh Botol',
                    value: '0 Cartons',
                    status: 'Out of\nStock',
                    statusColor: AppColors.systemErrorRedBase,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/insight-screen');
            return;
          }
          if (index == 2) {
            _showActionMessage('Profile is not available yet');
          }
        },
      ),
    );
  }

  Widget _buildLevelBanner() {
    return Container(
      width: double.infinity,
      height: 49,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryBimaBase,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryBimaLight),
      ),
      child: Row(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: 'Lv. '),
                TextSpan(
                    text: 'Beginner',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.neutralWhiteBase,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 29,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBimaLight,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                    'See the condition of your shop today',
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

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DummyActionScreen extends StatelessWidget {
  final String title;

  const _DummyActionScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Screen (Dummy)',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
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
