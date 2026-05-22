import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final bool loading;
  final String title;
  final VoidCallback onTap;
  const RoundButton({super.key, this.loading=false, required this.title, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(child: loading ? CircularProgressIndicator(color: Colors.white) : Text(title,style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}