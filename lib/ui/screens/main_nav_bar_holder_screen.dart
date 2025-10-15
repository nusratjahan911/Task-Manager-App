import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager/ui/screens/completed_task_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';

import '../widgets/tm_app_bar.dart';
class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});
  static const String name = '/dashboard';

  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {

  int _selectedindex = 0;

  final List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedindex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedindex,
          onDestinationSelected: (int index){
            _selectedindex = index;
            setState(() {});
          },

          destinations: [
            NavigationDestination(icon: Icon(Icons.new_label_outlined), label:'New' ),
            NavigationDestination(icon: Icon(Icons.refresh), label:'Progress' ),
            NavigationDestination(icon: Icon(Icons.done), label:'Completed' ),
            NavigationDestination(icon: Icon(Icons.close), label:'Cancelled' ),


      ]),
    );
  }
}





