import 'package:budget_odc/Page/budget_page/ajouter_budget_semain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BudgetSemaine extends StatefulWidget {
  const BudgetSemaine({super.key});

  @override
  State<BudgetSemaine> createState() => _BudgetSemaineState();
}

class _BudgetSemaineState extends State<BudgetSemaine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AjouterSemaine()));}),
      
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('budget').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var budgets = snapshot.data!.docs;
          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              var budget = budgets[index].data();
              return ListTile(
                title: Text('Plage de dates: ${budget['plagedate']['start']} - ${budget['plagedate']['end']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${budget['email']}'),
                    Text('Nombre de catégories: ${budget['nombre']}'),
                    Text('Descriptions: ${budget['descriptions'].join(', ')}'),
                    Text('Montants: ${budget['montants'].join(', ')}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}