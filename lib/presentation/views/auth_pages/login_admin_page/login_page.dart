import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/presentation/controllers/user_controller.dart';
import 'package:kulinerjogja/presentation/views/admin_page/dashboard_screen/dashboard_admin.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/welcome_page/welcome_page.dart';
import 'package:lottie/lottie.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController _userController = UserController();

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

  // -------------------- LOGIN ADMIN --------------------

  Future<void> _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
      try {
        String result = await _userController.loginAdmin(
          _namaController.text,
          _passwordController.text,
        );

        // Tampilkan snackbar "Login berhasil"
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));

        // Navigate to home page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardAdmin()),
        );
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
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
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Log as Admin",
                          style: GoogleFonts.poppins(
                            fontSize: 28.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.lock),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Username',
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
                          return 'Nama tidak boleh kosong';
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
                      onPressed: _loginAdmin,
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
