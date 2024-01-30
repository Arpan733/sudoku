import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sudoku_solver/solve.dart';
import 'package:sudoku_solver/validation.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<int>> sudoku = List.generate(9, (_) => List.generate(9, (_) => 0));

  List selectedContainer = [0, 0];
  List currentErrorContainer = [];

  bool isPermission = false;

  File? pickedImage;
  String text = '';
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
  }

  imgToText() async {
    setState(() {
      isScanning = true;
    });

    String image = await getImageFromCamera();

    if (image != '') {
      List<img.Image> l = await splitImage();

      if (l.isNotEmpty) {
        recognitionToSudoku(l);
      } else {
        setState(() {
          isScanning = false;
        });
      }
    } else {
      setState(() {
        isScanning = false;
      });
    }
  }

  requestCameraPermission() async {
    if (!isPermission) {
      final status = await Permission.camera.request();
      isPermission = status == PermissionStatus.granted;
    }
  }

  Future<String> getImageFromCamera() async {
    String imagePath =
        join((await getApplicationSupportDirectory()).path, "sudoku.jpeg");

    bool success = false;

    try {
      success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning',
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      if (kDebugMode) {
        print('success $success');
      }

      setState(() {
        if (success) {
          if (kDebugMode) {
            print('image: $imagePath');
          }
          pickedImage = File(imagePath);
        }
      });

      return imagePath;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
  }

  Future<List<img.Image>> splitImage() async {
    List<img.Image> imageList = [];
    img.Image? image = img.decodeImage(await pickedImage!.readAsBytes());

    int cellWidth = image!.width ~/ 9;
    int cellHeight = image.height ~/ 9;

    int x = 0, y = 0;

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        img.Image a = img.copyCrop(image,
            x: x, y: y, width: cellWidth, height: cellHeight);

        imageList.add(a);
        x += cellWidth;
      }

      y += cellHeight;
      x = 0;
    }

    return imageList;
  }

  recognitionToSudoku(List<img.Image> l) async {
    List<int> a = [];

    for (img.Image im in l) {
      List<int> pngBytes = img.encodePng(im);
      String filePath =
          '/data/user/0/com.example.sudoku_solver/files/sudoku.png';
      File f = await File(filePath).writeAsBytes(pngBytes);

      int t = await performTextRecognition(f);

      a.add(t);
    }

    List<List<int>> b = [[], [], [], [], [], [], [], [], []];
    int t = 0;

    for (int i = 0; i < a.length; i++) {
      if (i % 27 == 0 && i != 0) {
        t++;
      } else if (i % 9 == 0 && i != 0) {
        t = t - 2;
      } else if (i % 3 == 0 && i != 0) {
        t++;
      }

      b[t].add(a[i]);
    }

    sudoku = b;

    setState(() {
      isScanning = false;
    });
  }

  Future<int> performTextRecognition(File im) async {
    try {
      final inputImage = InputImage.fromFile(im);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final recognizerText = await textRecognizer.processImage(inputImage);

      if (recognizerText.text.isEmpty) {
        return 0;
      }

      int t = int.parse(recognizerText.text.toString()[0]);

      return t;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          'Sudoku Solver',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                sudoku = [
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                ];
                // sudoku = List.generate(9, (_) => List.generate(9, (_) => 0));
                currentErrorContainer = [];
                selectedContainer = [0, 0];
                pickedImage = null;
              });
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () async {
              isPermission = await Permission.camera.request().isGranted;

              if (!isPermission) {
                requestCameraPermission();
              } else {
                imgToText();
              }
            },
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: isScanning
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.indigoAccent,
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width * 1,
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // list.length != 0
                  //     ? SizedBox(
                  //         width: 315,
                  //         height: 315,
                  //         child: GridView.builder(
                  //           gridDelegate:
                  //               const SliverGridDelegateWithFixedCrossAxisCount(
                  //             crossAxisCount: 9,
                  //           ),
                  //           itemCount: list.length,
                  //           itemBuilder: (context, index) {
                  //             // print(sudoku);
                  //             return Image.memory(img.encodeJpg(listI[index]));
                  //             // return Image.file(list[index]);
                  //           },
                  //         ),
                  //       )
                  //     : Container(),
                  SizedBox(
                    width: 315,
                    height: 315,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: sudoku.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurpleAccent,
                              width: 2,
                            ),
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: sudoku[index].length,
                            itemBuilder: (context, i) {
                              bool isRed = false;
                              bool isSelected = false;

                              for (List l in currentErrorContainer) {
                                if (l[0] == index && l[1] == i) {
                                  isRed = true;
                                }
                              }

                              if (selectedContainer.isNotEmpty) {
                                if (selectedContainer[0] == index &&
                                    selectedContainer[1] == i) {
                                  isSelected = true;
                                }
                              }

                              return GestureDetector(
                                onTap: () {
                                  selectedContainer = [index, i];

                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blueAccent.shade100
                                        : (isRed
                                            ? Colors.red.withOpacity(0.25)
                                            : Colors.white),
                                    border: Border.all(
                                      color: Colors.deepPurpleAccent,
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    sudoku[index][i] == 0 ||
                                            sudoku[index][i] > 9
                                        ? ''
                                        : sudoku[index][i].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    alignment: Alignment.center,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 9,
                        mainAxisExtent: 50,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedContainer.isNotEmpty) {
                                sudoku[selectedContainer[0]]
                                    [selectedContainer[1]] = index + 1;

                                if (Logic().sameInContainer(sudoku) ||
                                    Logic().sameInLineHorizontal(sudoku) ||
                                    Logic().sameInLineVertical(sudoku)) {
                                  if (!currentErrorContainer.contains([
                                    selectedContainer[0],
                                    selectedContainer[1]
                                  ])) {
                                    currentErrorContainer.add([
                                      selectedContainer[0],
                                      selectedContainer[1]
                                    ]);
                                  }
                                } else {
                                  if (currentErrorContainer.length != 1 &&
                                      currentErrorContainer.isNotEmpty) {
                                    for (var element in currentErrorContainer) {
                                      if (element[0] == selectedContainer[0] &&
                                          element[1] == selectedContainer[1]) {
                                        currentErrorContainer.remove(element);
                                      }
                                    }
                                  } else if (currentErrorContainer.length ==
                                      1) {
                                    currentErrorContainer = [];
                                  }
                                }
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.indigoAccent,
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                  width: 1,
                                )),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 200,
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedContainer.isNotEmpty) {
                            sudoku[selectedContainer[0]][selectedContainer[1]] =
                                0;

                            if (Logic().sameInContainer(sudoku) ||
                                Logic().sameInLineHorizontal(sudoku) ||
                                Logic().sameInLineVertical(sudoku)) {
                              if (!currentErrorContainer.contains([
                                selectedContainer[0],
                                selectedContainer[1]
                              ])) {
                                currentErrorContainer.add([
                                  selectedContainer[0],
                                  selectedContainer[1]
                                ]);
                              }
                            } else {
                              if (currentErrorContainer.length != 1 &&
                                  currentErrorContainer.isNotEmpty) {
                                for (var element in currentErrorContainer) {
                                  if (element[0] == selectedContainer[0] &&
                                      element[1] == selectedContainer[1]) {
                                    currentErrorContainer.remove(element);
                                  }
                                }
                              } else if (currentErrorContainer.length == 1) {
                                currentErrorContainer = [];
                              }
                            }

                            if (kDebugMode) {
                              print(
                                  'Container: ${Logic().sameInContainer(sudoku)}');
                              print(
                                  'Horizontal: ${Logic().sameInLineHorizontal(sudoku)}');
                              print(
                                  'Vertical: ${Logic().sameInLineVertical(sudoku)}');
                            }
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey.shade700,
                              width: 1,
                            )),
                        alignment: Alignment.center,
                        child: const Text(
                          'Eraser',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: pickedImage != null && pickedImage!.path.isNotEmpty
                          ? Image.file(pickedImage!)
                          : Container(),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        List<List<int>>? result = Solve().solver(sudoku);

                        if (result == null) {
                          Toast.show('No possible Solution');
                        } else {
                          sudoku = result;
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey.shade700,
                              width: 1,
                            )),
                        alignment: Alignment.center,
                        child: const Text(
                          'Solve Puzzle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
