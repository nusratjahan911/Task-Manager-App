import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/reset_pasword_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ForgetPasswordVarifyOTPScreen extends StatefulWidget {
  const ForgetPasswordVarifyOTPScreen({super.key});
  static const String name = '/forget_password_otp';

  @override
  State<ForgetPasswordVarifyOTPScreen> createState() => _ForgetPasswordVarifyOTPScreenState();
}

class _ForgetPasswordVarifyOTPScreenState extends State<ForgetPasswordVarifyOTPScreen> {
  final TextEditingController _otpController = TextEditingController();
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
                      'Enter Your OTP',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A 6 digits verification code(OTP) has been sent to your email address',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 24),
                    PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      controller: _otpController,
                      appContext: context,
                    ),


                    SizedBox(height: 16),
                    FilledButton(
                      onPressed: _onTapSignUpButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              text: 'Already have an account? ',
                              children: [
                                TextSpan(
                                    text: 'Login',
                                    style: TextStyle(color: Colors.green),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _onTapVerifyButton
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

  void _onTapSignUpButton() {
    Navigator.pushNamedAndRemoveUntil(
        context, ResetPasswordScreen.name,
        (predicate) => false,
    );
  }

  void _onTapVerifyButton() {
    Navigator.pushNamedAndRemoveUntil(
      context,LoginScreen.name,
          (predicate) => false,
    );
  }

}
