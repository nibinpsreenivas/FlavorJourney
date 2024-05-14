import 'dart:developer' as devtools;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:FlavorJourney/resources/foodrep.dart';
import 'package:FlavorJourney/screens/add_post_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class imagesearch extends StatefulWidget {
  const imagesearch({super.key});

  @override
  State<imagesearch> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<imagesearch> {
  File? filePath;
  String label = '';
  double confidence = 0.0;

  pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
      rep.food = label;
    });
  }

  pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
      print(label);
      rep.food = label;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 230),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 250, 230),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Card(
                color: Color.fromARGB(255, 255, 95, 0),
                elevation: 20,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          height: 280,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: AssetImage('assets/upload.jpg'),
                            ),
                          ),
                          child: filePath == null
                              ? const Text('')
                              : Image.file(
                                  filePath!,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  pickImageCamera();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text(
                  "Take a Photo",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  pickImageGallery();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text(
                  "Pick from gallery",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (label == "") {
                    Fluttertoast.showToast(
                      msg: "plz upload food image first",
                    );
                  }
                  final apiKey = "";

                  final model =
                      GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
                  String s = "Generate food recipe for the food $label";
                  final content = [Content.text(s)];

                  await model.generateContent(content).then((response) {
                    // Extract the generated content from the response
                    final generatedContent = response.text!;

                    // Show the dialog with the generated content
                    showSendDialog(context, generatedContent, "Recipe");
                  });
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text(
                  "Recipe",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (label == "") {
                    Fluttertoast.showToast(
                      msg: "plz upload food image first",
                    );
                  }
                  final apiKey = "ENTER YOUR KEY";

                  final model =
                      GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
                  String s =
                      "Generate Food Protein Content for the food $label";
                  final content = [Content.text(s)];

                  await model.generateContent(content).then((response) {
                    // Extract the generated content from the response
                    final generatedContent = response.text!;

                    // Show the dialog with the generated content
                    showSendDialog(
                        context, generatedContent, "Food Protein Content");
                  });
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text(
                  "Food Protein Content",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (label == "") {
                    Fluttertoast.showToast(
                      msg: "plz upload food image first",
                    );
                  }
                  final apiKey = "";

                  final model =
                      GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
                  String s = "Generate Food Side Effects for the food $label";
                  final content = [Content.text(s)];

                  await model.generateContent(content).then((response) {
                    // Extract the generated content from the response
                    final generatedContent = response.text!;

                    // Show the dialog with the generated content
                    showSendDialog(
                        context, generatedContent, "Food Side Effects");
                  });
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text(
                  "Food Side Effects",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSendDialog(BuildContext context, String s, String item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item),
        content: SingleChildScrollView(
          child: Text(s),
        ),
      ),
    );
  }
}
