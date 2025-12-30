import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/text_encoder_provider.dart';
import '../providers/showcase_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/mode_switch_button.dart';
import '../widgets/settings_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _modeSwitchKey = GlobalKey();
  final GlobalKey _keyFieldKey = GlobalKey();
  final GlobalKey _inputFieldKey = GlobalKey();
  final GlobalKey _processButtonKey = GlobalKey();
  final GlobalKey _settingsBarKey = GlobalKey();

  bool _hasStartedShowcase = false;

  @override
  void initState() {
    super.initState();
    // Load showcase status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ShowcaseProvider>().loadShowcaseStatus();
    });
  }

  void _checkAndStartShowcase() {
    if (_hasStartedShowcase) return;

    final showcaseProvider = context.read<ShowcaseProvider>();
    debugPrint(
      'Showcase check: isLoading=${showcaseProvider.isLoading}, isCompleted=${showcaseProvider.isShowcaseCompleted}, shouldShow=${showcaseProvider.shouldShowShowcase}',
    );

    if (showcaseProvider.shouldShowShowcase && !_hasStartedShowcase) {
      _hasStartedShowcase = true;
      debugPrint('Starting showcase...');
      // Wait a bit to ensure UI is fully rendered
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _startShowcase();
        }
      });
    }
  }

  void _startShowcase() {
    try {
      debugPrint(
        'Calling startShowCase with ${[_modeSwitchKey, _keyFieldKey, _inputFieldKey, _processButtonKey, _settingsBarKey].length} keys',
      );
      ShowcaseView.get().startShowCase([
        _modeSwitchKey,
        _keyFieldKey,
        _inputFieldKey,
        _processButtonKey,
        _settingsBarKey,
      ]);
      debugPrint('Showcase started successfully');
    } catch (e, stackTrace) {
      // If showcase fails, log error (in debug mode)
      debugPrint('Failed to start showcase: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Check and start showcase when provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartShowcase();
    });

    return Consumer<ShowcaseProvider>(
      builder: (context, showcaseProvider, child) {
        // Check and start showcase when provider is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkAndStartShowcase();
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(
              localizations.appTitle,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 18, 20, 22),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Consumer<TextEncoderProvider>(
                    builder: (context, provider, child) {
                      final maxWidth = Responsive.maxContentWidth(context);
                      final screenPadding = Responsive.padding(
                        context,
                        all: 16,
                      );

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
                                // Mode Switch with Showcase
                                Center(
                                  child: Showcase(
                                    key: _modeSwitchKey,
                                    title: localizations.showcaseModeTitle,
                                    description:
                                        localizations.showcaseModeDescription,
                                    targetBorderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    tooltipBackgroundColor: Theme.of(
                                      context,
                                    ).cardColor,
                                    textColor:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color ??
                                        Colors.white,
                                    disposeOnTap: true,
                                    onTargetClick: () {
                                      ShowcaseView.get().next();
                                    },
                                    onBarrierClick: () {
                                      ShowcaseView.get().next();
                                    },
                                    child: ModeSwitchButton(
                                      isEncoding: provider.isEncoding,
                                      onToggle: provider.toggleMode,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Responsive.spacing(
                                    context,
                                    24,
                                    32,
                                    40,
                                  ),
                                ),

                                // Key Input with Showcase
                                Showcase(
                                  key: _keyFieldKey,
                                  title: localizations.showcaseKeyTitle,
                                  description:
                                      localizations.showcaseKeyDescription,
                                  targetBorderRadius: BorderRadius.circular(12),
                                  tooltipBackgroundColor: Theme.of(
                                    context,
                                  ).cardColor,
                                  textColor:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color ??
                                      Colors.white,
                                  disposeOnTap: true,
                                  onTargetClick: () {
                                    ShowcaseView.get().next();
                                  },
                                  onBarrierClick: () {
                                    ShowcaseView.get().next();
                                  },
                                  child: CustomTextField(
                                    label: localizations.encryptionKey,
                                    hint: localizations.enterKey,
                                    value: provider.key,
                                    onChanged: provider.setKey,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                SizedBox(
                                  height: Responsive.spacing(
                                    context,
                                    20,
                                    24,
                                    28,
                                  ),
                                ),

                                // Input Text with Showcase
                                Showcase(
                                  key: _inputFieldKey,
                                  title: localizations.showcaseInputTitle,
                                  description:
                                      localizations.showcaseInputDescription,
                                  targetBorderRadius: BorderRadius.circular(12),
                                  tooltipBackgroundColor: Theme.of(
                                    context,
                                  ).cardColor,
                                  textColor:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color ??
                                      Colors.white,
                                  disposeOnTap: true,
                                  onTargetClick: () {
                                    ShowcaseView.get().next();
                                  },
                                  onBarrierClick: () {
                                    ShowcaseView.get().next();
                                  },
                                  child: CustomTextField(
                                    label: provider.isEncoding
                                        ? localizations.originalText
                                        : localizations.encryptedText,
                                    hint: provider.isEncoding
                                        ? localizations.enterText
                                        : localizations.enterEncryptedText,
                                    value: provider.inputText,
                                    onChanged: provider.setInputText,
                                    maxLines: 6,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: () =>
                                        provider.process(context),
                                    errorText: provider.errorMessage,
                                  ),
                                ),
                                SizedBox(
                                  height: Responsive.spacing(
                                    context,
                                    20,
                                    24,
                                    28,
                                  ),
                                ),

                                // Process Button with Showcase
                                Showcase(
                                  key: _processButtonKey,
                                  title: localizations.showcaseButtonTitle,
                                  description:
                                      localizations.showcaseButtonDescription,
                                  targetBorderRadius: BorderRadius.circular(12),
                                  tooltipBackgroundColor: Theme.of(
                                    context,
                                  ).cardColor,
                                  textColor:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color ??
                                      Colors.white,
                                  disposeOnTap: true,
                                  onTargetClick: () {
                                    ShowcaseView.get().next();
                                  },
                                  onBarrierClick: () {
                                    ShowcaseView.get().next();
                                  },
                                  child: ElevatedButton(
                                    onPressed: provider.isProcessing
                                        ? null
                                        : () => provider.process(context),
                                    child: provider.isProcessing
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                provider.isEncoding
                                                    ? Icons.lock
                                                    : Icons.lock_open,
                                                size: Responsive.iconSize(
                                                  context,
                                                  20,
                                                  22,
                                                  24,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Responsive.spacing(
                                                  context,
                                                  8,
                                                  10,
                                                  12,
                                                ),
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
                                ),
                                SizedBox(
                                  height: Responsive.spacing(
                                    context,
                                    20,
                                    24,
                                    28,
                                  ),
                                ),

                                // Output Text
                                if (provider.outputText.isNotEmpty) ...[
                                  CustomTextField(
                                    label: provider.isEncoding
                                        ? localizations.encryptedText
                                        : localizations.decryptedText,
                                    hint: localizations.resultHere,
                                    value: provider.outputText,
                                    readOnly: true,
                                    maxLines: Responsive.isMobile(context)
                                        ? 6
                                        : 8,
                                  ),
                                  SizedBox(
                                    height: Responsive.spacing(
                                      context,
                                      12,
                                      16,
                                      20,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            provider.copyToInput();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  localizations.textCopied,
                                                ),
                                                duration: const Duration(
                                                  seconds: 1,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.swap_horiz,
                                            size: Responsive.iconSize(
                                              context,
                                              20,
                                              22,
                                              24,
                                            ),
                                          ),
                                          label: Text(
                                            localizations.copyToInput,
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.color,
                                            side: BorderSide(
                                              color:
                                                  Theme.of(
                                                        context,
                                                      ).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade300,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: Responsive.spacing(
                                                context,
                                                10,
                                                12,
                                                14,
                                              ),
                                              horizontal: Responsive.spacing(
                                                context,
                                                12,
                                                16,
                                                20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.spacing(
                                          context,
                                          8,
                                          12,
                                          16,
                                        ),
                                      ),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: provider.clearAll,
                                          icon: Icon(
                                            Icons.clear,
                                            size: Responsive.iconSize(
                                              context,
                                              20,
                                              22,
                                              24,
                                            ),
                                          ),
                                          label: Text(localizations.clearAll),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.color,
                                            side: BorderSide(
                                              color:
                                                  Theme.of(
                                                        context,
                                                      ).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade300,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: Responsive.spacing(
                                                context,
                                                10,
                                                12,
                                                14,
                                              ),
                                              horizontal: Responsive.spacing(
                                                context,
                                                12,
                                                16,
                                                20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Settings Bar at bottom with Showcase
                Showcase(
                  key: _settingsBarKey,
                  title: localizations.showcaseSettingsTitle,
                  description: localizations.showcaseSettingsDescription,
                  targetBorderRadius: BorderRadius.circular(12),
                  tooltipBackgroundColor: Theme.of(context).cardColor,
                  textColor:
                      Theme.of(context).textTheme.bodyLarge?.color ??
                      Colors.white,
                  disposeOnTap: true,
                  onTargetClick: () {
                    context.read<ShowcaseProvider>().completeShowcase();
                    ShowcaseView.get().dismiss();
                  },
                  onBarrierClick: () {
                    context.read<ShowcaseProvider>().completeShowcase();
                    ShowcaseView.get().dismiss();
                  },
                  child: const SettingsBar(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
