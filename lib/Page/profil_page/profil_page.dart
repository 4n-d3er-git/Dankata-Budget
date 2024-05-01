import 'package:budget_odc/Page/onBoarding/on_boarding_page.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:budget_odc/widgets/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController _nomCompletController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurcir = true;
  bool obscurcir1 = true;
  bool chargement = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? currUserEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: vertBackground,
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: currUserEmail)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error : ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
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

                    final nomComplet = userDataFields['nomComplet'] as String? ?? '';
                    final email = userDataFields['email'] as String? ?? '';
                    final telephone = userDataFields['telephone'] as String? ?? '';
                    
                    return Padding(
                      padding: EdgeInsets.only(top: 30, left: 8, right: 8),
                      child: Column(
                        children: [
                          Text(
                                "Profil",
                                style: TextStyle(color: noir, fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      TextFiedWiget(
                                        labelText: 'Nom Complet',
                                        hintTexte: nomComplet,
                                        controlleur: _nomCompletController,
                                        validateur: (valeur) {
                                          if (valeur == null ||
                                              valeur.isEmpty) {
                                            return 'Veuillez entrer votre nom complet';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFiedWiget(
                                        labelText: 'Numero de Telephone',
                                        hintTexte: telephone,
                                        controlleur: _telephoneController,
                                        validateur: (valeur) {
                                          if (valeur == null ||
                                              valeur.isEmpty) {
                                            return 'Veuillez entrer votre numero de telephone';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      chargement
                                          ? LinearProgressIndicator()
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
                                                    .validate()) {}
                                              },
                                              child: Text(
                                                "Modifier",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              )),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      MaterialButton(
        child: Text("Quitter"),
        onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (builder) =>  OnBoardingPage(),
      ),
    );
  
      })
                                    ],
                                  )),
                    //         
                        ],
                      ),
                    );
                    // Padding(
                    //   padding: EdgeInsets.only(top: 30, left: 8, right: 8),
                    //   child: ListView(
                    //     children: [
                    //       Column(
                    //         children: [
                    //           Text(
                    //             "Profil",
                    //             style: TextStyle(color: noir, fontSize: 20),
                    //           ),
                    //           SizedBox(
                    //             height: 20,
                    //           ),
                    //           Form(
                    //               key: formKey,
                    //               child: Column(
                    //                 children: [
                    //                   TextFiedWiget(
                    //                     labelText: 'Nom Complet',
                    //                     hintTexte: 'Nom Complet',
                    //                     controlleur: _nomCompletController,
                    //                     validateur: (valeur) {
                    //                       if (valeur == null ||
                    //                           valeur.isEmpty) {
                    //                         return 'Veuillez entrer votre nom complet';
                    //                       }
                    //                       return null;
                    //                     },
                    //                   ),
                    //                   SizedBox(
                    //                     height: 10,
                    //                   ),
                    //                   SizedBox(
                    //                     height: 10,
                    //                   ),
                    //                   TextFiedWiget(
                    //                     labelText: 'Numero de Telephone',
                    //                     hintTexte: 'Numero de Telephone',
                    //                     controlleur: _telephoneController,
                    //                     validateur: (valeur) {
                    //                       if (valeur == null ||
                    //                           valeur.isEmpty) {
                    //                         return 'Veuillez entrer votre numero de telephone';
                    //                       }
                    //                       return null;
                    //                     },
                    //                   ),
                    //                   SizedBox(
                    //                     height: 15,
                    //                   ),
                    //                   chargement
                    //                       ? LinearProgressIndicator()
                    //                       : MaterialButton(
                    //                           height: 50,
                    //                           minWidth: 250,
                    //                           color: vert,
                    //                           shape: RoundedRectangleBorder(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(10),
                    //                           ),
                    //                           onPressed: () {
                    //                             if (formKey.currentState!
                    //                                 .validate()) {}
                    //                           },
                    //                           child: Text(
                    //                             "Modifier",
                    //                             style: TextStyle(
                    //                                 color: Colors.white,
                    //                                 fontSize: 20),
                    //                           )),
                    //                   SizedBox(
                    //                     height: 15,
                    //                   ),
                    //                 ],
                    //               )),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // );
                  });
            }));
  }
}
