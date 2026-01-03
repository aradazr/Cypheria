import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/text_encoder_provider.dart';
import '../screens/text_encoder_layout.dart';
import '../screens/image_encoder_layout.dart';

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
            SizedBox(height: Responsive.spacing(context, 20, 22, 24)),

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
                              Responsive.spacing(context, 60, 80, 100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: TabSwitchButton(
                                usingImageEncoder: provider.isEncodingImage,
                                onToggle: provider.toggleTab,
                              ),
                            ),
                            SizedBox(
                              height: Responsive.spacing(context, 24, 32, 40),
                            ),

                            !provider.isEncodingImage
                                ? TextEncoderLayout()
                                : ImageEncoderLayout(),
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
