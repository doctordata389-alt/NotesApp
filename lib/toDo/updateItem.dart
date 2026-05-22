import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/UI/RoundButton.dart';
import 'package:notes/UI/Utils.dart';


class Updateitem extends StatefulWidget {
  final String updateitem;
  final bool isPinned;
  final bool done;
  final String idi,id;
  const Updateitem({super.key, 
  required this.updateitem,
  required this.done,
   required this.isPinned,
   required this.idi,
   required this.id
   });

  @override
  State<Updateitem> createState() => _UpdateitemState();
}



class _UpdateitemState extends State<Updateitem> {


TextEditingController updateitemcontroller=TextEditingController();
final user = FirebaseAuth.instance.currentUser;
final fireStore=FirebaseFirestore.instance.collection('todo');
final formkey=GlobalKey<FormState>();
bool isPinned=false;
bool done=false;



void Save(){
//String id=DateTime.now().microsecondsSinceEpoch.toString();
fireStore.doc(widget.id).update({
  'item':updateitemcontroller.text.toString(),
  'isPinned':isPinned,
  'userId':user!.uid,
  'done':done,
}).then((value) {
  setState(() {
      updateitemcontroller.clear();
    });
  Utils().showMessage('To-Do List Updated');
  Navigator.pop(context);
}).onError((error, stackTrace) {
  Utils().showMessage(error.toString());
});
}

@override
void initState() {
    super.initState();
    updateitemcontroller.text=widget.updateitem;
    isPinned=widget.isPinned;
    done=widget.done;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update To-Do Items'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formkey,
              child: TextFormField(
                controller: updateitemcontroller,
                maxLines: 3,
                decoration: InputDecoration(
                  //hintText: 'Add your to do work',
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
              title: 'Update Item List', 
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