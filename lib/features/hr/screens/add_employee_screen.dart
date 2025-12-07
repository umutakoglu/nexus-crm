import 'package:crm/features/hr/models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _ibanController = TextEditingController();

  String _selectedRole = 'Staff'; // Varsayılan rol
  final List<String> _roles = ['Admin', 'Manager', 'Staff'];

  // Yönetici Seçimi için
  String? _selectedManagerId;
  String? _selectedManagerName;
  List<EmployeeModel> _availableManagers = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchManagers();
  }

  Future<void> _fetchManagers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('role', whereIn: ['Admin', 'Manager'])
          .get();

      setState(() {
        _availableManagers = snapshot.docs
            .map((doc) => EmployeeModel.fromMap(doc.data(), doc.id))
            .toList();
      });
    } catch (e) {
      print('Yöneticiler çekilemedi: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final employee = EmployeeModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        department: _departmentController.text.trim(),
        iban: _ibanController.text.trim(),
        startDate: DateTime.now(), // Şimdilik bugünü alıyoruz
        remainingLeaveDays: 14, // Standart başlangıç
        managerId: _selectedManagerId,
        managerName: _selectedManagerName,
      );

      await FirebaseFirestore.instance
          .collection('employees')
          .add(employee.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personel başarıyla eklendi ✅'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
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
      appBar: AppBar(title: const Text('Yeni Personel Ekle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ad soyad gereklidir' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'E-posta gereklidir' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Telefon gereklidir' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.admin_panel_settings),
                ),
                items: _roles.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Yönetici Seçimi (Opsiyonel)
              DropdownButtonFormField<String>(
                value: _selectedManagerId,
                decoration: const InputDecoration(
                  labelText: 'Bağlı Olduğu Yönetici',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.supervisor_account),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Yönetici Yok'),
                  ),
                  ..._availableManagers.map((manager) {
                    return DropdownMenuItem(
                      value: manager.id,
                      child: Text('${manager.name} (${manager.role})'),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedManagerId = value;
                    if (value != null) {
                      final manager = _availableManagers.firstWhere(
                        (m) => m.id == value,
                      );
                      _selectedManagerName = manager.name;
                    } else {
                      _selectedManagerName = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Departman',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Departman gereklidir' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _ibanController,
                decoration: const InputDecoration(
                  labelText: 'IBAN',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveEmployee,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF000080),
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
