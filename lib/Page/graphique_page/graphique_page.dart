import 'dart:math';

import 'package:budget_odc/Page/onBoarding/on_boarding_page.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/bottomnevbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';


class GraphiquePage extends StatefulWidget {
  const GraphiquePage({super.key});

  @override
  State<GraphiquePage> createState() => _GraphiquePageState();
}

class _GraphiquePageState extends State<GraphiquePage>



    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
//   Future<List<DocumentSnapshot>> fetchData() async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('transaction')
//       .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
//       .where('type', isEqualTo: 'revenu')
//       .get();

//   return querySnapshot.docs;
// }

double calculTotalRevenu(List<DocumentSnapshot<Object?>> data) {
  double total = 0.0;
  data.forEach((doc) {
    total += doc['montant'] ?? 0.0;
  });
  return total;
}

List<PieChartSectionData> sectionDeGraphe(List<DocumentSnapshot<Object?>> data, double totalIncome) {
  List<PieChartSectionData> sections = [];
  data.forEach((doc) {
    double income = doc['montant'] ?? 0.0;
    double percentage = income / totalIncome * 100.0;
    sections.add(
      PieChartSectionData(
        color:      getColorForCategory(doc['category']),
 // Vous pouvez personnaliser les couleurs si vous le souhaitez
        value: percentage,
        title: '${doc['category']} (${percentage.toStringAsFixed(2)}%)',
        radius: 100,
      ),
    );
  });
  return sections;
}
Future<List<DocumentSnapshot<Object?>>> getRevenuData() async {
  QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
      .collection('transaction')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .where('type', isEqualTo: 'revenu')
      .get();

  return querySnapshot.docs;
}
Future<List<DocumentSnapshot<Object?>>> getDepenseData() async {
  QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
      .collection('transaction')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .where('type', isEqualTo: 'depense')
      .get();

  return querySnapshot.docs;
}

Widget revenuGraphe(List<DocumentSnapshot<Object?>> incomeData) {
  double totalIncome = calculTotalRevenu(incomeData);
  List<PieChartSectionData> sections = sectionDeGraphe(incomeData, totalIncome);

  return PieChart(
    PieChartData(
      sections: sections,
    ),
  );
}
Widget depenseGraphe(List<DocumentSnapshot<Object?>> incomeData) {
  double totalIncome = calculTotalRevenu(incomeData);
  List<PieChartSectionData> sections = sectionDeGraphe(incomeData, totalIncome);

  return PieChart(
    PieChartData(
      sections: sections,
    ),
  );
}
// Color getRandomColor() {
//   Random random = Random();
//   return Color.fromARGB(
//     255,
//     random.nextInt(256),
//     random.nextInt(256),
//     random.nextInt(256),
//   );
// }
Color getColorForCategory(String category) {
  List<int> colors = [
    Colors.blue.value,
    Colors.green.value,
    Colors.red.value,
    Colors.orange.value,
    Colors.purple.value,
    Colors.yellow.value,
    Colors.teal.value,
    Colors.pink.value,
    Colors.indigo.value,
    Colors.deepOrange.value,
    Colors.cyan.value,
    Colors.amber.value,
  ];

  int index = category.hashCode % colors.length;
  return Color(colors[index]);
}
// Widget buildPieChart(List<DocumentSnapshot> data) {
//   // Convertir les données Firestore en une liste de Map
//   List<Map<String, dynamic>> dataList = data
//       .map((doc) => {'label': doc['category'], 'value': doc['montant']})
//       .toList();

//   return PieChart(
//     PieChartData(
//       sections: dataList.asMap().entries.map((entry) {
//         return PieChartSectionData(
//           color: Colors.accents[entry.key % Colors.accents.length],
//           value: double.parse(entry.value['value'].toString()),
//           title: entry.value['label'].toString(),
//           radius: 100,
//           showTitle: true,
//         );
//       }).toList(),
//     ),
//   );
// }




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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: 
      Column(
        children: [
          FutureBuilder<List<DocumentSnapshot<Object?>>>(
            future: getRevenuData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: vert,));
              } else {
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                  
                } 
                else if (snapshot.data!.isEmpty) {
                    return Text("");
                  }
                else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30,left: 80.0),
                    child: Column(
                      
                      children: [
                       Text("Grapique des Revenus", style: TextStyle(fontWeight: FontWeight.bold, 
                       fontSize: 20
                       ),),
                        Container(
                          height: 200,
                          width: 200,

                          child: revenuGraphe(snapshot.data!)),
                          SizedBox(height: 10,),
                         
                      ],
                    ),
                  );
                }
              }
            },
          ),
          SizedBox(height: 20,),
          FutureBuilder<List<DocumentSnapshot<Object?>>>(
            future: getDepenseData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: vert,));
              } else {
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                    return Center(child: Text("Ajoutez des revenus et des depenses pour voir les graphiques."));
                }
                else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30,left: 80.0),
                    child: Column(
                      
                      children: [
                       Text("Grapique des Dépenses", style: TextStyle(fontWeight: FontWeight.bold, 
                       fontSize: 20
                       ),),
                        Container(
                          height: 200,
                          width: 200,
                          child: depenseGraphe(snapshot.data!)),
                          SizedBox(height: 10,),
                         
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      // FutureBuilder(
      //   future: fetchData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator(color: vert,));
      //     } else {
      //       if (snapshot.hasError) {
      //         return Center(child: Text('Erreur: ${snapshot.error}'));
      //       } else {
      //         return Center(child: buildPieChart(snapshot.data!));
      //       }
      //     }
      //   },
      // ),
    );
  }
}