import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import './home_screeen.dart'; 


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
void main() => runApp(const TravelApp());

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TravelGo',
      // home: const EiffelTowerScreen(),
      home: const SplashScreen(), // Start from splash screen
    );
  }
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // optional aesthetic choice
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            FadeAnimatedText(
              'Welcome to TravelGo!',
              textStyle: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              // speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
          onFinished: () {
            // Navigate to home screen when animation completes
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const EiffelTowerScreen()),
            );
          },
        ),
      ),
    );
  }
}
