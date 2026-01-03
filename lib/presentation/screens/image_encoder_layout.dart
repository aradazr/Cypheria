import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_encoder/presentation/providers/image_encoder_provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../widgets/mode_switch_button.dart';

class ImageEncoderLayout extends StatelessWidget {
  const ImageEncoderLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<ImageEncoderProvider>(
      builder: (context, provider, child) {
        final isEncoding = provider.isEncoding;

        final selectedImage = isEncoding
            ? provider.selectedImageToEncode
            : provider.selectedImageToDecode;

        final isLoading = isEncoding
            ? provider.isLoadingEncode
            : provider.isLoadingDecode;

        final isDone = isEncoding ? provider.isEncoded : provider.isDecoded;

        return Column(
          children: [
            Center(
              child: ModeSwitchButton(
                isEncoding: isEncoding,
                onToggle: provider.toggleMode,
              ),
            ),

            SizedBox(height: Responsive.spacing(context, 24, 26, 30)),

            Align(
              alignment: localizations.locale.languageCode == 'fa'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                localizations.encryptionKey,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.fontSize(context, 14, 16, 18),
                  fontFamily: 'PelakFA',
                ),
              ),
            ),

            SizedBox(height: Responsive.spacing(context, 6, 8, 10)),

            TextField(
              controller: provider.keyController,
              enableIMEPersonalizedLearning: true,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: Responsive.fontSize(context, 14, 16, 18),
                fontFamily: 'PelakFA',
              ),
              textDirection:
                  Localizations.localeOf(context).languageCode == 'fa'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              decoration: InputDecoration(
                hint: Text(
                  localizations.enterKey,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: Responsive.fontSize(context, 14, 16, 18),
                    fontFamily: 'PelakFA',
                  ),
                ),
                contentPadding: Responsive.padding(
                  context,
                  horizontal: 16,
                  vertical: Responsive.spacing(context, 14, 16, 18),
                ),
              ),
            ),

            SizedBox(height: Responsive.spacing(context, 10, 12, 14)),

            _imagePicker(
              context: context,
              image: selectedImage,
              hintText: isEncoding
                  ? localizations.uploadImageToEncode
                  : localizations.uploadImageToDecode,
              onPick: isEncoding
                  ? provider.pickImageToEncode
                  : provider.pickImageToDecode,
              onClear: isEncoding
                  ? provider.clearImageToEncode
                  : provider.clearImageToDecode,
            ),

            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            _actionButton(
              context: context,
              isEncoding: isEncoding,
              isLoading: isLoading,
              text: isEncoding
                  ? localizations.encoding
                  : localizations.decoding,
              onPressed: () {
                if (selectedImage == null) return;

                if (isEncoding) {
                  provider.isLoadingEncode = true;
                  provider.encodeImage(
                    provider.selectedImageToEncode!,
                    provider.keyController.text,
                  );
                } else {
                  provider.isLoadingDecode = true;
                  provider.decodeImage(
                    provider.selectedImageToDecode!,
                    provider.keyController.text,
                  );
                }
              },
            ),

            SizedBox(height: Responsive.spacing(context, 10, 12, 14)),

            if (isDone)
              _saveButton(
                context: context,
                text: localizations.saveToGallery,
                onPressed: () {
                  isEncoding
                      ? provider.saveEncodedImage()
                      : provider.saveDecodedImage();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.savedToGallery),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  // ===========================
  // Widgets (LOCAL HELPERS)
  // ===========================

  Widget _imagePicker({
    required BuildContext context,
    required File? image,
    required String hintText,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return Container(
      height: Responsive.height(context, 350),
      decoration: BoxDecoration(
        color: image == null ? const Color(0xFF1E1E2E) : Colors.transparent,
        border: image == null
            ? Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
              )
            : Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12, 16, 20),
        ),
      ),
      child: Center(
        child: InkWell(
          onTap: onPick,
          child: image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload,
                      size: Responsive.fontSize(context, 100, 120, 140),
                    ),
                    Text(
                      hintText,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Image.file(image),
                    Padding(
                      padding: Responsive.padding(context, left: 10, top: 10),
                      child: ElevatedButton(
                        onPressed: onClear,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            165,
                            48,
                            40,
                          ).withAlpha(200),
                        ),
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required bool isEncoding,
    required bool isLoading,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
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
                  isEncoding ? Icons.lock : Icons.lock_open,
                  size: Responsive.iconSize(context, 20, 22, 24),
                ),
                SizedBox(width: Responsive.spacing(context, 8, 10, 12)),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 16, 18, 20),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PelakFA',
                  ),
                ),
              ],
            ),
    );
  }

  Widget _saveButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          width: 2,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download,
            size: Responsive.iconSize(context, 20, 22, 24),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey.shade700,
          ),
          SizedBox(width: Responsive.spacing(context, 8, 10, 12)),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey.shade700,
              fontSize: Responsive.fontSize(context, 16, 18, 20),
              fontWeight: FontWeight.w600,
              fontFamily: 'PelakFA',
            ),
          ),
        ],
      ),
    );
  }
}
