import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingStep> _steps = [];

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  void _initializeSteps() {
    // Steps will be initialized in build method with localizations
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    context.read<OnboardingProvider>().completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'fa';

    // Initialize steps with localizations
    if (_steps.isEmpty) {
      _steps.addAll([
        OnboardingStep(
          icon: Icons.lock,
          title: localizations.onboardingTitle1,
          description: localizations.onboardingDescription1,
          color: const Color(0xFF6366F1),
        ),
        OnboardingStep(
          icon: Icons.vpn_key,
          title: localizations.onboardingTitle2,
          description: localizations.onboardingDescription2,
          color: const Color(0xFF8B5CF6),
        ),
        OnboardingStep(
          icon: Icons.swap_horiz,
          title: localizations.onboardingTitle3,
          description: localizations.onboardingDescription3,
          color: const Color(0xFF6366F1),
        ),
        OnboardingStep(
          icon: Icons.check_circle,
          title: localizations.onboardingTitle4,
          description: localizations.onboardingDescription4,
          color: const Color(0xFF10B981),
        ),
      ]);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
              child: Padding(
                padding: Responsive.padding(context, all: 16),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    localizations.skip,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 14, 16, 18),
                      fontFamily: 'PelakFA',
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return _buildPage(_steps[index], context);
                },
              ),
            ),

            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length,
                (index) => _buildIndicator(index == _currentPage, context),
              ),
            ),

            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            // Next/Get Started button
            Padding(
              padding: Responsive.padding(
                context,
                horizontal: Responsive.width(context, 24, 32, 40),
                vertical: Responsive.height(context, 16, 20, 24),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: Responsive.padding(
                      context,
                      vertical: Responsive.height(context, 14, 16, 18),
                    ),
                  ),
                  child: Text(
                    _currentPage == _steps.length - 1
                        ? localizations.getStarted
                        : localizations.next,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16, 18, 20),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'PelakFA',
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingStep step, BuildContext context) {
    return Padding(
      padding: Responsive.padding(
        context,
        horizontal: Responsive.width(context, 32, 40, 48),
        vertical: Responsive.height(context, 20, 24, 28),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: Responsive.width(context, 120, 140, 160),
            height: Responsive.width(context, 120, 140, 160),
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              size: Responsive.iconSize(context, 60, 70, 80),
              color: step.color,
            ),
          ),

          SizedBox(height: Responsive.spacing(context, 40, 48, 56)),

          // Title
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 24, 28, 32),
              fontWeight: FontWeight.bold,
              fontFamily: 'PelakFA',
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),

          SizedBox(height: Responsive.spacing(context, 16, 20, 24)),

          // Description
          Text(
            step.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 16, 18, 20),
              fontFamily: 'PelakFA',
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.width(context, 4, 5, 6),
      ),
      width: isActive
          ? Responsive.width(context, 24, 28, 32)
          : Responsive.width(context, 8, 10, 12),
      height: Responsive.height(context, 8, 10, 12),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF6366F1)
            : Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingStep {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

