import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

import 'widgets.dart';

void main() {
  runApp(const FormElementsApp());
}

class FormElementsApp extends StatelessWidget {
  const FormElementsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const FormAppPage(),
    );
  }
}

class FormAppPage extends StatefulWidget {
  const FormAppPage({super.key});
  @override
  State<FormAppPage> createState() => _FormAppPageState();
}

class _FormAppPageState extends State<FormAppPage> {
  bool switchIsToggled = false;

  int currentPageIndex = 0;

  String asigneeData = '';
  int? teamNumberData;
  Color colorSelectData = Colors.red;
  double repairabilityScore = 0;
  String drivebaseType = "Swerve";

  int? widthData;
  int? lengthData;
  bool canPassStage = false;

  bool intakeInBumper = false;
  String climberType = "Tube-in-Tube";

  bool autonExists = false;

  bool doesSpeaker = true;
  bool doesAmp = true;
  bool doesTrap = false;

  bool doesGroundPickup = false;
  bool doesSourcePickup = false;

  bool doesTurretShoot = false;
  bool doesExtendShoot = true;

  bool saveDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scouting Data Collection'),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.list_alt),
              label: 'General',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt),
              label: 'Auton',
            ),
            NavigationDestination(
              icon: Icon(Icons.gamepad),
              label: 'Teleop',
            ),
            NavigationDestination(
              icon: Icon(Icons.outbox),
              label: 'Output',
            )
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        body: IndexedStack(
          index: currentPageIndex,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: <Widget>[
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Team Number',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (value) {
                        teamNumberData = int.tryParse(value);
                      },
                      controller: TextEditingController(
                          text: teamNumberData == null
                              ? ''
                              : teamNumberData.toString()),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Asignee',
                      ),
                      onChanged: (value) {
                        asigneeData = value;
                      },
                      controller: TextEditingController(text: asigneeData),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Bot Width',
                              suffixText: "in"
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            onChanged: (value) {
                              widthData = int.tryParse(value);
                            },
                            controller: TextEditingController(
                                text: widthData == null
                                    ? ''
                                    : widthData.toString()),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Bot Length',
                              suffixText: 'in'
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            onChanged: (value) {
                              lengthData = int.tryParse(value);
                            },
                            controller: TextEditingController(
                                text: lengthData == null
                                    ? ''
                                    : lengthData.toString()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    ChoiceInput(
                      title: "Drivebase",
                      onChoiceUpdate: (value) {
                        setState(() {
                          drivebaseType = value!;
                        });
                      },
                      choice: drivebaseType,
                      options: const ["Swerve", "Tank", "Other"],
                    ),
                    const SizedBox(height: 8.0),
                    ChoiceInput(
                      title: "Climber Type",
                      onChoiceUpdate: (value) {
                        setState(() {
                          climberType = value!;
                        });
                      },
                      choice: climberType,
                      options: const ["Tube-in-Tube", "Lead Screw", "Hook and Winch", "Elevator"],
                    ),
                    const SizedBox(height: 8.0),
                    CheckboxListTile(
                      title: const Text('Can go under stage'),
                      value: canPassStage,
                      onChanged: (bool? newValue) {
                        setState(() {
                          canPassStage = newValue!;
                        });
                      },
                    ),
                    const Divider(),
                    CheckboxListTile(
                      title: const Text('Inside Bumper Intake?'),
                      value: intakeInBumper,
                      onChanged: (bool? newValue) {
                        setState(() {
                          intakeInBumper = newValue!;
                        });
                      },
                    ),
                    const Divider(),
                    Expanded(
                        child:
                        Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Speaker'),
                              value: doesSpeaker,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  doesSpeaker = newValue!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Amp'),
                              value: doesAmp,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  doesAmp = newValue!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Trap'),
                              value: doesTrap,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  doesTrap = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                        child:
                        Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Ground'),
                              value: doesGroundPickup,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  doesGroundPickup = newValue!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Source'),
                              value: doesSourcePickup,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  doesSourcePickup = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                        child:
                        Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Turet'),
                              value: doesTurretShoot,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  doesTurretShoot = newValue!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Extend'),
                              value: doesExtendShoot,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  doesExtendShoot = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    RatingInput(
                      title: 'Repairablity',
                      onRatingUpdate: (rating) {
                        repairabilityScore = rating.toDouble();
                      },
                      initialRating: repairabilityScore.toDouble(),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ListView(
                  children: <Widget>[
                      CheckboxListTile(
                        title: const Text('Has Auton'),
                        value: autonExists,
                        onChanged: (bool? newValue) {
                          setState(() {
                            autonExists = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const Icon(
                  Icons.poll_outlined,
                  size: 180,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      DataCard(
                          item: "Text Field",
                          data: asigneeData == "" ? "Empty" : asigneeData),
                      DataCard(
                          item: "Team Number",
                          data: teamNumberData == null
                              ? "Empty"
                              : teamNumberData.toString()),
                      DataCard(
                          item: "Checkbox", data: autonExists.toString()),
                      DataCard(
                          item: "Switch", data: switchIsToggled.toString()),
                      DataCard(
                          item: "Color Select",
                          data: colorSelectData.hex.toString()),
                      DataCard(item: "Rating", data: repairabilityScore.toString()),
                      DataCard(item: "Dropdown", data: drivebaseType),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: saveDisabled == false ? onSave : null,
                        label: const Text("Export CSV"),
                        icon: const Icon(Icons.save),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  void onSave() async {
    final fileData = const ListToCsvConverter().convert([
      ['item', 'value', 'group'],
      ['team', teamNumberData, 'general'],
      ['asignee', asigneeData, 'general'],
      ['bot_width', widthData, 'general'],
      ['bot_length', lengthData, 'general'],
      ['drivebase', drivebaseType, 'general'],
      ['climber', climberType, 'general'],
      ['under_stage', canPassStage, 'general'],
      ['intake_in_bumper', intakeInBumper, 'general'],
      ['speaker_score', doesSpeaker, 'general'],
      ['amp_score', doesAmp, 'general'],
      ['trap_score', doesTrap, 'general'],
      ['ground_pickup', doesGroundPickup, 'general'],
      ['source_pickup', doesSourcePickup, 'general'],
      ['turret_shoot', doesTurretShoot, 'general'],
      ['extend_shoot', doesExtendShoot, 'general'],
      ['repairability', repairabilityScore, 'general']
    ]);

    setState(() {
      saveDisabled = true;
    });

    if (Platform.isAndroid | Platform.isIOS) {
      await saveFileMobile(Uint8List.fromList(fileData.codeUnits));
    } else if (Platform.isLinux | Platform.isMacOS | Platform.isWindows) {
      await saveFileDesktop(Uint8List.fromList(fileData.codeUnits));
    } else {
      return;
    }
  }

  Future<void> saveFileMobile(Uint8List data) async {
    final params = SaveFileDialogParams(data: data, fileName: "output.csv");
    await FlutterFileDialog.saveFile(params: params);
    setState(() {
      saveDisabled = false;
    });
  }

  Future<void> saveFileDesktop(Uint8List data) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Export data',
      fileName: 'output.csv',
    );

    if (outputFile != null) {
      File file = File(outputFile);
      file.writeAsBytes(data);
    }
    setState(() {
      saveDisabled = false;
    });
  }
}
