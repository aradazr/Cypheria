import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/text_encoder_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/mode_switch_button.dart';

class TextEncoderLayout extends StatefulWidget {
  const TextEncoderLayout({super.key});

  @override
  State<TextEncoderLayout> createState() => _TextEncoderLayoutState();
}

class _TextEncoderLayoutState extends State<TextEncoderLayout> {
  bool _speechInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_speechInitialized) {
      final locale = Localizations.localeOf(context);
      final provider = Provider.of<TextEncoderProvider>(context, listen: false);
      provider.setLocale(locale);
      provider.initializeSpeech();
      _speechInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<TextEncoderProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Center(
              child: ModeSwitchButton(
                isEncoding: provider.isEncoding,
                onToggle: provider.toggleMode,
              ),
            ),
            SizedBox(height: Responsive.spacing(context, 24, 32, 40)),

            // Key Input
            CustomTextField(
              label: localizations.encryptionKey,
              hint: localizations.enterKey,
              value: provider.key,
              onChanged: provider.setKey,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            // Input Text
            CustomTextField(
              label: provider.isEncoding
                  ? localizations.originalText
                  : localizations.encryptedText,
              hint: provider.isListening
                  ? localizations.listening
                  : (provider.isEncoding
                      ? localizations.enterText
                      : localizations.enterEncryptedText),
              value: provider.inputText,
              onChanged: provider.setInputText,
              maxLines: 6,
              textInputAction: TextInputAction.done,
              onSubmitted: () => provider.process(context),
              errorText: provider.errorMessage,
              onMicrophoneTap: () => provider.startListening(),
              isListening: provider.isListening,
            ),
            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            // Process Button
            ElevatedButton(
              onPressed: provider.isProcessing
                  ? null
                  : () => provider.process(context),
              child: provider.isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          provider.isEncoding ? Icons.lock : Icons.lock_open,
                          size: Responsive.iconSize(context, 20, 22, 24),
                        ),
                        SizedBox(width: Responsive.spacing(context, 8, 10, 12)),
                        Text(
                          provider.isEncoding
                              ? localizations.encoding
                              : localizations.decoding,
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 16, 18, 20),
                            fontWeight: FontWeight.w600,
                            fontFamily: Responsive.getFontFamily(context),
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            // Output Text
            if (provider.outputText.isNotEmpty) ...[
              CustomTextField(
                label: provider.isEncoding
                    ? localizations.encryptedText
                    : localizations.decryptedText,
                hint: localizations.resultHere,
                value: provider.outputText,
                readOnly: true,
                maxLines: Responsive.isMobile(context) ? 6 : 8,
              ),
              SizedBox(height: Responsive.spacing(context, 12, 16, 20)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        provider.copyToInput();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.textCopied),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.swap_horiz,
                        size: Responsive.iconSize(context, 20, 22, 24),
                      ),
                      label: Text(localizations.copyToInput),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.color,
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.spacing(context, 10, 12, 14),
                          horizontal: Responsive.spacing(context, 12, 16, 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.spacing(context, 8, 12, 16)),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: provider.clearAll,
                      icon: Icon(
                        Icons.clear,
                        size: Responsive.iconSize(context, 20, 22, 24),
                      ),
                      label: Text(localizations.clearAll),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.color,
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.spacing(context, 10, 12, 14),
                          horizontal: Responsive.spacing(context, 12, 16, 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
