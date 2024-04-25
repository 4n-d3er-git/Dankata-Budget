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
      home: const GestionBudget(),
    );
  }
}

class GestionBudget extends StatefulWidget {
  const GestionBudget({
    super.key,
  });

  @override
  State<GestionBudget> createState() => _GestionBudgetState();
}

class _GestionBudgetState extends State<GestionBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion de Budget"),
      ),
      body: Center(child: Text("Gestion de Budget")),
    );
  }
}
