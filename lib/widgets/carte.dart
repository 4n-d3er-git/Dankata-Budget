// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';

class Carte extends StatelessWidget {
  String stitre;
  bool revenu;
  void Function()? onTape;

  Carte(
      {Key? key,
      required this.onTape,
      required this.stitre,
      required this.revenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 169,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: revenu ? vert : rouge,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          revenu
              ? Text(
                  "Revenus",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              : Text(
                  "Dépenses",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Gnf $stitre",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 115,
            ),
            child: IconButton(
                onPressed: onTape,
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 30,
                )),
          ),
        ],
      ),
    );
  }
}

class Carte2 extends StatelessWidget {
  String stitre;
  bool balance;

  Carte2({Key? key, required this.stitre, required this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 169,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: noir,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          balance
              ? Text(
                  "Montant",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              : Text(
                  "Graphe",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
          SizedBox(
            height: 5,
          ),
          balance
              ? Text(
                  "Gnf $stitre",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              : Text(
                  "+ $stitre %",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
        ],
      ),
    );
  }
}
