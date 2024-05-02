import 'package:budget_odc/Page/budget_page/ajouter_budget_semain.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BudgetSemaine extends StatefulWidget {
  const BudgetSemaine({super.key});

  @override
  State<BudgetSemaine> createState() => _BudgetSemaineState();
}

class _BudgetSemaineState extends State<BudgetSemaine>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AjouterSemaine()));
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
                    }

                    var budgets = snapshot.data!.docs;
                     // Filtrer les données selon la plage de dates choisie
                    var budgetsFiltres = budgets.where((budget) {
                      var plageDeDates = budget['plagedate'];
                      DateTime start = plageDeDates['start'].toDate();
                      DateTime end = plageDeDates['end'].toDate();
                      return start.isAfter(plageChoisie!.start) && end.isBefore(plageChoisie!.end);
                    }).toList();
                    // Calculer le montant total uniquement pour les données filtrées
    double montantTotal = 0;
    for (var budget in budgetsFiltres) {
      List<double> montants = List<double>.from(budget['montants']);
      montantTotal += montants.fold(0, (prev, montant) => prev + montant);
    }
                    // for (var budget in budgets) {
                    //   List<double> montants =
                    //       List<double>.from(budget['montants']);
                    //   montantTotal +=
                    //       montants.fold(0, (prev, montant) => prev + montant);
                    // }

                    return Text(
                      "Gnf $montantTotal",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    choisirPlageDeDates();
                  },
                  child: Row(
                    children: [
                      Text(
                        "Filtrer",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                    ],
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
                }

                var budgets = snapshot.data!.docs;
                // Filtrer les données selon la plage de dates choisie
                var budgetsFiltres = budgets.where((budget) {
                  var plageDeDates = budget['plagedate'];
                  DateTime start = plageDeDates['start'].toDate();
                  DateTime end = plageDeDates['end'].toDate();
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
                  top: 200,
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
                        DateTime start = budget['plagedate']['start'].toDate();
                        DateTime end = budget['plagedate']['end'].toDate();
                        // Extraire les descriptions et les montants
                        List<String> descriptions =
                            List<String>.from(budget['descriptions']);
                        List<double> montants =
                            List<double>.from(budget['montants']);

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
                            Text('Email: ${budget['email']}  $start  $end'),
                            Text('Nombre de catégories: ${budget['nombre']}'),
                            // Afficher chaque description avec son montant correspondant
                            for (int i = 0; i < descriptions.length; i++)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text("${descriptions[i]}"),
                                    trailing: Text("${montants[i]}"),
                                  ),
                                ],
                              ),
                            // Afficher le montant total
                            Text('Montant total: $montantTotal'),
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
