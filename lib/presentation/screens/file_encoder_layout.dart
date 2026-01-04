import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_encoder/presentation/providers/file_encoder_provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../widgets/mode_switch_button.dart';

class FileEncoderLayout extends StatelessWidget {
  const FileEncoderLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<FileEncoderProvider>(
      builder: (context, provider, child) {
        final isEncoding = provider.isEncoding;
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
                errorText: provider.errorMessage,
                contentPadding: Responsive.padding(
                  context,
                  horizontal: 16,
                  vertical: Responsive.spacing(context, 14, 16, 18),
                ),
              ),
            ),

            SizedBox(height: Responsive.spacing(context, 10, 12, 14)),

            _filePicker(
              context: context,
              fileName: isEncoding && provider.isEncoded
                  ? provider.originalFileName
                  : provider.selectedFileName,
              hintText: isEncoding
                  ? localizations.uploadFileToEncode
                  : localizations.uploadFileToDecode,
              onPick: isEncoding
                  ? provider.pickFileToEncode
                  : provider.pickFileToDecode,
              onClear: isEncoding
                  ? provider.clearFileToEncode
                  : provider.clearFileToDecode,
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
                  : () async {
                      if (isEncoding) {
                        final fileToEncode =
                            provider.isEncoded &&
                                provider.originalFileToEncode != null
                            ? provider.originalFileToEncode!
                            : provider.selectedFileToEncode;

                        if (fileToEncode == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.pleaseSelectFile),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        await provider.encodeFile(
                          fileToEncode,
                          provider.keyController.text,
                        );

                        // Show error message if encode failed
                        if (provider.errorMessage != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(provider.errorMessage!),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        // For decoding, always use originalFileToDecode (the encrypted file picked by user)
                        final fileToDecode = provider.originalFileToDecode;

                        if (fileToDecode == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.pleaseSelectFile),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        await provider.decodeFile(
                          fileToDecode,
                          provider.keyController.text,
                        );

                        // Show error message if decode failed
                        if (provider.errorMessage != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(provider.errorMessage!),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
            ),

            SizedBox(height: Responsive.spacing(context, 10, 12, 14)),

            if (isDone)
              _saveButton(
                context: context,
                text: localizations.saveFile,
                onPressed: () async {
                  if (isEncoding) {
                    await provider.saveEncodedFile(
                      localizations.saveEncryptedFileDialog,
                    );
                  } else {
                    await provider.saveDecodedFile(
                      localizations.saveDecryptedFileDialog,
                    );
                  }

                  // Show error message if save failed
                  if (provider.errorMessage != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.errorMessage!),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (provider.errorMessage == null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations.savedFile),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
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

  Widget _filePicker({
    required BuildContext context,
    required String? fileName,
    required String hintText,
    required VoidCallback onPick,
    required VoidCallback onClear,
    bool isEncoded = false,
  }) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      height: Responsive.height(context, 200),
      decoration: BoxDecoration(
        color: fileName == null
            ? const Color(0xFF1E1E2E)
            : Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12, 16, 20),
        ),
      ),
      child: fileName == null
          ? InkWell(
              onTap: onPick,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_file,
                      size: Responsive.fontSize(context, 60, 70, 80),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
                    Padding(
                      padding: Responsive.padding(context, horizontal: 16),
                      child: Text(
                        hintText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: Responsive.fontSize(context, 14, 16, 18),
                          fontFamily: 'PelakFA',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              alignment: Alignment.topLeft,
              children: [
                Padding(
                  padding: Responsive.padding(context, all: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            size: Responsive.iconSize(context, 32, 36, 40),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, 12, 14, 16),
                          ),
                          Expanded(
                            child: Text(
                              fileName,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: Responsive.fontSize(
                                      context,
                                      14,
                                      16,
                                      18,
                                    ),
                                    fontFamily: 'PelakFA',
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      if (isEncoded) ...[
                        SizedBox(
                          height: Responsive.spacing(context, 8, 10, 12),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(context, 12, 14, 16),
                            vertical: Responsive.spacing(context, 6, 8, 10),
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              Responsive.borderRadius(context, 20, 24, 28),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock,
                                size: Responsive.iconSize(context, 16, 18, 20),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: Responsive.spacing(context, 4, 5, 6),
                              ),
                              Text(
                                localizations.encrypted,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: Responsive.fontSize(
                                    context,
                                    12,
                                    14,
                                    16,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PelakFA',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  top: Responsive.spacing(context, 8, 10, 12),
                  right: Responsive.spacing(context, 8, 10, 12),
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
                      fontFamily: 'PelakFA',
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
            fontFamily: 'PelakFA',
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
