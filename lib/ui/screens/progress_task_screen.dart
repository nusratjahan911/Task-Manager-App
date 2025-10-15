import 'package:flutter/material.dart';
import '../../data/Services/api_caller.dart';

import '../../data/models/task_model.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  bool _getProgressTaskInProgress = false;
  List<TaskModel> _progressTaskList= [];

  @override
  void initState() {
    super.initState();
    _getAllProgressTask();
  }



  Future<void> _getAllProgressTask() async{
    _getProgressTaskInProgress  = true;
    setState(() {});

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.progressTaskListUrl);
    if (response.isSuccess){
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;

    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getProgressTaskInProgress = false;
    setState(() {});
  }


  void _removeTask(int index){
    setState(() {
      _progressTaskList.removeAt(index);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Visibility(
                  visible: _getProgressTaskInProgress == false,
                  replacement: CircularProgressIndicator(),
                  child: ListView.separated(
                                itemCount: _progressTaskList.length,
                                itemBuilder: (context, index) {
                  return TaskCard(label: 'Progress', color: Colors.purpleAccent, taskModel: _progressTaskList[index],
                    refreshParent: () {
                    _getAllProgressTask();
                    }, onDelete: () {
                    _removeTask(index);
                    },);
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




