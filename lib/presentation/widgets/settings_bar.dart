import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/responsive.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/app_wrapper.dart';

class SettingsBar extends StatelessWidget {
  const SettingsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      padding: Responsive.padding(
        context,
        horizontal: Responsive.width(context, 16, 20, 24),
        vertical: Responsive.height(context, 10, 12, 14),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Language Toggle Button
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
          SizedBox(width: Responsive.spacing(context, 6, 8, 10)),
          // Theme Toggle Button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                onPressed: themeProvider.toggleTheme,
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'تغییر به تم دارک',
                iconSize: Responsive.iconSize(context, 22, 24, 26),
              );
            },
          ),
          SizedBox(width: Responsive.spacing(context, 6, 8, 10)),
          // Help/Onboarding Button
          Consumer<OnboardingProvider>(
            builder: (context, onboardingProvider, child) {
              return IconButton(
                onPressed: () {
                  // Reset onboarding
                  onboardingProvider.resetOnboarding();
                  
                  // Reset will trigger rebuild and show onboarding
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const AppWrapper(),
                    ),
                  );
                },
                icon: const Icon(Icons.help_outline),
                tooltip: localizations?.skip ?? 'Show Help',
                iconSize: Responsive.iconSize(context, 22, 24, 26),
              );
            },
          ),
        ],
      ),
    );
  }
}

