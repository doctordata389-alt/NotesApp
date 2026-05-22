import 'package:flutter/material.dart';
import 'package:notes/UI/SplashServices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  SplashServices splashServices = SplashServices();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // Navigation logic (your existing)
    splashServices.islogin(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C), // dark background
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Outer Circle
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade900.withOpacity(0.4),
                ),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade800.withOpacity(0.5),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade700.withOpacity(0.7),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1E2A47),
                      ),
                      child: const Icon(
                        Icons.notes,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // App Name
              const Text(
                "NoteSync",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 5),

              // Subtitle
              const Text(
                "Flutter x Firebase",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 40),

              // Loading indicator
              const CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}