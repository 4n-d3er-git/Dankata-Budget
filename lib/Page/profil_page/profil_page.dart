import 'package:budget_odc/Page/onBoarding/on_boarding_page.dart';
import 'package:budget_odc/Page/profil_page/modifier_profil.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
// FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Méthode pour déconnecter l'utilisateur
  Future<void> _deconnexion(BuildContext context) async {
    try {
      // Appel de la méthode de déconnexion de Firebase Auth
      await _auth.signOut();

      // Supprimer l'état de connexion de SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('isLoggedIn');
      print("Déconnecté");
      // Naviguer vers la LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingPage()),
      );
    } catch (e) {
      // Gestion des erreurs de déconnexion
      print("Erreur de déconnexion : $e");
      // Affichez un message d'erreur à l'utilisateur
      montrerErreurSnackBar("Erreur de déconnexion", context);
    }
  }

  String? emailUtilisateur = FirebaseAuth.instance.currentUser!.email;

  void conseilDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Conseils"),
          content: Text(
              "Ceci est la section conseil, en cliquant sur OK vous serrez "
              "rédirigé vers le site pour consulter des conseils sur ."),
          actions: [
            TextButton(
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // fermer dialog
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  void deconnexionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Déconnexion"),
          content: Text("Voulez-vous vraiment vous déconnecter ?"),
          actions: [
            TextButton(
              child: const Text(
                'Oui',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _deconnexion(context);
              },
            ),
            TextButton(
              child: const Text(
                'NON',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // fermer dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profil"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  conseilDialog();
                },
                icon: Icon(
                  Icons.info,
                  color: vert,
                )),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: emailUtilisateur)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error : ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: vert,
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No data found");
              }
              final userData = snapshot.data!.docs;

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final userDataFields = userData[index];

                    final nomComplet =
                        userDataFields['nomComplet'] as String? ?? '';
                    final email = userDataFields['email'] as String? ?? '';
                    final telephone =
                        userDataFields['telephone'] as String? ?? '';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text.rich(TextSpan(text: "NOM: ", children: [
                              TextSpan(
                                text: "$nomComplet",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ])),
                          ),
                          ListTile(
                            title: Text.rich(TextSpan(text: "TELEPHONE: ", children: [
                              TextSpan(
                                text: "$telephone",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ])),
                          ),
                          ListTile(
                            title: Text.rich(TextSpan(
                              text: "EMAIL: ",
                              children: [
                                TextSpan(text: "$email", style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold
                                ),)
                            ]) ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const ModifierProfilPage();
                              }));
                            },
                            child: Text(
                              "Modifier le Profil",
                              style: TextStyle(
                                color: vert,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          MaterialButton(
                              color: vert,
                              child: Text(
                                "Se Déconnecter",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                deconnexionDialog();
                              })
                        ],
                      ),
                    );
                  });
            }));
  }
}
