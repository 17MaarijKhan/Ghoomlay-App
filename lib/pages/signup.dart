// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:random_string/random_string.dart';
// import '../services/shared_pref.dart';
// import 'home.dart';
// import 'login.dart'; // Add this if you have a separate login page

// class SignUp extends StatefulWidget {
//   const SignUp({Key? key}) : super(key: key);

//   @override
//   SignUpState createState() => SignUpState();
// }

// class SignUpState extends State<SignUp> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool isLoading = false;

//   void registration() async {
//     String email = mailController.text.trim();
//     String password = passwordController.text.trim();
//     String name = nameController.text.trim();

//     if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
//       setState(() => isLoading = true);
//       try {
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email, password: password);

//         if (!mounted) return;
//         await userCredential.user!.updateDisplayName(name);

//         String id = randomAlphaNumeric(10);
//         Map<String, dynamic> userInfoMap = {
//           "Name": name,
//           "Email": email,
//           "Image":
//               "https://firebasestorage.googleapis.com/v0/b/your-app-id.appspot.com/o/default_avatar.png?alt=media",
//           "Id": id,
//         };

//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(id)
//             .set(userInfoMap);

//         await SharedPreferenceHelper().saveUserEmail(email);
//         await SharedPreferenceHelper().saveUserId(id);
//         await SharedPreferenceHelper().saveUserDisplayName(name);
//         await SharedPreferenceHelper().saveUserImage(userInfoMap["Image"]);

//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const Home()),
//         );
//       } on FirebaseAuthException catch (e) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.message ?? "An error occurred")),
//         );
//       } finally {
//         setState(() => isLoading = false);
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body:
//           isLoading
//               ? const Center(
//                 child: CircularProgressIndicator(color: Colors.orange),
//               )
//               : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.45,
//                       width: double.infinity,
//                       child: ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(30),
//                           bottomRight: Radius.circular(30),
//                         ),
//                         child: Image.asset(
//                           'images/signup.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Signup",
//                       style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 25.0,
//                         vertical: 10,
//                       ),
//                       child: Column(
//                         children: [
//                           _buildTextField("Name", nameController),
//                           const SizedBox(height: 15),
//                           _buildTextField("Email", mailController),
//                           const SizedBox(height: 15),
//                           _buildTextField(
//                             "Password",
//                             passwordController,
//                             obscure: true,
//                           ),
//                           const SizedBox(height: 25),
//                           SizedBox(
//                             width: double.infinity,
//                             height: 50,
//                             child: ElevatedButton(
//                               onPressed: registration,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.orange,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Sign up",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "Already have an account? ",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => Login(),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text(
//                                   "Signin",
//                                   style: TextStyle(color: Colors.orange),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller, {
//     bool obscure = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.white),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.orange),
//         ),
//       ),
//     );
//   }
// }

//---------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import '../services/shared_pref.dart';
import 'home.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void registration() async {
    String email = mailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      setState(() => isLoading = true);
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (!mounted) return;
        await userCredential.user!.updateDisplayName(name);

        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userInfoMap = {
          "Name": name,
          "Email": email,
          "Image":
              "https://firebasestorage.googleapis.com/v0/b/your-app-id.appspot.com/o/default_avatar.png?alt=media",
          "Id": id,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .set(userInfoMap);

        await SharedPreferenceHelper().saveUserEmail(email);
        await SharedPreferenceHelper().saveUserId(id);
        await SharedPreferenceHelper().saveUserDisplayName(name);
        await SharedPreferenceHelper().saveUserImage(userInfoMap["Image"]);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "An error occurred")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3), // Soft off-white background
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF023D54)),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.asset(
                          'images/5-Amazing-Places-To-Visit-In-Northern-Areas-Of-Pakistan.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF023D54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          _buildTextField("Name", nameController),
                          const SizedBox(height: 15),
                          _buildTextField("Email", mailController),
                          const SizedBox(height: 15),
                          _buildTextField(
                            "Password",
                            passwordController,
                            obscure: true,
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: registration,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF023D54,
                                ), // Deep Blue
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Signin",
                                  style: TextStyle(
                                    color: Color(0xFF023D54),
                                  ), // Deep Blue
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF023D54)), // Deep Blue
        ),
      ),
    );
  }
}
