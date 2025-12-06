//```
import 'package:crm/features/crm/models/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _authorizedPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _taxIdController = TextEditingController();

  bool _isLoading = false;
  bool _isCorporate = true; // Varsayılan kurumsal

  @override
  void dispose() {
    _companyNameController.dispose();
    _authorizedPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final customer = CustomerModel(
        isCorporate: _isCorporate,
        companyName: _isCorporate ? _companyNameController.text.trim() : null,
        authorizedPerson: _authorizedPersonController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        taxId: _taxIdController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('customers')
          .add(customer.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Müşteri başarıyla kaydedildi')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Müşteri Ekle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Müşteri Tipi Seçimi
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Kurumsal'),
                    icon: Icon(Icons.business),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Bireysel'),
                    icon: Icon(Icons.person),
                  ),
                ],
                selected: {_isCorporate},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isCorporate = newSelection.first;
                    // Tipi değişince controller'ları temizlemek isteyebiliriz ama şimdilik kalsın
                  });
                },
              ),
              const SizedBox(height: 24),

              // Firma Adı (Sadece Kurumsal ise görünür)
              if (_isCorporate) ...[
                TextFormField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Firma Adı',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_isCorporate && (value == null || value.isEmpty)) {
                      return 'Firma adı gereklidir';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Yetkili Kişi
              TextFormField(
                controller: _authorizedPersonController,
                decoration: const InputDecoration(
                  labelText: 'Yetkili Adı Soyadı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Yetkili adı gereklidir' : null,
              ),
              const SizedBox(height: 16),

              // E-posta
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta gereklidir';
                  }
                  // Basit Email Regex
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Geçerli bir e-posta giriniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Telefon
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Telefon gereklidir' : null,
              ),
              const SizedBox(height: 16),

              // Vergi No / TC No
              TextFormField(
                controller: _taxIdController,
                decoration: InputDecoration(
                  labelText: _isCorporate ? 'Vergi Numarası' : 'TC Kimlik No',
                  border: const OutlineInputBorder(),
                  counterText: "", // Altındaki karakter sayacını gizle
                ),
                keyboardType: TextInputType.number,
                maxLength: _isCorporate ? 10 : 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kimlik numarası gereklidir';
                  }
                  if (_isCorporate && value.length != 10) {
                    return 'Vergi numarası 10 haneli olmalıdır';
                  }
                  if (!_isCorporate && value.length != 11) {
                    return 'TC Kimlik numarası 11 haneli olmalıdır';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Adres
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Adres gereklidir' : null,
              ),
              const SizedBox(height: 32),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCustomer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Kaydet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
