import 'package:budget_odc/Page/budget_page/budget_page.dart';
import 'package:budget_odc/Page/graphique_page/graphique_page.dart';
import 'package:budget_odc/Page/home_Page/ajouter_depense.dart';
import 'package:budget_odc/Page/home_Page/ajouter_epargne.dart';
import 'package:budget_odc/Page/home_Page/ajouter_revenu.dart';
import 'package:budget_odc/Page/onBoarding/on_boarding_page.dart';
import 'package:budget_odc/Page/profil_page/profil_page.dart';
import 'package:budget_odc/models/auth.dart';
import 'package:budget_odc/models/utilisateursModels.dart';
import 'package:budget_odc/provider/utilisateur_provider.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/carte.dart';
import 'package:budget_odc/widgets/tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_hide_bottom_navigation_bar/scroll_to_hide_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String? currUserEmail = FirebaseAuth.instance.currentUser!.email;
  Authentification auth = Authentification();

  // Calculer les revenus de l'utilisateur actuel

  // Stream<double> calculerRevenusUtilisateur(String email) {
  //   return FirebaseFirestore.instance
  //       .collection('transaction')
  //       .where('email', isEqualTo: email) 
  //       .where('type', isEqualTo: 'revenu')
  //       // Filtrer par e-mail de l'utilisateur
  //       .snapshots()
  //       .map((querySnapshot) {
  //     double totalRevenus = 0;
  //     querySnapshot.docs.forEach((doc) {
  //       Map<String, dynamic> data = doc.data()!; // Vérification null
  //       double? montant = data['montant']; // Vérification null
  //       if (montant != null) {
  //         totalRevenus += montant;
  //       }
  //     });
  //     return totalRevenus;
  //   });
  // }
