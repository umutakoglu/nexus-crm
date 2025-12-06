import 'package:flutter/material.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İzin Yönetimi')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'İzin Talepleri ve Onayları\n(Yapım Aşamasında)',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
