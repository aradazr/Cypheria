import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/onboarding_provider.dart';
import '../providers/language_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingStep> _getSteps(AppLocalizations localizations) {
    return [
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
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final localizations = AppLocalizations.of(context)!;
    final steps = _getSteps(localizations);
    if (_currentPage < steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).then((_) {
        setState(() {
          // Page changed
        });
      });
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
    final steps = _getSteps(localizations);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Skip button and Language Toggle
              Padding(
                padding: Responsive.padding(context, all: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        localizations.skip,
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 14, 16, 18),
                          fontFamily: Responsive.getFontFamily(context),
                        ),
                      ),
                    ),
                    Consumer<LanguageProvider>(
                      builder: (context, languageProvider, child) {
                        return IconButton(
                          onPressed: languageProvider.toggleLanguage,
                          icon: const Icon(Icons.language),
                          tooltip: languageProvider.isPersian
                              ? 'Switch to English'
                              : 'تغییر به فارسی',
                          iconSize: Responsive.iconSize(context, 22, 24, 26),
                        );
                      },
                    ),
                  ],
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
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    return _buildPage(steps[index], context, isRTL);
                  },
                ),
              ),

              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  steps.length,
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
                      _currentPage == steps.length - 1
                          ? localizations.getStarted
                          : localizations.next,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 16, 18, 20),
                        fontWeight: FontWeight.w600,
                        fontFamily: Responsive.getFontFamily(context),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: Responsive.spacing(context, 20, 24, 28)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingStep step, BuildContext context, bool isRTL) {
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
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 24, 28, 32),
              fontWeight: FontWeight.bold,
              fontFamily: Responsive.getFontFamily(context),
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),

          SizedBox(height: Responsive.spacing(context, 16, 20, 24)),

          // Description
          Text(
            step.description,
            textAlign: TextAlign.center,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 16, 18, 20),
              fontFamily: Responsive.getFontFamily(context),
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
