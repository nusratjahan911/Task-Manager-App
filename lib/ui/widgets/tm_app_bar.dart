///jelono widget k appbar banano jay (PreferredSizedWidget) diye.


import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';


class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key, this.fromUpdateProfile,
  });

  final bool? fromUpdateProfile;

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {

    final profilePhoto = AuthController.userModel!.photo;

    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: (){
          if (widget.fromUpdateProfile ?? false){
            return;
          }
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => UpdateProfileScreen())
          );
        },
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(
              child: profilePhoto.isNotEmpty ? Image.memory(
              Uint8List.fromList(List<int>.from(jsonDecode(profilePhoto))),
              fit:BoxFit.cover,)
              : Icon(Icons.person),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    AuthController.userModel?.fullName ?? '',  ///Name
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white
                )),
                Text(
                  AuthController.userModel?.email ?? '', ///email
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white
                ),),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Text("LogOut",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.red)),
        IconButton(onPressed: _signOut, icon: Icon(Icons.logout))
      ],
    );
  }
  
  
  Future<void> _signOut() async{
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.name, (predicate)=> false);
  }
}
