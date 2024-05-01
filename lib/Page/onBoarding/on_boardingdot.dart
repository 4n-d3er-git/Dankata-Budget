import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';

Widget OnBoardingDot({required int index, required int currentIndex}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 600),
    margin: EdgeInsets.only(right: 5),
    width: currentIndex == index ? 30 : 30,
    height: currentIndex == index ? 5 : 5,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: currentIndex == index ? vert : gris,
    ),
  );
}