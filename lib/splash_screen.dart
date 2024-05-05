import 'package:budget_odc/Page/onBoarding/on_boarding_page.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:budget_odc/widgets/bottomnevbar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //controlleur de la video
  late VideoPlayerController _controlleur;

  @override
  void initState() {
    super.initState();

    _controlleur = VideoPlayerController.asset(
      'assets/dankata.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);

    _playVideo();
  }

  void _playVideo() async {
    // jouer la video
    _controlleur.play();

    // attendre 5 secondes
    await Future.delayed(const Duration(seconds: 5));
     
User? firebaseUtilisateur = FirebaseAuth.instance.currentUser;
        Widget premierWidget;

        if (firebaseUtilisateur != null) {
          premierWidget = BottomNavBar();
        } else {
          premierWidget = OnBoardingPage();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => premierWidget),
        );
      }
      
    
  @override
  void dispose() {
    _controlleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controlleur.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controlleur.value.aspectRatio,
                child: VideoPlayer(
                  _controlleur,
                ),
              )
            : Center(
                    child: Text(
                  "Dankata Budget",
                  style: TextStyle(color: vert, fontSize: 30),
                ))
      ),
    );
  }
}