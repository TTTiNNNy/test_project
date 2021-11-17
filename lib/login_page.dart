import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_pr/global_fashion.dart';
import 'package:test_pr/main_page.dart';

import 'language_api.dart';
import 'login_page_fashion.dart';
import 'network_api.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKeyName = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPassword = GlobalKey<FormState>();
  String _name = '', _password = '';

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: GlobalFashion.titleColor,
          title: Container(child: Text('Kanban'))),
      body: Container(
          color: GlobalFashion.bodyColor,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                        key: _formKeyName,
                        child: TextFormField(
                          style: TextStyle(
                              color: LoginPageFashion.textColor, fontSize: 22),
                          decoration: LoginPageFashion.inputTextDecoration(
                              hintText: "Enter your username"),
                          validator: (String? value) {
                            if (value == null || value.length < 4) {
                              return 'Minimum is 4 characters';
                            }
                            _name = value;
                            return null;
                          },
                        )
                    )
                ),
                Container(
                    margin: const EdgeInsets.all(20),
                    child: Form(
                        key: _formKeyPassword,
                        child: TextFormField(
                          decoration: LoginPageFashion.inputTextDecoration(
                              hintText: "Enter your password"),
                          style: const TextStyle(
                              color: LoginPageFashion.textColor, fontSize: 22),
                          validator: (String? value) {
                            if (value == null || value.length < 8) {
                              return 'Minimum is 8 characters';
                            }
                            _password = value;
                            return null;
                          },
                        )
                    )
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton(
                      child: Container(
                          padding: const EdgeInsets.all(
                              GlobalFashion.betweenCardsMargin),
                          child: const Text('Log in',
                              style: TextStyle(
                                  color: GlobalFashion.bodyColor,
                                  fontSize: 22))),
                      onPressed: () async {
                        if (_formKeyName.currentState != null &&
                            _formKeyPassword.currentState != null) {
                          var _isNameValidate =
                              _formKeyName.currentState!.validate();
                          var _isPasswordValidate =
                              _formKeyPassword.currentState!.validate();
                          if (_isNameValidate && _isPasswordValidate) {
                            ServerRequest.bufUserData(
                                name: _name, password: _password);
                            LanguageStuff.computeOwnLanguage(context);
                            int requestCode =
                                await ServerRequest.fetchCardsInfo();
                            if (requestCode == -1) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        MainScreen(),
                                  ));
                            } else {
                              var snackBar = SnackBar(
                                  content: Text('Error :$requestCode'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            const snackBar = SnackBar(
                                content: Text(
                                    'Please, check name and password requirements'));

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }

                        //Navigator.pushNamed(context, '/exchange_rates');
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              GlobalFashion.activeColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                                  )
                              )
                      )
                  ),
                )
              ]
          )
      ),
    );
  }
}
