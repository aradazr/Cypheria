import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/responsive.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isPersian = localizations.locale.languageCode == 'fa';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.termsOfService),
      ),
      body: SingleChildScrollView(
        padding: Responsive.padding(context, all: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPersian ? 'قوانین و مقررات استفاده' : 'Terms of Service',
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
              isPersian ? '۱. پذیرش شرایط' : '1. Acceptance of Terms',
              isPersian
                  ? 'با استفاده از اپلیکیشن Cypheria، شما این قوانین و مقررات را می‌پذیرید. اگر با هر بخشی از این شرایط موافق نیستید، لطفاً از استفاده از اپلیکیشن خودداری کنید.'
                  : 'By using the Cypheria app, you agree to these terms and conditions. If you do not agree with any part of these terms, please refrain from using the app.',
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            _buildSection(
              context,
              isPersian ? '۲. استفاده از اپلیکیشن' : '2. Use of the App',
              isPersian
                  ? '• شما موظفید از اپلیکیشن فقط برای اهداف قانونی استفاده کنید\n• شما مسئول حفظ امنیت کلیدهای رمزگذاری خود هستید\n• ما مسئولیتی در قبال از دست رفتن داده‌ها یا کلیدهای رمزگذاری نداریم\n• استفاده از اپلیکیشن برای فعالیت‌های غیرقانونی ممنوع است'
                  : '• You must use the app only for lawful purposes\n• You are responsible for keeping your encryption keys secure\n• We are not responsible for data loss or encryption key loss\n• Use of the app for illegal activities is prohibited',
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            _buildSection(
              context,
              isPersian ? '۳. محدودیت مسئولیت' : '3. Limitation of Liability',
              isPersian
                  ? '• اپلیکیشن "همان‌طور که هست" ارائه می‌شود بدون هیچ گونه ضمانت\n• ما هیچ مسئولیتی در قبال خسارات مستقیم، غیرمستقیم یا اتفاقی نداریم\n• شما مسئولیت کامل استفاده از اپلیکیشن را بر عهده می‌گیرید'
                  : '• The app is provided "as is" without any warranties\n• We are not liable for any direct, indirect, or incidental damages\n• You assume full responsibility for using the app',
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            _buildSection(
              context,
              isPersian ? '۴. تغییرات در قوانین' : '4. Changes to Terms',
              isPersian
                  ? 'ما حق تغییر این قوانین و مقررات را در هر زمان محفوظ می‌داریم. ادامه استفاده از اپلیکیشن پس از تغییرات به معنای پذیرش شرایط جدید است.'
                  : 'We reserve the right to change these terms at any time. Continued use of the app after changes means acceptance of the new terms.',
            ),
            SizedBox(height: Responsive.spacing(context, 16, 20, 24)),
            _buildSection(
              context,
              isPersian ? '۵. قانون حاکم' : '5. Governing Law',
              isPersian
                  ? 'این قوانین و مقررات تحت قوانین محلی شما تنظیم می‌شود.'
                  : 'These terms are governed by your local laws.',
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
