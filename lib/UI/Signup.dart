import 'package:flutter/material.dart';
import 'package:notes/UI/RoundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/UI/Utils.dart';
import 'package:notes/UI/Login_Screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

bool loading=false;
final TextEditingController emailController=TextEditingController();
final TextEditingController passwordController=TextEditingController();
final formKey=GlobalKey<FormState>();
final FirebaseAuth _auth=FirebaseAuth.instance;
bool isPasswordVIsible=false;

@override
void dispose(){
  emailController.dispose();
  passwordController.dispose();
  super.dispose();
}

void signup(){
  _auth.createUserWithEmailAndPassword(
    email: emailController.text.toString(), 
    password: passwordController.text.toString()
  ).then((value) {
    setState(() {
      loading=false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    Utils().showMessage(  'Signup successful! Please log in with your new account.');
  }).onError((error, stackTrace) {
    setState(() {
      loading=false;
    });
    Utils().showMessage(error.toString());
    setState(() {
      loading=false;
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80,),
              Center(child: Text('Welcome Back',style: TextStyle(fontSize: 25),)),
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.person,size: 100,color: Colors.white,),
                ),
              ),
              Text('Register for an account',style: TextStyle(fontSize: 25),),
              Form(
                key: formKey,
                child: Column(
                  children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress ,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please enter email';
                    }
                    return null;
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          isPasswordVIsible=!isPasswordVIsible;
                        });
                      }, 
                      icon: Icon(isPasswordVIsible ?
                      Icons.visibility
                      : Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please enter password';
                    }
                    return null;
                  }
                ),
              ),
            ]
          )
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  }, 
                  child: Text('Already have an account? Sign in',style: TextStyle(color: Colors.blue),)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundButton(
                  title: 'Sign up', 
                  loading: loading,
                  onTap: (){
                         if(formKey.currentState!.validate()){
                          setState(() {
                            loading=true;
                      });
                          signup();
                         }
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(height: 6,)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider(height: 6,)),
                  ],
                ),
              ),
              RoundButton(
                title: 'G Continue with Google', 
                loading: loading,
                onTap: (){
                     
                }),
            ],
          ),
        ),
      )
    );
  }
}