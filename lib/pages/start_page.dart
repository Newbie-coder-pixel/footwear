import 'package:flutter/material.dart';
import 'package:footwear_client/pages/register_page.dart';
import 'login_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Navigate to LoginPage after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

    @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  'https://www.freepik.com/free-vector/flat-design-cross-country-logo_28554571.htm#fromView=search&page=1&position=42&uuid=0fb8f4f2-ba8d-4f84-bbd2-9e7206af4ce6',
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder.png', // Fallback image
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title or Logo
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Text(
                      'Footwear Store',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 6.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                // Optional slogan or tagline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Text(
                      'Step into comfort and style!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
