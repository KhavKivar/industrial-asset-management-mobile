import 'dart:async';
import 'dart:ffi';

import 'package:app_licman/ui/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../const/Colors.dart';
import '../services/login_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController textNameController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  void _doSomething() async {
    if (_formKey.currentState!.validate()) {
      final response = await checkUserAndPassword();

      if (response['status'] == 'success') {
        await Future.delayed(Duration(milliseconds: 1), () {
          _btnController.success();
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage()));
        return;
      } else if (response['status'] == 'invalid user or password') {
      } else {}
      await Future.delayed(Duration(milliseconds: 1), () {
        _btnController.error();
      });
    }

    await Future.delayed(Duration(milliseconds: 1500), () {
      _btnController.reset();
    });
  }

  bool obscureText = true;
  bool showError = false;
  String message = '';
  checkUserAndPassword() async {
    String user = textNameController.value.text.replaceAll(' ', '');
    String password = textPasswordController.value.text.replaceAll(' ', '');
    final response = await loginApi(user, password);

    if (response['status'] == "success") {
      //Save Data
      print("Success");
      var box = await Hive.openBox('user');
      box.put('token', response['token']);
      box.put('user', user);
      return response;
    } else if (response['status'] == 'invalid user or password') {
      print("fail");
      setState(() {
        showError = true;
        message = response['status'];
      });
    } else {
      setState(() {
        showError = true;
        message = response['status'];
      });
    }
    return response;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: Colors.amber[50],
        ),
        Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: width * 0.5,
              constraints: BoxConstraints(minWidth: 350),
              decoration: BoxDecoration(
                  color: dark, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Acceder",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Estos campos no pueden ser vacios';
                        }
                        return null;
                      },
                      controller: textNameController,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 0.0),
                          ),
                          hintText: "Nombre de usuario",
                          fillColor: Colors.white,
                          filled: true),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Estos campos no pueden ser vacios';
                            }
                            return null;
                          },
                          controller: textPasswordController,
                          obscureText: obscureText ? true : false,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 0.0),
                              ),
                              hintText: "Contraseña",
                              fillColor: Colors.white,
                              filled: true),
                        ),
                        showError
                            ? Text(
                                message,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LayoutBuilder(builder: (context, constraint) {
                      print(constraint.toString());
                      return SizedBox(
                        width: double.infinity,
                        child: RoundedLoadingButton(
                          width: width,
                          borderRadius: 5,
                          child: Text('Iniciar sesion',
                              style: TextStyle(color: Colors.white)),
                          controller: _btnController,
                          onPressed: _doSomething,
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
