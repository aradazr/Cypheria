import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
    // Load onboarding status when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OnboardingProvider>().loadOnboardingStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, onboardingProvider, child) {
        // Show loading indicator while checking onboarding status
        if (onboardingProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show onboarding if not completed, otherwise show home screen
        if (onboardingProvider.shouldShowOnboarding) {
          return const OnboardingScreen();
        }

        return const HomeScreen();
      },
    );
  }
}

