import 'package:budget_odc/Page/auth_Page/inscription.dart';
import 'package:budget_odc/Page/onBoarding/on_boardingdot.dart';
import 'package:budget_odc/Page/onBoarding/on_boardingstate.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int indexCourrent = 0;

  List<Map<String, String>> elements = [   
    {
      "titre": "Commencez avec la",
      "sousTitre": "Budgetisateion Basée sur le Revenu.",
      "description": "Une methode de gestion de vos finances en organisant vos dépensen en catégories spécifiques.",
      "image": "assets/images/on1.png",
    },
    {
      "titre": "Continuez à mettre à jour vos revenus",
      "sousTitre": "avec un budget avantageux.",
      "description": "La mise en oeuvre de stratégies respectueuses du budget, vous pouvez tirer le meilleur"
      " parti de vos resources financières et atteindre vos obgetifs financières plus facilement.",
      "image": "assets/images/on3.png",
    },
    {
      "titre": "Continuze à mettre à jour vos dépenses avec",
      "sousTitre": " DankataBudget",
      "description": "En examinant et en optimisant régulièrement vos dépenses, vous pouvez vous assurer."
      "que vous tirez le meilleur parti de vos ressources financières et que  vous restez sur la bonne voie avec"
      "vos styles de vie repectueux de votre budget.",
      "image": "assets/images/on2.png",
    },
  ];
  final PageController  _pageController = PageController(initialPage: 0);

  bool dernierePage = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left:5.0, right: 5),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        indexCourrent = value;
                        dernierePage = (value ==2);
                      });
                    },
                    itemCount: elements.length,
                    itemBuilder: (context, index) => OnBoardingState(
                      titre: elements[index]["titre"].toString(),
                      sousTitre: elements[index]["sousTitre"].toString(),
                      description: elements[index]["description"].toString(),
                      image: elements[index]["image"].toString(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          elements.length,
                          (index) => onBoardingDot(
                              index: index, indexCourrent: indexCourrent),
                        ),
                      ),
                      SizedBox(height: 15,),
                       Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                      },
                                    icon: Icon(Icons.arrow_back_outlined)),

                                    dernierePage ?
                                    
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  height: 40,
                                  decoration: BoxDecoration(color: vert),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Inscription()));
                                                                        },
                                    child: Text(
                                      "Créer un compte",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ):
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  height: 40,
                                  decoration: BoxDecoration(color: vert),
                                  child: TextButton(
                                    onPressed: () {
                                      _pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                                                        },
                                    child: Text(
                                      "Suivant",
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
                      
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
