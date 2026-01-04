import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../providers/text_encoder_provider.dart';

class TabSwitchButton extends StatelessWidget {
  final TabType currentTab;
  final Function(TabType) onTabChanged;

  const TabSwitchButton({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              context,
              label: localizations.textEncoingTab,
              icon: Icons.text_fields,
              isActive: currentTab == TabType.text,
              onTap: () => onTabChanged(TabType.text),
              primaryColor: primaryColor,
            ),
          ),
          Expanded(
            child: _buildTab(
              context,
              label: localizations.imageEncodingTab,
              icon: Icons.image,
              isActive: currentTab == TabType.image,
              onTap: () => onTabChanged(TabType.image),
              primaryColor: primaryColor,
            ),
          ),
          Expanded(
            child: _buildTab(
              context,
              label: localizations.fileEncodingTab,
              icon: Icons.insert_drive_file,
              isActive: currentTab == TabType.file,
              onTap: () => onTabChanged(TabType.file),
              primaryColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Responsive.spacing(context, 12, 14, 16),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: Responsive.iconSize(context, 20, 22, 24),
              color: isActive
                  ? primaryColor
                  : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
            ),
            SizedBox(height: Responsive.spacing(context, 4, 5, 6)),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? primaryColor
                    : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: Responsive.fontSize(context, 12, 14, 16),
                fontFamily: 'PelakFA',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
