import 'package:demo/form/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();

  late bool _passwordVisible;
  late bool _ispasswordVisible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
    _ispasswordVisible = false;
  }

  void register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final String firstName = firstname.text;
    final String lastName = lastname.text;
    final String Email = email.text;
    final String Password = password.text;
    final String Cpassword = firstname.text;
    try {
      await auth.createUserWithEmailAndPassword(
          email: Email, password: Password);
    } catch (e) {
      print("Error");
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Registration Form!",
                  style: TextStyle(color: Colors.black, fontSize: 30))
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: firstname,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "First Name",
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
              controller: lastname,
              obscureText: true,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: "Last Name"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: email,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail),
                labelText: "Email Address",
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: cpassword,
              obscureText: !_ispasswordVisible,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _ispasswordVisible = !_ispasswordVisible;
                        });
                      },
                      icon: Icon(_ispasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  labelText: "Confirm Password"),
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
                onPressed: register,
                child: const Text("Register")),
          ),
        ],
      )),
    );
  }
}
