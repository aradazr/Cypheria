import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:text_encoder/presentation/providers/image_encoder_provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/text_encoder_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/mode_switch_button.dart';

class ImageEncoderLayout extends StatelessWidget {
  const ImageEncoderLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<ImageEncoderProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Center(
              child: ModeSwitchButton(
                isEncoding: provider.isEncoding,
                onToggle: provider.toggleMode,
              ),
            ),
            SizedBox(height: Responsive.spacing(context, 24, 26, 30)),
            Align(
              alignment: localizations.locale.languageCode == 'fa'
                  ? .centerRight
                  : .centerLeft,
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
              enableIMEPersonalizedLearning: true,

              controller: provider.keyController,
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
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: Responsive.fontSize(context, 14, 16, 18),
                  fontFamily: 'PelakFA',
                ),
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

            provider.isEncoding
                ? Container(
                    height: Responsive.height(context, 350),
                    decoration: BoxDecoration(
                      color: provider.selectedImageToEncode == null
                          ? Color(0xFF1E1E2E)
                          : Colors.transparent,
                      border: provider.selectedImageToEncode == null
                          ? Border.all(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
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
                        onTap: () {
                          provider.pickImageToEncode();
                        },
                        child: provider.selectedImageToEncode == null
                            ? Column(
                                mainAxisAlignment: .center,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    size: Responsive.fontSize(
                                      context,
                                      100,
                                      120,
                                      140,
                                    ),
                                  ),
                                  Text(
                                    localizations.uploadImageToEncode,
                                    style: TextTheme.of(context).bodyLarge,
                                    textAlign: .center,
                                  ),
                                ],
                              )
                            : Stack(
                                alignment: .topLeft,
                                children: [
                                  Image.file(provider.selectedImageToEncode!),
                                  Padding(
                                    padding: Responsive.padding(
                                      context,
                                      left: 10,
                                      top: 10,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        provider.clearImageToEncode();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          165,
                                          48,
                                          40,
                                        ).withAlpha(200),
                                      ),
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  )
                : Container(
                    height: Responsive.height(context, 350),
                    decoration: BoxDecoration(
                      color: provider.selectedImageToDecode == null
                          ? Color(0xFF1E1E2E)
                          : Colors.transparent,
                      border: provider.selectedImageToDecode == null
                          ? Border.all(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
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
                        onTap: () {
                          provider.pickImageToDecode();
                        },
                        child: provider.selectedImageToDecode == null
                            ? Column(
                                mainAxisAlignment: .center,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    size: Responsive.fontSize(
                                      context,
                                      100,
                                      120,
                                      140,
                                    ),
                                  ),
                                  Text(
                                    localizations.uploadImageToDecode,
                                    style: TextTheme.of(context).bodyLarge,
                                    textAlign: .center,
                                  ),
                                ],
                              )
                            : Stack(
                                alignment: .topLeft,
                                children: [
                                  Image.file(provider.selectedImageToDecode!),
                                  Padding(
                                    padding: Responsive.padding(
                                      context,
                                      left: 10,
                                      top: 10,
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          165,
                                          48,
                                          40,
                                        ).withAlpha(200),
                                      ),
                                      onPressed: () {
                                        provider.clearImageToDecode();
                                      },
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            provider.isEncoding
                ? ElevatedButton(
                    onPressed: () {
                      provider.isLoadingEncode = true;
                      provider.encodeImage(
                        provider.selectedImageToEncode!,
                        provider.keyController.text,
                      );
                    },
                    child: provider.isLoadingEncode
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: .center,
                            children: [
                              Icon(
                                provider.isEncoding
                                    ? Icons.lock
                                    : Icons.lock_open,
                                size: Responsive.iconSize(context, 20, 22, 24),
                              ),
                              SizedBox(
                                width: Responsive.spacing(context, 8, 10, 12),
                              ),
                              Text(
                                provider.isEncoding
                                    ? localizations.encoding
                                    : localizations.decoding,
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(
                                    context,
                                    16,
                                    18,
                                    20,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PelakFA',
                                ),
                              ),
                            ],
                          ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      provider.isLoadingDecode = true;
                      provider.decodeImage(
                        provider.selectedImageToDecode!,
                        provider.keyController.text,
                      );
                    },
                    child: provider.isLoadingDecode
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                provider.isEncoding
                                    ? Icons.lock
                                    : Icons.lock_open,
                                size: Responsive.iconSize(context, 20, 22, 24),
                              ),
                              SizedBox(
                                width: Responsive.spacing(context, 8, 10, 12),
                              ),
                              Text(
                                provider.isEncoding
                                    ? localizations.encoding
                                    : localizations.decoding,
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(
                                    context,
                                    16,
                                    18,
                                    20,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PelakFA',
                                ),
                              ),
                            ],
                          ),
                  ),
            SizedBox(height: Responsive.spacing(context, 10, 12, 14)),
            (provider.isEncoding && provider.isEncoded) ||
                    (!provider.isEncoding && provider.isDecoded)
                ? ElevatedButton(
                    onPressed: () {
                      provider.isEncoding
                          ? provider.saveEncodedImage()
                          : provider.saveDecodedImage();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.savedToGallery),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
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
                          localizations.saveToGallery,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.grey.shade700,
                            fontSize: Responsive.fontSize(context, 16, 18, 20),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'PelakFA',
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        );
      },
    );
  }
}
