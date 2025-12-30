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
                fontFamily: 'PelakFA',
              ),
        ),
        SizedBox(height: Responsive.spacing(context, 6, 8, 10)),
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          readOnly: widget.readOnly,
          onSubmitted: widget.onSubmitted != null ? (_) => widget.onSubmitted!() : null,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: Responsive.fontSize(context, 14, 16, 18),
            fontFamily: 'PelakFA',
          ),
          textDirection: Localizations.localeOf(context).languageCode == 'fa'
              ? TextDirection.rtl
              : TextDirection.ltr,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: Responsive.fontSize(context, 14, 16, 18),
              fontFamily: 'PelakFA',
            ),
            errorText: widget.errorText,
            contentPadding: Responsive.padding(
              context,
              horizontal: 16,
              vertical: Responsive.spacing(context, 14, 16, 18),
            ),
            suffixIcon: _controller.text.isNotEmpty && !widget.readOnly
                ? IconButton(
                    icon: Icon(
                      Icons.copy,
                      color: Colors.grey,
                      size: Responsive.iconSize(context, 20, 22, 24),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _controller.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            localizations?.copied ?? 'Copied',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

