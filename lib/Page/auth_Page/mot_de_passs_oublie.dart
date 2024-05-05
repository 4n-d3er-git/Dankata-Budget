import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/chargement.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:budget_odc/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MotDePassOublie extends StatefulWidget {
  const MotDePassOublie({super.key});

  @override
  State<MotDePassOublie> createState() => _MotDePassOublieState();
}

class _MotDePassOublieState extends State<MotDePassOublie> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool chargement = false;
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _envoyerEmailVerificatiion(String email) async {
    setState(() {
        chargement = true;
      });
    try {
      
      await _auth.sendPasswordResetEmail(email: email);
      montrerSnackBar(
          "Un mail vous à été envoyé contenant un lien pour réinitialiser votre mot de pass",
          context);
      emailController.clear();
      setState(() {
        chargement = false;
      });
    } catch (e) {
      montrerErreurSnackBar(
          "une erreur s'est produite, veuillez réessayer", context);
      setState(() {
        chargement = false;
      });
    }
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
                        "Mot de Pass Oublie",
                        style: TextStyle(
                          color: vert,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Changez de mot de pass...",
                        style: TextStyle(color: gris),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Text(
                                    "Un mail contenant un lien pour réinitialiser votre mot de pass vous sera envoyé à votre adresse"
                                    " email",style: TextStyle(color: gris),
                                    ),
                                    SizedBox(height: 10,),
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
                                  mdp: false,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                chargement
                                    ? ChargementWidget()
                                    : MaterialButton(
                                        height: 50,
                                        minWidth: 250,
                                        color: vert,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            _envoyerEmailVerificatiion(
                                                emailController.text.trim());
                                          } else {}
                                        },
                                        child: Text(
                                          "Envoyer le Lien",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                SizedBox(
                                  height: 15,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Je m'en souviens",
                                      style: TextStyle(
                                          color: vert,
                                          decoration: TextDecoration.underline),
                                    ))
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
