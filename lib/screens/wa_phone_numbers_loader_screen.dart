import 'package:retail_smb/data-defenition/suplier.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/connect_suplier_widhet.dart';
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
    final hasSelectedSupplier = _selectedSuppliers.contains(true);

    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLighter,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasHeight =
                constraints.maxHeight < 850 ? 850.0 : constraints.maxHeight;
            return SingleChildScrollView(
              child: SizedBox(
                height: canvasHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 48,
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
                        top: 31,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryBimaBase,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0D101828),
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.neutralWhiteLighter,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 63,
                        left: 16,
                        child: Image.asset(
                          'assets/images/bima-icon.png',
                          width: 96,
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 49,
                        right: 0,
                        child: Container(
                          width: 229,
                          height: 76,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBimaDarker,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Select the Supplier you want to connect with',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: Container(
                          width: double.infinity,
                          height: 610,
                          padding: const EdgeInsets.fromLTRB(19, 24, 13, 22),
                          decoration: BoxDecoration(
                            color: AppColors.neutralWhiteLighter,
                            border:
                                Border.all(color: AppColors.primaryBimaLight),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                width: 316,
                                child: Text(
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
                              ),
                              const SizedBox(height: 24),
                              SupplierConnectedList(
                                maxHeight: 400,
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
                                child: ConnectSuplierWidhet(
                                  enabled: hasSelectedSupplier,
                                  onPressed: () {
                                    if (!hasSelectedSupplier) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please select at least one supplier',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.pushReplacementNamed(
                                        context, '/summary-supplier');
                                  },
                                ),
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
          },
        ),
      ),
    );
  }
}
