import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/Services/api_caller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/utils/urls.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _signUpInProgress = false;

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
                      'Join With Us',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
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
                      controller: _firstNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                      ),
                      validator: (String? value){
                        String inputText = value ?? '';
                        if (value?.trim().isEmpty ?? true){
                          return 'Enter first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _lastNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                      ),
                      validator: (String? value){
                        String inputText = value ?? '';
                        if (value?.trim().isEmpty ?? true){
                          return 'Enter last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Mobile',
                      ),
                      validator: (String? value){
                        String inputText = value ?? '';
                        if (value?.trim().isEmpty ?? true){
                          return 'Enter mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Password'),
                      validator: (String? value){
                        String inputText = value ?? '';
                        if ((value?.length ?? 0) <= 6){
                          return 'Enter a valid password more than 6 letters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _signUpInProgress == false,
                      replacement: circuler_progress_indicator(),
                      child: FilledButton(
                        onPressed: _onTapSubmitButton,
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Column(
                        children: [
                          RichText(
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
                                          ..onTap = _onTapLoginButton)
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


  void _onTapSubmitButton(){
    if (_formkey.currentState!.validate()){
     _signUp();
    }

  }
  
  void _onTapLoginButton(){
    Navigator.pop(context);
  }




  Future<void> _signUp() async{
    _signUpInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email":_emailController.text.trim(),
      "firstName":_firstNameController.text.trim(),
      "lastName":_lastNameController.text.trim(),
      "mobile":_mobileController.text.trim(),
      "password":_passwordController.text,
    };
    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.registrationUrl,
      body: requestBody
    );
    _signUpInProgress = false;
    setState(() {});
    if (response.isSuccess){
      _clearTextField();
      showSnackBarMessage(context, "Registration success! Please login.");

    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }


  }


  void _clearTextField(){
    _emailController.clear();
    _passwordController.clear();
    _mobileController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}


