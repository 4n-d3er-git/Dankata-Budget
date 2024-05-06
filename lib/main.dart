
import 'package:budget_odc/Page/onBoarding/on_boarding_page.dart';
import 'package:budget_odc/splash_screen.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/bottomnevbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  runApp(const ProjetApp());
}

class ProjetApp extends StatelessWidget {
  const ProjetApp({Key? key}) : super(key: key);

  // Méthode pour initialiser Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: isUserLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MaterialApp(
                 debugShowCheckedModeBanner: false,
                  home: 
                  SplashScreen(),
                //   Scaffold(
                // body: Center(
                //           child: Text(
                //         "Dankata Budget",
                //         style: TextStyle(color: vert, fontSize: 30),
                //       ))),
                );
              } else {
                if (snapshot.data == true) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: "Dankata Budget",
                    home: SplashScreen(),
                  //  home: BottomNavBar(),
                  );
                } else {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: SplashScreen(),
                    // home: OnBoardingPage(),
                  );
                }
              }
            },
          );
        } else {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
                  home: 
                  SplashScreen(),
                //   Scaffold(
                // body: Center(
                //     child: Text(
                //   "Dankata Budget",
                //   style: TextStyle(color: vert, fontSize: 30),
                // ))),
          );
        }
      },
    );
  }
}