Stream<double> calculerRevenusUtilisateur(String email, DateTime? startDate, DateTime? endDate) {
  Query transactionsQuery = FirebaseFirestore.instance
      .collection('transaction')
      .where('email', isEqualTo: email)
      .where('type', isEqualTo: 'revenu');

  if (startDate != null && endDate != null) {
    transactionsQuery = transactionsQuery
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate);
  }

  return transactionsQuery.snapshots().map((querySnapshot) {
    double totalRevenus = 0;
    querySnapshot.docs.forEach((doc) {
      // Vérifier si les données ne sont pas null
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Cast sécurisé
        double? montant = data['montant'] as double?; // Vérification null
        if (montant != null) {
          totalRevenus += montant;
        }
      }
    });
    return totalRevenus;
  });
}
  //----------------------------------------------------------
  // Stream<double> calculerDepensesUtilisateur(String email) {
  //   return FirebaseFirestore.instance
  //       .collection('transaction')
  //       .where('email', isEqualTo: email) // Filtrer par e-mail de l'utilisateur
  //       .where('type', isEqualTo: 'depense')
  //       .snapshots()
  //       .map((querySnapshot) {
  //     double totalDepenses = 0;
  //     querySnapshot.docs.forEach((doc) {
  //       Map<String, dynamic> data = doc.data()!; // Vérification null
  //       double? montant = data['montant']; // Vérification null
  //       if (montant != null) {
  //         totalDepenses += montant;
  //       }
  //     });
  //     return totalDepenses;
  //   });
  // }

  Stream<double> calculerDepensesUtilisateur(String email, DateTime? startDate, DateTime? endDate) {
  Query transactionsQuery = FirebaseFirestore.instance
      .collection('transaction')
      .where('email', isEqualTo: email)
      .where('type', isEqualTo: 'depense');

  if (startDate != null && endDate != null) {
    transactionsQuery = transactionsQuery
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate);
  }

  return transactionsQuery.snapshots().map((querySnapshot) {
    double totalDepenses = 0;
    querySnapshot.docs.forEach((doc) {
      // Vérifier si les données ne sont pas null
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Cast sécurisé
        double? montant = data['montant'] as double?; // Vérification null
        if (montant != null) {
          totalDepenses += montant;
        }
      }
    });
    return totalDepenses;
  });
}


  //-------------------------------------------------
  // Calculer le solde actuel de l'utilisateur actuel
  Future<double> calculerSoldeUtilisateur(String email) async {
    double solde = 0;
    double revenus = await calculerRevenusUtilisateur(email, _startDate, _endDate).first;
    double depenses = await calculerDepensesUtilisateur(email, _startDate, _endDate).first;
    double epargne = await calculerEpargneUtilisateur(email, _startDate, _endDate).first;


    solde = revenus - (depenses + epargne);
    return solde;
  }
  //! ------------------------------------------------------------
  Stream<double> calculerEpargneUtilisateur(String email, DateTime? startDate, DateTime? endDate) {
  Query transactionsQuery = FirebaseFirestore.instance
      .collection('transaction')
      .where('email', isEqualTo: email)
      .where('type', isEqualTo: 'epargne');

  if (startDate != null && endDate != null) {
    transactionsQuery = transactionsQuery
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate);
  }

  return transactionsQuery.snapshots().map((querySnapshot) {
    double totalEpargnes = 0;
    querySnapshot.docs.forEach((doc) {
      // Vérifier si les données ne sont pas null
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Cast sécurisé
        double? montant = data['montant'] as double?; // Vérification null
        if (montant != null) {
          totalEpargnes += montant;
        }
      }
    });
    return totalEpargnes;
  });
}

  // Stream<double> calculerEpargneUtilisateur(String email) {
  //   return FirebaseFirestore.instance
  //       .collection('transaction')
  //       .where('email', isEqualTo: email) // Filtrer par e-mail de l'utilisateur
  //       .where('type', isEqualTo: 'epargne')
  //       .snapshots()
  //       .map((querySnapshot) {
  //     double totalEpargnes = 0;
  //     querySnapshot.docs.forEach((doc) {
  //       Map<String, dynamic> data = doc.data()!; // Vérification null
  //       double? montant = data['montant']; // Vérification null
  //       if (montant != null) {
  //         totalEpargnes += montant;
  //       }
  //     });
  //     return totalEpargnes;
  //   });
  // }

  //  Future<double> calculerPourcentage(String email) async{
  //   double pourcentage = 0;
  //   double pourcentageRevenus = await calculerRevenusUtilisateur(email).first/100;
    
  //   double pourcentageDepenses = await calculerSoldeUtilisateur(email)/100;
    
  //   pourcentage =pourcentageRevenus - pourcentageDepenses;
  //   return pourcentage;
  //  }

          DateTime? _startDate;
  DateTime? _endDate;
  DateTimeRange plageChoisi =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

