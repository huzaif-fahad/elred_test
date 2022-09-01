import 'package:elred_test/app_services/auth_service.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          "elRed",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: signInViewBody(),
    );
  }

  signInViewBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/el-red-logo.png'),
            ),
            GestureDetector(
              child: SizedBox(
                height: 50.0,
                width: 350,
                child: Material(
                    borderRadius: BorderRadius.circular(50),
                    shadowColor: Colors.blueAccent,
                    color: Colors.blueAccent,
                    elevation: 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/google-logo.png',
                          width: 60,
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        const Text(
                          "Login with Google",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    )),
              ),
              onTap: () {
                signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
