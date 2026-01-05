import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isPersian = localizations.locale.languageCode == 'fa';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.privacyPolicy),
      ),
      body: SingleChildScrollView(
        padding: Responsive.padding(context, all: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPersian
                  ? 'سیاست حریم خصوصی'
                  : 'Privacy Policy',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.fontSize(context, 20, 22, 24),
                    fontFamily: Responsive.getFontFamily(context),
                  ),
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            Text(
              isPersian
                  ? 'آخرین به‌روزرسانی: ${DateTime.now().toString().substring(0, 10)}'
                  : 'Last Updated: ${DateTime.now().toString().substring(0, 10)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Responsive.fontSize(context, 12, 14, 16),
                    fontFamily: Responsive.getFontFamily(context),
                  ),
            ),
            SizedBox(height: Responsive.spacing(context, 20, 24, 28)),
            _buildSection(
              context,
              isPersian ? '۱. جمع‌آوری اطلاعات' : '1. Information Collection',
              isPersian
                  ? 'اپلیکیشن Cypheria تمام پردازش‌های رمزگذاری و رمزگشایی را به صورت محلی روی دستگاه شما انجام می‌دهد. ما هیچ اطلاعاتی را جمع‌آوری، ذخیره یا ارسال نمی‌کنیم.\n\n• تمام داده‌های شما (متن، تصاویر، فایل‌ها، صدا) فقط روی دستگاه شما پردازش می‌شوند\n• هیچ داده‌ای به سرورهای خارجی ارسال نمی‌شود\n• هیچ اطلاعات شخصی از شما جمع‌آوری نمی‌شود'
                  : 'Cypheria app performs all encryption and decryption processes locally on your device. We do not collect, store, or transmit any information.\n\n• All your data (text, images, files, audio) is processed only on your device\n• No data is sent to external servers\n• No personal information is collected from you',
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            _buildSection(
              context,
              isPersian ? '۲. دسترسی‌های مورد نیاز' : '2. Required Permissions',
              isPersian
                  ? 'اپلیکیشن برای عملکرد صحیح به دسترسی‌های زیر نیاز دارد:\n\n• دسترسی به میکروفون: برای ضبط صدا\n• دسترسی به فایل‌ها: برای انتخاب و ذخیره فایل‌ها\n• دسترسی به گالری: برای انتخاب و ذخیره تصاویر\n\nتمام این دسترسی‌ها فقط برای عملکرد اپلیکیشن استفاده می‌شوند و هیچ داده‌ای به خارج از دستگاه شما ارسال نمی‌شود.'
                  : 'The app requires the following permissions for proper functionality:\n\n• Microphone access: For recording audio\n• File access: For selecting and saving files\n• Gallery access: For selecting and saving images\n\nAll these permissions are used only for app functionality and no data is transmitted outside your device.',
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            _buildSection(
              context,
              isPersian ? '۳. امنیت داده‌ها' : '3. Data Security',
              isPersian
                  ? '• تمام عملیات رمزگذاری و رمزگشایی به صورت محلی انجام می‌شود\n• از الگوریتم AES-256-CBC برای رمزگذاری استفاده می‌شود\n• کلیدهای رمزگذاری شما فقط روی دستگاه شما ذخیره می‌شوند\n• هیچ کلید یا داده‌ای به سرورهای ما ارسال نمی‌شود'
                  : '• All encryption and decryption operations are performed locally\n• AES-256-CBC algorithm is used for encryption\n• Your encryption keys are stored only on your device\n• No keys or data are sent to our servers',
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            _buildSection(
              context,
              isPersian ? '۴. تغییرات در سیاست حریم خصوصی' : '4. Changes to Privacy Policy',
              isPersian
                  ? 'ما ممکن است این سیاست حریم خصوصی را به‌روزرسانی کنیم. در صورت تغییرات مهم، شما را از طریق اپلیکیشن مطلع خواهیم کرد.'
                  : 'We may update this Privacy Policy. In case of significant changes, we will notify you through the app.',
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            _buildSection(
              context,
              isPersian ? '۵. تماس با ما' : '5. Contact Us',
              isPersian
                  ? 'اگر سوالی درباره این سیاست حریم خصوصی دارید، لطفاً با ما تماس بگیرید.'
                  : 'If you have any questions about this Privacy Policy, please contact us.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.fontSize(context, 16, 18, 20),
                fontFamily: Responsive.getFontFamily(context),
              ),
        ),
        SizedBox(height: Responsive.spacing(context, 8, 10, 12)),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: Responsive.fontSize(context, 14, 16, 18),
                fontFamily: Responsive.getFontFamily(context),
                height: 1.6,
              ),
        ),
      ],
    );
  }
}

