import 'package:crm/features/hr/models/leave_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestLeaveScreen extends StatefulWidget {
  const RequestLeaveScreen({super.key});

  @override
  State<RequestLeaveScreen> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String _selectedType = 'Yıllık İzin';
  final List<String> _types = [
    'Yıllık İzin',
    'Hastalık İzni',
    'Mazeret İzni',
    'Ücretsiz İzin',
  ];

  DateTimeRange? _selectedDateRange;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF000080),
            colorScheme: const ColorScheme.light(primary: Color(0xFF000080)),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tarih aralığı seçin')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturumu bulunamadı');
      }

      // Mevcut çalışanı bul
      final employeeSnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (employeeSnapshot.docs.isEmpty) {
        throw Exception(
          'Personel kaydı bulunamadı. Lütfen yöneticinizle görüşün.',
        );
      }

      final employeeDoc = employeeSnapshot.docs.first;
      final employeeData = employeeDoc.data();
      final employeeName = employeeData['name'] ?? user.email;
      final managerId = employeeData['managerId']; // Yöneticisi kim?

      final request = LeaveRequestModel(
        employeeId: employeeDoc
            .id, // Auth UID yerine Personel Dokümanı ID'si daha güvenli
        employeeName: employeeName,
        type: _selectedType,
        startDate: _selectedDateRange!.start,
        endDate: _selectedDateRange!.end,
        description: _descriptionController.text.trim(),
        status: 'Pending',
        managerId: managerId, // Yöneticisine gönder
      );

      await FirebaseFirestore.instance
          .collection('leave_requests')
          .add(request.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('İzin talebi başarıyla oluşturuldu ✅'),
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
      appBar: AppBar(title: const Text('İzin Talebi Oluştur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // İzin Türü
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'İzin Türü',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _types.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Tarih Seçimi
              InkWell(
                onTap: _pickDateRange,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tarih Aralığı',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  child: Text(
                    _selectedDateRange == null
                        ? 'Seçmek için dokunun'
                        : '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year} (${_selectedDateRange!.duration.inDays + 1} Gün)',
                    style: TextStyle(
                      color: _selectedDateRange == null
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Açıklama
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama / Mazeret',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Açıklama gereklidir' : null,
              ),
              const SizedBox(height: 32),

              // Gönder Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF000080),
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Talebi Gönder',
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
