import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:petleo_test/constants/app_colors.dart';
import 'package:petleo_test/services/api_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File? pickedFile;
  late var image;
  bool isPosting = false;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.cadetGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text('Create post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (pickedFile != null)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    pickedFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text (optional)',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // White border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // White border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // White border when enabled
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Container(
              width: _width * 0.3,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                color: AppColors.dblack,
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Image'),
                    Icon(Icons.image_search),
                  ],
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  image = await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    setState(() {
                      pickedFile = File(image.path);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image selected')),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: _width * 0.4,
              child: ElevatedButton(
                onPressed: () async {
                  if (pickedFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select an image')),
                    );
                    return;
                  }

                  final text = _textController.text;
                  await api.postImage(image, text);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post submitted')),
                  );

                  // Optionally, clear the form
                  setState(() {
                    pickedFile = null;
                    _textController.clear();
                  });
                },
                child: Text('POST'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
