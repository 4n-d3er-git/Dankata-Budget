 import 'package:budget_odc/Page/budget_page/budget_mois/ajouter_budget_mois.dart';
import 'package:budget_odc/Page/budget_page/budget_semaine/ajouter_budget_semain.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BudgetMois extends StatefulWidget {
  const BudgetMois({super.key});

  @override
  State<BudgetMois> createState() => _BudgetMoisState();
}

class _BudgetMoisState extends State<BudgetMois>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  DateTimeRange plageChoisie =
      DateTimeRange(start: DateTime(2010), end: DateTime(2050));
  Future<void> choisirPlageDeDates() async {
    final plage = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (plage != null) {
      setState(() {
        plageChoisie = plage;
      });
    }
  }

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

  DateTimeRange plageChoisi =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  void afficherDetailBudget(BuildContext context, Map<String, dynamic> budget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime debut = budget['plagedate']['debut'].toDate();
        DateTime fin = budget['plagedate']['fin'].toDate();
        // Extraire les descriptions et les montants
        List<String> descriptions = List<String>.from(budget['descriptions']);
        List<double> montants = List<double>.from(budget['montants']);
        String titre = budget['titre'];
        // Calculer le total des montants
  double montantTotal = montants.fold(0, (prev, montant) => prev + montant);
        return AlertDialog(
          title: Text("Détails du Budget"),
          content: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(titre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  Text(
                      "Du ${debut.day}/${debut.month}/${debut.year} Au ${fin.day}/${fin.month}/${fin.year}"),
                  for (int i = 0; i < descriptions.length; i++)
                    Text("${descriptions[i]} : ${montants[i]}"),
                  Text("Total : $montantTotal gnf"),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: vert,
            child: Icon(Icons.add, color: Colors.white,),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AjouterMois()));
            }),
        body: Stack(children: [
          Container(
            margin: EdgeInsets.all(8.0),
            height: 2000,
            width: 400,
            decoration: BoxDecoration(
              color: vert,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Montant Total",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('budget')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else if(snapshot.data!.docs.isEmpty) {
                      return Text("Aucun budget disponible");
                    }

                    var budgets = snapshot.data!.docs;
                    // Filtrer les données selon la plage de dates choisie
                    var budgetsFiltres = budgets.where((budget) {
                      var plageDeDates = budget['plagedate'];
                      DateTime start = plageDeDates['debut'].toDate()?? DateTime.now();
                      DateTime end = plageDeDates['fin'].toDate();
                      return start.isAfter(plageChoisie!.start) &&
                          end.isBefore(plageChoisie!.end);
                    }).toList();
                    // Calculer le montant total uniquement pour les données filtrées
                    double montantTotal = 0;
                    for (var budget in budgetsFiltres) {
                      List<double> montants =
                          List<double>.from(budget['montants']);
                      montantTotal +=
                          montants.fold(0, (prev, montant) => prev + montant);
                    }
                    // for (var budget in budgets) {
                    //   List<double> montants =
                    //       List<double>.from(budget['montants']);
                    //   montantTotal +=
                    //       montants.fold(0, (prev, montant) => prev + montant);
                    // }

                    return Text.rich(TextSpan(
                      text: "GNF ",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      children: [
                        TextSpan(
                          text: '$montantTotal',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: MaterialButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      choisirPlageDeDates();
                    },
                    child: Text(
                      "Filtrer",
                      style: TextStyle(color: vert, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('budget').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else if(snapshot.data!.docs.isEmpty){
                  return Center(child: Text("Aucun Budget"),);
                }

                var budgets = snapshot.data!.docs;
                // Filtrer les données selon la plage de dates choisie
                var budgetsFiltres = budgets.where((budget) {
                  var plageDeDates = budget['plagedate'];
                  DateTime start = plageDeDates['debut'].toDate()?? DateTime.now();
                  DateTime end = plageDeDates['fin'].toDate();
                  return start.isAfter(plageChoisie!.start) &&
                      end.isBefore(plageChoisie!.end);
                }).toList();

                double montantTotal = 0;
                for (var budget in budgets) {
                  List<double> montants = List<double>.from(budget['montants']);
                  montantTotal +=
                      montants.fold(0, (prev, montant) => prev + montant);
                }

                return Positioned(
                  top: 150,
                  child: Container(
                    width: 350,
                    height: 2000,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: EdgeInsets.all(8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: budgetsFiltres.length,
                      itemBuilder: (context, index) {
                        var budget = budgetsFiltres[index].data();

                        // var budget = budgets[index].data();
// Extraire la plage de dates
                        DateTime debut = budget['plagedate']['debut'].toDate();
                        DateTime fin = budget['plagedate']['fin'].toDate();
                        // Extraire les descriptions et les montants
                        List<String> descriptions =
                            List<String>.from(budget['descriptions']);
                        List<double> montants =
                            List<double>.from(budget['montants']);
                        String titre = budget['titre'];

                        // Vérifier que les listes de descriptions et de montants ont la même longueur
                        if (descriptions.length != montants.length) {
                          return Text(
                              'Erreur: Les descriptions et les montants ne correspondent pas.');
                        }

                        // Calculer le montant total
                        double montantTotal = montants.fold(
                            0,
                            (previousValue, montant) =>
                                previousValue + montant);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Afficher chaque description avec son montant correspondant
                            for (int i = 0; i < descriptions.length; i++)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      )
                                    ]),
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                          titre,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        subtitle: Text(
                                            "Du ${debut.day}/${debut.month}/${debut.year} Au ${fin.day}/${fin.month}/${fin.year}"),
                                        onTap: () {
                                          afficherDetailBudget(context, budget);
                                        },
                                        // title: Text("${descriptions[i]}"),
                                        // trailing: Text("${montants[i]}"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            // Afficher le montant total
                            // Text('Montant total: $montantTotal'),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
        ]));
  }
}
