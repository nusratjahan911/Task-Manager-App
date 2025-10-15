import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/Services/api_caller.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/forget_password_varify_email_screen.dart';
import 'package:task_manager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/utils/urls.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String name = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _loginProgress = false;

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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      'Get started with',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value){
                        String inputText = value ?? '';
                        if (EmailValidator.validate(inputText) == false){
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Password'),
                      validator: (String? value){
                        String inputText = value ?? '';
                        if ((value?.length ?? 0) <= 6){
                          return 'Password should more than 6 letters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _loginProgress == false,
                      replacement: circuler_progress_indicator(),
                      child: FilledButton(
                        onPressed: _onTapLoginButton,
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: _onTapForgetPasswordButton,
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(color: Colors.grey),
                              )),
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                  text: "Don't have an account? ",
                                  children: [
                                TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(color: Colors.green),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _onTapSignUpButton
                                )
                              ])),
                        ],
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
    Navigator.pushNamed(context, SignUpScreen.name);
  }

  void _onTapForgetPasswordButton() {
    Navigator.pushNamed(
        context, ForgetPasswordVarifyEmailScreen.name);
  }

  void _onTapLoginButton() {
    if(_formkey.currentState!.validate()){
      _login();
    }
  }


  Future<void> _login() async{
    _loginProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email":_emailController.text.trim(),
      "password":_passwordController.text
    };
    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.loginUrl, body: requestBody
    );
    if (response.isSuccess && response.responseData['status'] == 'success'){
      UserModel model = UserModel.fromJson(response.responseData['data']);
      String accessToken = response.responseData['token'];
      await AuthController.saveUserData(model, accessToken);


       Navigator.pushNamedAndRemoveUntil(
       context, MainNavBarHolderScreen.name,
         (predicate) => false,
       );
    }else{
      _loginProgress = false;
      setState(() {});
      final message = response.responseData['data'];
      showSnackBarMessage(context, message ?? response.errorMessage!);
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
