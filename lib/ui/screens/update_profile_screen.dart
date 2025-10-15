import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/Services/api_caller.dart';
import '../../data/models/user_model.dart';
import '../../data/utils/urls.dart';
import '../controller/auth_controller.dart';
import '../widgets/photo_picker_field.dart';
import '../widgets/snack_bar_message.dart';
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;


  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    UserModel user = AuthController.userModel!;

    _emailController.text = user.email;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _mobileController.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromUpdateProfile: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text("Update Profile",style: TextTheme.of(context).titleLarge),
                  const SizedBox(height: 24),

                  photo_picker_field(
                    onTap: _pickImage,
                    selectedPhoto: _selectedImage,
                  ),

                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password [Optional]'),
                    validator: (String? value){
                      if((value != null && value.isNotEmpty) && value.length < 6){
                        return 'Enter a password more than 6 latter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                   Visibility(
                     visible: _updateProfileInProgress == false,
                    replacement: CircularProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onTapUpdateButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
              ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUpdateButton(){
    if (_formkey.currentState!.validate()){
      _updateProfile();
    }
  }


  Future<void> _updateProfile()async {
    _updateProfileInProgress = true;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      "email" : _emailController.text.trim(),
      "firstName" : _firstNameController.text.trim(),
      "lastName" : _lastNameController.text.trim(),
      "mobile" : _mobileController.text.trim(),
    };
    if(_passwordController.text.isNotEmpty){
      requestBody['password'] = _passwordController.text;
    }


    String? encodedPhoto ;

    if(_selectedImage != null){
      List<int> bytes = await _selectedImage!.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      requestBody['photo'] = encodedPhoto;
    }
    final ApiResponse response = await ApiCaller.postRequest(
        url:Urls.updateProfileUrl, body: requestBody);

    _updateProfileInProgress = false;
    setState(() {});

    if(response.isSuccess){
      _passwordController.clear();

      UserModel model = UserModel(id: AuthController.userModel!.id,
        email: _emailController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobile: _mobileController.text.trim(),
        photo: encodedPhoto ?? AuthController.userModel!.photo,
      );
      await AuthController.updateUserData(model);

      showSnackBarMessage(context, 'Profile has been updated!');
    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }

  }



  Future<void> _pickImage() async{
    XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null){
      _selectedImage = pickedImage;
      setState(() {});

    }

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



