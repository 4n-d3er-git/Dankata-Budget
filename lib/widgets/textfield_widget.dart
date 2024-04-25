// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:budget_odc/theme/couleur.dart';

class TextFiedWiget extends StatelessWidget {
  String hintTexte;
  String? Function(String?)? validateur;
  TextEditingController? controlleur;
  String labelText;
  TextFiedWiget({
    Key? key,
    required this.labelText,
    required this.hintTexte,
    this.validateur,
    this.controlleur,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: labelText,
            style: TextStyle(fontWeight: FontWeight.bold, color: noirClair),
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        TextFormField(
            decoration: InputDecoration(
              focusColor: vert,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: vert, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: vert, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: vert, width: 5),
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintTexte,
              filled: true,
              fillColor: Colors.white,
            ),
            controller: controlleur,
            validator: validateur),
      ],
    );
  }
}
