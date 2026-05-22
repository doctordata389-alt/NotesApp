import 'package:flutter/material.dart';
import 'package:notes/UI/RoundButton.dart';
import 'package:notes/Bottom_Navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/UI/Utils.dart';
import 'package:notes/UI/Signup.dart';
import 'package:notes/UI/ForgotPassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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

void signin(){
  _auth.signInWithEmailAndPassword(
    email: emailController.text.toString(), 
    password: passwordController.text.toString()
  ).then((value) {
    setState(() {
      loading=false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
    Utils().showMessage(  'Login successful! Welcome back.');
  }).onError((error, stackTrace) {
    setState(() {
      loading=false;
    });
    Utils().showMessage(error.toString());
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
              Text('Sign in to your account',style: TextStyle(fontSize: 25),),
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
                  obscureText: !isPasswordVIsible,
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
              Row(
                children: [
                  TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                  }, 
                  child: Text('Register',style: TextStyle(color: Colors.blue),)),
                  SizedBox(width: 120,),
                  TextButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Forgotpassword()));
                    }, 
                    child: Text('Forgot Password?',style: TextStyle(color: Colors.blue),)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundButton(
                  title: 'Sign in', 
                  loading: loading,
                  onTap: (){
                         if(formKey.currentState!.validate()){
                            setState(() {
                              loading=true;
                            });
                          signin();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: (){
                          
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata,size: 30,color: Colors.blue,),
                      SizedBox(width: 10,),
                      Text('Sign in with Google',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  ),
              ),
            ],
          ),
        ),
      )
    );
  }
}