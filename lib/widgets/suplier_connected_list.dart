import 'package:retail_smb/data-defenition/suplier.dart';
import 'package:flutter/material.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'supplier_connected_card.dart';

class SupplierConnectedList extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Scrollbar(
        thumbVisibility: true,
        radius: const Radius.circular(20),
        thickness: 6,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: suppliers.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: AppSize.width(context, 0.03)),
          itemBuilder: (context, index) => SupplierConnectedCard(
            name: suppliers[index].name,
            phone: suppliers[index].phone,
            isChecked: selectedValues[index],
            onChanged: (value) {
              onChanged?.call(index, value);
            },
          ),
        ),
      ),
    );
  }
}
