import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';
class TabBarWidget extends StatelessWidget {
   TabBarWidget({super.key,});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: TabBar(tabs: [
      Tab(text: "Toutes les Transactions",),
      Tab(text: "Revenu",),
      Tab(text: "Dépense",)
    ], indicatorColor: vertBackground, labelColor: vert, unselectedLabelColor: noir,),);
  }
}

class TabBarViewWidget extends StatelessWidget {

   TabBarViewWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        SingleChildScrollView(
          child: Center(child: Text("Toutes"),),
        ),
        SingleChildScrollView(
          child: Center(child: Text("Revenu"),),
        ),
        SingleChildScrollView(
          child: Center(child: Text("Dépense"),),
        ),
      ],
    );
  }
}