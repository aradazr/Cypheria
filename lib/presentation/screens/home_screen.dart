import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/text_encoder_provider.dart';
import '../screens/text_encoder_layout.dart';
import '../screens/image_encoder_layout.dart';
import '../screens/file_encoder_layout.dart';
import '../screens/audio_encoder_layout.dart';

import '../widgets/tab_switch_button.dart';
import '../widgets/settings_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.appTitle,
          style: TextStyle(fontSize: Responsive.fontSize(context, 18, 20, 22)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Switch Button right below AppBar
            Consumer<TextEncoderProvider>(
              builder: (context, provider, child) {
                return TabSwitchButton(
                  currentTab: provider.currentTab,
                  onTabChanged: (tab) => provider.setTab(tab),
                );
              },
            ),

            Expanded(
              child: Consumer<TextEncoderProvider>(
                builder: (context, provider, child) {
                  final maxWidth = Responsive.maxContentWidth(context);
                  final screenPadding = Responsive.padding(context, all: 16);

                  return Center(
                    child: SingleChildScrollView(
                      padding: screenPadding,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth,
                          minHeight:
                              MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              AppBar().preferredSize.height -
                              Responsive.spacing(context, 100, 120, 140),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (provider.currentTab == TabType.text)
                              const TextEncoderLayout()
                            else if (provider.currentTab == TabType.image)
                              const ImageEncoderLayout()
                            else if (provider.currentTab == TabType.file)
                              const FileEncoderLayout()
                            else if (provider.currentTab == TabType.audio)
                              const AudioEncoderLayout(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Settings Bar at bottom
            const SettingsBar(),
          ],
        ),
      ),
    );
  }
}
