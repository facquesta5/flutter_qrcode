// lib/login_form.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'no_roteiro_page.dart'; // Importe a nova página

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _login() async {
    String cliente = _clienteController.text;
    String usuario = _usuarioController.text;
    String senha = _senhaController.text;

    String url = 'https://aciersgm.com.br/osp_login.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userdata': '$cliente^$usuario^$senha',
        },
      );
      // Verifique o código de status da resposta do servidor
      if (response.statusCode == 200) {
        // Verifique a resposta do servidor
        print('Resposta: ${response.body}');
        // Verifique a resposta do servidor para determinar se o login foi bem-sucedido
        if (response.body == 'Login bem-sucedido') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (response.body == 'leste2_n^Herminio^500000^Não existe roteiro definido para Herminio') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoRoteiroPage()),
          );
        } else {
          _showErrorDialog('Falha - Usuário não cadastrado no SGM ou senha errada!');
        }
      } else {
        print('Falha no login');
        print('Resposta: ${response.body}');
        _showErrorDialog('Falha - Usuário não cadastrado no SGM ou senha errada!');
      }
    } catch (e) {
      print('Erro: $e');
      _showErrorDialog('Erro: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro de Login'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _clienteController,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _usuarioController,
                  decoration: const InputDecoration(labelText: 'Usuário'),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _senhaController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Bem-vindo à Home Page!'),
      ),
    );
  }
}