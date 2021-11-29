import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/form/register.dart';
import 'package:demo/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
   const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  late bool _passwordVisible;


  var loading = false;
  void _logInwithFacebook() async {
    setState(() {
      loading = true;
    });
    try {
      final loginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
        'imageUrl': userData['picture']['data']['url'],
        'name': userData['name']
      });

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => const Home()),
      //     (route) => false);
    } on FirebaseAuthException catch (e) {
      var content = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          content = 'This account exist with a diffrent sign in provider';
          break;
        case 'invalid-credential':
          content = 'Unknown error has occuerrd';
          break;
        case 'This operation is not allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-disabled':
          content = 'This user you tried to log into is disabled';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into is not found';
          break;
      }

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("login with Facebook Failed"),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
              ));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;



  Future googleLogin() async{
   final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googlAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googlAuth.accessToken,
      idToken: googlAuth.idToken
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }
  var test3 = GoogleAuthProvider();
     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Button(
                color: Colors.blue,
                text: "Login with Facebook",
                image: const AssetImage('assets/images/facebook.png'),
                onPressed: () {
                  _logInwithFacebook();
                }),
            const SizedBox(
              height: 20,
            ),
            _Button(
                color: Colors.green,
                text: "Login with Google",
                image: const AssetImage('assets/images/google.png'),
                onPressed: () {
                      googleLogin();
                     
                  
                }),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Login Form!",
                    style: TextStyle(color: Colors.black, fontSize: 30))
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: username,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "User Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: password,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(_passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    labelText: "Password"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 0)),
                  onPressed: () {},
                  child: const Text("Login")),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Flexible(
                    child: Divider(
                      thickness: 2,
                      color: Colors.black,
                      height: 30,
                    ),
                  ),
                  Flexible(child: Text("OR")),
                  Flexible(
                    child: Divider(
                      height: 30,
                      color: Colors.black,
                      thickness: 2,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()));
                      },
                      child: const Text(
                        "Register",
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Color color;
  final String text;
  final ImageProvider image;
  final VoidCallback onPressed;

  const _Button(
      {required this.color,
      required this.text,
      required this.image,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Image(
                image: image,
                width: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(color: color, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 35,
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
