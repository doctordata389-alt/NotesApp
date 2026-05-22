import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/UI/Login_Screen.dart';
import 'package:notes/UI/RoundButton.dart';
import 'package:notes/UI/Utils.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {

final TextEditingController emailController=TextEditingController();
final formKey=GlobalKey<FormState>();
final FirebaseAuth _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Registered email';
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 20,),
          RoundButton(title: 'Get Recovery Email', onTap: (){
            if(formKey.currentState!.validate()){
              _auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                Utils().showMessage('Recovery email sent! Please check your inbox.');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().showMessage(error.toString());
              });
            }
          })
        ],
      ),

    );
  }
}
   