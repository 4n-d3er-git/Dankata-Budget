import 'package:budget_odc/Page/auth_Page/inscription.dart';
import 'package:budget_odc/Page/budget_page/budget_annee/ajouter_budget_annee.dart';
import 'package:budget_odc/Page/budget_page/budget_semaine/ajouter_budget_semain.dart';
import 'package:budget_odc/Page/budget_page/budget_semaine/budget_semaine.dart';
import 'package:budget_odc/Page/home_Page/home_page.dart';
import 'package:budget_odc/Page/onBoarding/on_boarding_page.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/bottomnevbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const ProjetApp());
}

// class ProjetApp extends StatelessWidget {
//   const ProjetApp({super.key});
// Future<void> initializeFirebase() async{

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return  FutureBuilder(future: initializeFirebase(), builder: (context , snapshot){
//       if(snapshot.connectionState == ConnectionState.done){
//         return StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot){
//           if(snapshot.hasData){
//             return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Gestion de Budget",
//       home:
//       // AjouterAnnee(),
//       BottomNavBar(),
//       // HomePage(),
//     );
//       } else{
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: OnBoardingPage(),
//         );
//           }
//         });
//       } return Center(child: CircularProgressIndicator(color: vert,));
//     });

//   }
// }

// Importez votre OnBoardingPage

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
                  home: Scaffold(
                body: Center(
                          child: Text(
                        "Gestion de Budget",
                        style: TextStyle(color: vert, fontSize: 30),
                      ))),
                );
              } else {
                if (snapshot.data == true) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: "Gestion de Budget",
                    home: BottomNavBar(),
                  );
                } else {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: OnBoardingPage(),
                  );
                }
              }
            },
          );
        } else {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
                  home: Scaffold(
                body: Center(
                    child: Text(
                  "Gestion de Budget",
                  style: TextStyle(color: vert, fontSize: 30),
                ))),
          );
        }
      },
    );
  }
}
