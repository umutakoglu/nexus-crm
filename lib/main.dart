/*import 'package:crm/core/theme/app_theme.dart';
import 'package:crm/features/auth/presentation/login_screen.dart';
// import 'package:crm/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // Note: Firebase initialization is commented out until the user provides the actual configuration in firebase_options.dart
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CorporateNexus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // EKLENDİ
import 'firebase_options.dart'; // EKLENDİ (Otomatik oluşan dosya)

// main fonksiyonunu "async" yapıyoruz çünkü Firebase'in açılmasını bekleyecek
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Motoru ısıtıyoruz
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // İşte o sihirli ayar!
  );

  runApp(const BenimUygulamam());
}

class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Nexus CRM")),
        body: const Center(
          child: Text(
            "Firebase Başarıyla Bağlandı! 🚀",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}