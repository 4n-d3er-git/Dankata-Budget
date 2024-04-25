import 'package:budget_odc/Page/auth_Page/inscription.dart';
import 'package:budget_odc/Page/onBoarding/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProjetApp());
}

class ProjetApp extends StatelessWidget {
  const ProjetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gestion de Budget",
      home:  OnBoardingPage(),
    );
  }
}
