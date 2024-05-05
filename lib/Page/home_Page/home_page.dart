import 'package:budget_odc/Page/home_Page/ajouter_depense.dart';
import 'package:budget_odc/Page/home_Page/ajouter_epargne.dart';
import 'package:budget_odc/Page/home_Page/ajouter_revenu.dart';

import 'package:budget_odc/theme/couleur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String? emailUtilisateur = FirebaseAuth.instance.currentUser!.email;

  // Calculer les revenus de l'utilisateur actuel
  Stream<double> calculerRevenusUtilisateur(
      String email, DateTime? dateDebut, DateTime? dateFin) {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('email', isEqualTo: email)
        .where('type', isEqualTo: 'revenu');

    if (dateDebut != null && dateFin != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: dateDebut)
          .where('date', isLessThanOrEqualTo: dateFin);
    }

    return transactionsQuery.snapshots().map((querySnapshot) {
      double totalRevenus = 0;
      querySnapshot.docs.forEach((doc) {
        // Vérifier si les données ne sont pas null
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data =
              doc.data() as Map<String, dynamic>; // Cast sécurisé
          double? montant = data['montant'] as double?; // Vérification null
          if (montant != null) {
            totalRevenus += montant;
          }
        }
      });
      return totalRevenus;
    });
  }

  Stream<double> calculerDepensesUtilisateur(
      String email, DateTime? dateDebut, DateTime? dateFin) {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('email', isEqualTo: email)
        .where('type', isEqualTo: 'depense');

    if (dateDebut != null && dateFin != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: dateDebut)
          .where('date', isLessThanOrEqualTo: dateFin);
    }

    return transactionsQuery.snapshots().map((querySnapshot) {
      double totalDepenses = 0;
      querySnapshot.docs.forEach((doc) {
        // Vérifier si les données ne sont pas null
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data =
              doc.data() as Map<String, dynamic>; // Cast sécurisé
          double? montant = data['montant'] as double?; // Vérification null
          if (montant != null) {
            totalDepenses += montant;
          }
        }
      });
      return totalDepenses;
    });
  }

  // Calculer le solde actuel de l'utilisateur actuel
  Future<double> calculerSoldeUtilisateur(String email) async {
    double solde = 0;
    double revenus =
        await calculerRevenusUtilisateur(email, _dateDebut, _dateFin).first;
    double depenses =
        await calculerDepensesUtilisateur(email, _dateDebut, _dateFin).first;
    double epargne =
        await calculerEpargneUtilisateur(email, _dateDebut, _dateFin).first;

    solde = revenus - (depenses + epargne);
    return solde;
  }

  // ------------------------------------------------------------
  Stream<double> calculerEpargneUtilisateur(
      String email, DateTime? dateDebut, DateTime? dateFin) {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('email', isEqualTo: email)
        .where('type', isEqualTo: 'epargne');

    if (dateDebut != null && dateFin != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: dateDebut)
          .where('date', isLessThanOrEqualTo: dateFin);
    }

    return transactionsQuery.snapshots().map((querySnapshot) {
      double totalEpargnes = 0;
      querySnapshot.docs.forEach((doc) {
        // Vérifier si les données ne sont pas null
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data =
              doc.data() as Map<String, dynamic>; // Cast sécurisé
          double? montant = data['montant'] as double?; // Vérification null
          if (montant != null) {
            totalEpargnes += montant;
          }
        }
      });
      return totalEpargnes;
    });
  }

  DateTime? _dateDebut;
  DateTime? _dateFin;
  DateTimeRange plageChoisi =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  Future<QuerySnapshot> _filtreRevenu() async {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('type', isEqualTo: 'revenu')
        .where('email', isEqualTo: emailUtilisateur);

    if (_dateDebut != null && _dateFin != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: _dateDebut)
          .where('date', isLessThanOrEqualTo: _dateFin);
    }

    return await transactionsQuery.get();
  }

  Future<QuerySnapshot> _filtreDepense() async {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('type', isEqualTo: 'depense')
        .where('email', isEqualTo: emailUtilisateur);

    if (_dateDebut != null && _dateFin != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: _dateDebut)
          .where('date', isLessThanOrEqualTo: _dateFin);
    }

    return await transactionsQuery.get();
  }

  Future<QuerySnapshot> _filtreEpargne() async {
    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transaction')
        .where('type', isEqualTo: 'epargne')
        .where('email', isEqualTo: emailUtilisateur);

    if (_dateDebut != null && _dateFin != null) {
      transactionsQuery = transactionsQuery
          .where('date', isGreaterThanOrEqualTo: _dateDebut)
          .where('date', isLessThanOrEqualTo: _dateFin);
    }

    return await transactionsQuery.get();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: blancBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: blancBackground,
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
                  emailUtilisateur.toString(),
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            actions: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: vert, borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        helpText: "selectionnez une plage de date",
                        cancelText: "Quitter",
                        fieldEndHintText: "Date de Fin",
                        fieldStartHintText: "Date de Début",
                        fieldEndLabelText: "Selectionnez une ",
                        fieldStartLabelText: "Selectionnez une ",
                        confirmText: "Confirmer",
                        saveText: "confirmer",
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                        initialDateRange: _dateDebut != null && _dateFin != null
                            ? DateTimeRange(start: _dateDebut!, end: _dateFin!)
                            : null,
                      );
                      if (picked != null &&
                          picked.start != null &&
                          picked.end != null) {
                        setState(() {
                          _dateDebut = picked.start;
                          _dateFin = picked.end;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    StreamBuilder<double>(
                        stream: calculerRevenusUtilisateur(
                            emailUtilisateur!, _dateDebut, _dateFin),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                            // CircularProgressIndicator(
                            //   color: vert,
                            // );
                          } else if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
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
                    SizedBox(
                      width: 5,
                    ),
                    StreamBuilder<double>(
                        stream: calculerDepensesUtilisateur(
                            emailUtilisateur!, _dateDebut, _dateFin),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                            // CircularProgressIndicator(
                            //   color: vert,
                            // );
                          } else if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
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
                      future: calculerSoldeUtilisateur(emailUtilisateur!),
                      builder: (BuildContext context,
                          AsyncSnapshot<double> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return 
                          const SizedBox();
                          // CircularProgressIndicator(
                          //   color: vert,
                          // );
                        } else if (snapshot.hasError) {
                          return Text('Erreur: ${snapshot.error}');
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
                                  "Solde",
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
                    SizedBox(
                      width: 5,
                    ),
                    StreamBuilder<double>(
                        stream: calculerEpargneUtilisateur(
                            emailUtilisateur!, _dateDebut, _dateFin),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: vert,
                            );
                          } else if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
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
                  ],
                ),
              ),
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
                  Tab(text: "Epargnes")
                ],
                indicatorColor: blancBackground,
                labelColor: vert,
                unselectedLabelColor: noir,
                indicatorWeight: 1,
              ),
              Container(
                  height: 250,
                  child: TabBarView(
                    children: [
                      //! Revenu
                      FutureBuilder<QuerySnapshot>(
                          future: _filtreRevenu(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Erreur : ${snapshot.error}");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LinearProgressIndicator(
                                color: vert,
                              );
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: const Text("Aucun Revenu"));
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
                                  DateTime date =
                                      userDataFields['date'].toDate();

                                  return ListTile(
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(compte),
                                        Text(
                                            "${date.day}/${date.month}/${date.year}"),
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

                      //! DEPENSE
                      FutureBuilder<QuerySnapshot>(
                          future: _filtreDepense(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Erreur : ${snapshot.error}");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LinearProgressIndicator(
                                color: vert,
                              );
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text("Aucune Dépense"));
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
                                  DateTime date =
                                      userDataFields['date'].toDate();

                                  return ListTile(
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(compte),
                                        Text(
                                            "${date.day}/${date.month}/${date.year}"),
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

                      // ! Epargne
                      FutureBuilder<QuerySnapshot>(
                          future: _filtreEpargne(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Erreur : ${snapshot.error}");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LinearProgressIndicator(
                                color: vert,
                              );
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text("Aucune Epargne"));
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

                                  DateTime date =
                                      userDataFields['date'].toDate();

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
                                    subtitle: Text(
                                        "${date.day}/${date.month}/${date.year}"),
                                  );
                                });
                          }),
                    ],
                  )),
            ],
          )),
    );
  }
}
