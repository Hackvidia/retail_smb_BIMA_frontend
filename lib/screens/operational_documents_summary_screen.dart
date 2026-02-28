import 'package:flutter/material.dart';
import 'package:retail_smb/models/operational_document_item.dart';
import 'package:retail_smb/models/starter_screen_args.dart';
import 'package:retail_smb/services/document_extract_service.dart';
import 'package:retail_smb/state/app_session_state.dart';
import 'package:retail_smb/theme/color_schema.dart';

class OperationalDocumentsSummaryScreen extends StatefulWidget {
  const OperationalDocumentsSummaryScreen({super.key});

  @override
  State<OperationalDocumentsSummaryScreen> createState() =>
      _OperationalDocumentsSummaryScreenState();
}

class _OperationalDocumentsSummaryScreenState
    extends State<OperationalDocumentsSummaryScreen> {
  final DocumentExtractService _extractService = DocumentExtractService();

  bool _isInitialized = false;
  bool _isLoading = true;
  String? _errorMessage;

  List<DocumentExtractionRef> _extractionRefs = const [];
  List<DocumentSummaryData> _cards = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is OperationalDocumentsSummaryArgs && args.extractionRefs.isNotEmpty) {
      _extractionRefs = args.extractionRefs;
      _loadSummaries();
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage = 'No extraction references found. Please upload docs again.';
    });
  }

  Future<void> _loadSummaries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AppSessionState.instance.hydrate();
      final token = AppSessionState.instance.authToken;
      if (token == null || token.trim().isEmpty) {
        throw Exception('Session expired. Please login again.');
      }

      final List<DocumentSummaryData> cards = [];
      for (final ref in _extractionRefs) {
        final summary = await _extractService.fetchSummary(
          type: ref.type,
          extractionId: ref.extractionId,
          token: token,
        );
        cards.add(summary);
      }

      if (!mounted) return;
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _onContinue() {
    if (AppSessionState.instance.isFirstTimeInput) {
      Navigator.pushReplacementNamed(
        context,
        '/starter-app',
        arguments: const StarterScreenArgs(mode: StarterEntryMode.firstTime),
      );
      return;
    }
    Navigator.pushReplacementNamed(context, '/insight-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 412,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _backButton(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 8, 26, 0),
                    child: _bubbleAndMascot(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 12, 26, 24),
                    child: _mainContainer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryBimaBase,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D101828),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _bubbleAndMascot() {
    return SizedBox(
      width: 361,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 104,
            top: 0,
            child: Container(
              width: 229,
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryBimaDarker,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Summary of reading your\nsales & cost records!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                  color: AppColors.neutralWhiteLighter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: -4,
            child: Image.asset(
              'assets/images/bima-left-icon.png',
              width: 95,
              height: 95,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainContainer() {
    return Container(
      width: 361,
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.neutralWhiteLighter,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.primaryBimaLight),
      ),
      child: Column(
        children: [
          const Text(
            'Summary your\nOperational Records!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 18),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            )
          else if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE42B3B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _loadSummaries,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 360,
              child: ListView.separated(
                itemCount: _cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _summaryCard(_cards[index]),
              ),
            ),
          const SizedBox(height: 20),
          const Text.rich(
            TextSpan(
              text: 'This is just ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.neutralBlackBase,
              ),
              children: [
                TextSpan(
                  text: 'an initial summary',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBimaDark,
                  ),
                ),
                TextSpan(text: ' dari BIMA for you. BIMA will '),
                TextSpan(
                  text: 'become more accurate\nas more data is added',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBimaDark,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBimaBase,
                foregroundColor: AppColors.neutralWhiteLighter,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(DocumentSummaryData card) {
    final rows = card.rows;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.primaryBimaLight),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    card.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Text(
                  'See all',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.neutralBlackLighter,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.brand25,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Row(
              children: [
                Expanded(child: Text('Item', style: _headerStyle)),
                Expanded(child: Text('Type of stocks', style: _headerStyle)),
                Expanded(
                  child: Text('Price', textAlign: TextAlign.right, style: _headerStyle),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: rows.isEmpty
                ? const Text(
                    'No items found from extraction.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.neutralBlackBase,
                    ),
                  )
                : Column(
                    children: rows
                        .map(
                          (row) => Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(row.item, style: _rowStyle)),
                                Expanded(
                                  child: Text(row.stockType, style: _rowStyle),
                                ),
                                Expanded(
                                  child: Text(
                                    row.price,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      color: AppColors.primaryBimaDarker,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

const TextStyle _headerStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 10,
  fontWeight: FontWeight.w400,
  height: 1.5,
  color: Color(0xCC000000),
);

const TextStyle _rowStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 10,
  fontWeight: FontWeight.w500,
  height: 1.5,
  color: Color(0xCC000000),
);
