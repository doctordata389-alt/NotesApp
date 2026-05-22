import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/UI/Utils.dart';
import 'package:notes/Database/DB_handler.dart';



class Update extends StatefulWidget {
  final String selectedTag;
  final bool isPinned;
  final String id;
  final String title;
  final String note;
  const Update({
    super.key, 
    required this.isPinned,
    required this.selectedTag,
    required this.title,
    required this.note,
    required this.id,
    });

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

final DbHandler dbhandler = DbHandler();
final TextEditingController UpdatetitleController=TextEditingController();
final TextEditingController UpdatenoteController=TextEditingController();
late String selectedTag;
late bool isPinned;
final firestore=FirebaseFirestore.instance.collection('post');
CollectionReference ref=FirebaseFirestore.instance.collection('post');


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

  @override
  void initState() {
    super.initState();
    UpdatetitleController.text = widget.title;
    UpdatenoteController.text=widget.note;
    selectedTag=widget.selectedTag;
    isPinned=widget.isPinned;
  }



Future<void> save() async {

  Map<String, dynamic> updatedNote = {

    'title': UpdatetitleController.text.trim(),

    'note': UpdatenoteController.text.trim(),

    'tag': selectedTag,

    'isPinned': isPinned ? 1 : 0,

    'date': DateFormat('d MMM y')
        .format(DateTime.now()),

    'id': widget.id,
  };

  try {

    // FIRESTORE UPDATE

    await firestore
        .doc(widget.id)
        .update(updatedNote);

    // SQFLITE UPDATE

    await dbhandler.updateData(
      updatedNote,
      widget.id,
    );

    Utils().showMessage(
      'Note Updated Successfully',
    );

    Navigator.pop(context);

  } catch (e) {

    Utils().showMessage(e.toString());
  }
}

 @override
  void dispose(){
    UpdatetitleController.dispose();
    UpdatenoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Update',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 30),),
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
              child:Text('Update',style: TextStyle(color: Colors.white),)
            ),
          )
        ],
      ) ,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: UpdatetitleController,
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
                controller: UpdatenoteController,
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