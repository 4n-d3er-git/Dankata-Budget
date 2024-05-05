import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/chargement.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AjouterEpargne extends StatefulWidget {
  const AjouterEpargne({super.key});

  @override
  State<AjouterEpargne> createState() => _AjouterEpargneState();
}

class _AjouterEpargneState extends State<AjouterEpargne> {
  late TextEditingController _objectifController;
  late TextEditingController _montantController;

String? emailUtilisateur = '';
bool chargement = false;
  @override
  void initState() {
    super.initState();
    _objectifController = TextEditingController();
    _montantController = TextEditingController();
  emailUtilisateur = FirebaseAuth.instance.currentUser?.email;
  }

  String documentId = '';
  double montant = 0;
  @override
  void dispose() {
    _objectifController.dispose();
    _montantController.dispose();
    super.dispose();
  }




   //!
  void onPressedD(BuildContext context) async {
  final montant = _montantController.text.trim();
  final objectif = _objectifController.text.trim();
  setState(() {
    chargement = true;
  });
  try {
    if (montant.isNotEmpty   && objectif.isNotEmpty ) {
      
      final eventDoc = FirebaseFirestore.instance.collection("transaction").doc();

      final donneesRevenu = {
        'montant': double.parse(montant),
        'objectifs': objectif,
        'email': emailUtilisateur,
        "type": "epargne",
        "date": DateTime.now()
      };

      await eventDoc.set(donneesRevenu);
      Navigator.pop(context);
      montrerSnackBar("Epargne ajouté avec succès", context);
      // Récupérer l'ID du document ajouté
      final documentId = eventDoc.id;
      print("Document ajouté avec l'ID: $documentId");
    } else if (montant.isEmpty) {
      montrerErreurSnackBar("Veuillez renseigner le montant", context);
    } else if (objectif.isEmpty) {
      montrerErreurSnackBar("Veuillez renseigner au moins un objectif", context);
    } 
  } catch (e) {
    montrerErreurSnackBar("Une erreur est survenue: $e", context);
    setState(() {
      chargement = false;
    });
  } finally {
        setState(() {
          chargement = false;
        });
      }

  print("$montant, $objectif $documentId, emailUtilisateur: $emailUtilisateur");
}
//!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blancBackground,
      appBar: AppBar(
        backgroundColor: blancBackground,
        title: Text("Epargne"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(children: [
              
            
              Row(
                children: [
                  Text(
                    "Montant",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: rouge),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: rouge),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(),
                        hintText: "Montant",
                      ),
                      controller: _montantController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    "Objectifs",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                       Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(),
                          child: TextField(
                            controller: _objectifController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: ""),
                          )),
                          
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 20,
              ),
              chargement ? 
             ChargementWidget():
              MaterialButton(
                  height: 50,
                  minWidth: 250,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    onPressedD(context);
                  },
                  child: Text(
                    "Ajouter",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
