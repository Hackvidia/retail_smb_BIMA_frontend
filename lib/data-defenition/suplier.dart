class Supplier {
  final String name;
  final String phone;
  final bool initialValue;

  Supplier({
    required this.name,
    required this.phone,
    this.initialValue = false,
  });
}