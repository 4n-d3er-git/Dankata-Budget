import 'package:budget_odc/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'dart:typed_data';
import '../models/utilisateursModels.dart';
class Authentification {
 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

 Future<Utilisateurs> avoirDetailsUtilisateurs() async {
    // log("Ander Locative");
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firebaseFirestore
        .collection("users")
        .doc(currentUser.uid)
        .get() 
        .catchError(
      (onError) {
        throw Exception(onError);
      },
    );

    return Utilisateurs.fromSnap(snapshot);
  }

  Future<String> creerUnCompte(
    {required String email, required String password, required BuildContext context}
  ) async {
    String reponse = "Une erreur s'est produite";
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          reponse = "accomplie";

      User? user = userCredential.user;
      print(user!.uid);
      return user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 
        montrerSnackBar("Le mot de pass est court !", context);
      } else if (e.code == 'email-already-in-use') {
        return 
        montrerSnackBar("Cet email est déja utilisé !", context);
      }
    } catch (e) {
      print(e);
    }
    return  reponse;
  }

  Future<String> seConnecter(
    {required String email, required String motDePass, required BuildContext context}
  ) async {
    String reponse = "Une erreur s'est produite";
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: motDePass);
          reponse = "accomplie";
      User? user = userCredential.user;
      print(user!.uid);
      return user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 
         montrerSnackBar("Cet utilisateur n'existe pas !", context );
      } else if (e.code == 'wrong-password') {
        return 
         montrerSnackBar("Mot de pass incorrect !", context );
      }
    } catch (e) {
      print(e);
    }
    return  reponse;
  }

  // profil de l'utilisateur
   Future<String> informationComplete({
    required String nomComple,
    required String email,
    required String telepone,
    required BuildContext context,
    
  }) async {
    String reponse = "Une erreur s'est produite";
    try {
    if (_auth.currentUser != null) {
      Utilisateurs userCreaditials = Utilisateurs(
        email: _auth.currentUser!.email!,
        uid: _auth.currentUser!.uid,
        nomComplet: nomComple,
        telephone: telepone,
      );
      await _firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set(userCreaditials.toJson());
      reponse = "accomplie";
    } else {
      // Gérer le cas où _auth.currentUser est null
      reponse = "non accomplie";
      montrerSnackBar("non accomplie", context);
    }
  } on FirebaseAuthException catch (err) {
    montrerSnackBar(err.message!, context);
  }
  return reponse;
}

  // forgot password
  Future<String> motDePassOublie(
      {required BuildContext context, required String email}) async {
    String reponse = "Une erreur s'est produite";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      reponse = 'accomplie';
    } on FirebaseException catch (e) {
      montrerSnackBar(e.toString(), context);
    }
    return reponse;
  }

  // signout
  Future<String> seDeconnecter() async {
    String reponse = "Une erreur s'est produite";
    try {
      await _auth.signOut();
      reponse = "Deconnecte";
    } catch (e) {
      reponse = e.toString();
    }
    return reponse;
  }

  // reset password
   

}