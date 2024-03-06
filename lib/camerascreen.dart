import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

enum ImageAngles { top, front, rear, left, right, total }

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  TakePictureScreen({
    super.key,
    required this.controller,
    required this.futureController,
    required this.onImageTaken,
    required this.totalAngleTaken,
    required this.topAngleTaken,
    required this.frontAngleTaken,
    required this.rearAngleTaken,
    required this.leftAngleTaken,
    required this.rightAngleTaken,
    required this.totalUpdated,
    required this.topUpdated,
    required this.frontUpdated,
    required this.rearUpdated,
    required this.leftUpdated,
    required this.rightUpdated,
  });

  final CameraController controller;
  final Future<void> futureController;
  final Function(XFile, ImageAngles) onImageTaken;

  bool topAngleTaken = false;
  bool frontAngleTaken = false;
  bool rearAngleTaken = false;
  bool leftAngleTaken = false;
  bool rightAngleTaken = false;
  bool totalAngleTaken = false;

  Function(bool) totalUpdated;
  Function(bool) frontUpdated;
  Function(bool) rearUpdated;
  Function(bool) leftUpdated;
  Function(bool) rightUpdated;
  Function(bool) topUpdated;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
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
                                  widget.topUpdated(true);
                                });
                                widget.onImageTaken(image, ImageAngles.top);
                              },
                              () {
                                topAngle = null;
                                setState(() {
                                  widget.topUpdated(false);
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: widget.topAngleTaken
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
                                  widget.frontUpdated(true);
                                });
                                widget.onImageTaken(image, ImageAngles.front);
                              },
                              () {
                                frontAngle = null;
                                setState(() {
                                  widget.frontUpdated(false);
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: widget.frontAngleTaken
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
                                  widget.rearUpdated(true);
                                });
                                widget.onImageTaken(image, ImageAngles.rear);
                              },
                              () {
                                rearAngle = null;
                                setState(() {
                                  widget.rearUpdated(true);
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: widget.rearAngleTaken
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
                                  widget.leftUpdated(true);
                                });
                                widget.onImageTaken(image, ImageAngles.left);
                              },
                              () {
                                leftAngle = null;
                                setState(() {
                                  widget.leftUpdated(true);
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: widget.leftAngleTaken
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
                                  widget.rightUpdated(true);
                                });
                                widget.onImageTaken(image, ImageAngles.right);
                              },
                              () {
                                rightAngle = null;
                                setState(() {
                                  widget.rightUpdated(true);
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: widget.rightAngleTaken
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
                                  widget.totalUpdated(true);
                                });
                                widget.onImageTaken(image, ImageAngles.total);
                              },
                              () {
                                totalAngle = null;
                                setState(() {
                                  widget.totalUpdated(false);
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          style: widget.totalAngleTaken
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
