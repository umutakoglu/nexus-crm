class CustomerModel {
  final String? id;
  final String? companyName;
  final String authorizedPerson;
  final String email;
  final String phone;
  final String address;
  final String taxId;
  final bool isCorporate;

  CustomerModel({
    this.id,
    this.companyName,
    required this.authorizedPerson,
    required this.email,
    required this.phone,
    required this.address,
    required this.taxId,
    required this.isCorporate,
  });

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'authorizedPerson': authorizedPerson,
      'email': email,
      'phone': phone,
      'address': address,
      'taxId': taxId,
      'isCorporate': isCorporate,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map, String id) {
    return CustomerModel(
      id: id,
      companyName: map['companyName'],
      authorizedPerson: map['authorizedPerson'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      taxId: map['taxId'] ?? '',
      isCorporate: map['isCorporate'] ?? true,
    );
  }
}
