import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tela_login/bemvindo_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _verSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      label: Text('e-mail'), hintText: 'nome@email.com'),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Digite seu e-mail';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _senhaController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _verSenha,
                  decoration: InputDecoration(
                      label: const Text('senha'),
                      hintText: 'Digite sua senha',
                      suffixIcon: IconButton(
                        icon: Icon(_verSenha
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () {
                          setState(() {
                            _verSenha = !_verSenha;
                          });
                        },
                      )),
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return 'Digite sua senha';
                    } else if (senha.length < 6) {
                      return 'Digite uma senha mais forte';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        logar();
                      }
                    },
                    child: const Text('Entrar'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  logar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse(
        'https://run.mocky.io/v3/d1f09022-80d5-4355-b4c2-b94f7fbdca90');
    var response = await http.post(
      url,
      body: {
        'username': _emailController.text,
        'password': _senhaController.text,
      },
    );
    if (response.statusCode == 200) {
      String token = json.decode(response.body)['token'];
      await sharedPreferences.setString('token', 'Token $token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BemVindoPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('e-mail ou senha inválidos'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
