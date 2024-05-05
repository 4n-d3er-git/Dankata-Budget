import 'package:budget_odc/Page/auth_Page/connexion.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/bottomnevbar.dart';
import 'package:budget_odc/widgets/chargement.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:budget_odc/widgets/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inscription extends StatefulWidget {
  const Inscription({Key? key}) : super(key: key);

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

// ajouter les details de l'utilisateurs dans la base de donnee
  Future ajouterDetailsUtilisateurs(
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
        motdepass.length >= 7) {
      setState(() {
        chargement = true;
      });
      try {
        // creer le compte de l'utilisateur
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: motdepass);
        ajouterDetailsUtilisateurs(
          nom,
          email,
          telephone,
        );
        // Stockage de l'état de connexion dans SharedPreferences
        //cache
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        // naviguer vers la page principale
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return BottomNavBar();
        }));
        montrerSnackBar("Bienveu dans ...", context);
        _nomCompletController.clear();
        _emailController.clear();
        _telephoneController.clear();
        _motDePasseController.clear();
        _confirmerMotDePassController.clear();
        // gestion des exceptions
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          montrerErreurSnackBar("Mot de pass trop court", context);
        } else if (e.code == 'email-already-in-use') {
          montrerErreurSnackBar(
              "Un utilisateur existe déjà avec cet email", context);
        } else if (e.code == 'invalid-email') {
          montrerErreurSnackBar("Cette adresse email est incorrect", context);
        } else if (e.code == 'user-not-found') {
          montrerErreurSnackBar("Aucun utilisateur trouvé", context);
        } else if (e.code == 'too-many-requests') {
          montrerErreurSnackBar(
              "Vous avez essayé assez de tentation veuillez reéssayer plus tard",
              context);
        } else if (e.code == 'user-disabled') {
          montrerErreurSnackBar(
              "Cet utilisateur à été désactivé veuillez contacter un administrateur",
              context);
        } else if (e.code == 'operation-not-allowed') {
          montrerErreurSnackBar("Opération non allouée", context);
        } else if (e.code == 'invalid-credential') {
          montrerErreurSnackBar("Erreur", context);
        } else if (e.code == 'account-exists-with-different-credential') {
          montrerErreurSnackBar("Erreur Inconnue", context);
        } else if (e.code == 'network-request-failed') {
          montrerErreurSnackBar(
              "impossible de se connecter, veuillez vérifier votre connexion intrnet puis reessayer",
              context);
        }
      } catch (e) {
        montrerSnackBar("$e", context);
      } finally {
        setState(() {
          chargement = false;
        });
      }
    }
    // gestion des erreurs
    else if (nom.isEmpty) {
      montrerErreurSnackBar("Veuillez entrer votre nom complet", context);
    } else if (email.isEmpty) {
      montrerErreurSnackBar("Veuillez entrer votre Email", context);
    } else if (!email.contains('@')) {
      montrerErreurSnackBar("Veullez entrer un email valide", context);
    } else if (telephone.isEmpty) {
      montrerErreurSnackBar(
          "veuillez entrer votre numero de telephone", context);
    } else if (motdepass.isEmpty) {
      montrerErreurSnackBar("Veuillez entrer votre mot de pass", context);
    } else if (motdepass != cmotdepass) {
      montrerErreurSnackBar(
          "Les deux mots de pass ne correspondent pas, veuillez corriger puis reesyer",
          context);
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
                                  mdp: false,
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
                                  mdp: false,
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
                                  mdp: false,
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
                                  mdp: true,
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
                                  mdp: true,
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
                                            registerUser();
                                            print(
                                                "${_nomCompletController.text}, ${_emailController.text}, ${_telephoneController.text}, ${_motDePasseController.text}");
                                          } else {
                                            print("non valide");
                                          }
                                        },
                                        child: Text(
                                          "S'inscrire",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
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
