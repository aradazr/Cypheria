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
        // Update locale in provider
        provider.setLocale(Localizations.localeOf(context));
        final isEncoding = provider.isEncoding;

        // For encoding: use original image for display, not encrypted file
        // For decoding: use decoded image (which is a valid PNG)
        final displayImage = isEncoding
            ? (provider.isEncoded
                  ? provider.originalImageToEncode
                  : provider.selectedImageToEncode)
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
                  fontFamily: Responsive.getFontFamily(context),
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
                fontFamily: Responsive.getFontFamily(context),
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
                    fontFamily: Responsive.getFontFamily(context),
                  ),
                ),
                errorText: provider.errorMessage,
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
              image: displayImage,
              hintText: isEncoding
                  ? localizations.uploadImageToEncode
                  : localizations.uploadImageToDecode,
              onPick: isEncoding
                  ? provider.pickImageToEncode
                  : provider.pickImageToDecode,
              onClear: isEncoding
                  ? provider.clearImageToEncode
                  : provider.clearImageToDecode,
              isEncoded: isEncoding && provider.isEncoded,
            ),

            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            _actionButton(
              context: context,
              isEncoding: isEncoding,
              isLoading: isLoading,
              text: isEncoding
                  ? localizations.encoding
                  : localizations.decoding,
              onPressed: isLoading
                  ? null
                  : () {
                      if (isEncoding) {
                        // Use original image if encoded, otherwise use selected image
                        final fileToEncode =
                            provider.isEncoded &&
                                provider.originalImageToEncode != null
                            ? provider.originalImageToEncode!
                            : provider.selectedImageToEncode;

                        if (fileToEncode == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.pleaseSelectImage),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        provider.encodeImage(
                          fileToEncode,
                          provider.keyController.text,
                        );
                      } else {
                        // Use encrypted file if decoded, otherwise use selected image
                        final fileToDecode =
                            provider.isDecoded &&
                                provider.originalImageToDecode != null
                            ? provider.originalImageToDecode!
                            : provider.selectedImageToDecode;

                        if (fileToDecode == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.pleaseSelectImage),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        provider.decodeImage(
                          fileToDecode,
                          provider.keyController.text,
                        );
                      }
                    },
            ),

            SizedBox(height: Responsive.spacing(context, 10, 12, 14)),

            if (isDone)
              Column(
                children: [
                  _saveButton(
                    context: context,
                    text: localizations.saveToGallery,
                    onPressed: () async {
                      if (isEncoding) {
                        await provider.saveEncodedImage();
                      } else {
                        await provider.saveDecodedImage();
                      }

                      if (provider.errorMessage == null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.savedToGallery),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: Responsive.spacing(context, 10, 12, 14)),
                  _shareButton(
                    context: context,
                    text: localizations.share,
                    onPressed: () async {
                      if (isEncoding) {
                        await provider.shareEncodedImage();
                      } else {
                        await provider.shareDecodedImage();
                      }

                      if (provider.errorMessage != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.errorMessage!),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
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
    bool isEncoded = false,
  }) {
    final localizations = AppLocalizations.of(context)!;

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
          onTap: image == null ? onPick : null,
          child: image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload,
                      size: Responsive.fontSize(context, 100, 120, 140),
                    ),
                    SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
                    Padding(
                      padding: Responsive.padding(context, horizontal: 16),
                      child: Text(
                        hintText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: Responsive.fontSize(context, 14, 16, 18),
                          fontFamily: Responsive.getFontFamily(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              : Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    // Display the original image with overlay if encrypted
                    Image.file(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // If image fails to load (encrypted file in decode mode), show placeholder
                        return Container(
                          height: Responsive.height(context, 350),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(
                              Responsive.borderRadius(context, 12, 16, 20),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: Responsive.padding(
                                context,
                                horizontal: 16,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock,
                                    size: Responsive.fontSize(
                                      context,
                                      80,
                                      100,
                                      120,
                                    ),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  SizedBox(
                                    height: Responsive.spacing(
                                      context,
                                      16,
                                      20,
                                      24,
                                    ),
                                  ),
                                  Text(
                                    localizations.encryptedFileSelected,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          fontSize: Responsive.fontSize(
                                            context,
                                            14,
                                            16,
                                            18,
                                          ),
                                          fontFamily: Responsive.getFontFamily(context),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: Responsive.spacing(
                                      context,
                                      8,
                                      10,
                                      12,
                                    ),
                                  ),
                                  Text(
                                    localizations.decryptToView,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontSize: Responsive.fontSize(
                                            context,
                                            12,
                                            14,
                                            16,
                                          ),
                                          fontFamily: Responsive.getFontFamily(context),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Overlay badge if encrypted
                    if (isEncoded)
                      Positioned(
                        top: Responsive.spacing(context, 10, 12, 14),
                        right: Responsive.spacing(context, 10, 12, 14),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(context, 12, 14, 16),
                            vertical: Responsive.spacing(context, 6, 8, 10),
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(
                              Responsive.borderRadius(context, 20, 24, 28),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: Responsive.spacing(
                                  context,
                                  8,
                                  10,
                                  12,
                                ),
                                offset: Offset(
                                  0,
                                  Responsive.spacing(context, 2, 2, 3),
                                ),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock,
                                size: Responsive.iconSize(context, 16, 18, 20),
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: Responsive.spacing(context, 4, 5, 6),
                              ),
                              Text(
                                localizations.encrypted,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Responsive.fontSize(
                                    context,
                                    12,
                                    14,
                                    16,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Responsive.getFontFamily(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Close button
                    Positioned(
                      top: Responsive.spacing(context, 10, 12, 14),
                      left: Responsive.spacing(context, 10, 12, 14),
                      child: ElevatedButton(
                        onPressed: onClear,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            165,
                            48,
                            40,
                          ).withValues(alpha: 200),
                          padding: Responsive.padding(
                            context,
                            all: Responsive.spacing(context, 8, 10, 12),
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          size: Responsive.iconSize(context, 18, 20, 22),
                        ),
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
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.spacing(context, 14, 16, 18),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: Responsive.fontSize(context, 20, 22, 24),
                width: Responsive.fontSize(context, 20, 22, 24),
                child: CircularProgressIndicator(
                  strokeWidth: Responsive.spacing(context, 2, 2.5, 3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
                      fontFamily: Responsive.getFontFamily(context),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _saveButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.save, size: Responsive.iconSize(context, 20, 22, 24)),
        label: Text(
          text,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 14, 16, 18),
            fontFamily: Responsive.getFontFamily(context),
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
            width: Responsive.spacing(context, 1, 1.5, 2) / 10,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Responsive.spacing(context, 10, 12, 14),
            horizontal: Responsive.spacing(context, 12, 16, 20),
          ),
        ),
      ),
    );
  }

  Widget _shareButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.share, size: Responsive.iconSize(context, 20, 22, 24)),
        label: Text(
          text,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 14, 16, 18),
            fontFamily: Responsive.getFontFamily(context),
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
            width: Responsive.spacing(context, 1, 1.5, 2) / 10,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Responsive.spacing(context, 10, 12, 14),
            horizontal: Responsive.spacing(context, 12, 16, 20),
          ),
        ),
      ),
    );
  }
}
