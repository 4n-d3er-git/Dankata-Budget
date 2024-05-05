import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';

Widget onBoardingDot({required int index, required int indexCourrent}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 600),
    margin: EdgeInsets.only(right: 5),
    width: indexCourrent == index ? 30 : 30,
    height: indexCourrent == index ? 5 : 5,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: indexCourrent == index ? vert : gris,
    ),
  );
}