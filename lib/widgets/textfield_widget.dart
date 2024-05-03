// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:budget_odc/theme/couleur.dart';

class TextFiedWiget extends StatefulWidget {
  String hintTexte;
  String? Function(String?)? validateur;
  TextEditingController? controlleur;
  String labelText;
  bool mdp;

  TextFiedWiget(
      {Key? key,
      required this.hintTexte,
      this.validateur,
      this.controlleur,
      required this.labelText,
      required this.mdp})
      : super(key: key);

  @override
  State<TextFiedWiget> createState() => _TextFiedWigetState();
}

class _TextFiedWigetState extends State<TextFiedWiget> {
  bool obscurcir = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: widget.labelText,
            style: TextStyle(fontWeight: FontWeight.bold, color: noirClair),
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        widget.mdp
            ? TextFormField(
                obscureText: obscurcir,
                obscuringCharacter: "*",
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
                    hintText: widget.hintTexte,
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurcir = !obscurcir;
                          });
                        },
                        icon: Icon(
                          obscurcir ? Icons.visibility : Icons.visibility_off,
                          color: obscurcir ? vert : gris,
                        ))),
                controller: widget.controlleur,
                validator: widget.validateur)
            : TextFormField(
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
                  hintText: widget.hintTexte,
                  filled: true,
                  fillColor: Colors.white,
                  
                ),
                controller: widget.controlleur,
                validator: widget.validateur),
      ],
    );
  }
}
