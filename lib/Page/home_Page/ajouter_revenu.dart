import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/chargement.dart';
import 'package:budget_odc/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AjouterRevenu extends StatefulWidget {
  const AjouterRevenu({Key? key}) : super(key: key);

  @override
  State<AjouterRevenu> createState() => _AjouterRevenuState();
}

class _AjouterRevenuState extends State<AjouterRevenu> {
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _categoryController;
  late TextEditingController _montantController;
  List<String> _options = [
    'Allocation',
    'Salaire',
    'Autres'
  ]; // List of options

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? userEmail = '';
  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _categoryController = TextEditingController();
    _montantController = TextEditingController();
    userEmail = FirebaseAuth.instance.currentUser?.email;
  }

  String documentId = '';
  double montant = 0;
  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _categoryController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _options.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_options[index]),
              onTap: () {
                setState(() {
                  _categoryController.text = _options[index];
                });
                Navigator.pop(
                    context); // Close the bottom sheet after selection
              },
            );
          },
        );
      },
    );
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       _dateController.text =
  //           '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
  //     });
  //   }
  // }

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime,
  //   );
  //   if (pickedTime != null && pickedTime != _selectedTime) {
  //     setState(() {
  //       _selectedTime = pickedTime;
  //       _timeController.text = '${_selectedTime.hour}:${_selectedTime.minute}';
  //     });
  //   }
  // }
  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
      ),
      dialogBackgroundColor: Colors.white,
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: theme, child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
      ),
      dialogBackgroundColor: Colors.white,
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: theme, child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
         _timeController.text = '${_selectedTime.hour}:${_selectedTime.minute}';
      });
    }
  }

  String? selectedValue;

  Future<void> ajouterRevenu(DateTime date, 
  // TimeOfDay time, 
  String category,
      double montant, String compte) async {
    final eventDoc = FirebaseFirestore.instance.collection("transaction").doc();

    final donneesRevenu = {
      'montant': montant,
      'date': date,
      // 'time': time,
      'category': category,
      'compte': compte,
      'email': userEmail,
      'type': 'revenu'
    };
    await eventDoc.set(donneesRevenu);

    documentId = eventDoc.id;
  }
bool chargement = false;
  //!
  void onPressedD(BuildContext context) async {
  final montant = _montantController.text.trim();
  final categorie = _categoryController.text.trim();
  final compte = selectedValue.toString();
  final heure = _selectedTime.toString();
  final date = _selectedDate.toString();
setState(() {
  chargement = true;
});
  try {
    if (montant.isNotEmpty && date.isNotEmpty && heure.isNotEmpty && categorie.isNotEmpty && compte.isNotEmpty) {
      final eventDoc = FirebaseFirestore.instance.collection("transaction").doc();

      final donneesRevenu = {
        'montant': double.parse(montant),
        'date': _selectedDate,
        // 'time': _selectedTime,
        'category': categorie,
        'compte': compte,
        'email': userEmail,
        "type": "revenu"
      };

      await eventDoc.set(donneesRevenu);
      Navigator.pop(context);
      montrerSnackBar("Revenu ajouté avec succès", context);
      // Récupérer l'ID du document ajouté
      final documentId = eventDoc.id;
      print("Document ajouté avec l'ID: $documentId");
    } else if (date.isEmpty) {
      montrerErreurSnackBar("Veuillez renseigner la date", context);
    } else if (heure.isEmpty) {
      montrerErreurSnackBar("Veuillez renseigner l'heure", context);
    } else if (montant.isEmpty) {
      montrerErreurSnackBar("Veuillez renseigner le montant", context);
    } else if (categorie.isEmpty) {
      montrerErreurSnackBar("Veuillez renseigner la catégorie", context);
    } else if (compte.isEmpty) {
      montrerErreurSnackBar("Veuillez renseigner le compte", context);
    }
  } catch (e) {
    montrerErreurSnackBar("Une erreur est survenue: $e", context);
    setState(() {
      chargement= false;
    });
  }

  print("$montant, $categorie, $compte, $heure, $date? $documentId, userEmail: $userEmail");
}
//!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: vertBackground,
      appBar: AppBar(
        backgroundColor: vertBackground,
        title: Text("Revenu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(children: [
              Row(
                children: [ 
                  Text(
                    "Date&Heure",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                        width: 110,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: vert),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextField(
                          enabled: false,
                          controller: _dateController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: vert),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: _dateController.text.isEmpty
                                  ? "Date"
                                  : _dateController.text),
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: Container(
                        width: 110,
                        height: 30,
                        decoration: BoxDecoration(),
                        child: TextField(
                          controller: _timeController,
                          enabled: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: vert),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: _timeController.text.isEmpty
                                  ? "Heure"
                                  : _timeController.text),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
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
                      controller: _montantController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: vert),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: vert),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(),
                        hintText: "Montant",
                      ),
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
                    "Catégorie",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        _showOptionsBottomSheet(context);
                      },
                      child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(),
                          child: TextField(
                            controller: _categoryController,
                            enabled: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: vert),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: _categoryController.text),
                          )))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    "Compte",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = 'compte';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: selectedValue == 'compte' ? vert : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Compte',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedValue == 'compte'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = 'cash';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: selectedValue == 'cash' ? vert : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Cash',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedValue == 'cash'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = 'carte';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: selectedValue == 'carte' ? vert : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Carte',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedValue == 'carte'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              chargement ? ChargementWidget():
              MaterialButton(
                  height: 50,
                  minWidth: 250,
                  color: vert,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // onPressed: () async {
                  //   final montant = _montantController.text.trim();
                  //   final categorie = _categoryController.text.trim();
                  //   final compte = selectedValue.toString();
                  //   final heure = _selectedTime.toString();
                  //   final date = _selectedDate.toString();

                  //   try {
                  //     if (montant.isNotEmpty &&
                  //         date.isNotEmpty &&
                  //         heure.isNotEmpty &&
                  //         categorie.isNotEmpty &&
                  //         compte.isNotEmpty) {
                  //       await ajouterRevenu(DateTime.parse(date), 
                  //           // _selectedTime,
                  //           categorie, double.parse(montant), compte,
                  //           // _selectedDate ,
                  //           // _selectedTime,
                           
                           
                  //           );
                  //     } else if (date.isEmpty) {
                  //       montrerSnackBar("Veuillez renseigner la date", context);
                  //     } else if (heure.isEmpty) {
                  //       montrerSnackBar("Veuillez renseigner l'heure", context);
                  //     } else if (montant.isEmpty) {
                  //       montrerSnackBar(
                  //           "Veuillez renseigner le montant", context);
                  //     } else if (categorie.isEmpty) {
                  //       montrerSnackBar(
                  //           "Veuillez renseigner la catégorie", context);
                  //     } else if (compte.isEmpty) {
                  //       montrerSnackBar(
                  //           "Veuillez renseigner le compte", context);
                  //     }
                  //   } catch (e) {
                  //     montrerSnackBar("Une erreur est survenue :,", context);
                  //   }
                  //   print("$montant, $categorie, $compte, $heure, $_selectedTime, $date, $_selectedDate ");
                  // },
                  onPressed: (){
                    onPressedD(context);},
                  // onPressed: () async {
                  //   print("ok");
                  // },
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
