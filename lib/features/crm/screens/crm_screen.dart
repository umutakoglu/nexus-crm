import 'package:flutter/material.dart';

class CRMScreen extends StatelessWidget {
  const CRMScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRM Modülü')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_alt, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Müşteri İlişkileri Yönetimi\n(Yapım Aşamasında)',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
