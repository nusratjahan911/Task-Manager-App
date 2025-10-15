import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/data/Services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';
class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {


  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewTaskInProgress = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
                padding:EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text('Add New Task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleEditingController,
                        decoration: InputDecoration(
                          hintText: 'Title'
                        ),
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true) {
                            return 'Enter your title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Description',
                        ),
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true) {
                            return 'Enter description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: _addNewTaskInProgress == false,
                          replacement: CircularProgressIndicator() ,
                          child: FilledButton(onPressed: _onTapAddButton, child: Text('Add')))
                    ],
                  )
              ),
            ),
          )),

    );
  }

  void _onTapAddButton(){
    if(_formKey.currentState!.validate()){
      _addNewTask();

    }
  }


  Future<void> _addNewTask() async{
    _addNewTaskInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "title" : _titleEditingController.text.trim(),
      "description" : _descriptionController.text.trim(),
      "status": "New"
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    _addNewTaskInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      _clearTextField();
      showSnackBarMessage(context, 'New task has been added');

    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }
  }



  void _clearTextField(){
    _titleEditingController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