Future<QuerySnapshot> _filtreRevenu() async {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('type', isEqualTo: 'revenu')
        .where('email', isEqualTo: currUserEmail);

    if (_startDate != null && _endDate != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: _startDate)
          .where('date', isLessThanOrEqualTo: _endDate);
    }

    return await transactionsQuery.get();
  } 
  Future<QuerySnapshot> _filtreDepense() async {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('type', isEqualTo: 'depense')
        .where('email', isEqualTo: currUserEmail);

    if (_startDate != null && _endDate != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: _startDate)
          .where('date', isLessThanOrEqualTo: _endDate);
    }

    return await transactionsQuery.get();
  } 
  Future<QuerySnapshot> _filtreEpargne() async {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('type', isEqualTo: 'epargne')
        .where('email', isEqualTo: currUserEmail);

    if (_startDate != null && _endDate != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: _startDate)
          .where('date', isLessThanOrEqualTo: _endDate);
    }

    return await transactionsQuery.get();
  } 
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: vertBackground,
          appBar: AppBar(
            backgroundColor: vertBackground,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bonjour",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  currUserEmail.toString(),
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            actions: [Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: vert, borderRadius: BorderRadius.circular(50)),
              child: IconButton(onPressed: ()async {
                    final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                  initialDateRange: _startDate != null && _endDate != null
                      ? DateTimeRange(start: _startDate!, end: _endDate!)
                      : null,
                );
                if (picked != null && picked.start != null && picked.end != null) {
                  setState(() {
                    _startDate = picked.start;
                    _endDate = picked.end;
                  });
                }
                  }, icon: Icon(Icons.filter_list, color: Colors.white,)),
            )],
          ),
          body:
              //   FutureBuilder<QuerySnapshot>(
              // future:
              // // _fetchData(),
              // FirebaseFirestore.instance
              //     .collection('revenu')
              //     .where('email', isEqualTo: currUserEmail)
              //     .get(),
              // builder: (context, snapshot) {
              //   if (snapshot.hasError) {
              //     return Text("Error : ${snapshot.error}");
              //   }
              //   if (snapshot.connectionState == ConnectionState.waiting) {
              //     return CircularProgressIndicator();
              //   }
              //   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //     return const Text("No data found");
              //   }
              //   final userData = snapshot.data!.docs;

              //   return

              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: userData.length,
              //   itemBuilder: (context, index) {
              //     final userDataFields = userData[index];

              //     final uname = userDataFields['nomComplet'] as String? ?? '';
              //     final email = userDataFields['email'] as String? ?? '';
              //     final phone = userDataFields['telephone'] as String? ?? '';

              // return
              // Center(child: Text(uname),);
              //  Column(
              //    children: snapshot.data!.docs.map((document) {
              //     var montant = document["montant"];
              //     String categorie = document["category"];
              //     String compte = document["compte"];
              //      return
              Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    StreamBuilder<double>(
                        stream: calculerRevenusUtilisateur(currUserEmail!, _startDate, _endDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            double totalRevenus = snapshot.data!;
                            return Container(
                              height: 130,
                              width: 169,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: vert,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Revenus",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Gnf $totalRevenus",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 115,
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AjouterRevenu()));
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    // Carte(
                    //   stitre: "montant",
                    //   revenu: true,
                    //   onTape: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => AjouterRevenu()));
                    //   },
                    // ),
                    SizedBox(
                      width: 5,
                    ),
                    // Carte(
                    //   stitre: '00',
                    //   revenu: false,
                    //   onTape: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => AjouterDepense()));
                    //   },
                    // ),
                    StreamBuilder<double>(
                        stream: calculerDepensesUtilisateur(currUserEmail!, _startDate, _endDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            double totalDepenses = snapshot.data!;
                            return Container(
                              height: 130,
                              width: 169,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: rouge,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dépenses",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Gnf $totalDepenses",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 115,
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AjouterDepense()));
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    FutureBuilder<double>(
                      future: calculerSoldeUtilisateur(currUserEmail!),
                      builder: (BuildContext context,
                          AsyncSnapshot<double> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          double solde = snapshot.data!;
                          return Container(
                            height: 130,
                            width: 169,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: noir,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Montant",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Gnf $solde",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    // Carte2(
                    //   stitre: '00',
                    //   balance: true,
                    // ),
                    SizedBox(
                      width: 5,
                    ),
                    // Carte2(stitre: '00', balance: false),
                    StreamBuilder<double>(
                        stream: calculerEpargneUtilisateur(currUserEmail!, _startDate, _endDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            double totalEpargnes = snapshot.data!;
                            return Container(
                              height: 130,
                              width: 169,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Epargne",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Gnf $totalEpargnes",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 115,
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AjouterEpargne()));
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    // FutureBuilder<double>(
                    //   future: calculerPourcentage(currUserEmail!),
                    //   builder: (BuildContext context,
                    //       AsyncSnapshot<double> snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return CircularProgressIndicator();
                    //     } else if (snapshot.hasError) {
                    //       return Text('Error: ${snapshot.error}');
                    //     } else {
                    //       double pourcentage = snapshot.data!;
                    //       return Container(
                    //         height: 130,
                    //         width: 169,
                    //         padding: EdgeInsets.all(8),
                    //         decoration: BoxDecoration(
                    //           color: noir,
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Pourcentage",
                    //               style: TextStyle(
                    //                   color: Colors.white, fontSize: 20),
                    //             ),
                    //             SizedBox(
                    //               height: 5,
                    //             ),
                    //             Text(
                    //               "$pourcentage %",
                    //               style: TextStyle(
                    //                   color: Colors.white, fontSize: 20),
                    //             )
                    //           ],
                    //         ),
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text("Date"),
              SizedBox(
                height: 8,
              ),
              TabBar(
                tabs: [
                  
                  Tab(
                    text: "Revenus",
                  ),
                  Tab(
                    text: "Dépenses",
                  ),
                  Tab(
                    text: "Epargnes"
                  )
                ],
                indicatorColor: vertBackground,
                labelColor: vert,
                unselectedLabelColor: noir,
              ),
              Container(
                  height: 200,
                  child: TabBarView(
                    children: [
                      
                      //! Revenu
                      FutureBuilder<QuerySnapshot>(
                          future:_filtreRevenu(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Error : ${snapshot.error}");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text("No data found");
                            }
                            final userData = snapshot.data!.docs;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: userData.length,
                                itemBuilder: (context, index) {
                                  final userDataFields = userData[index];

                                  final montant = userDataFields['montant'];
                                  final categorie =
                                      userDataFields['category'] as String? ??
                                          '';
                                  final compte =
                                      userDataFields['compte'] as String? ?? '';
                                  final date = userDataFields['date'];

                                  return ListTile(
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(compte),
                                        // Text("$date"),
                                      ],
                                    ),
                                    trailing: Text(
                                      "+$montant",
                                      style:
                                          TextStyle(color: vert, fontSize: 16),
                                    ),
                                    title: Text(
                                      categorie,
                                      style: TextStyle(
                                          color: vert,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                });
                          }),
                      // SingleChildScrollView(
                      //   child: Center(
                      //     child: Text("Dépense"),
                      //   ),
                      // ),
                      //! DEPENSE
                      FutureBuilder<QuerySnapshot>(
                          future:_filtreDepense(),
                              
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Error : ${snapshot.error}");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text("No data found");
                            }
                            final userData = snapshot.data!.docs;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: userData.length,
                                itemBuilder: (context, index) {
                                  final userDataFields = userData[index];

                                  final montant = userDataFields['montant'];
                                  final categorie =
                                      userDataFields['category'] as String? ??
                                          '';
                                  final compte =
                                      userDataFields['compte'] as String? ?? '';
                                  final date = userDataFields['date'];

                                  return ListTile(
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(compte),
                                        // Text("$date"),
                                      ],
                                    ),
                                    trailing: Text(
                                      "-$montant",
                                      style:
                                          TextStyle(color: rouge, fontSize: 16),
                                    ),
                                    title: Text(
                                      categorie,
                                      style: TextStyle(
                                          color: vert,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                });
                          }),
                      // SingleChildScrollView(
                      //   child: Center(
                      //     child: Text("Dépense"),
                      //   ),
                      // ),
                      // ! Epargne
                      FutureBuilder<QuerySnapshot>(
                          future: _filtreEpargne(),
                              // _fetchData(),
                             
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Error : ${snapshot.error}");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text("No data found");
                            }
                            final userData = snapshot.data!.docs;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: userData.length,
                                itemBuilder: (context, index) {
                                  final userDataFields = userData[index];

                                  final montant = userDataFields['montant'];
                                  final objectif =
                                      userDataFields['objectifs'] as String? ??
                                          '';
                                  

                                  final date = userDataFields['date'];

                                  return ListTile(
                                    
                                    trailing: Text(
                                      "$montant",
                                      style:
                                          TextStyle(color: vert, fontSize: 16),
                                    ),
                                    title: Text(
                                      objectif,
                                      style: TextStyle(
                                          color: vert,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                });
                          }),
                    ],
                  )),
            ],
          )
          //       }).toList(),

          ),
    );
  }
}
