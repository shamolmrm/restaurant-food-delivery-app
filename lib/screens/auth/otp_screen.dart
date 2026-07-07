import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../core/utils/extensions.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = '';
  bool _isLoading = false;

  Future<void> _verify() async {
    if (_otp.length < 6) {
      context.showSnack('Enter the 6-digit code', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final valid = await auth.verifyOtp(_otp);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (valid) {
      context.go(RouteNames.main);
    } else {
      context.showSnack('Invalid OTP. Try: 123456', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
    );

    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify OTP'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Text('📱', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 24),
            const Text('Verify Your Phone',
                style: AppTextStyles.headlineLarge),
            const SizedBox(height: 8),
            Text(
              'Enter the 6-digit code sent to\n${widget.phone}',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyDecorationWith(
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              onCompleted: (pin) => setState(() => _otp = pin),
              onChanged: (pin) => setState(() => _otp = pin),
            ),
            const SizedBox(height: 12),
            Text(
              'Demo: use 123456',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: 40),
            GradientButton(
              label: 'Verify',
              onPressed: _verify,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: () =>
                      context.showSnack('Code resent!'),
                  child: Text(
                    'Resend',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
