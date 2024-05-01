import 'package:budget_odc/models/auth.dart';
import 'package:budget_odc/models/utilisateursModels.dart';
import 'package:flutter/cupertino.dart';


class UtilisateurProvider extends ChangeNotifier {
  Utilisateurs? _users;
  bool chargement = false;
  final Authentification _auth = Authentification();
  // getter of the _users
  Utilisateurs get getUser => _users!;
  Future<void> refreshUser() async {
    print("\n\n\nWorking tree file");
    chargement = true;
    Utilisateurs userCreaditials = await _auth.avoirDetailsUtilisateurs();
    _users = userCreaditials;
    print("\n\n\nWorking tree file");
    print(userCreaditials.nomComplet);
    chargement = false;
    notifyListeners();
  }
}