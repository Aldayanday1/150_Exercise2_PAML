import 'package:flutter/material.dart';
import 'package:kulinerjogja/presentation/controllers/user_controller.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/token_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Periksa jika ada pesan dari navigasi sebelumnya
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final String message =
            ModalRoute.of(context)!.settings.arguments as String;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });
  }

// vaidasi login user
  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _emailController.text;
        String password = _passwordController.text;
        String message = await _userController.loginUser(email, password);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TokenInputPageLogin(email: email),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login User')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginUser,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
