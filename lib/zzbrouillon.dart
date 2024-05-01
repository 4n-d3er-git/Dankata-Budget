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
