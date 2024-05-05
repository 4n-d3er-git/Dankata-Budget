import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';

// creer un snackBar personnalisé

montrerSnackBar(String contenu,  BuildContext context,){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(contenu, style: TextStyle(color: Colors.white),),
  dismissDirection: DismissDirection.up,
  elevation: 0,
  duration: Duration(seconds: 3),
  backgroundColor: vert,
  action: SnackBarAction(label: "X", onPressed: (){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }, textColor: Colors.white),
  )
  );
}

montrerErreurSnackBar(String contenu,  BuildContext context,){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(contenu, style: TextStyle(color: Colors.white),),
  dismissDirection: DismissDirection.up,
  elevation: 0,
  duration: Duration(seconds: 3),
  backgroundColor: rouge,
  action: SnackBarAction(label: "X", onPressed: (){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }, textColor: Colors.white),
  )
  );
}

// // // String montrerSnackBar(String contenu, BuildContext context) {
// // //   ScaffoldMessenger.of(context).showSnackBar(
// // //     SnackBar(
// // //       content: Text(
// // //         contenu,
// // //         style: TextStyle(color: Colors.white),
// // //       ),
// // //       dismissDirection: DismissDirection.up,
// // //       elevation: 0,
// // //       duration: Duration(seconds: 3),
// // //       backgroundColor: vert,
// // //       action: SnackBarAction(
// // //         label: "X",
// // //         onPressed: () {
// // //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
// // //         },
// // //         textColor: Colors.white,
// // //       ),
// // //     ),
// // //   );
// // // }

// // String montrerSnackBar(String contenu, BuildContext context) {
// //   ScaffoldMessenger.of(context).showSnackBar(
// //     SnackBar(
// //       content: Text(
// //         contenu,
// //         style: TextStyle(color: Colors.white),
// //       ),
// //       dismissDirection: DismissDirection.up,
// //       elevation: 0,
// //       duration: Duration(seconds: 3),
// //       backgroundColor: vert,
// //       action: SnackBarAction(
// //         label: "X",
// //         onPressed: () {
// //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
// //         },
// //         textColor: Colors.white,
// //       ),
// //     ),
// //   );
// //   return contenu;
// // }