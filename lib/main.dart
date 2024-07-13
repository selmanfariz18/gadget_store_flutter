import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'forget_password.dart';
import 'home_page.dart';
import 'register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gadget-Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF3F5C5A)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gadget-Store'),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/forgetPassword': (context) => const ForgetPasswordPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const MyHomePage(
              title: 'login',
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final response = await http.post(
          Uri.parse('http://192.168.189.228:8080/api/v1/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 && data['success']) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user', jsonEncode(data['user']));
          prefs.setString('token', data['token']);

          Navigator.pushReplacementNamed(context, '/home');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } catch (e) {
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
        padding: const EdgeInsets.only(top: 240.0, left: 30.0, right: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Gadget-Store",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFFFCFA3),
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Enter email address'),
                  EmailValidator(
                      errorText: 'Please enter a valid email address'),
                ]),
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  hintStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  labelStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color(0xFFFFCFA3),
                  ),
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
                  RequiredValidator(errorText: 'Please enter password'),
                  MinLengthValidator(8,
                      errorText: 'Password must be at least 8 characters long'),
                  PatternValidator(r'(?=.*?[#!@$%^&*-])',
                      errorText:
                          'Passwords must have at least one special character'),
                ]),
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  hintStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  labelStyle: TextStyle(color: Color(0xFFFFCFA3)),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color(0xFFFFCFA3),
                  ),
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
              TextButton(
                child: Text(
                  "Forget Password?",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w200,
                      ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/forgetPassword');
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 45),
                  backgroundColor: const Color(0xFFFFCFA3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              TextButton(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w200,
                        ),
                    children: const <TextSpan>[
                      TextSpan(text: "Haven't joined yet? "),
                      TextSpan(
                        text: "Join Now",
                        style: TextStyle(
                          color: Color(0xFFFFCFA3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
