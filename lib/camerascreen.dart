import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

enum ImageAngles { top, front, rear, left, right, total }

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.controller,
    required this.futureController,
    required this.onImageTaken,
  });

  final CameraController controller;
  final Future<void> futureController;
  final Function(XFile, ImageAngles) onImageTaken;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  bool topAngleTaken = false;
  bool frontAngleTaken = false;
  bool rearAngleTaken = false;
  bool leftAngleTaken = false;
  bool rightAngleTaken = false;
  bool totalAngleTaken = false;

  XFile? topAngle;
  XFile? frontAngle;
  XFile? rearAngle;
  XFile? leftAngle;
  XFile? rightAngle;
  XFile? totalAngle;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: widget.futureController,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Stack(
              children: [
                Center(child: CameraPreview(widget.controller)),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withAlpha(0),
                        Theme.of(context).canvasColor.withAlpha(127),
                        Theme.of(context).canvasColor
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StaggeredGrid.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      children: [
                        FilledButton(
                          onPressed: () {
                            takePicture(
                              (image) {
                                topAngle = image;
                                setState(() {
                                  topAngleTaken = true;
                                });
                                widget.onImageTaken(image, ImageAngles.top);
                              },
                              () {
                                topAngle = null;
                                setState(() {
                                  topAngleTaken = false;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: topAngleTaken
                              ? ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).primary),
                                  foregroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).onPrimary),
                                )
                              : null,
                          child: const Row(
                            children: [
                              Icon(Icons.camera),
                              SizedBox(width: 4.0),
                              Text("Top"),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            takePicture(
                              (image) {
                                frontAngle = image;
                                setState(() {
                                  frontAngleTaken = true;
                                });
                                widget.onImageTaken(image, ImageAngles.front);
                              },
                              () {
                                frontAngle = null;
                                setState(() {
                                  frontAngleTaken = false;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: frontAngleTaken
                              ? ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).primary),
                                  foregroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).onPrimary),
                                )
                              : null,
                          child: const Row(
                            children: [
                              Icon(Icons.camera),
                              SizedBox(width: 4.0),
                              Text("Front"),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            takePicture(
                              (image) {
                                rearAngle = image;
                                setState(() {
                                  rearAngleTaken = true;
                                });
                                widget.onImageTaken(image, ImageAngles.rear);
                              },
                              () {
                                rearAngle = null;
                                setState(() {
                                  rearAngleTaken = false;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: rearAngleTaken
                              ? ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).primary),
                                  foregroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).onPrimary),
                                )
                              : null,
                          child: const Row(
                            children: [
                              Icon(Icons.camera),
                              SizedBox(width: 4.0),
                              Text("Rear"),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            takePicture(
                              (image) {
                                leftAngle = image;
                                setState(() {
                                  leftAngleTaken = true;
                                });
                                widget.onImageTaken(image, ImageAngles.left);
                              },
                              () {
                                leftAngle = null;
                                setState(() {
                                  leftAngleTaken = false;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: leftAngleTaken
                              ? ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).primary),
                                  foregroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).onPrimary),
                                )
                              : null,
                          child: const Row(
                            children: [
                              Icon(Icons.camera),
                              SizedBox(width: 4.0),
                              Text("Left"),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            takePicture(
                              (image) {
                                rightAngle = image;
                                setState(() {
                                  rightAngleTaken = true;
                                });
                                widget.onImageTaken(image, ImageAngles.right);
                              },
                              () {
                                rightAngle = null;
                                setState(() {
                                  rightAngleTaken = false;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: rightAngleTaken
                              ? ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).primary),
                                  foregroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).onPrimary),
                                )
                              : null,
                          child: const Row(
                            children: [
                              Icon(Icons.camera),
                              SizedBox(width: 4.0),
                              Text("Right"),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            takePicture(
                              (image) {
                                totalAngle = image;
                                setState(() {
                                  totalAngleTaken = true;
                                });
                                widget.onImageTaken(image, ImageAngles.total);
                              },
                              () {
                                totalAngle = null;
                                setState(() {
                                  totalAngleTaken = false;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: totalAngleTaken
                              ? ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).primary),
                                  foregroundColor: MaterialStateProperty.all(
                                      ColorScheme.fromSeed(
                                    seedColor: Colors.green,
                                    brightness: Brightness.dark,
                                  ).onPrimary),
                                )
                              : null,
                          child: const Row(
                            children: [
                              Icon(Icons.camera),
                              SizedBox(width: 4.0),
                              Text("3/4"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> takePicture(Function(XFile) onTaken, Function onReject) async {
    try {
      // Ensure that the camera is initialized.
      await widget.futureController;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await widget.controller.takePicture();
      onTaken(image);
      if (!mounted) return;
      // If the picture was taken, display it on a new screen.
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            onReject: onReject,
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Unknown Error"),
            icon: const Icon(
              Icons.error_rounded,
              size: 72,
            ),
            content: Text(
              e.toString(),
              style: const TextStyle(fontFamily: "RobotoMono"),
            ),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({
    super.key,
    required this.onReject,
    required this.imagePath,
  });

  final Function onReject;

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Preview')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              File(imagePath),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorScheme.fromSeed(
                      seedColor: Colors.green,
                      brightness: Brightness.dark,
                    ).primary),
                    foregroundColor:
                        MaterialStateProperty.all(ColorScheme.fromSeed(
                      seedColor: Colors.green,
                      brightness: Brightness.dark,
                    ).onPrimary),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check),
                      Text("Approve"),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                FilledButton(
                  onPressed: () {
                    onReject();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorScheme.fromSeed(
                      seedColor: Colors.redAccent,
                      brightness: Brightness.dark,
                    ).primary),
                    foregroundColor:
                        MaterialStateProperty.all(ColorScheme.fromSeed(
                      seedColor: Colors.redAccent,
                      brightness: Brightness.dark,
                    ).onPrimary),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.block),
                      Text("Reject"),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
