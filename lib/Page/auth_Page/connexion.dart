
import 'package:budget_odc/Page/auth_Page/mot_de_passs_oublie.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/bottomnevbar.dart';
import 'package:budget_odc/widgets/chargement.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:budget_odc/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  // les controlleurs pour les champs de saisie
  TextEditingController emailController = TextEditingController();
  TextEditingController motDePasseController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // le chargement
  bool chargement = false;

// fonction de connexion
  void connexion() async {
    final email = emailController.text.trim();
    final password = motDePasseController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      

      try {
        setState(() {
        chargement = true;
      });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
         // Stockage de l'état de connexion dans SharedPreferences
         //cache
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        // naviguer vers la page principale
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return const BottomNavBar();
        }));
        montrerSnackBar("Content de vous revoir !", context);
        emailController.clear();
        motDePasseController.clear();
        // les exceptions
      } on FirebaseAuthException catch (e) {
        // print(e.code);
        if (e.code == "user-not-found") {
          montrerErreurSnackBar("Utilisateur non trouvé, veuillez vous inscrire",  context);
        } else if (e.code == "wrong-password") {
          montrerErreurSnackBar("Mot de Pass incorrecte",  context);
        } else if (e.code == 'email-already-in-use') {
          montrerErreurSnackBar("Cet email est déjà utilisé",  context);
        } else if (e.code == 'invalid-email') {
          montrerErreurSnackBar("Adresse email invalide",  context);
        }  else if (e.code == 'too-many-requests') {
         montrerErreurSnackBar("Vous avez fait assez de tentative, veuillez réessayer plus tard",  context);
        } else if (e.code == 'user-disabled') {
          montrerErreurSnackBar("Cet utilisateur à été désactivé, veuillez contacter un administrateur",  context);
        } else if (e.code == 'operation-not-allowed') {
          montrerErreurSnackBar("Opération non allouée",  context);
        } else if (e.code == 'invalid-credential') {
          montrerErreurSnackBar("Erreur de connexion",  context);
        } else if (e.code == 'account-exists-with-different-credential') {
          montrerErreurSnackBar("Erreur de connexion",  context);
        } else if (e.code == 'network-request-failed') {
          montrerErreurSnackBar("Impossible de se connecter, veuillez vérifier votre connexion internet",  context);
        }
      } catch (e) {
        montrerErreurSnackBar("$e", context);
      } finally {
        setState(() {
          chargement = false;
        });
      }
    } 
  }
@override
  void initState() {
    emailController = TextEditingController();
    motDePasseController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    motDePasseController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancBackground,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Connexion",
                        style: TextStyle(
                          color: vert,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Connectez-vous à Dankata Budget.",
                        style: TextStyle(color: gris),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFiedWiget(
                                  labelText: 'Email',
                                  hintTexte: 'Email',
                                  controlleur: emailController,
                                  validateur: (valeur) {
                                    if (valeur == null || valeur.isEmpty) {
                                      return 'Veuillez entrer votre email';
                                    }
                                    return null;
                                  }, mdp: false,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFiedWiget(
                                  labelText: 'Mot de Pass',
                                  hintTexte: 'Mot de Pass',
                                  controlleur: motDePasseController,
                                  validateur: (valeur) {
                                    if (valeur == null || valeur.isEmpty) {
                                      return 'Veuillez entrer votre mot de pass';
                                    }
                                    return null;
                                  },
                                  mdp: true,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                    onPressed: () {
                                      print("Mot de passe oublie");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MotDePassOublie()));
                                    },
                                    child: Text(
                                      "Mot de passe oublie ?",
                                      style: TextStyle(
                                          color: vert,
                                          decoration: TextDecoration.underline),
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                // faire le chargement pendant l'envoie de donnees
                                chargement ? ChargementWidget():
                                MaterialButton(
                                    height: 50,
                                    minWidth: 250,
                                    color: vert,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      // declencher la connexion si tous les champs sont saisi
                                      if (formKey.currentState!.validate()) {
                                        connexion();
                                      } else {}
                                    },
                                    child: Text(
                                      "Se Connecter",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(children: [
                                  Text("Vous n'avez pas de compte ? "),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      print("pop context");
                                    },
                                    child: Text(
                                      "S'inscrire",
                                      style: TextStyle(
                                        color: vert,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ])
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  )
                ],
              ))),
    );
  }
}
