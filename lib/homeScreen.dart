

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/UI/NoteCard.dart';
import 'package:notes/UI/Utils.dart';
import 'package:notes/addNote.dart';
import 'package:notes/Database/DB_handler.dart';



class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

//int _selectedIndex = 0;
late Future<List<Map<String, dynamic>>> notesFuture;
final filters=['All','Favorite','Pinned','General','Work','Personal','Study'];
 String selectedFilter = 'All';
int total=0;
int pin=0;
int IsFavorite=0;
bool isSearching=false;
TextEditingController searchController=TextEditingController();
final auth=FirebaseAuth.instance;
final firestore=FirebaseFirestore.instance.collection('post').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
CollectionReference ref=FirebaseFirestore.instance.collection('post');




class _HomescreenState extends State<Homescreen> {


  final DbHandler dbhandler=DbHandler();

Color _getTagColor(String tag){
  switch(tag){
    case 'Favorite':
    return const Color.fromARGB(255, 175, 46, 143);
    case 'Work':
    return const Color.fromARGB(255, 189, 92, 85);
    case 'Personal':
    return const Color.fromARGB(255, 142, 233, 144);
    case 'Study':
    return const Color.fromARGB(255, 195, 96, 212);
    default:
    return const Color.fromARGB(255, 100, 167, 223);

  }
}
Color chipcolor(String filter){
  if(filter=='Pinned') return Colors.orange;
  if(filter=='All') return Colors.brown;
  return _getTagColor(filter);
}

void refreshNotes(){
  setState(() {
    notesFuture=dbhandler.readData();
  });
}

@override
void initState(){
  super.initState();
  notesFuture=dbhandler.readData();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('My Notes',style: TextStyle(fontSize: 35,fontWeight: FontWeight.w600),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                      controller: searchController,
                      onChanged: (value){
                        setState(() {
                          
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueGrey,
                        hintText: 'Search notes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty?
                        IconButton(
                          onPressed: (){
                            setState(() {
                              searchController.clear();
                            });
                          }, 
                          icon: Icon(Icons.clear)):null
                       /* suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            isSearching=false;
                          });
                        }, icon:Icon(Icons.close))*/
                      ),
                    ),
          ),
          SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: filters.map((filter) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedFilter = filter;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: selectedFilter == filter
                  ? chipcolor(filter)
                  : Colors.blueGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              filter,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }).toList(),
  ),
),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: notesFuture,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return Center(child: Text('No Notes Found'));
                }
                List<Map<String, dynamic>> notes=List.from(snapshot.data!);
                //int total=notes.length;
                /*int pin=notes.where(
                  (note)=>note['isPinned']==true,
                ).length;*/
                notes.sort((a, b) {
                  return (b['isPinned'] as int)
                  .compareTo(a['isPinned'] as int);
                  
                });
                if (selectedFilter == 'Pinned') {
                            notes = notes.where(
                        (note) => note['isPinned'] ==1,
                          ).toList();
                        }
                          else if (selectedFilter != 'All') {
                           notes = notes.where(
                          (note) => note['tag'] == selectedFilter,
                         ).toList();
                        }
                     
                if(searchController.text.toString().isNotEmpty){
                  String querry=searchController.text.trim().toLowerCase();
                  notes=notes.where((note){
                    final title=note['title'].toString().toLowerCase();
                    final content=note['note'].toString().toLowerCase();
            
                    return title.contains(querry)|| content.contains(querry);
                  }).toList();
                }      
            
                return MasonryGridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 1,
                    itemCount: notes.length, 
                  itemBuilder: (context, index){
                    var note=notes[index];
                    Color color=_getTagColor(note['tag']??'Genral');
                    return Notecard(
                      title: note['title']??'', 
                      Note: note['note']??'', 
                      tag: note['tag']??'Genral', 
                      date: note['date']??'',
                      id: note['id']??'',
                      isPinned: note['isPinned']==1, 
                      cardColor: color.withValues(), 
                      tagColor: color, 
                      dotColor: color,
                      onUpdate: refreshNotes,
                
                      onDelete: () async{
                        await dbhandler.deleteData(note['id']);
                
                        await ref.doc(note['id']).delete();
                        Utils().showMessage('Note Deleted');
                        refreshNotes();
                
                      },
                      );
                  }
                  );
              }
              ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
          ),
          child: IconButton(onPressed:
           (){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>Addnote())).then((value){
              refreshNotes();
            });
           }, 
           icon: Icon(Icons.add,color: Colors.black,size: 40,),)
        ),
      ),
    );
  }
}
                              
