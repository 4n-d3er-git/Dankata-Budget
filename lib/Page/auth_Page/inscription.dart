import 'package:budget_odc/Page/auth_Page/connexion.dart';
import 'package:budget_odc/Page/home_Page/home_page.dart';
import 'package:budget_odc/models/auth.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:budget_odc/widgets/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Inscription extends StatefulWidget {
  const Inscription({Key? key}): super (key: key);

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  TextEditingController _nomCompletController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  TextEditingController _motDePasseController = TextEditingController();
  TextEditingController _confirmerMotDePassController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurcir = true;
  bool obscurcir1 = true;
  bool chargement = false;

  @override
  void dispose() {
    _nomCompletController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
   _motDePasseController.dispose();
    _confirmerMotDePassController.dispose();
    super.dispose();
  }

 Future addUserDetails(
    String nom,
    String email,
    String telephone,
  ) async {
    await FirebaseFirestore.instance.collection('users').add({
      "nomComplet": nom,
      "email": email,
      "telephone": telephone,
    });
  }

  void registerUser() async {
    final nom = _nomCompletController.text.trim();
    final email = _emailController.text.trim();
    final telephone = _telephoneController.text.trim();
    final motdepass = _motDePasseController.text.trim();
    final cmotdepass = _confirmerMotDePassController.text.trim();

    if (nom.isNotEmpty &&
        email.isNotEmpty &&
        telephone.isNotEmpty &&
        motdepass == cmotdepass &&
        motdepass.length >= 7 ) {
      setState(() {
        chargement = true;
      });
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: motdepass);
        addUserDetails(nom, email, telephone, );
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return  HomePage();
        }));
        _nomCompletController.clear();
        _emailController.clear();
        _telephoneController.clear();
        _motDePasseController.clear();
        _confirmerMotDePassController.clear();
      } on FirebaseAuthException catch (e) {
        //print(e.code);
        if (e.code == 'weak-password') {
          showAlertDialog(context, 'Invalid Input', 'Weak password');
        } else if (e.code == 'email-already-in-use') {
          showAlertDialog(context, 'Invalid Input', 'Email already in use');
        } else if (e.code == 'invalid-email') {
          showAlertDialog(context, 'Invalid Input', 'Invalid email');
        } else if (e.code == 'user-not-found') {
          showAlertDialog(context, 'Invalid Input', 'User not found');
        } else if (e.code == 'too-many-requests') {
          showAlertDialog(context, 'Invalid Input',
              'Too many login attempts. Please try again later.');
        } else if (e.code == 'user-disabled') {
          showAlertDialog(context, 'Invalid Input', 'User account disabled');
        } else if (e.code == 'operation-not-allowed') {
          showAlertDialog(context, 'Invalid Input', 'Operation not allowed');
        } else if (e.code == 'invalid-credential') {
          showAlertDialog(context, 'Invalid Input', 'Invalid credential');
        } else if (e.code == 'account-exists-with-different-credential') {
          showAlertDialog(context, 'Invalid Input',
              'An account with the same email already exists but with a different sign-in method');
        } else if (e.code == 'network-request-failed') {
          showAlertDialog(context, 'Invalid Input', 'check your internet');
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
    } else if (nom.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter username");
    } else if (email.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter your email");
    } else if (!email.contains('@')) {
      showAlertDialog(context, "Invalid Input", "please enter correct email");
    } else if (!email.contains('@')) {
      showAlertDialog(context, "Invalid Input", "please enter correct email");
    } else if (telephone.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter your mobile no.");
    } else if (telephone.length != 10) {
      showAlertDialog(
          context, "Invalid Input", "please enter correct phone no.");
    } else if (motdepass.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter password");
    } else if (motdepass.length < 8) {
      showAlertDialog(context, "Invalid Input",
          "password length must be minimum of 8 characters");
    } else if (motdepass != cmotdepass) {
      showAlertDialog(context, "Invalid Input",
          "password and confirm password are not same");
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // soumissionInscription() async {
    //   setState(() {
    //     chargement = true;
    //   });
    //   String reponse = await Authentification().creerUnCompte(
    //     email: _emailController.text,
    //     password: _motDePasseController.text, context: context,
    //   );
    //   if(reponse == "accomplie"){
    //   }
    //   else{
    //     // montrerSnackBar("Une erreur s'est produite", context);
    //     setState(() {
    //     chargement = false;
    //   });
    //   }
      
    // }
    // sousmissionInformations() async {
    //   setState(() {
    //     chargement = true;
    //   });
    //   String reponse = await Authentification().informationComplete(
    //     context: context,
    //     nomComple: _nomCompletController.text.trim(),
    //     email: _emailController.text.trim(),
    //     telepone: _telephoneController.text.trim(),
    //   );
    //   if (reponse == 'accomplie') {
    //     setState(() {
    //       chargement = false;
    //     });
    //     montrerSnackBar("Compte créé avec succès.\nBienvenu dans ...", context);
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (context) => HomePage(),
    //       ),
    //     );
    //   }
    // }
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
                        "Inscription",
                        style: TextStyle(
                          color: vert,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Creez votre compte avec...",
                        style: TextStyle(color: gris),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFiedWiget(
                                  labelText: 'Nom Complet',
                                  hintTexte: 'Nom Complet',
                                  controlleur: _nomCompletController,
                                  validateur: (valeur) {
                                    if (valeur == null || valeur.isEmpty) {
                                      return 'Veuillez entrer votre nom complet';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFiedWiget(
                                  labelText: 'Email',
                                  hintTexte: 'Email',
                                  controlleur: _emailController,
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
                                  labelText: 'Numero de Telephone',
                                  hintTexte: 'Numero de Telephone',
                                  controlleur: _telephoneController,
                                  validateur: (valeur) {
                                    if (valeur == null || valeur.isEmpty) {
                                      return 'Veuillez entrer votre numero de telephone';
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
                                  controlleur: _motDePasseController,
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
                                TextFiedWiget(
                                  labelText: 'Confirmer Mot de Pass',
                                  hintTexte: 'Confirmer Mot de Pass',
                                  controlleur: _confirmerMotDePassController,
                                  validateur: (valeur) {
                                    if (valeur == null || valeur.isEmpty) {
                                      return 'Veuillez confirmer votre mot de pass';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                chargement ?
                                LinearProgressIndicator(

                                ):
                                MaterialButton(
                                    height: 50,
                                    minWidth: 250,
                                    color: vert,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        
                                      } 
                                      if (_motDePasseController.text !=
                                          _confirmerMotDePassController.text) {
                                         montrerSnackBar("Les mots de passe ne sont pas identiques", context);

                                      }else{
                                        print("valide");
                                        registerUser();
                                        print("${_nomCompletController.text}, ${_emailController.text}, ${_telephoneController.text}, ${_motDePasseController.text}");


                                      }
                                    },
                                    child: Text(
                                      "S'inscrire",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(children: [
                                  Text("Vous avez deja un compte ? "),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Connexion()));
                                    },
                                    child: Text(
                                      "Se connecter",
                                      style: TextStyle(
                                        color: vert,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 18,
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
