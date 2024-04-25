import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingState extends StatelessWidget {
  OnBoardingState({
    Key? key,
    required this.title,
    required this.desc,
    required this.imageURL,
  }) : super(key: key);
  final String title;
  final String desc;
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 34,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Image.asset(
            imageURL,
            width: double.infinity,
            height: 200,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff023020),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
