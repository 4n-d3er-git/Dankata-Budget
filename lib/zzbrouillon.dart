// // Calculer les revenus de l'utilisateur actuel
// Future<double> calculerRevenusUtilisateur(String email) async {
//   double totalRevenus = 0;
//   try {
//     QuerySnapshot revenusSnapshot = await FirebaseFirestore.instance.collection('revenus')
//         .where('email', isEqualTo: email) // Filtrer par e-mail de l'utilisateur
//         .get();
//     revenusSnapshot.docs.forEach((doc) {
//       totalRevenus += doc.data()['montant'];
//     });
//   } catch (e) {
//     print('Erreur lors du calcul des revenus de l\'utilisateur: $e');
//   }
//   return totalRevenus;
// }

// // Calculer les dépenses de l'utilisateur actuel
// Future<double> calculerDepensesUtilisateur(String email) async {
//   double totalDepenses = 0;
//   try {
//     QuerySnapshot depensesSnapshot = await FirebaseFirestore.instance.collection('depenses')
//         .where('email', isEqualTo: email) // Filtrer par e-mail de l'utilisateur
//         .get();
//     depensesSnapshot.docs.forEach((doc) {
//       totalDepenses += doc.data()['montant'];
//     });
//   } catch (e) {
//     print('Erreur lors du calcul des dépenses de l\'utilisateur: $e');
//   }
//   return totalDepenses;
// }

// // Calculer le solde actuel de l'utilisateur actuel
// Future<double> calculerSoldeUtilisateur(String email) async {
//   double solde = 0;
//   double revenus = await calculerRevenusUtilisateur(email);
//   double depenses = await calculerDepensesUtilisateur(email);
//   solde = revenus - depenses;
//   return solde;
// }

// // Utilisation
// void main() async {
//   String emailUtilisateurActuel = 'email@example.com'; // Vous devez récupérer l'e-mail de l'utilisateur actuel
//   double revenus = await calculerRevenusUtilisateur(emailUtilisateurActuel);
//   double depenses = await calculerDepensesUtilisateur(emailUtilisateurActuel);
//   double solde = await calculerSoldeUtilisateur(emailUtilisateurActuel);
//   print('Revenus de l\'utilisateur: $revenus');
//   print('Dépenses de l\'utilisateur: $depenses');
//   print('Solde actuel de l\'utilisateur: $solde');
// }


//!


// // Calculer le solde actuel du compte depuis Firebase
// Future<double> calculerSoldeCompte() async {
//   double solde = 0;
//   try {
//     // Récupérer tous les documents de la collection des revenus
//     QuerySnapshot revenusSnapshot = await FirebaseFirestore.instance.collection('revenus').get();
//     // Parcourir les documents et additionner les montants des revenus
//     revenusSnapshot.docs.forEach((doc) {
//       solde += doc.data()['montant'];
//     });

//     // Récupérer tous les documents de la collection des dépenses
//     QuerySnapshot depensesSnapshot = await FirebaseFirestore.instance.collection('depenses').get();
//     // Parcourir les documents et soustraire les montants des dépenses
//     depensesSnapshot.docs.forEach((doc) {
//       solde -= doc.data()['montant'];
//     });
//   } catch (e) {
//     print('Erreur lors du calcul du solde du compte: $e');
//   }
//   return solde;
// }

// // Utilisation
// void main() async {
//   // Calculer le solde actuel du compte
//   double solde = await calculerSoldeCompte();
//   print('Le solde actuel du compte est: $solde');
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class TransactionScreen extends StatefulWidget {
//   @override
//   _TransactionScreenState createState() => _TransactionScreenState();
// }

// class _TransactionScreenState extends State<TransactionScreen> {
//   DateTime? _startDate;
//   DateTime? _endDate;

//   Future<QuerySnapshot> _fetchData() async {
//     Query transactionsQuery = FirebaseFirestore.instance
//         .collection('transaction')
//         .where('type', isEqualTo: 'epargne')
//         .where('email', isEqualTo: emailUtilisateur);

//     if (_startDate != null && _endDate != null) {
//       transactionsQuery = transactionsQuery
//           .where('date', isGreaterThanOrEqualTo: _startDate)
//           .where('date', isLessThanOrEqualTo: _endDate);
//     }

//     return await transactionsQuery.get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transactions'),
//       ),
//       body: Column(
//         children: [
//           ListTile(
//             title: Text(
//               _startDate == null && _endDate == null
//                   ? 'Sélectionner une plage de dates'
//                   : 'Du: ${_startDate!.toString()} au: ${_endDate!.toString()}',
//             ),
//             trailing: Icon(Icons.date_range),
//             onTap: () async {
//               final picked = await showDateRangePicker(
//                 context: context,
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime.now(),
//                 initialDateRange: _startDate != null && _endDate != null
//                     ? DateTimeRange(start: _startDate!, end: _endDate!)
//                     : null,
//               );
//               if (picked != null && picked.start != null && picked.end != null) {
//                 setState(() {
//                   _startDate = picked.start;
//                   _endDate = picked.end;
//                 });
//               }
//             },
//           ),
//           Expanded(
//             child: FutureBuilder<QuerySnapshot>(
//               future: _fetchData(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text("Erreur : ${snapshot.error}");
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator(color: vert,);
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Text("Aucune donnée trouvée");
//                 }
//                 final userData = snapshot.data!.docs;
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: userData.length,
//                   itemBuilder: (context, index) {
//                     final userDataFields = userData[index];
//                     final montant = userDataFields['montant'];
//                     final objectif = userDataFields['objectifs'] as String? ?? '';
//                     final date = userDataFields['date'];

//                     return ListTile(
//                       trailing: Text(
//                         "$montant",
//                         style: TextStyle(color: vert, fontSize: 16),
//                       ),
//                       title: Text(
//                         objectif,
//                         style: TextStyle(color: vert, fontWeight: FontWeight.bold),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Stack(
//   children: [
//     Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: Container(
//         padding: EdgeInsets.all(20),
//         color: Colors.blue,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               "Montant Total",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             // Déplacer ce Text à l'extérieur du ListView.builder
//             StreamBuilder(
//               stream: FirebaseFirestore.instance.collection('budget').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator(color: vert,);
//                 }

//                 var budgets = snapshot.data!.docs;
//                 double montantTotal = 0;
//                 for (var budget in budgets) {
//                   List<double> montants = List<double>.from(budget['montants']);
//                   montantTotal += montants.fold(0, (prev, montant) => prev + montant);
//                 }

//                 return Text(
//                   "Gnf $montantTotal",
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 );
//               },
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             MaterialButton(
//               onPressed: () {},
//               child: Row(
//                 children: [
//                   Text(
//                     "Filtrer",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   Icon(
//                     Icons.filter_list,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     // Placer le reste de votre code ici
//   ],
// ),
