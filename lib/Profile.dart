import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/UI/Login_Screen.dart';
import 'package:notes/UI/Utils.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
List<String> options=['Notifications','Dark Mode','Font Size','Export Note as PDF','Settings','Log Out'];
final auth=FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser;

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
       ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              child: Text('S',style: TextStyle(fontSize: 50),),
             ),
            SizedBox(height: 20,),
            //Text('No Name',style: TextStyle(fontSize: 16),),
            SizedBox(height: 10,),
            Text(user?.email??'No Email',style: TextStyle(fontSize: 16),),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, Index){
                  final String item=options[Index];
                  return InkWell(
                    onTap: () {
                      if(item=='Notifications'){
                        Utils().showMessage('Notifications setings will be available soon');
                      } else if(item=='Dark Mode'){
                        Utils().showMessage('Dark Mode setings will be available soon');
                      } else if(item=='Font Size'){
                        Utils().showMessage('Font Size setings will be available soon');
                      } else if(item=='Export Note as PDF'){
                        Utils().showMessage('Exporting  setings will be available soon');
                      } else if(item=='Settings'){
                        Utils().showMessage('Setings will be available soon');
                      } else if(item=='Log Out'){
                        auth.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>LoginScreen()));
              }).then((value){
                Utils().showMessage('LogOut Successfull');
              }).onError((error, stackTrace) {
                Utils().showMessage(error.toString());
              });
                      }
                    },
                    child: ListTile(
                      title: Text(options[Index]),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  );
                }),
            )
          ],
        ),
      ),
    );
  }
}