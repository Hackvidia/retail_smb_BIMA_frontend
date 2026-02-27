import 'package:retail_smb/data-defenition/suplier.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/connect_suplier_widhet.dart';
import 'package:retail_smb/widgets/description_decoration.dart';
import 'package:retail_smb/widgets/hero_widget.dart';
import 'package:retail_smb/widgets/suplier_connected_list.dart';
import 'package:flutter/material.dart';

class WaPhoneNumbersLoaderScreen extends StatefulWidget {
  const WaPhoneNumbersLoaderScreen({super.key});

  @override
  State<WaPhoneNumbersLoaderScreen> createState() =>
      _WaPhoneNumbersLoaderScreenState();
}

class _WaPhoneNumbersLoaderScreenState
    extends State<WaPhoneNumbersLoaderScreen> {
  late final List<Supplier> _suppliers;
  late List<bool> _selectedSuppliers;

  @override
  void initState() {
    super.initState();
    _suppliers = [
      Supplier(
        name: "Toko Sembako Sumber Jaya",
        phone: "(+62) 1234 5678",
        initialValue: true,
      ),
      Supplier(
        name: "Toko Berkah Abadi",
        phone: "(+62) 9876 5432",
      ),
      Supplier(
        name: "Toko Sembako Sumber Jaya",
        phone: "(+62) 1234 5678",
      ),
      Supplier(
        name: "Toko Sembako Sumber Jaya",
        phone: "(+62) 1234 5678",
      ),
      Supplier(
        name: "Toko Sembako Sumber Jaya",
        phone: "(+62) 1234 5678",
      ),
      Supplier(
        name: "Toko Sembako Sumber Jaya",
        phone: "(+62) 1234 5678",
      ),
    ];
    _selectedSuppliers =
        _suppliers.map((supplier) => supplier.initialValue).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Stack(
            children: [
              Positioned(
                top: 90,
                child: Container(
                  width: 360,
                  height: 360,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBimaLighter,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const HeroWidget(),
              const DescriptionDecoration(
                content: 'Select the Supplier you want to connect with',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 175),
                child: Container(
                  width: double.infinity,
                  height: AppSize.height(context, 0.69),
                  padding: const EdgeInsets.fromLTRB(19, 24, 19, 20),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhiteLighter,
                    border: Border.all(color: AppColors.primaryBimaLight),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'BIMA only reads chats with the suppliers you select here',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      SupplierConnectedList(
                        maxHeight: AppSize.height(context, 0.43),
                        suppliers: _suppliers,
                        selectedValues: _selectedSuppliers,
                        onChanged: (index, value) {
                          setState(() {
                            _selectedSuppliers[index] = value;
                          });
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ConnectSuplierWidhet(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
