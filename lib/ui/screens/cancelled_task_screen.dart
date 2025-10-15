import 'package:flutter/material.dart';

import '../../data/Services/api_caller.dart';
import '../../data/models/task_model.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  bool _getCancelledTaskInProgress = false;
  List<TaskModel> _cancelledTaskList= [];

  @override
  void initState() {
    super.initState();
    _getAllCompletedTask();
  }




  Future<void> _getAllCompletedTask() async{
    _getCancelledTaskInProgress  = true;
    setState(() {});

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.cancelledTaskListUrl);
    if (response.isSuccess){
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;

    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCancelledTaskInProgress = false;
    setState(() {});
  }

  void _removeTask(int index){
    setState(() {
      _cancelledTaskList.removeAt(index);
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Visibility(
              visible: _getCancelledTaskInProgress ==  false,
              replacement: CircularProgressIndicator(),
              child: ListView.separated(
                itemCount: _cancelledTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(label: 'Cancelled', color: Colors.red,
                    taskModel: _cancelledTaskList[index],refreshParent: () {
                    _getAllCompletedTask();
                    }, onDelete: () { _removeTask(index); },);
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




