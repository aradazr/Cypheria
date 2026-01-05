import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/responsive.dart';
import '../../core/localization/app_localizations.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String? value;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final int maxLines;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;
  final String? errorText;
  final bool readOnly;
  final VoidCallback? onMicrophoneTap;
  final bool isListening;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.value,
    this.onChanged,
    this.obscureText = false,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
    this.errorText,
    this.readOnly = false,
    this.onMicrophoneTap,
    this.isListening = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
            fontSize: Responsive.fontSize(context, 14, 16, 18),
            fontFamily: Responsive.getFontFamily(context),
          ),
        ),
        SizedBox(height: Responsive.spacing(context, 6, 8, 10)),
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          readOnly: widget.readOnly,
          onSubmitted: widget.onSubmitted != null
              ? (_) => widget.onSubmitted!()
              : null,
          keyboardType: widget.obscureText
              ? TextInputType.visiblePassword
              : TextInputType.text,
          textCapitalization: TextCapitalization.none,
          inputFormatters: [
            // Allow all characters including Persian/Unicode
            // Using a custom formatter that accepts all Unicode characters
            _UnicodeTextInputFormatter(),
          ],
          // Enable IME composition for better support of non-Latin scripts
          enableIMEPersonalizedLearning: true,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: Responsive.fontSize(context, 14, 16, 18),
            fontFamily: Responsive.getFontFamily(context),
          ),
          textDirection: Localizations.localeOf(context).languageCode == 'fa'
              ? TextDirection.rtl
              : TextDirection.ltr,
          enableSuggestions: !widget.obscureText,
          autocorrect: !widget.obscureText,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          // Force text input to accept all characters
          buildCounter: null,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: Responsive.fontSize(context, 14, 16, 18),
              fontFamily: Responsive.getFontFamily(context),
            ),
            errorText: widget.errorText,
            contentPadding: Responsive.padding(
              context,
              horizontal: 16,
              vertical: Responsive.spacing(context, 14, 16, 18),
            ),
            suffixIcon: _buildSuffixIcon(context, localizations),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon(BuildContext context, AppLocalizations? localizations) {
    final List<Widget> actions = [];

    // Add microphone button if callback is provided
    if (widget.onMicrophoneTap != null) {
      actions.add(
        IconButton(
          icon: Icon(
            widget.isListening ? Icons.mic : Icons.mic_none,
            color: widget.isListening 
                ? Theme.of(context).colorScheme.error 
                : Theme.of(context).colorScheme.primary,
            size: Responsive.iconSize(context, 20, 22, 24),
          ),
          onPressed: widget.onMicrophoneTap,
          tooltip: widget.isListening 
              ? (localizations?.stopListening ?? 'Stop Listening')
              : (localizations?.startListening ?? 'Start Listening'),
        ),
      );
    }

    // Add copy button if text is not empty
    if (_controller.text.isNotEmpty) {
      actions.add(
        IconButton(
          icon: Icon(
            Icons.copy,
            color: Colors.grey,
            size: Responsive.iconSize(context, 20, 22, 24),
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _controller.text));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations?.copied ?? 'Copied'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          tooltip: localizations?.copied ?? 'Copy',
        ),
      );
    }

    if (actions.isEmpty) return null;
    if (actions.length == 1) return actions[0];

    // If both buttons exist, wrap them in a Row
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions,
    );
  }
}

// Custom TextInputFormatter to allow all Unicode characters including Persian
class _UnicodeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow all characters (no filtering)
    return newValue;
  }
}
