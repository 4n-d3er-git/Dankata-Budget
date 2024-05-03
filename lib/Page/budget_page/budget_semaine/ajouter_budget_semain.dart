import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/chargement.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AjouterSemaine extends StatefulWidget {
  const AjouterSemaine({super.key});

  @override
  State<AjouterSemaine> createState() => _AjouterSemaineState();
}

class _AjouterSemaineState extends State<AjouterSemaine> {
  TextEditingController _nombreDeCategorieController = TextEditingController();
  TextEditingController _titreController = TextEditingController();

  List<TextEditingController> _descriptionDesCategories = [];
  List<TextEditingController> _montantDeCategorie = [];
  int _nombreDeCategories = 0;
  DateTimeRange plageChoisi =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

String? userEmail ="";
bool chargement = false;
      @override
  void initState() {
        userEmail = FirebaseAuth.instance.currentUser?.email;
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

void sendBudget(BuildContext context) async {
  // final nobreCat = _nombreDeCategorieController.text.trim();
  // final description = _descriptionDesCategories;
  // final montant = _montantDeCategorie;
  final titre = _titreController.text.trim();
  final nobreCat = int.tryParse(_nombreDeCategorieController.text.trim()) ?? 0;
  final description = _descriptionDesCategories.map((controller) => controller.text.trim()).toList();
  final montant = _montantDeCategorie.map((controller) => double.tryParse(controller.text.trim()) ?? 0.0).toList();
  
  
  setState(() {
      chargement = true;  
    });
  try {
    
    if (titre.isNotEmpty && montant.isNotEmpty && description.isNotEmpty && nobreCat > 0) {
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
          'start': plageChoisi.start,
          'end': plageChoisi.end,
        },
        'titre': titre,
        'descriptions': description,
        'nombre': nobreCat,
        'montants': montant,
        'email': userEmail,
        'type': 'semaine',
      };
print("Nombre de descriptions: ${description.length}");
print("Nombre de nombreCat: ${montant.length}");
print('$titre');

      await eventDoc.set(donneesBudget);
      montrerSnackBar("Budget ajouté avec succès", context);
      // Récupérer l'ID du document ajouté
      final documentId = eventDoc.id;
      print("Document ajouté avec l'ID: $documentId");
      
  Navigator.pop(context);

    } else if (titre.isEmpty) {
      montrerSnackBar("Veuillez renseigner le titre", context);
    } else if (description.isEmpty) {
      montrerSnackBar("Veuillez renseigner la description", context);
    } else if (montant.isEmpty) {
      montrerSnackBar("Veuillez renseigner le montant", context);
    } else if (nobreCat <= 0) {
      montrerSnackBar("Veuillez renseigner le nombre", context);
    } 

    
  } catch (e) {
    montrerErreurSnackBar("Une erreur est survenue: $e", context);
    setState(() {
      chargement = false;
    });
  }
setState(() {
  chargement =false;
});
  print("$montant, $nobreCat, userEmail: $userEmail");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: vert, borderRadius: BorderRadius.circular(50)),
            child: TextButton(
                onPressed: () async {
                  final DateTimeRange? plageDate = await showDateRangePicker(
                    helpText: "selectionnez une plage de 7 jours",
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
          "Budget de la semaine", //style: TextStyle(fontSize: 13),
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
                      keyboardType: TextInputType.number,
                      controller: _titreController,
                      cursorColor: vert,
                      // onChanged: (value) {
                      //   setState(() {
                      //     _nombreDeCategories = int.tryParse(value) ?? 0;
                      //   });
                      // },
                    ),
                  ),
                  SizedBox(height: 15,),
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
                          hintText: "Nombre de catégorie",
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
                          montrerSnackBar(
                              "veuillez entrer le nombre de catégorie",
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
                                  hintText: "Catégorie"),
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
                    if (_nombreDeCategorieController.text.isEmpty) { 
                      montrerErreurSnackBar(
                          "veuillez entrer le nombre de catégorie", context);
                    } else if (_descriptionDesCategories.isEmpty) {
                      montrerErreurSnackBar(
                          "veuillez appuiyer sur OK puis remplir tous les champs",
                          context);
                    } else if (plageChoisi.duration.inDays != 7) {
                      montrerErreurSnackBar(
                          "vous devez choisir au moins 7 jours", context);
                    } else {
                     sendBudget  (context);  }

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
