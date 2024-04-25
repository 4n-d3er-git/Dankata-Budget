import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class MotDePassOublie extends StatefulWidget {
  const MotDePassOublie({super.key});

  @override
  State<MotDePassOublie> createState() => _MotDePassOublieState();
}

class _MotDePassOublieState extends State<MotDePassOublie> {
  TextEditingController emailController = TextEditingController();
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
                                      "Envoyer le Lien",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
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
