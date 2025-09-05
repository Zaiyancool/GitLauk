import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/auth_pages/LoginRegisterPage.dart';
import 'package:flutter_application_1/auth_pages/loginPage.dart';

import 'package:flutter_application_1/comp_manager/TextFileMng.dart';
import 'package:flutter_application_1/comp_manager/ButtonMng.dart';


class SignupScreen extends StatefulWidget {
  
  final Function()? onTap;
  const SignupScreen({super.key, required this.onTap});
  
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailCtrl = TextEditingController();

  final TextEditingController passCtrl = TextEditingController();

  final TextEditingController confirmPassCtrl = TextEditingController();

  void regUser() async{

    //LOading circle
    showDialog(
      context: context,
      builder: (context){
        return const Center(child: CircularProgressIndicator(),);
      }
    );

    //try create an account
    try{
      
      if(passCtrl.text == confirmPassCtrl.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passCtrl.text.trim(),
        );

      //pop the loading circle
      Navigator.pop(context);
      _showSuccessDialog();

      }
      else{
        throw FirebaseAuthException(code: 'password-not-matched');
      }

    }
    on FirebaseAuthException catch (e){
      
      //pop the loading circle
      Navigator.pop(context);

      //wrong password (old)
       if (e.code == 'password-not-matched'){
        wrongPassMessage();

      } 
      else if (e.code == 'email-already-in-use') {
        _showEmailInUseDialog();
      } 
      else if (e.code == 'invalid-email') {
        _showInvalidEmailDialog();
      } 
      else if (e.code == 'weak-password') {
        _showWeakPasswordDialog();
      } 
      else {
        _showGenericErrorDialog(e.code);
      }
    }

  }

// void wrongCredentialMessage(){
//     showDialog(
//       context: context, 
//       barrierDismissible: true,
//       builder: (context){
//         return const AlertDialog(

//           title: Text('Incorrect Credentials'),
//         );
//       }
//     );
//   }

void wrongPassMessage(){
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (context){
        return const AlertDialog(
          title: Text('Password not matched'),
        );
      }
    );
  }

    void _showEmailInUseDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Email Already In Use'),
        content: Text('This email is already registered.'),
      ),
    );
  }

  void _showInvalidEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Invalid Email'),
        content: Text('Please enter a valid email address.'),
      ),
    );
  }

  void _showWeakPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Weak Password'),
        content: Text('Password must be at least 6 characters long.'),
      ),
    );
  }

  void _showGenericErrorDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Failed'),
        content: Text('Error code: $code'),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Success'),
        content: Text('Account created successfully!'),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldMng(
              controller: emailCtrl,
              obscureText: false,
              hintText: 'Email',
            ),

            SizedBox(height: 16),
            TextFieldMng(
              controller: passCtrl,
              obscureText: true,
              hintText: 'Password',
            ),

            SizedBox(height: 16),
            TextFieldMng(
              controller: confirmPassCtrl,
              obscureText: true,
              hintText: 'Confirm Password',
            ),

            // SizedBox(height: 32),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushReplacement(
            //         context, MaterialPageRoute(builder: (_) => HomeScreen()));
            //   },
            //   child: Text('Create Account'),
            // )
            SizedBox(height: 25),

            ButtonMng(
              onTap: regUser,
              text: "Sign Up",
            ),                   

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already a member?"),
                const SizedBox(width: 4,),
                GestureDetector(
                  onTap: widget.onTap,

                  child: Text(
                    "Login now",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}