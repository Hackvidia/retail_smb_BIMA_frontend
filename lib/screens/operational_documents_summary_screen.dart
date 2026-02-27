import 'package:flutter/material.dart';
import 'package:retail_smb/models/operational_document_item.dart';
import 'package:retail_smb/theme/color_schema.dart';

class OperationalDocumentsSummaryScreen extends StatefulWidget {
  const OperationalDocumentsSummaryScreen({super.key});

  @override
  State<OperationalDocumentsSummaryScreen> createState() =>
      _OperationalDocumentsSummaryScreenState();
}

class _OperationalDocumentsSummaryScreenState
    extends State<OperationalDocumentsSummaryScreen> {
  List<OperationalDocumentItem> _documents = const [];
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is OperationalDocumentsSummaryArgs &&
        args.uploadedDocuments.isNotEmpty) {
      _documents = args.uploadedDocuments;
    } else {
      _documents = const [
        OperationalDocumentItem(
          type: 'Product price list',
          fileName: 'Pricelist Bulan Januari.doc',
          sizeLabel: '19,05 MB',
        ),
      ];
    }
  }

  List<_PricingRow> _buildRows() {
    if (_documents.any((d) => d.type == 'Product price list')) {
      return const [
        _PricingRow(item: 'Aqua', stockType: 'Cartons', price: 20000),
        _PricingRow(item: 'Indomie Goreng', stockType: 'Cartons', price: 24000),
        _PricingRow(item: 'Teh Botol', stockType: 'Cartons', price: 30000),
      ];
    }

    return _documents
        .asMap()
        .entries
        .map(
          (entry) => _PricingRow(
            item: _shortenName(entry.value.fileName),
            stockType: _mapTypeToStock(entry.value.type),
            price: 18000 + (entry.key * 3500),
          ),
        )
        .toList();
  }

  String _shortenName(String fileName) {
    final plain = fileName.replaceAll('.doc', '');
    return plain.length <= 15 ? plain : '${plain.substring(0, 15)}...';
  }

  String _mapTypeToStock(String type) {
    switch (type) {
      case 'Daily sales':
        return 'Daily';
      case 'Product price list':
        return 'Cartons';
      case 'Operational expenditures':
        return 'Monthly';
      case 'Capital expenditures':
        return 'Assets';
      default:
        return 'General';
    }
  }

  String _formatRupiah(int value) => 'Rp $value';

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows();

    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 370,
              child: Stack(
                children: [
                  Positioned(
                    left: 18,
                    top: 106,
                    child: Container(
                      width: 360,
                      height: 360,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBimaLighter,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 62,
                    child: _backButton(),
                  ),
                  Positioned(
                    left: 26,
                    right: 0,
                    top: 95,
                    child: _bubbleAndMascot(),
                  ),
                  Positioned(
                    top: 219,
                    left: 0,
                    right: 0,
                    child: _mainContainer(rows),
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
      height: 96,
      child: Stack(
        children: [
          Positioned(
            left: 86,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryBimaDarker,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Summary of reading your sales & cost records!',
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
              'assets/images/bima-icon.png',
              width: 95,
              height: 95,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainContainer(List<_PricingRow> rows) {
    return Container(
      width: 361,
      height: 620,
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
          _pricingCard(rows),
          const SizedBox(height: 28),
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
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/home-screen'),
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
                  fontSize: 30 / 2,
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

  Widget _pricingCard(List<_PricingRow> rows) {
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
              children: const [
                Expanded(
                  child: Text(
                    'Product Pricing',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22 / 2,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
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
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    'Item',
                    style: _headerStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Type of stocks',
                    style: _headerStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Price',
                    textAlign: TextAlign.right,
                    style: _headerStyle,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              children: rows
                  .map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              row.item,
                              style: _rowStyle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row.stockType,
                              style: _rowStyle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _formatRupiah(row.price),
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

class _PricingRow {
  final String item;
  final String stockType;
  final int price;

  const _PricingRow({
    required this.item,
    required this.stockType,
    required this.price,
  });
}
