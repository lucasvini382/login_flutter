import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tela_login/home_page.dart';
import 'package:tela_login/login_page.dart';

class BemVindoPage extends StatefulWidget {
  const BemVindoPage({super.key});

  @override
  State<BemVindoPage> createState() => _BemVindoPageState();
}

class _BemVindoPageState extends State<BemVindoPage> {
  @override
  void initState() {
    super.initState();
    verificarUsuario().then((temUsuario) => {
          if (temUsuario)
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              )
            }
          else
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              )
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bem Vindo Page'),
      ),
    );
  }

  Future<bool> verificarUsuario() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = _sharedPreferences.getString('token');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }
}
