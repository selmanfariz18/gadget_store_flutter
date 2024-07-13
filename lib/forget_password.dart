import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gadget_store_flutter/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _resetPassword() async {
    final String email = _emailController.text;
    final String newPassword = _passwordController.text;
    final String answer = _answerController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.189.228:8080/api/v1/auth/forgot-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'newPassword': newPassword,
          'answer': answer,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage(title: '')),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F5C5A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Forget Password",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFFFCFA3),
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                validator:
                    EmailValidator(errorText: 'Enter a valid email address'),
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  hintStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  labelStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  prefixIcon: Icon(Icons.email, color: Color(0xFFFFCFA3)),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _answerController,
                validator:
                    RequiredValidator(errorText: 'Enter security answer'),
                decoration: const InputDecoration(
                  hintText: 'Nick-Name',
                  labelText: 'Nick-Name',
                  hintStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  labelStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  prefixIcon: Icon(Icons.security, color: Color(0xFFFFCFA3)),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Please enter new password'),
                  MinLengthValidator(8,
                      errorText: 'Password must be at least 8 characters long'),
                  PatternValidator(r'(?=.*?[#!@$%^&*-])',
                      errorText:
                          'Passwords must have at least one special character'),
                ]),
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'New Password',
                  labelText: 'New Password',
                  hintStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  labelStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFFFCFA3)),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFCFA3)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _resetPassword();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 45),
                  backgroundColor: const Color(0xFFFFCFA3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
