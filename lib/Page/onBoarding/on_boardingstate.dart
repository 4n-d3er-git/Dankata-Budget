import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';

class OnBoardingState extends StatelessWidget {
  OnBoardingState({
    Key? key,
    required this.titre,
    required this.sousTitre,
    required this.description,
    required this.image,
  }) : super(key: key);
  final String titre;
  final String sousTitre;
  final String description;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 34,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0),
          child: Image.asset(
            image,
            width: double.infinity,
            height: 250,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titre,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff023020),
                ),
              ),
              Text(sousTitre,style: TextStyle(color: orange, fontSize: 26,
                  fontWeight: FontWeight.bold,),),
              SizedBox(
                height: 10,
              ),
              
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
      
      ],
    );
  }
}
