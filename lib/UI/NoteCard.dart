import 'package:flutter/material.dart';
import 'package:notes/UI/Update.dart';


class Notecard extends StatelessWidget {
  final String title, Note, tag, date,id ;
  final Color cardColor, tagColor,dotColor;
  final bool isPinned;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const Notecard({
    super.key,
     required this.title,
     required this.Note, 
     required this.tag, 
     required this.date, 
     required this.cardColor, 
     required this.tagColor, 
     required this.dotColor,
     required this.onDelete,
     required this.onFavorite, 
     this.isPinned=false,
     this.isFavorite=false,
     required this.id,
      required this.onUpdate
     });

     @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {

  Navigator.push(

    context,

    MaterialPageRoute(

      builder: (context) => Update(

        title: title,

        note: Note,

        isPinned: isPinned,

        selectedTag: tag,

        id: id,
      ),
    ),

  ).then((value){

    onUpdate();

  });

      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: tagColor.withValues()),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if(isPinned)
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Icon(Icons.push_pin,size: 11,color: Colors.black),)),
                SizedBox(width: 5,),
              Expanded(
                child: Text(title,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: onFavorite,
                child: Icon(
                  isFavorite? Icons.favorite:Icons.favorite_border,
                  color:isFavorite? Colors.red:Colors.black))
            ],
          ),
          Text(Note,
          //maxLines: 4,
          //overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontSize: 12,)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( date, style: TextStyle(color: Colors.black54, fontSize: 11)),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle
                ),
                ),
                GestureDetector(onTap: onDelete, 
                child: Icon(Icons.delete,color: Colors.black,)),
            ],
          ),
        ]
      ),
      ),
    );
  }
}