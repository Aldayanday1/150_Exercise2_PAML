import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/presentation/controllers/user_controller.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/token_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/register_page/register_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/welcome_page/welcome_page.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  // -------------------- INITIALIZE ARGUMENT --------------------

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

  // -------------------- LOGIN USER --------------------

// vaidasi login user
  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _emailController.text;
        String password = _passwordController.text;
        // message dari hasil login
        String message = await _userController.loginUser(email, password);

        // Tampilkan snackbar "Login berhasil"
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        // Navigate to token page after successful login
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
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Lottie.network(
              'https://lottie.host/622b70c5-e4ad-44f9-b0ae-cd2a2241ac49/NPNSeOC9Q2.json',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          // Logo ody fullscreen
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/ody.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Positioned(
            top: 75,
            left: 30,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),
                padding: EdgeInsets.only(left: 5),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 16,
                  color: Colors.white,
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomePage(),
                        ));
                  },
                ),
              ),
            ),
          ),
          // Login form
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/profile.png',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/lock.png',
                            width: 16,
                            height: 16,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Image.asset(
                              _obscurePassword
                                  ? 'assets/visibility_off.png'
                                  : 'assets/visibility.png',
                              width: 20,
                              height: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      child: Row(
                        children: [
                          Text(
                            "Don't have account?",
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              " Sign Up",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
