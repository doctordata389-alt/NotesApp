import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/UI/Utils.dart';
import 'package:notes/toDo/addItem.dart';
import 'package:notes/toDo/updateItem.dart';


class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

final auth=FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser;
final firestore=FirebaseFirestore.instance.collection('todo').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
CollectionReference ref=FirebaseFirestore.instance.collection('todo');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        centerTitle: true,
        
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: firestore, 
            builder: (context,snapShot){
              if(snapShot.connectionState==ConnectionState.waiting){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
              }
              if(!snapShot.hasData || snapShot.data!.docs.isEmpty){
                return Center(child: Text("No To-Do Item found"));
              }
              var items=snapShot.data!.docs;
              var incpmlete=items.where((action)=>(action['done']??false)==false,).toList();
              var complete=items.where((action)=>(action['done']??false)==true,).toList();
              return Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Tasks TO-Do',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                          ),
                          Expanded(
                            child: incpmlete.isEmpty?
                            Center(child: Text('No incomplete tasks Left'),
                            )
                            :ListView.builder(
                              itemCount: incpmlete.length,
                              itemBuilder: (context,index){
                                var itm=incpmlete[index];
                            
                                return ListTile(
                              leading: IconButton(
                                onPressed: (){
                                  ref.doc(itm.id).update({'done':true});
                                }, 
                                icon: Icon(Icons.check_box_outline_blank)),
                              title: Text(itm['item']??''),
                              trailing: IconButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Updateitem(
                                    updateitem:itm['item']??'',
                                    isPinned: false,
                                    done: false,
                                    idi:user!.uid,
                                    id: itm['id']??'',
                                     )));
                                }, icon: Icon(Icons.edit)),  
                            );
                              }
                              )
                            ),
                       ]
                      ),
                    ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Tasks Completed',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                          ),
                          Expanded(
                            child: complete.isEmpty?
                            Center(child: Text('No tasks Completed'),
                            )
                            :ListView.builder(
                              itemCount: complete.length,
                              itemBuilder: (context,index){
                                var itm=complete[index];
                            
                                return ListTile(
                              leading: IconButton(
                                onPressed: (){
                                  ref.doc(itm.id).update({'done':false});
                                }, 
                                icon: Icon(Icons.check_box_outlined)),
                              title: Text(itm['item']??''),
                              trailing: IconButton(
                                onPressed: (){
                                  ref.doc(itm.id).delete().then((value){
                                    Utils().showMessage('Deleted');
                                  }).onError((error, stackTrace) {
                                    Utils().showMessage(error.toString());
                                  },);
                                }, 
                                icon: Icon(Icons.delete_outline)),  
                            );
                              }
                              )
                            ),
                                               ]
                                              ),
                        ),
                  ],
                ),
              );
            }
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
            Navigator.push(context, MaterialPageRoute(builder:(context)=>Additem()));
           }, 
           icon: Icon(Icons.add,color: Colors.black,size: 40,),)
        ),
      ),
    );
  }
}