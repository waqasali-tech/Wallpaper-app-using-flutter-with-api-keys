import 'package:final_project/drawer/dark_light.dart';
import 'package:flutter/material.dart';

//import 'package:helloworld/Mudasar/Light_after.dart';
import 'package:lottie/lottie.dart';
//import 'package:recipe_/Mudasar/ligth_dark.dart';

class SplashToMain extends StatefulWidget {
  const SplashToMain({super.key});

  @override
  State<SplashToMain> createState() => _SplashToMainState();
}

class _SplashToMainState extends State<SplashToMain>
    with TickerProviderStateMixin {
  late AnimationController _fadeScaleController;
  late AnimationController _textSlideController;
  late Animation<double> _fadeScaleAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeScaleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _textSlideController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _fadeScaleAnimation =
        CurvedAnimation(parent: _fadeScaleController, curve: Curves.easeOut);

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textSlideController, curve: Curves.easeInCirc),
    );

    _fadeScaleController.forward();
    _textSlideController.forward();

    Future.delayed(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LightDark()),
      );
    });
  }

  @override
  void dispose() {
    _fadeScaleController.dispose();
    _textSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 5),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
          
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _fadeScaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeScaleAnimation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(140),
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Image.asset(
                          'images/mudassar1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SlideTransition(
                  position: _textSlideAnimation,
                  child: const Text(
                    'Welcome To Waqas App',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Lottie.asset(
                  'images/loading.json', 
                  width: 80,
                  height: 80,
                  repeat: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
