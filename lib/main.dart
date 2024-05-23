import 'dart:io';

import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListOfActions(),
    );
  }
}

class ListOfActions extends StatelessWidget {
  const ListOfActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _requestCameraPermission();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyDemoApp()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                child: const Text("Take Picture"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                child: const Text("Upload Picture"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      // Permission granted
    } else {
      // Handle the case when the user denies the permission
    }
  }
}

class MyDemoApp extends StatefulWidget {
  const MyDemoApp({super.key});

  @override
  State<MyDemoApp> createState() => _MyDemoAppState();
}

class _MyDemoAppState extends State<MyDemoApp> {
  late DeepArController _controller;
  bool _isInitialized = false;
   String typeOfFilter = "effects";

  List masks = [
    "none",
    "assets/aviators",
    "assets/bigmouth",
    "assets/lion",
    "assets/dalmatian",
    "assets/bcgseg",
    "assets/look2",
    "assets/fatify",
    "assets/flowers",
    "assets/grumpycat",
    "assets/koala",
    "assets/mudmask",
    "assets/obama",
    "assets/pug",
    "assets/slash",
    "assets/sleepingmask",
    "assets/smallface",
    "assets/teddycigar",
    "assets/tripleface",
    "assets/twistedface",
  ];
  List effects = [
    "none",
    "assets/fire",
    "assets/heart",
    "assets/blizzard",
    "assets/rain",
    "assets/burning_effect",
  ];
  List filters = [
    "none",
    "assets/drawingmanga",
    "assets/sepia",
    "assets/bleachbypass",
    "assets/realvhs",
    "assets/filmcolorperfection"
  ];
  List effectsType = [
    "masks","effects","filters"
  ];
  List get effectList {
    switch (typeOfFilter) {
      case "masks":
        return masks;
        break;
      case "effects":
        return effects;
        break;
      case "filters":
        return filters;
        break;
      default:
        return masks;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = DeepArController();
    await _controller.initialize(
      androidLicenseKey:
          "154d5f798a5303ab81e93fb224c15a356340468eb8538913f66b28438d1ef1c4b0f78a92d87bebfc",
      iosLicenseKey: "---iOS key---",
      resolution: Resolution.high,
    );
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Stack(
            children: [
              DeepArPreview(_controller),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          padding: EdgeInsets.all(15),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(effectList.length, (p) {
                              String imgPath = effectList[p];
                              return GestureDetector(
                                onTap: () async {
                                  if (!_controller.isInitialized) return;
                                  _controller.switchEffect(
                                      imgPath);
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.all(6),
                                  width: 55,
                                  height: 55,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    "$p",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color:
                                        Colors.black),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: List.generate(effectsType.length, (p) {

                            return Expanded(
                              child: Container(
                                height: 40,
                                margin: const EdgeInsets.all(2),
                                child: TextButton(
                                  onPressed: () async {
                                    typeOfFilter =effectsType[p].toString();
                                    setState(() {});
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.black,
                                    // shape: CircleBorder(
                                    //     side: BorderSide(
                                    //         color: Colors.white, width: 3))
                                  ),
                                  child: Text(
                                    effectsType[p].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  _controller.switchEffect('assets/beard');

                                },
                                child: const Text("Change Filter")),
                            ElevatedButton(
                                onPressed: () async {
                                  final imageFile =
                                      await _controller.takeScreenshot();
                                  _saveImageFile(imageFile);
                                  // _controller.
                                },
                                child: const Text("Take Picture")),
                            ElevatedButton(
                                onPressed: () {
                                  _controller.flipCamera();
                                },
                                child: const Text("Flip")),
                          ],
                        )
                      ],
                    )),
              )
            ],
          )
        : const Center(
            child: Text("Loading Preview"),
          );
  }

  Future<void> _saveImageFile(File imageFile) async {
    // Request permissions
    await _requestPermission();

    // Read the image file as bytes
    final Uint8List bytes = await imageFile.readAsBytes();

    // Save the image to the gallery
    final result = await ImageGallerySaver.saveImage(bytes,
        quality: 100, name: "screenshot");

    if (result["isSuccess"]) {
      // Image saved successfully
      print("Image saved to gallery");
    } else {
      // Handle the error
      print("Failed to save image to gallery");
    }
  }

  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      // Permission granted
    } else {
      // Handle the case when the user denies the permission
    }
  }
}
