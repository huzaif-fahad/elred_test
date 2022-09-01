import 'package:elred_test/app_views/signIn_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_services/auth_service.dart';

class sideNavBar extends StatelessWidget {
  const sideNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    String? photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
    String? userName = FirebaseAuth.instance.currentUser?.displayName;
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            color: Colors.blueGrey,
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(photoUrl.toString()),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userName.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "UID : ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        userId.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SignInView()));
              await signOut();
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log Out"),
            ),
          ),
        ],
      )),
    );
  }
}
