import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masraf Yönetimi')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Masraf Girişi ve Onayları\n(Yapım Aşamasında)',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
