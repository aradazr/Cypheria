import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';

class TabSwitchButton extends StatelessWidget {
  final bool usingImageEncoder;
  final VoidCallback onToggle;

  const TabSwitchButton({
    super.key,
    required this.usingImageEncoder,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12, 14, 16),
        ),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context,
            label: localizations.textEncoingTab,
            icon: Icons.text_fields,
            isActive: !usingImageEncoder,
            onTap: !usingImageEncoder ? null : onToggle,
          ),

          Container(
            width: 1,
            height: Responsive.height(context, 40, 44, 48),
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
          _buildButton(
            context,
            label: localizations.imageEncodingTab,
            icon: Icons.image,
            isActive: usingImageEncoder,
            onTap: usingImageEncoder ? null : onToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        Responsive.borderRadius(context, 12, 14, 16),
      ),
      child: Container(
        padding: Responsive.padding(
          context,
          horizontal: Responsive.width(context, 16, 20, 24),
          vertical: Responsive.height(context, 10, 12, 14),
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(context, 12, 14, 16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: Responsive.iconSize(context, 18, 20, 22),
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            SizedBox(width: Responsive.spacing(context, 6, 8, 10)),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
                fontSize: Responsive.fontSize(context, 14, 16, 18),
                fontFamily: 'PelakFA',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
