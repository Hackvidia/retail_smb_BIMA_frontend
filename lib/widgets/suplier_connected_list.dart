import 'package:retail_smb/data-defenition/suplier.dart';
import 'package:flutter/material.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'supplier_connected_card.dart';

class SupplierConnectedList extends StatefulWidget {
  final List<Supplier> suppliers;
  final List<bool> selectedValues;
  final Function(int index, bool value)? onChanged;
  final double maxHeight;
  const SupplierConnectedList({
    super.key,
    required this.suppliers,
    required this.selectedValues,
    required this.maxHeight,
    this.onChanged,
  }) : assert(
          suppliers.length == selectedValues.length,
          'suppliers and selectedValues must have the same length',
        );

  @override
  State<SupplierConnectedList> createState() => _SupplierConnectedListState();
}

class _SupplierConnectedListState extends State<SupplierConnectedList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxHeight,
      child: RawScrollbar(
        controller: _scrollController,
        thumbColor: AppColors.primaryBimaBase,
        trackVisibility: false,
        thumbVisibility: true,
        radius: const Radius.circular(16),
        thickness: 6,
        minThumbLength: 44,
        child: ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          itemCount: widget.suppliers.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: AppSize.width(context, 0.03)),
          itemBuilder: (context, index) => SupplierConnectedCard(
            name: widget.suppliers[index].name,
            phone: widget.suppliers[index].phone,
            isChecked: widget.selectedValues[index],
            onChanged: (value) {
              widget.onChanged?.call(index, value);
            },
          ),
        ),
      ),
    );
  }
}
