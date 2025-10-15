import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/forget_password_verify_otp_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ForgetPasswordVarifyEmailScreen extends StatefulWidget {
  const ForgetPasswordVarifyEmailScreen({super.key});
  static const String name = '/forget-password-email';

  @override
  State<ForgetPasswordVarifyEmailScreen> createState() => _ForgetPasswordVarifyEmailScreenState();
}

class _ForgetPasswordVarifyEmailScreenState extends State<ForgetPasswordVarifyEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      'Your Email Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A 6 digits verification code(OTP) will be sent to your email address',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _onTapNextButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                  text: "Already have an account? ",
                                  children: [
                                    TextSpan(
                                        text: 'Login',
                                        style: TextStyle(color: Colors.green),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _onTapLoginButton
                                    )
                                  ])
                      ),

                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapLoginButton() {
    Navigator.pop(context);
  }

  void _onTapNextButton() {
    Navigator.pushNamed(
        context, ForgetPasswordVarifyOTPScreen.name);
  }



  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
