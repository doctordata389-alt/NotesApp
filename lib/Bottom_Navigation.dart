import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/Profile.dart';
import 'package:notes/homeScreen.dart';
import 'package:notes/toDo/ToDo.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
int _selectedIndex = 0;

void goHome(){
  setState(() {
    _selectedIndex = 0;
  });
}


Future<bool> _showExitDialouge() async{
return await showDialog(
  context: context, 
  builder: (context)=>AlertDialog(
    title: Text('Exit App'),
    content:Text('Are you sure you want to Exit App'),
    actions: [
      TextButton(
        onPressed: ()=>Navigator.pop(context,false), 
        child: Text('No')
        ),
      TextButton(
        onPressed: ()=>Navigator.pop(context,true), 
        child: Text('Yes')
        ),
    ],
  ),
  )?? false;
}


  @override
  Widget build(BuildContext context) {

final List<Widget> pages = [
  Homescreen(),
Todo(),
Profile()
];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async{
        if(didPop) return;

        if(_selectedIndex!=0){
          setState(() {
            _selectedIndex=0;
          });
        }else {
          bool shouldExit=await _showExitDialouge();

          if(shouldExit){
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: pages, 
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueGrey,
          
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              label: 'To-Do',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}