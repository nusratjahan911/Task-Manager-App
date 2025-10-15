import 'package:flutter/material.dart';
import 'package:task_manager/data/Services/api_caller.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getTaskStatusCountInProgress = false;
  bool _getNewTaskInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  List<TaskModel> _newTaskList= [];

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTask();
  }


  void _removeTask(index){
    setState(() {
      _newTaskList.removeAt(index);
    });
  }



  Future<void> _getAllTaskStatusCount() async{
    _getTaskStatusCountInProgress  = true;
    setState(() {});

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.taskStatusCountUrl);
    if (response.isSuccess){
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = list;

    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getTaskStatusCountInProgress = false;
    setState(() {});
  }


  Future<void> _getAllNewTask() async{
    _getNewTaskInProgress  = true;
    setState(() {});

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.newTaskListUrl);
    if (response.isSuccess){
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;

    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getNewTaskInProgress = false;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: 90,
                child: Visibility(
                  visible: _getTaskStatusCountInProgress == false,
                  replacement: CircularProgressIndicator(),
                  child: ListView.separated(
                    itemCount: _taskStatusCountList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return TaskCountByStatusCard(
                        title: _taskStatusCountList[index].status,
                        count: _taskStatusCountList[index].count,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 4,
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                  child: Visibility(
                    visible: _getNewTaskInProgress == false,
                    replacement:  CircularProgressIndicator(),
                    child: ListView.separated(
                      itemCount: _newTaskList.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskModel: _newTaskList[index],
                            label: 'New', color: Colors.blue,
                          refreshParent: () {
                            _getAllNewTask();
                          }, onDelete: () { _removeTask(index); },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8);
                      },
                    ),
                  )
              )
            ],
          )
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: _onTapNewTaskButton,
        child: Icon(Icons.add),
      ),

    );

  }
  void _onTapNewTaskButton (){
    Navigator.push(
        context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
        );

  }

}




