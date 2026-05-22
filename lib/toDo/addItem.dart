import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/UI/RoundButton.dart';
import 'package:notes/UI/Utils.dart';

class Additem extends StatefulWidget {
  const Additem({super.key});

  @override
  State<Additem> createState() => _AdditemState();
}


class _AdditemState extends State<Additem> {

TextEditingController itemcontroller=TextEditingController();
final user = FirebaseAuth.instance.currentUser;
final fireStore=FirebaseFirestore.instance.collection('todo');
final formkey=GlobalKey<FormState>();
bool isPinned=false;
bool done=false;



void Save(){
String id=DateTime.now().microsecondsSinceEpoch.toString();
fireStore.doc(id).set({
  'item':itemcontroller.text.toString(),
  'isPinned':isPinned,
  'userId':user!.uid,
  'done':done,
  'id':id,
}).then((value) {
  setState(() {
      itemcontroller.clear();
    });
  Utils().showMessage('To-Do item Added');
  Navigator.pop(context);
}).onError((error, stackTrace) {
  Utils().showMessage(error.toString());
});
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add To-Do Items'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formkey,
              child: TextFormField(
                controller: itemcontroller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add your to do work',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                ),
                validator: (value) {
                  if(value!.isEmpty){
                    return 'Empty action';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundButton(
              title: 'Add Item to List', 
              onTap: (){
                if(formkey.currentState!.validate()){
                  Save();
                }
              }),
          )
        ],
      ),
    );
  }
}