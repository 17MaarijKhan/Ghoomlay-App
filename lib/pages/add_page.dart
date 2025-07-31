// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:image_picker/image_picker.dart';

// class AddPostScreen extends StatefulWidget {
//   const AddPostScreen({super.key});

//   @override
//   State<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {
//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController captionController = TextEditingController();

//   Uint8List? _imageBytes;
//   final picker = ImagePicker();
//   bool isUploading = false;

//   Future pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final bytes = await pickedFile.readAsBytes();
//       setState(() {
//         _imageBytes = bytes;
//       });
//     }
//   }

//   Future<void> uploadPost() async {
//     if (_imageBytes == null ||
//         placeController.text.isEmpty ||
//         cityController.text.isEmpty ||
//         captionController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please complete all fields')),
//       );
//       return;
//     }

//     setState(() => isUploading = true);

//     String base64Image = base64Encode(_imageBytes!);

//     DatabaseReference ref =
//         FirebaseDatabase.instance.ref().child('posts').push();
//     await ref.set({
//       'placeName': placeController.text.trim(),
//       'cityName': cityController.text.trim(),
//       'caption': captionController.text.trim(),
//       'imageBase64': base64Image,
//       'timestamp': DateTime.now().toIso8601String(),
//     });

//     setState(() => isUploading = false);
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Post added successfully')));
//     Navigator.pop(context);
//   }

//   Widget buildTextField(
//     String label,
//     TextEditingController controller, {
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: "Enter $label",
//             hintStyle: const TextStyle(color: Colors.grey),
//             filled: true,
//             fillColor: const Color(0xFF1E1E1E),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Add Post",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             GestureDetector(
//               onTap: pickImage,
//               child: Container(
//                 height: 180,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF1E1E1E),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.orange, width: 1.2),
//                 ),
//                 child:
//                     _imageBytes == null
//                         ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(
//                               Icons.cloud_upload_outlined,
//                               size: 50,
//                               color: Colors.orangeAccent,
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               "Tap to upload image",
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         )
//                         : ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.memory(
//                             _imageBytes!,
//                             fit:
//                                 BoxFit.contain, // Changed from cover to contain
//                             width: double.infinity,
//                             height: 180,
//                           ),
//                         ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             buildTextField("Place Name", placeController),
//             buildTextField("City Name", cityController),
//             buildTextField("Caption", captionController, maxLines: 4),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: isUploading ? null : uploadPost,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               icon:
//                   isUploading
//                       ? const SizedBox(
//                         width: 22,
//                         height: 22,
//                         child: CircularProgressIndicator(color: Colors.white),
//                       )
//                       : const Icon(Icons.send, color: Colors.white),
//               label: Text(
//                 isUploading ? 'Uploading...' : 'Post',
//                 style: const TextStyle(color: Colors.white, fontSize: 17),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//-------------------------------------------------------------------------------------

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  Uint8List? _imageBytes;
  final picker = ImagePicker();
  bool isUploading = false;

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> uploadPost() async {
    if (_imageBytes == null ||
        placeController.text.isEmpty ||
        cityController.text.isEmpty ||
        captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() => isUploading = true);

    String base64Image = base64Encode(_imageBytes!);

    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('posts').push();
    await ref.set({
      'placeName': placeController.text.trim(),
      'cityName': cityController.text.trim(),
      'caption': captionController.text.trim(),
      'imageBase64': base64Image,
      'timestamp': DateTime.now().toIso8601String(),
    });

    setState(() => isUploading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Post added successfully')));
    Navigator.pop(context);
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color(0xFF0A3D62), // Deep Blue for labels
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Color(0xFF0A3D62)),
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey), // Grey border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 2,
              ), // Grey
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD), // Soft white
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D62), // Deep blue
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Post",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 1.2),
                ),
                child:
                    _imageBytes == null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 50,
                              color: Color(0xFF0A3D62),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tap to upload image",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 180,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 24),
            buildTextField("Place Name", placeController),
            buildTextField("City Name", cityController),
            buildTextField("Caption", captionController, maxLines: 4),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isUploading ? null : uploadPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3D62), // Deep Blue
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon:
                  isUploading
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : const Icon(Icons.send, color: Colors.white),
              label: Text(
                isUploading ? 'Uploading...' : 'Post',
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
