import 'package:budget_odc/Page/auth_Page/mot_de_passs_oublie.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  TextEditingController emailController = TextEditingController();
  TextEditingController motDePasseController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
