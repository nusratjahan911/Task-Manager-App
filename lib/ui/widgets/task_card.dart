import 'package:flutter/material.dart';
import 'package:task_manager/data/Services/api_caller.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/utils/urls.dart';

///all page er list er part

class TaskCard extends StatefulWidget {
  final String label;
  final Color color;

  const TaskCard(
      {super.key,
      required this.label,
      required this.color,
      required this.taskModel,
        required this.refreshParent,
        required this.onDelete,
        });

  final TaskModel taskModel;
  final VoidCallback refreshParent;
  final VoidCallback onDelete;


  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  bool _changeStatusInProgress = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.white,
        title: Text(widget.taskModel.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(widget.taskModel.description),
            Text(
              'Date : ${widget.taskModel.createdDate}',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            ),
            Row(
              children: [
                Chip(
                  label: Text(widget.taskModel.status),
                  backgroundColor: widget.color,
                  labelStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: _showChangeStatusDialouge,
                    icon: Visibility(
                      visible: _changeStatusInProgress == false,
                      replacement:CircularProgressIndicator() ,
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    )
                ),
                IconButton(
                    onPressed: _showDeleteDialog,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            )
          ],
        )
    );
  }

  ///method for change status
  void _showChangeStatusDialouge(){
    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        title: Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                _changeStatus('New');
              },
              title: Text('New'),
              trailing: widget.taskModel.status == 'New' ? Icon(Icons.done) : null,
            ),
            ListTile(
              onTap: (){
                _changeStatus('Progress');
              },
              title: Text('Progress'),
              trailing: widget.taskModel.status == 'Progress' ? Icon(Icons.done) : null,
            ),
            ListTile(
              onTap: (){
                _changeStatus('Cancelled');
              },
              title: Text('Cancelled'),
              trailing: widget.taskModel.status == 'Cancelled' ? Icon(Icons.done) : null,
            ),
            ListTile(
              onTap: (){
                _changeStatus('Completed');
              },
              title: Text('Completed'),
              trailing: widget.taskModel.status == 'Completed' ? Icon(Icons.done) : null,
            )
          ],
        ),
      );
    });
  }

  ///API calling for change status
  Future<void> _changeStatus(String status) async{
    if (status == widget.taskModel.status){
      return;
    }
    Navigator.pop(context);
    _changeStatusInProgress = true;
    setState(() {});

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.updateTaskStatusUrl(widget.taskModel.id, status));
    _changeStatusInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.refreshParent();
    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }

  }


///Api for delete task
  Future<bool> _deleteTask() async {
      final ApiResponse response = await ApiCaller.getRequest(
          url: Urls.deleteTaskListUrl(widget.taskModel.id));
      if (response.isSuccess) {
        return true;
      } else {
        return false;
      }
  }


///method for delete task
  void _showDeleteDialog() async{
    bool? confirm  = await showDialog(context: context, builder: (ctx){
      return AlertDialog(
        title: Text(" Delete Task",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure to delete ${widget.taskModel.title}?'),
          ],
        ),
        actions: [
          ElevatedButton(child:Text('Cancel',style: TextStyle(color: Colors.green),),
              onPressed: ()=> Navigator.of(context).pop(false)),
          ElevatedButton(onPressed: ()=> Navigator.of(context).pop(true),
              child: Text('Delete',style: TextStyle(color: Colors.red),)
          ),
        ],
      );
    });
    ///Call api
    if (confirm == true){
      bool success = await _deleteTask();
      if(success){
        widget.onDelete();
        showSnackBarMessage(context, 'Task deleted successfully');
      }else{
        showSnackBarMessage(context, 'Failed to delete task');
      }
    }


  }
}
