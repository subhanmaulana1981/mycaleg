import 'package:flutter/material.dart';
import 'package:mycaleg/services/auth.dart';
import 'package:mycaleg/widgets/loading.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.toggleView}) : super(key: key);

  final Function toggleView;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Daftar"),
        actions: <Widget>[
          Row(
            children: <Widget>[
              const Text("Masuk di sini"),
              IconButton(
                onPressed: () {
                  widget.toggleView();
                },
                icon: const Icon(Icons.login),
                tooltip: "Masuk",
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/pelangi_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Masukkan email!" : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: const InputDecoration(
                            label: Text("Email"), hintText: "Masukkan email"),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      TextFormField(
                        validator: (val) => val!.length < 6
                            ? "Masukkan katakunci >6 karakter"
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                            label: Text("Password"),
                            hintText: "Minimal 8 karakter"),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _authService
                                    .registerWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error = "Masukkan email yang benar!";
                                    loading = false;
                                  });
                                }

                                /*print("email: $email");
                                print("password: $password");*/
                              }
                            },
                            child: const Text("Daftar"),
                          ),
                        ],
                      ),
                      Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      const Text(
                        "(c) 2022 Maju Bersama production",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
