import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateurs {
  final String? uid;
  final String? email;
  final String? nomComplet;
  final String? telephone;

  Utilisateurs({required this.uid, required this.email, required this.nomComplet, required this.telephone});

   Map<String, dynamic> toJson() => {
        "nomComplet": nomComplet,
        "telephone": telephone,
        "email": email,
        "uid": uid,
      };

      static Utilisateurs fromSnap(DocumentSnapshot documentSnapshot) {
    
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Utilisateurs(
      uid: snapshot['uid'],
      email: snapshot['email'],
      nomComplet: snapshot['nomComplet'],
      telephone: snapshot['telephone'],
    );
  }
}