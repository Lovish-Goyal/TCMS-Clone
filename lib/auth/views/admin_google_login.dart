import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sems/shared/utils/snacbar_helper.dart';
import 'package:sems/auth/utils/terms_privacy.dart';
import '../../core/contants/assets.dart';
import '../../router.dart';
import '../../shared/widgets/refresh_dialog.dart';
import '../providers/auth_state.dart';
import '../providers/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoadingDialogShown = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen(authNotifierProvider, (previous, state) {
      if (state is AuthLoading && !_isLoadingDialogShown) {
        showLoadingDialog(context);
        _isLoadingDialogShown = true;
      } else if (state is! AuthLoading && _isLoadingDialogShown) {
        hideLoadingDialog(context);
        _isLoadingDialogShown = false;
      }

      if (state is AuthAuthenticated) {
        context.go(AppRoute.home.path);
      } else if (state is AuthRequiresRegistration) {
        context.push(
          AppRoute.register.path,
          extra: {
            'uid': state.uid,
            'email': state.email,
            'name': state.name,
            'role': state.role,
          },
        );
      } else if (state is AuthError) {
        SnackbarHelper.showErrorSnackBar(context, state.message);
      } else if (state is AuthLoggedOut) {
        context.go(AppRoute.roleSelection.path);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo/logo_sems-trans.png",
                        height: 180,
                      ),
                      const Text(
                        "SEMS",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Education Management System",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300.0,
                  child: authState is AuthLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ElevatedButton.icon(
                          icon: Image.network(Assets.googleLogo, height: 20),
                          label: const Text("Sign in"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () => _handleSignIn(ref),
                        ),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 30,
            left: 30,
            bottom: 30,
            child: TermsAndPrivacyWidget(
              privacyPolicyUrl: 'link here',
              termsOfServiceUrl: 'link here',
              textColor: Colors.white,
              linkColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignIn(WidgetRef ref) {
    ref.read(authNotifierProvider.notifier).signInWithGoogle('Admin');
  }
}
