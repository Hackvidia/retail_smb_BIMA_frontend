import 'package:flutter/material.dart';
import 'package:retail_smb/models/starter_screen_args.dart';
import 'package:retail_smb/services/home_overview_service.dart';
import 'package:retail_smb/state/app_session_state.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/app_bottom_navigation_bar.dart';
import 'package:retail_smb/widgets/dashboard_card_container.dart';
import 'package:retail_smb/widgets/quick_action_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeOverviewService _homeOverviewService = HomeOverviewService();

  List<BusinessHealthItem> _businessHealthItems = const [
    BusinessHealthItem(
      prefixText: 'Your stock of ',
      highlightedText: 'Indomie goreng',
      suffixText: ' was safe!',
      markerColor: AppColors.systemGreenBase,
    ),
    BusinessHealthItem(
      prefixText: 'You almost forgot to order ',
      highlightedText: 'Indomie goreng',
      markerColor: AppColors.systemWarningYellowLighter,
    ),
  ];
  String _reminderTitle = 'Tepung Serbaguna is Overstock';
  String _reminderMessage =
      "It's been more than 3 months since stock hasn't decreased";

  @override
  void initState() {
    super.initState();
    _loadBusinessHealth();
  }

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

  Future<void> _loadBusinessHealth() async {
    try {
      await AppSessionState.instance.hydrate();
      final token = AppSessionState.instance.authToken;
      if (token == null || token.trim().isEmpty) return;

      final data =
          await _homeOverviewService.fetchBusinessHealth(token: token.trim());
      if (!mounted || data == null) return;

      setState(() {
        _reminderTitle = data.warningItemName.isEmpty
            ? _reminderTitle
            : data.warningItemName;
        _reminderMessage = data.warningMessage.isEmpty
            ? _reminderMessage
            : data.warningMessage;
        _businessHealthItems = [
          _buildBusinessHealthItem(
            itemName: data.safeItemName,
            message: data.safeMessage,
            markerColor: AppColors.systemGreenBase,
          ),
          _buildBusinessHealthItem(
            itemName: data.warningItemName,
            message: data.warningMessage,
            markerColor: AppColors.systemWarningYellowLighter,
          ),
        ];
      });
    } catch (_) {
      // Keep defaults when API fails.
    }
  }

  BusinessHealthItem _buildBusinessHealthItem({
    required String itemName,
    required String message,
    required Color markerColor,
  }) {
    if (itemName.isNotEmpty && message.contains(itemName)) {
      final split = message.split(itemName);
      final prefix = split.isNotEmpty ? split.first : '';
      final suffix = split.length > 1 ? split.sublist(1).join(itemName) : '';
      return BusinessHealthItem(
        prefixText: prefix,
        highlightedText: itemName,
        suffixText: suffix,
        markerColor: markerColor,
      );
    }
    return BusinessHealthItem(
      prefixText: message.isEmpty ? '' : '$message ',
      highlightedText: itemName.isEmpty ? '-' : itemName,
      markerColor: markerColor,
    );
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
                ],
              ),
              const SizedBox(height: 12),
              _buildReminderCard(),
              const SizedBox(height: 12),
              DashboardSectionWidget.businessHealth(
                businessHealthItems: _businessHealthItems,
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
            'assets/images/sm-icon.png',
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

  Widget _buildReminderCard() {
    return DashboardCardContainer(
      title: 'Reminder',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primaryBimaLighter),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _reminderTitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 34 / 2,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _reminderMessage,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: AppColors.neutralBlackLighter,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _showActionMessage('Detail clicked'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(74, 36),
                    side: const BorderSide(color: AppColors.primaryBimaBase),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Detail',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 24 / 2,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBimaBase,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showActionMessage('Take out now clicked'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(108, 36),
                    backgroundColor: AppColors.primaryBimaBase,
                    foregroundColor: AppColors.neutralWhiteLighter,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Take out now',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 24 / 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
