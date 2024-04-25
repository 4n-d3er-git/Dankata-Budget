import 'package:budget_odc/Page/auth_Page/inscription.dart';
import 'package:budget_odc/Page/onBoarding/on_boardingdot.dart';
import 'package:budget_odc/Page/onBoarding/on_boardingstate.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentIndex = 0;

  List<Map<String, String>> items = [
    {
      "title": "sdqgfsshqhd",
      "desc": "sldqhjhsqpsdmqsdsdsqddsssqd.",
      "imageURL": "assets/images/on1.png",
    },
    {
      "title": "shdhgdfjsjgdjgdjds",
      "desc": "gfsjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj",
      "imageURL": "assets/images/on2.png",
    },
    {
      "title": "sfykhhhhhhhhhhhhhhhhhhhhhhhh",
      "desc": "dghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh.",
      "imageURL": "assets/images/on3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                  // height: 1 ,
                  ),
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemCount: items.length,
                  itemBuilder: (context, index) => OnBoardingState(
                    title: items[index]["title"].toString(),
                    desc: items[index]["desc"].toString(),
                    imageURL: items[index]["imageURL"].toString(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        items.length,
                        (index) => OnBoardingDot(
                            index: index, currentIndex: currentIndex),
                      ),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    currentIndex == 4
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_back)),
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 40,
                                decoration: BoxDecoration(color: vert),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Sauter",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: currentIndex == 2
                          ? MaterialButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Inscription()));
                              },
                              child: Text("Créer un Compte"),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.green[900],
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.all(12),
                                  minimumSize: Size(double.infinity, 40),
                                ),
                                onPressed: null,
                                child: Text(
                                  "Créer un Compte",
                                  style: TextStyle(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
