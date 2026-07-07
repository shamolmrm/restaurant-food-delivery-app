import 'package:go_router/go_router.dart';
import '../../screens/admin/admin_login_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/main/main_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/splash/splash_screen.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: RouteNames.otp,
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return OtpScreen(phone: phone);
      },
    ),
    GoRoute(
      path: RouteNames.main,
      builder: (_, __) => const MainScreen(),
    ),
    GoRoute(
      path: RouteNames.adminLogin,
      builder: (_, __) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: RouteNames.adminDashboard,
      builder: (_, __) => const AdminDashboardScreen(),
    ),
  ],
);
