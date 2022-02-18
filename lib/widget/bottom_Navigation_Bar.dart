// import 'dart:io';

// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';


 
  
// class Navigation_bar extends StatefulWidget {
//   const Navigation_bar({ Key? key }) : super(key: key);

//   @override
//   State<Navigation_bar> createState() => _Navigation_barState();
// }

// class _Navigation_barState extends State<Navigation_bar> {
//     final imagepicker = ImagePicker();
//     _imageformgallery() async {
//     await Future.delayed(const Duration(seconds: 1), () {});
//     var image = await imagepicker.pickImage(source: ImageSource.gallery);
//     if (image == null) {
//       return null;
//     } else {
//       setState(() {
//         _imagefile = File(image.path);
//         isImageLoded = true;
//       });
//     }
//   }

//   _imageformcamara() async {
//     await Future.delayed(const Duration(seconds: 1), () {});
//     var image = await imagepicker.pickImage(source: ImageSource.camera);
//     if (image == null) {
//       return null;
//     } else {
//       setState(() {
//         _imagefile = File(image.path);
//         isImageLoded = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CurvedNavigationBar(
//         color: Colors.blue,
//         index: 1,
//         height: 50,
//         backgroundColor: Colors.transparent,
//         items: items,
//         onTap: (index) {
//           if (index == 0) {
//             output = "";

//             finaltext = "";
//             _imageformcamara();
//           } else if (index == 2) {
//             output = "";
//             finaltext = "";
//             _imageformgallery();
//           }
//         },
//       );
//   }
// }
