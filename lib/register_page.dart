import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:convert';
import 'main.dart';
// import 'package:toast/toast.dart'; // Add this package for toast notifications

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String phone = '';
  String address = '';
  String answer = '';

  Future<void> handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.189.228:8080/api/v1/auth/register'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'name': name,
            'email': email,
            'password': password,
            'phone': phone,
            'address': address,
            'answer': answer,
          }),
        );

        final resData = json.decode(response.body);
        if (resData['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage(
                      title: '',
                    )),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(resData['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(resData['message'])),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong')),
        );
      }
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
                "Register",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFFFCFA3),
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => name = value,
                validator: RequiredValidator(errorText: 'Enter name'),
                decoration: _inputDecoration('Name', Icons.person),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => email = value,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Enter email address'),
                  EmailValidator(
                      errorText: 'Please enter a valid email address'),
                ]),
                decoration: _inputDecoration('Email', Icons.email),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => password = value,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Please enter password'),
                  MinLengthValidator(8,
                      errorText: 'Password must be at least 8 characters long'),
                  PatternValidator(r'(?=.*?[#!@$%^&*-])',
                      errorText:
                          'Passwords must have at least one special character'),
                ]),
                obscureText: true,
                decoration: _inputDecoration('Password', Icons.lock),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => phone = value,
                validator: RequiredValidator(errorText: 'Enter phone number'),
                decoration: _inputDecoration('Phone', Icons.phone),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => address = value,
                validator: RequiredValidator(errorText: 'Enter address'),
                decoration: _inputDecoration('Address', Icons.home),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => answer = value,
                validator: RequiredValidator(errorText: 'Enter answer'),
                decoration: _inputDecoration('Nick-Name', Icons.security),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 45),
                  backgroundColor: const Color(0xFFFFCFA3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      labelText: label,
      hintStyle: const TextStyle(color: Color(0xFFFFCFA3)),
      labelStyle: const TextStyle(color: Color(0xFFFFCFA3)),
      prefixIcon: Icon(icon, color: const Color(0xFFFFCFA3)),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFCFA3)),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFCFA3)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFCFA3)),
      ),
    );
  }
}
