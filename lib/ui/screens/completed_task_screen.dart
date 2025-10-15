import 'package:flutter/material.dart';

import '../../data/Services/api_caller.dart';
import '../../data/models/task_model.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  bool _getCompletedTaskInProgress = false;
  List<TaskModel> _completedTaskList= [];

  @override
  void initState() {
    super.initState();
    _getAllCompletedTask();
  }


  Future<void> _getAllCompletedTask() async{
    _getCompletedTaskInProgress  = true;
    setState(() {});

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.completedTaskListUrl);
    if (response.isSuccess){
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;

    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCompletedTaskInProgress = false;
    setState(() {});
  }


  void _removeTask(int index){
    setState(() {
      _completedTaskList.removeAt(index);
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Visibility(
              visible: _getCompletedTaskInProgress == false,
              replacement: CircularProgressIndicator(),
              child: ListView.separated(
                itemCount: _completedTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(label: 'Completed', color: Colors.green,
                    taskModel: _completedTaskList[index], refreshParent: () {
                    _getAllCompletedTask();
                    }, onDelete: () { _removeTask(index); },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
              ),
            )
      ),

    );
  }
}




