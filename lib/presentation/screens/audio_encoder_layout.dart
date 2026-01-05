import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/audio_encoder_provider.dart';
import '../widgets/mode_switch_button.dart';

class AudioEncoderLayout extends StatefulWidget {
  const AudioEncoderLayout({super.key});

  @override
  State<AudioEncoderLayout> createState() => _AudioEncoderLayoutState();
}

class _AudioEncoderLayoutState extends State<AudioEncoderLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _updateAnimation(bool isRecording) {
    if (isRecording && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (!isRecording && _animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '00:00';
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<AudioEncoderProvider>(
      builder: (context, provider, child) {
        // Update locale in provider
        provider.setLocale(Localizations.localeOf(context));
        
        final isEncoding = provider.isEncoding;
        final isLoading = isEncoding
            ? provider.isLoadingEncode
            : provider.isLoadingDecode;
        final isDone = isEncoding ? provider.isEncoded : provider.isDecoded;
        final hasAudio = isEncoding
            ? (provider.recordedAudioFile != null || provider.selectedAudioToEncode != null)
            : provider.selectedAudioToDecode != null;
        
        // Update animation based on recording state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _updateAnimation(provider.isRecording);
          }
        });

        return SingleChildScrollView(
          child: Column(
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

            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            // Recording/Playback Section
            if (isEncoding)
              _buildRecordingSection(context, provider, localizations)
            else
              _buildDecodingSection(context, provider, localizations),

            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),

            // Action Button (Record/Encode/Decode)
            _actionButton(
              context: context,
              isEncoding: isEncoding,
              isLoading: isLoading,
              hasAudio: hasAudio,
              isRecording: provider.isRecording,
              isPlaying: provider.isPlaying,
              text: isEncoding
                  ? (provider.isRecording
                      ? localizations.stopRecording
                      : (hasAudio
                          ? localizations.encoding
                          : localizations.recordAudio))
                  : localizations.decoding,
              onPressed: isLoading
                  ? null
                  : () async {
                      if (isEncoding) {
                        if (provider.isRecording) {
                          await provider.stopRecording();
                        } else if (hasAudio) {
                          final audioToEncode = provider.isEncoded &&
                                  provider.originalAudioToEncode != null
                              ? provider.originalAudioToEncode!
                              : provider.recordedAudioFile ?? provider.selectedAudioToEncode;

                          if (audioToEncode == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localizations.pleaseRecordAudio),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          await provider.encodeAudio(
                            audioToEncode,
                            provider.keyController.text,
                          );

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
                          await provider.startRecording();
                        }
                      } else {
                        final audioToDecode = provider.originalAudioToDecode;

                        if (audioToDecode == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.pleaseSelectFile),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        await provider.decodeAudio(
                          audioToDecode,
                          provider.keyController.text,
                        );

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

            // Save and Share buttons if done
            if (isDone)
              Column(
                children: [
                  _saveButton(
                    context: context,
                    text: localizations.saveFile,
                    onPressed: () async {
                      if (isEncoding) {
                        await provider.saveEncodedAudio(
                          localizations.saveEncryptedFileDialog,
                        );
                      } else {
                        await provider.saveDecodedAudio(
                          localizations.saveDecryptedFileDialog,
                        );
                      }

                      if (provider.errorMessage != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.errorMessage!),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.savedFile),
                            duration: const Duration(seconds: 2),
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
                        await provider.shareEncodedAudio();
                      } else {
                        await provider.shareDecodedAudio();
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
          ),
        );
      },
    );
  }

  Widget _buildRecordingSection(
    BuildContext context,
    AudioEncoderProvider provider,
    AppLocalizations localizations,
  ) {
    final hasAudio = provider.recordedAudioFile != null || provider.selectedAudioToEncode != null;
    final audioFile = provider.isEncoded && provider.originalAudioToEncode != null
        ? provider.originalAudioToEncode!
        : (provider.recordedAudioFile ?? provider.selectedAudioToEncode);

    return Column(
      children: [
        // Microphone Button with Animation
        GestureDetector(
          onTap: provider.isRecording
              ? null
              : () async {
                  // If there's audio, clear it first, then start recording
                  if (hasAudio) {
                    provider.stopPlaying();
                    provider.clearAudio();
                    // Wait a bit for UI to update
                    await Future.delayed(const Duration(milliseconds: 100));
                  }
                  await provider.startRecording();
                  
                  // Show error message with settings button if permission is permanently denied
                  if (provider.errorMessage != null && context.mounted) {
                    if (provider.isPermissionPermanentlyDenied) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.errorMessage!),
                          duration: const Duration(seconds: 5),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            label: Localizations.localeOf(context).languageCode == 'fa' ? 'تنظیمات' : 'Settings',
                            textColor: Colors.white,
                            onPressed: () {
                              provider.openSettings();
                            },
                          ),
                        ),
                      );
                    } else {
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
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: provider.isRecording ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: Responsive.width(context, 120, 140, 160),
                  height: Responsive.width(context, 120, 140, 160),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.isRecording
                        ? Colors.red.withValues(alpha: 0.2)
                        : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    border: Border.all(
                      color: provider.isRecording
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.mic,
                    size: Responsive.iconSize(context, 50, 60, 70),
                    color: provider.isRecording
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: Responsive.spacing(context, 16, 20, 24)),

        // Recording Duration or Playback Controls
        if (provider.isRecording)
          Text(
            localizations.recording,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red,
              fontSize: Responsive.fontSize(context, 16, 18, 20),
              fontFamily: Responsive.getFontFamily(context),
            ),
          )
        else if (hasAudio && audioFile != null)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      provider.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: Responsive.iconSize(context, 32, 36, 40),
                    ),
                    onPressed: () => provider.playAudio(audioFile),
                  ),
                  SizedBox(width: Responsive.spacing(context, 16, 20, 24)),
                  IconButton(
                    icon: Icon(
                      Icons.stop,
                      size: Responsive.iconSize(context, 32, 36, 40),
                    ),
                    onPressed: provider.stopPlaying,
                  ),
                ],
              ),
              SizedBox(height: Responsive.spacing(context, 8, 10, 12)),
              if (provider.playbackDuration != null)
                Text(
                  '${_formatDuration(provider.playbackPosition ?? Duration.zero)} / ${_formatDuration(provider.playbackDuration)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Responsive.fontSize(context, 14, 16, 18),
                    fontFamily: Responsive.getFontFamily(context),
                  ),
                )
              else if (provider.recordingDuration != null)
                Text(
                  _formatDuration(provider.recordingDuration),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Responsive.fontSize(context, 14, 16, 18),
                    fontFamily: Responsive.getFontFamily(context),
                  ),
                ),
              SizedBox(height: Responsive.spacing(context, 12, 14, 16)),
              // Record Again button
              OutlinedButton.icon(
                onPressed: () {
                  provider.stopPlaying();
                  provider.clearAudio();
                },
                icon: Icon(
                  Icons.refresh,
                  size: Responsive.iconSize(context, 18, 20, 22),
                ),
                label: Text(
                  localizations.recordAgain,
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
                    vertical: Responsive.spacing(context, 8, 10, 12),
                    horizontal: Responsive.spacing(context, 16, 20, 24),
                  ),
                ),
              ),
            ],
          )
        else
          Text(
            localizations.noAudioRecorded,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
              fontSize: Responsive.fontSize(context, 14, 16, 18),
              fontFamily: Responsive.getFontFamily(context),
            ),
          ),
      ],
    );
  }

  Widget _buildDecodingSection(
    BuildContext context,
    AudioEncoderProvider provider,
    AppLocalizations localizations,
  ) {
    final hasAudio = provider.selectedAudioToDecode != null;
    final audioFile = provider.isDecoded && provider.selectedAudioToDecode != null &&
            provider.selectedAudioToDecode!.path != provider.originalAudioToDecode?.path
        ? provider.selectedAudioToDecode!
        : provider.originalAudioToDecode;

    return Column(
      children: [
        if (hasAudio && audioFile != null)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      provider.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: Responsive.iconSize(context, 32, 36, 40),
                    ),
                    onPressed: () => provider.playAudio(audioFile),
                  ),
                  SizedBox(width: Responsive.spacing(context, 16, 20, 24)),
                  IconButton(
                    icon: Icon(
                      Icons.stop,
                      size: Responsive.iconSize(context, 32, 36, 40),
                    ),
                    onPressed: provider.stopPlaying,
                  ),
                ],
              ),
              SizedBox(height: Responsive.spacing(context, 8, 10, 12)),
              if (provider.playbackDuration != null)
                Text(
                  '${_formatDuration(provider.playbackPosition ?? Duration.zero)} / ${_formatDuration(provider.playbackDuration)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Responsive.fontSize(context, 14, 16, 18),
                    fontFamily: Responsive.getFontFamily(context),
                  ),
                ),
            ],
          )
        else
          InkWell(
            onTap: provider.pickAudioToDecode,
            child: Container(
              constraints: BoxConstraints(
                minHeight: Responsive.height(context, 150),
              ),
              padding: Responsive.padding(context, all: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(
                  Responsive.borderRadius(context, 12, 16, 20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload_file,
                    size: Responsive.fontSize(context, 50, 60, 70),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: Responsive.spacing(context, 10, 12, 16)),
                  Text(
                    localizations.uploadFileToDecode,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: Responsive.fontSize(context, 14, 16, 18),
                      fontFamily: Responsive.getFontFamily(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required bool isEncoding,
    required bool isLoading,
    required bool hasAudio,
    required bool isRecording,
    required bool isPlaying,
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
                    isEncoding
                        ? (isRecording
                            ? Icons.stop
                            : (hasAudio ? Icons.lock : Icons.mic))
                        : Icons.lock_open,
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

