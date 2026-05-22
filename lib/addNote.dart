import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/UI/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/Database/DB_handler.dart';

   final dbhandler=DbHandler();


class Addnote extends StatefulWidget {
 
  const Addnote({super.key,});

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {

final TextEditingController titleController=TextEditingController();
final TextEditingController noteController=TextEditingController();
bool loading=false;
bool isPinned = false;
final fireStore=FirebaseFirestore.instance.collection('post');
String selectedTag='General';
final user = FirebaseAuth.instance.currentUser;


  Future<void> save()async{
    String id=DateTime.now().microsecondsSinceEpoch.toString();
    Map<String, dynamic> note = {
      'title': titleController.text.toString(),
      'note': noteController.text.toString(),
      'tag': selectedTag,
      'isPinned': isPinned?1:0,
      'date': DateFormat('d MMM y').format(DateTime.now()).toString(),
      'id':id,
      'userId':user!.uid,
    };
    try{
      await fireStore.doc(id).set(note);
      await dbhandler.insertdata(note);
      setState(() {
        
      });

      Utils().showMessage('note saved successfully');
      noteController.clear();
      titleController.clear();
      Navigator.pop(context);
    }catch(e){
      Utils().showMessage(e.toString());
    }
  }

 @override
  void dispose(){
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

Color getTagColor(String tag){
  switch(tag){
    case 'Favorite':
    return const Color.fromARGB(255, 175, 46, 143);
    case 'Work':
    return const Color.fromARGB(255, 224, 135, 128);
    case 'Personal':
    return const Color.fromARGB(255, 165, 235, 166);
    case 'Study':
    return const Color.fromARGB(255, 218, 155, 230);
    default:
    return const Color.fromARGB(255, 159, 199, 231);

  }
}

    return Scaffold(
      appBar:AppBar(
        title: Text('New Note',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 30),),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextButton(
              onPressed:(){
                save();
              },
              child:Text('Save',style: TextStyle(color: Colors.white),)
            ),
          )
        ],
      ) ,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Wrap(
                    spacing: 10,
                    children: ['General','Favorite','Work','Personal','Study']
                    .map(
                      (tag)=>ChoiceChip(
                        label: Text(tag), 
                        selected: selectedTag==tag,
                        onSelected: (selected){
                          setState(() {
                            selectedTag=tag;
                          });
                        },
                        selectedColor: getTagColor(tag),
                        labelStyle: TextStyle(
                          color: selectedTag==tag
                          ?Colors.white:Colors.white
                        ),
                      ),
                    )
                     .toList(),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title:Text('Pin this note'),
               value: isPinned, 
               onChanged: (value){
                setState(() {
                  isPinned=value;
                });
               }),
            Expanded(
              child: TextFormField(
                controller: noteController,
                maxLines: 7,
                //expands: true,
                decoration: InputDecoration(
                  hintText: 'Note',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
            ),
          ],
        ),
      )
      );
  }
}