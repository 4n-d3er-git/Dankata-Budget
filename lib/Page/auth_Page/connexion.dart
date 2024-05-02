
import 'package:budget_odc/Page/auth_Page/mot_de_passs_oublie.dart';
import 'package:budget_odc/Page/home_Page/home_page.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/bottomnevbar.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:budget_odc/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  TextEditingController emailController = TextEditingController();
  TextEditingController motDePasseController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool chargement = false;
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
        // await storeUserType('host');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return const BottomNavBar();
        }));
        emailController.clear();
        motDePasseController.clear();
      } on FirebaseAuthException catch (e) {
        // print(e.code);
        if (e.code == "user-not-found") {
          montrerSnackBar(
               "user not found, please register", context);
        } else if (e.code == "wrong-password") {
          montrerSnackBar( "incorrect password", context);
        } else if (e.code == 'email-already-in-use') {
          montrerSnackBar( 'Email already in use', context);
        } else if (e.code == 'invalid-email') {
          montrerSnackBar( 'Invalid email', context);
        } else if (e.code == 'user-not-found') {
          montrerSnackBar( 'User not found', context);
        } else if (e.code == 'too-many-requests') {
          montrerSnackBar(
              'Too many login attempts. Please try again later.', context);
        } else if (e.code == 'user-disabled') {
          montrerSnackBar('User account disabled', context);
        } else if (e.code == 'operation-not-allowed') {
          montrerSnackBar( 'Operation not allowed', context);
        } else if (e.code == 'invalid-credential') {
          montrerSnackBar('Invalid credential', context);
        } else if (e.code == 'account-exists-with-different-credential') {
          montrerSnackBar(            
           'An account with the same email already exists but with a different sign-in method', context);
        } else if (e.code == 'network-request-failed') {
          montrerSnackBar( 'Invalid Input', context);
        }
      } catch (e) {
        // print("something bad happened");
        // print(e
        //     .runtimeType); //this will give the type of exception that occured
        // print(e);
      } finally {
        setState(() {
          chargement = false;
        });
      }
    } else if (email.isEmpty) {
      montrerSnackBar("please enter email", context);
    } else if (password.isEmpty) {
      montrerSnackBar( "please enter password", context);
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
      backgroundColor: vertBackground,
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
                        "Connectez-vous avec...",
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
                                  },
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
                                MaterialButton(
                                    height: 50,
                                    minWidth: 250,
                                    color: vert,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
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
