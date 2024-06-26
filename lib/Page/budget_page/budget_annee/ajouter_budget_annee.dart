import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/chargement.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AjouterAnnee extends StatefulWidget {
  const AjouterAnnee({super.key});

  @override
  State<AjouterAnnee> createState() => _AjouterAnneeState();
}

class _AjouterAnneeState extends State<AjouterAnnee> {
  TextEditingController _nombreDeCategorieController = TextEditingController();
  TextEditingController _titreController = TextEditingController();

  List<TextEditingController> _descriptionDesCategories = [];
  List<TextEditingController> _montantDeCategorie = [];
  int _nombreDeCategories = 0;
  DateTimeRange plageChoisi =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  String? emailUtilisateur = "";
  bool chargement = false;
  @override
  void initState() {
    emailUtilisateur = FirebaseAuth.instance.currentUser?.email;
    _descriptionDesCategories = [];
    _montantDeCategorie = [];

    super.initState();
  }

  @override
  void dispose() {
    _nombreDeCategorieController.dispose();
    _titreController.dispose();
    for (var controller in _descriptionDesCategories) {
      controller.dispose();
    }
    for (var controller in _montantDeCategorie) {
      controller.dispose();
    }
    super.dispose();
  }

  void ajouterBudget(BuildContext context) async {
    
    final titre = _titreController.text.trim();
    final nobreCat =
        int.tryParse(_nombreDeCategorieController.text.trim()) ?? 0;
    final description = _descriptionDesCategories
        .map((controller) => controller.text.trim())
        .toList();
    final montant = _montantDeCategorie
        .map((controller) => double.tryParse(controller.text.trim()) ?? 0.0)
        .toList();
        setState(() {
        chargement = true;
      });
    try {
      
      if (titre.isNotEmpty &&
          montant.isNotEmpty &&
          description.isNotEmpty &&
          nobreCat > 0) {
        final eventDoc = FirebaseFirestore.instance.collection("budget").doc();
        List<String> jours = [];
        for (int i = 0; i < _nombreDeCategories; i++) {
          final description = _descriptionDesCategories[i].text.trim();
          jours.add(description);
        }
        for (int i = 0; i < _nombreDeCategories; i++) {
          final nobreCat = _montantDeCategorie[i].text.trim();
          jours.add(nobreCat);
        }
        final donneesBudget = {
          'plagedate': {
            'debut': plageChoisi.start,
            'fin': plageChoisi.end,
          },
          'titre': titre,
          'descriptions': description,
          'nombre': nobreCat,
          'montants': montant,
          'email': emailUtilisateur,
          'type': 'annee',
        };
        print("Nombre de descriptions: ${description.length}");
        print("Nombre de nombreCat: ${montant.length}");
        print('$titre');

        await eventDoc.set(donneesBudget);
        // Récupérer l'ID du document ajouté
        final documentId = eventDoc.id;
        print("Document ajouté avec l'ID: $documentId");
        // retoure à l'autre ecran
        Navigator.pop(context);
        montrerSnackBar("Budget ajouté avec succès", context);

      } else if (titre.isEmpty) {
        montrerErreurSnackBar("Veuillez renseigner le titre", context);
      } else if (description.isEmpty) {
        montrerErreurSnackBar("Veuillez renseigner la description", context);
      } else if (montant.isEmpty) {
        montrerErreurSnackBar("Veuillez renseigner le montant", context);
      } else if (nobreCat <= 0) {
        montrerErreurSnackBar("Veuillez renseigner le nombre", context);
      }

      montrerSnackBar("Budget ajouté avec succès", context);
    } catch (e) {
      montrerErreurSnackBar("Une erreur est survenue: $e", context);
      setState(() {
        chargement = false;
      });
    }
    setState(() {
      chargement = false;
    });
    print("$montant, $nobreCat, emailUtilisateur: $emailUtilisateur");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: 35,
            width: 50,
            decoration: BoxDecoration(
                color: vert, borderRadius: BorderRadius.circular(50)),
            child: TextButton(
                onPressed: () async {
                  // afficher le selecteur de date
                  final DateTimeRange? plageDate = await showDateRangePicker(
                      helpText: "selectionnez une plage de 365 jours",
                      cancelText: "Quitter",
                      fieldEndHintText: "Date de Fin",
                      fieldStartHintText: "Date de Début",
                      fieldEndLabelText: "Selectionnez une ",
                      fieldStartLabelText: "Selectionnez une ",
                      confirmText: "Confirmer",
                      saveText: "confirmer",
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030));
                  if (plageDate != null) {
                    setState(() {
                      plageChoisi = plageDate;
                    });
                  }
                },
                child: Text(
                  "${plageChoisi.duration.inDays}",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
        title: Text(
          "Budget Annuel", 
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Donnez un tire au budget",
                      hintStyle: TextStyle(
                        fontSize: 10,
                      )),
                  controller: _titreController,
                  cursorColor: vert,
                  
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Nombre de descriptions",
                          hintStyle: TextStyle(
                            fontSize: 12,
                          )),
                      keyboardType: TextInputType.number,
                      controller: _nombreDeCategorieController,
                      cursorColor: vert,
                      onChanged: (value) {
                        setState(() {
                          _nombreDeCategories = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _descriptionDesCategories.clear();
                      for (int i = 0; i < _nombreDeCategories; i++) {
                        _descriptionDesCategories.add(TextEditingController());
                      }
                      for (int i = 0; i < _nombreDeCategories; i++) {
                        _montantDeCategorie.add(TextEditingController());
                      }

                      setState(() {
                        if (_nombreDeCategorieController.text.isEmpty) {
                          montrerErreurSnackBar(
                              "veuillez entrer le Nombre de descriptions",
                              context);
                        }
                      });
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: vert,
                  )
                ],
              ),

              //!_descriptionDesCategories
              const SizedBox(
                height: 20,
              ),
              Column(
                children: List.generate(
                  _descriptionDesCategories.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            height: 50,
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _montantDeCategorie[index],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Montant"),
                            )),
                        Container(
                            height: 50,
                            width: 150,
                            child: TextField(
                              controller: _descriptionDesCategories[index],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Description"),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              chargement ? ChargementWidget():
              MaterialButton(
                  height: 50,
                  minWidth: 250,
                  color: vert,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    if(_titreController.text.isEmpty){
                      montrerErreurSnackBar("veuillez entrer un titre", context);
                    }
                    else if (_nombreDeCategorieController.text.isEmpty) {
                      montrerErreurSnackBar(
                          "veuillez entrer le Nombre de descriptions", context);
                    } else if (_descriptionDesCategories.isEmpty) {
                      montrerErreurSnackBar(
                          "veuillez appuiyer sur OK puis remplir tous les champs",
                          context);
                   } else if (plageChoisi.duration.inDays != 365) {
                      montrerErreurSnackBar(
                          "vous devez choisir au moins 365 jours", context);
                    } else {
                      ajouterBudget(context);
                    }
                  },
                  child: Text(
                    "Valider",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
