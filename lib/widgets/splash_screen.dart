import 'package:flutter/material.dart';

import '../services/brand_config_service.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({super.key, required this.onInitializationComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    // Start fade animation
    _animationController.forward();

    // Wait for minimum splash duration and image loading
    await Future.wait([
      Future.delayed(const Duration(seconds: 3)), // Minimum splash time
      _preloadImage(), // Preload the splash image
    ]);

    // Complete initialization
    widget.onInitializationComplete();
  }

  Future<void> _preloadImage() async {
    final config = BrandConfigService.currentConfig;
    if (config?.splashScreenUrl != null) {
      try {
        final image = NetworkImage(config!.splashScreenUrl);
        await precacheImage(image, context);
        if (mounted) {
          setState(() {
            _imageLoaded = true;
          });
        }
      } catch (e) {
        // Handle image loading error
        debugPrint('Failed to load splash screen image: $e');
        if (mounted) {
          setState(() {
            _imageLoaded = true; // Continue even if image fails
          });
        }
      }
    } else {
      setState(() {
        _imageLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = BrandConfigService.currentConfig;

    if (config == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: config.backgroundColor,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [config.primaryColor, config.secondaryColor],
                ),
              ),
              child: Stack(
                children: [
                  // Background splash image from URL
                  if (config.splashScreenUrl.isNotEmpty && _imageLoaded)
                    Positioned.fill(
                      child: Image.network(
                        config.splashScreenUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  config.primaryColor,
                                  config.secondaryColor,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Overlay gradient for better text visibility
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand logo placeholder
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              config.brandName
                                  .split(' ')
                                  .map((word) => word[0])
                                  .join(''),
                              style: TextStyle(
                                color: config.primaryColor,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // App title
                        Text(
                          config.appTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 10),

                        // Brand name
                        Text(
                          config.brandName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 50),

                        // Loading indicator
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
