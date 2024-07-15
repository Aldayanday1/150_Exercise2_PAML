import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistem_pengaduan/domain/model/user_profile.dart';
import 'package:sistem_pengaduan/presentation/controllers/user_controller.dart';
import 'package:sistem_pengaduan/presentation/views/auth_pages/login_user_page/login_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserController _userController = UserController();
  late Future<UserProfile?> _userProfileFuture;

  // ------------------- FILE IMAGE PICKER  -------------------

  final ImagePicker _imagePicker = ImagePicker();
  File? _profileImage;
  File? _backgroundImage;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _userController.getUserProfile();
  }

  // ------------------- PICK PROFILE IMAGE -------------------

  Future<void> _pickProfileImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickBackgroundImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _backgroundImage = File(pickedFile.path);
      });
    }
  }

  // ------------------- UPDATE PROFILE -------------------

  Future<void> _updateProfile() async {
    try {
      String message = await _userController.updateUserProfile(
          _profileImage, _backgroundImage);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (e.toString().contains('Token tidak valid')) {
        // -------BREAK SESSION UPDATE PROFILE-------
        // Token tidak valid, arahkan pengguna ke halaman login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
            settings: RouteSettings(
              arguments: 'Session habis, silakan login kembali',
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  // ------------------- SNACKBAR SESSION BREAK -------------------

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserProfile?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          // memperbarui tampilan sesuai dengan status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // -------BREAK SESSION PROFILE-------
            // Jika error karena token tidak valid, arahkan ke halaman login
            if (snapshot.error.toString().contains('Token tidak valid')) {
              Future.microtask(
                () {
                  _showSnackBar('Session habis, silakan login kembali');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              );
              return SizedBox.shrink(); // Mengembalikan widget kosong sementara
            }
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Profil tidak ditemukan'));
          } else {
            UserProfile userProfile = snapshot.data!;
            return Stack(
              fit: StackFit.expand,
              children: [
                // Background image with blur effect
                if (_backgroundImage != null)
                  Positioned.fill(
                    child: Image.file(
                      _backgroundImage!,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),
                  )
                else if (userProfile.backgroundImage.isNotEmpty)
                  Positioned.fill(
                    child: Image.network(
                      userProfile.backgroundImage,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 220),
                        // Profile image
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : NetworkImage(userProfile.profileImage)
                                      as ImageProvider<Object>,
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: _pickProfileImage,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.blueAccent,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 15),
                        // Name and Email
                        Text(
                          userProfile.nama,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        // SizedBox(height: 2),
                        Text(
                          userProfile.email,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: _pickBackgroundImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(0.3), // Transparansi
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Edit Background",
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: _updateProfile,
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withOpacity(0.3), // Transparansi
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              "Save Changes",
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  left: 30,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3), // Transparansi
                      ),
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 17,
                        right: 10,
                      ), // Padding untuk memberikan ruang di sekitar ikon
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromARGB(255, 155, 155, 155),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
