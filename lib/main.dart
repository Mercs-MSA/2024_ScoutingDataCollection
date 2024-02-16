import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_form_elements/datatypes.dart';
import 'package:flutter_form_elements/field_forms.dart';
import 'package:flutter_form_elements/pit_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets.dart';

void main() {
  runApp(const ScoutingApp());
}

class ScoutingApp extends StatelessWidget {
  const ScoutingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouting App',
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

  int pitPageIndex = 0;
  int fieldPageIndex = 0;
  int appMode = 0;

  int? fieldTeamNumber;
  int? pitTeamNumber;

  int? fieldMatchNumber;

  double pitRepairabilityScore = 0;
  String pitDrivebaseType = "Swerve";
  String? pitAltDrivebaseType;

  int? pitWidthData;
  int? pitLengthData;
  int? pitHeightData;
  bool pitCanPassStage = false;

  bool pitIntakeInBumper = false;
  String pitClimberType = "Tube-in-Tube";
  String? pitAltClimberType;

  bool fieldAutonExists = false;
  bool pitAutonExists = false;

  bool pitDoesSpeaker = true;
  bool pitDoesAmp = true;
  bool pitDoesTrap = false;

  bool pitDoesGroundPickup = false;
  bool pitDoesSourcePickup = false;

  bool pitDoesTurretShoot = false;
  bool pitDoesExtendShoot = true;

  int fieldAutonSpeakerNotes = 0;
  int fieldAutonAmpNotes = 0;

  int fieldAutonSpeakerNotesMissed = 0;
  int fieldAutonAmpNotesMissed = 0;

  bool saveDisabled = false;

  //TODO: Make this data real with json import
  List<ScoutingTask> incompleteFieldScoutingTasks = [
    ScoutingTask(team: 9999, match: 18, alliance: Alliances.blue),
    ScoutingTask(team: 9998, match: 19, alliance: Alliances.red),
    ScoutingTask(team: 9997, match: 20, alliance: Alliances.blue),
  ];

  List<PitScoutingTask> incompletePitScoutingTasks = [
    PitScoutingTask(team: 9999),
    PitScoutingTask(team: 9998),
    PitScoutingTask(team: 9997)
  ];

  List<PitScoutingTask> completePitScoutingTasks = [
    PitScoutingTask(team: 9000),
    PitScoutingTask(team: 8999),
    PitScoutingTask(team: 8998)
  ];

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      appMode = prefs.getInt('appMode') ?? 0;
    });
  }

  Future<void> setAppModePref(mode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('appMode', mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: appMode,
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Welcome!")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        appMode = 1;
                        setAppModePref(appMode);
                      });
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(150)),
                      maximumSize:
                          MaterialStateProperty.all(const Size.fromHeight(200)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pit Scouting",
                          style: TextStyle(fontSize: 24),
                        ),
                        Text("Enter pit scouting mode.")
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        appMode = 2;
                        setAppModePref(appMode);
                      });
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(150)),
                      maximumSize:
                          MaterialStateProperty.all(const Size.fromHeight(200)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Field Scouting", style: TextStyle(fontSize: 24)),
                        Text("Enter field scouting mode.")
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const Image(
                  image: AssetImage('images/mercs.png'),
                  fit: BoxFit.scaleDown,
                  width: 256,
                  isAntiAlias: true,
                ),
                const Spacer(),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        appMode = 3;
                        setAppModePref(appMode);
                      });
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(100)),
                      maximumSize:
                          MaterialStateProperty.all(const Size.fromHeight(200)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    child: const FittedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("App Setup", style: TextStyle(fontSize: 24)),
                            Text("Configure app and team lists")
                          ]),
                    ),
                  ),
                ),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Are you sure?"),
                                content: const Text("Do you want to reset all information on the app?"),
                                actions: [
                                  TextButton(
                                    child: const Text('Reset'),
                                    onPressed: () {
                                      pitPageIndex = 0;
                                      fieldPageIndex = 0;
                                      appMode = 0;
                                      fieldTeamNumber = null;
                                      pitTeamNumber = null;
                                      fieldMatchNumber = null;
                                      pitRepairabilityScore = 0;
                                      pitDrivebaseType = "Swerve";
                                      pitAltDrivebaseType = null;
                                      pitWidthData = null;
                                      pitLengthData = null;
                                      pitHeightData = null;
                                      pitCanPassStage = false;
                                      pitIntakeInBumper = false;
                                      pitClimberType = "Tube-in-Tube";
                                      pitAltClimberType = null;
                                      fieldAutonExists = false;
                                      pitAutonExists = false;
                                      pitDoesSpeaker = true;
                                      pitDoesAmp = true;
                                      pitDoesTrap = false;
                                      pitDoesGroundPickup = false;
                                      pitDoesSourcePickup = false;
                                      pitDoesTurretShoot = false;
                                      pitDoesExtendShoot = true;
                                      fieldAutonSpeakerNotes = 0;
                                      fieldAutonAmpNotes = 0;
                                      fieldAutonSpeakerNotesMissed = 0;
                                      fieldAutonAmpNotesMissed = 0;
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size.fromHeight(100)),
                        maximumSize: MaterialStateProperty.all(
                            const Size.fromHeight(200)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: const FittedBox(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Reset App", style: TextStyle(fontSize: 24)),
                            ]),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Pit Data Collection'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      appMode = 0;
                      pitPageIndex = 0;
                      setAppModePref(appMode);
                    });
                  },
                  icon: const Icon(Icons.start))
            ],
          ),
          bottomNavigationBar: NavigationBar(
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.flag),
                label: 'Start',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt),
                label: 'Data',
              ),
              NavigationDestination(
                icon: Icon(Icons.outbox),
                label: 'Output',
              )
            ],
            selectedIndex: pitPageIndex,
            onDestinationSelected: (int index) {
              if ((pitTeamNumber != null) &&
                  (pitPageIndex == 0) &&
                  (index == 1) &&
                  !(incompletePitScoutingTasks
                      .any((entry) => entry.team == pitTeamNumber))) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      icon: const Icon(
                        Icons.warning_rounded,
                        size: 72,
                      ),
                      content: const Text(
                          "You are selecting a team that you are not assigned to scout. Are you sure you want to continue?"),
                      actionsOverflowButtonSpacing: 20,
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              pitPageIndex = 0;
                              pitTeamNumber = null;
                            });
                          },
                          child: const Text("Go Back"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Yes, I'm Sure"),
                        ),
                      ],
                    );
                  },
                );
              }
              setState(() {
                pitPageIndex = index;
              });
            },
          ),
          body: IndexedStack(
            index: pitPageIndex,
            children: [
              ListView(
                children: [
                  // TODO: Use real data from data import
                  ExpansionTile(
                    title: const Text("To Be Scouted"),
                    initiallyExpanded: true,
                    children: [
                      for (final entry in incompletePitScoutingTasks)
                        PitScoutSelection(
                          team: entry.team,
                          onSelected: () {
                            setState(() {
                              pitTeamNumber = entry.team;
                            });
                          },
                        )
                    ],
                  ),
                  ExpansionTile(
                    title: const Text("Scouted"),
                    initiallyExpanded: false,
                    children: [
                      for (final entry in completePitScoutingTasks)
                        PitScoutSelection(
                          team: entry.team,
                          onSelected: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Warning"),
                                  icon: const Icon(
                                    Icons.warning_rounded,
                                    size: 72,
                                  ),
                                  content: const Text(
                                      "You are selecting a team that has already been scouted. Do you want to re-scout this team?"),
                                  actionsOverflowButtonSpacing: 20,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          pitTeamNumber = null;
                                        });
                                      },
                                      child: const Text("Go Back"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Yes, I'm Sure"),
                                    ),
                                  ],
                                );
                              },
                            );
                            setState(() {
                              pitTeamNumber = entry.team;
                            });
                          },
                          completed: true,
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
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
                            pitTeamNumber = int.tryParse(value);
                          },
                          controller: TextEditingController(
                            text: pitTeamNumber == null
                                ? ''
                                : pitTeamNumber.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PitForm(
                teamNumberPresent: pitTeamNumber == null ? false : true,
                onLengthChanged: (value) {
                  pitLengthData = value;
                },
                onWidthChanged: (value) {
                  pitWidthData = value;
                },
                onHeightChanged: (value) {
                  pitHeightData = value;
                },
                onRepairabilityChanged: (value) {
                  pitRepairabilityScore = value;
                },
                onDrivebaseChanged: (value) {
                  setState(() {
                    pitDrivebaseType = value;
                  });
                },
                onAltDrivebaseChanged: (value) {
                  setState(() {
                    pitAltDrivebaseType = value;
                  });
                },
                onIntakeInBumperChanged: (value) {
                  setState(() {
                    pitIntakeInBumper = value;
                  });
                },
                onClimberTypeChanged: (value) {
                  setState(() {
                    pitClimberType = value;
                  });
                },
                onAltClimberTypeChanged: (value) {
                  setState(() {
                    pitAltClimberType = value;
                  });
                },
                onDoesSpeakerChanged: (value) {
                  setState(() {
                    pitDoesSpeaker = value;
                  });
                },
                onDoesAmpChanged: (value) {
                  setState(() {
                    pitDoesAmp = value;
                  });
                },
                onDoesTrapChanged: (value) {
                  setState(() {
                    pitDoesTrap = value;
                  });
                },
                onDoesGroundPickupChanged: (value) {
                  setState(() {
                    pitDoesGroundPickup = value;
                  });
                },
                onDoesSourcePickupChanged: (value) {
                  setState(() {
                    pitDoesSourcePickup = value;
                  });
                },
                onDoesExtendShootChanged: (value) {
                  setState(() {
                    pitDoesExtendShoot = value;
                  });
                },
                onDoesTurretShootChanged: (value) {
                  setState(() {
                    pitDoesTurretShoot = value;
                  });
                },
                onAutonExistsChanged: (value) {
                  setState(() {
                    pitAutonExists = value;
                  });
                },
                repairability: pitRepairabilityScore,
                drivebase: pitDrivebaseType,
                altDrivebase: pitAltDrivebaseType,
                length: pitLengthData,
                width: pitWidthData,
                height: pitHeightData,
                intakeInBumper: pitIntakeInBumper,
                climberType: pitClimberType,
                altClimberType: pitAltClimberType,
                doesSpeaker: pitDoesSpeaker,
                doesAmp: pitDoesAmp,
                doesTrap: pitDoesTrap,
                doesSourcePickup: pitDoesSourcePickup,
                doesGroundPickup: pitDoesGroundPickup,
                doesExtendShoot: pitDoesExtendShoot,
                doesTurretShoot: pitDoesTurretShoot,
                autonExists: pitAutonExists,
              ),
              Column(
                children: [
                  const Icon(
                    Icons.output_rounded,
                    size: 180,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final item in getPitKVFormattedData())
                          DataCard(
                            item: item[0],
                            data: item[1].toString(),
                            type: item[1].runtimeType.toString(),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed:
                              saveDisabled == false ? onPitScoutSave : null,
                          label: const Text("Export CSV"),
                          icon: const Icon(Icons.save),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Field Data Collection'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    appMode = 0;
                    fieldPageIndex = 0;
                    setAppModePref(appMode);
                  });
                },
                icon: const Icon(Icons.start),
              )
            ],
          ),
          body: IndexedStack(
            index: fieldPageIndex,
            children: [
              ListView(children: [
                Column(children: [
                  // TODO: Use real data from data import
                  ExpansionTile(
                    title: const Text("To Be Scouted"),
                    initiallyExpanded: true,
                    children: [
                      for (final entry in incompleteFieldScoutingTasks)
                        ScoutSelection(
                          team: entry.team,
                          match: entry.match,
                          alliance: entry.alliance,
                          onSelected: () {
                            setState(() {
                              fieldTeamNumber = entry.team;
                              fieldMatchNumber = entry.match;
                            });
                          },
                        )
                    ],
                  ),
                  const ExpansionTile(
                    title: Text("Scouted"),
                    initiallyExpanded: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
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
                            fieldTeamNumber = int.tryParse(value);
                          },
                          controller: TextEditingController(
                            text: fieldTeamNumber == null
                                ? ''
                                : fieldTeamNumber.toString(),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Match Number',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          onChanged: (value) {
                            fieldMatchNumber = int.tryParse(value);
                          },
                          controller: TextEditingController(
                            text: fieldMatchNumber == null
                                ? ''
                                : fieldMatchNumber.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ]),
              FieldAutonForm(
                teamNumberPresent: fieldTeamNumber == null
                    ? false
                    : true && fieldMatchNumber == null
                        ? false
                        : true,
                autonExists: fieldAutonExists,
                onAutonExistsChanged: (value) {
                  setState(() {
                    fieldAutonExists = value!;
                  });
                },
                speakerNotes: fieldAutonSpeakerNotes,
                onSpeakerNotesChanged: (value) {
                  setState(() {
                    fieldAutonSpeakerNotes = value;
                  });
                },
                speakerNotesMissed: fieldAutonSpeakerNotesMissed,
                onSpeakerNotesMissedChanged: (value) {
                  setState(() {
                    fieldAutonSpeakerNotesMissed = value;
                  });
                },
                ampNotes: fieldAutonAmpNotes,
                onAmpNotesChanged: (value) {
                  setState(() {
                    fieldAutonAmpNotes = value;
                  });
                },
                ampNotesMissed: fieldAutonAmpNotesMissed,
                onAmpNotesMissedChanged: (value) {
                  setState(() {
                    fieldAutonAmpNotesMissed = value;
                  });
                },
              ),
              const Placeholder(),
              const Placeholder(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: saveDisabled == false ? onFieldScoutSave : null,
                  label: const Text("Export CSV"),
                  icon: const Icon(Icons.save),
                ),
              )
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: fieldPageIndex,
            onDestinationSelected: (index) {
              setState(() {
                fieldPageIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                label: "Start",
                icon: Icon(Icons.flag),
              ),
              NavigationDestination(
                label: "Auton",
                icon: Icon(Icons.smart_toy),
              ),
              NavigationDestination(
                label: "Teleop",
                icon: Icon(Icons.sports_esports),
              ),
              NavigationDestination(
                label: "Post",
                icon: Icon(Icons.sports_score),
              ),
              NavigationDestination(
                icon: Icon(Icons.outbox),
                label: 'Output',
              )
            ],
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Application Setup'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    appMode = 0;
                    setAppModePref(appMode);
                  });
                },
                icon: const Icon(Icons.start),
              )
            ],
          ),
        )
      ],
    );
  }

  List<List> getFieldKVFormattedData() {
    return [
      ["key", "value"],
      ["FORMNAME", "field"],
      ["teamNumber", fieldTeamNumber],
      ["matchNumber", fieldMatchNumber],
      ["hasAuton", fieldAutonExists],
      [
        "autonSpeakerNotesScored",
        fieldAutonExists ? fieldAutonSpeakerNotes : "null"
      ],
      [
        "autonSpeakerNotesMissed",
        fieldAutonExists ? fieldAutonSpeakerNotesMissed : "null"
      ],
      ["autonAmpNotesScored", fieldAutonExists ? fieldAutonAmpNotes : "null"],
      [
        "autonAmpNotesMissed",
        fieldAutonExists ? fieldAutonAmpNotesMissed : "null"
      ],
    ];
  }

  List<List> getPitKVFormattedData() {
    return [
      ["key", "value"],
      ["FORMNAME", "pit"],
      ["teamNumber", pitTeamNumber],
      ['botLength', pitLengthData],
      ['botWidth', pitWidthData],
      ['botHeight', pitLengthData],
      ['drivebase', pitDrivebaseType],
      ['drivebaseAlt', pitAltDrivebaseType],
      ['climber', pitClimberType],
      ['climberAlt', pitAltClimberType],
      ['intakeInBumper', pitIntakeInBumper],
      ['speakerScore', pitDoesSpeaker],
      ['ampScore', pitDoesAmp],
      ['trapScore', pitDoesTrap],
      ['groundPickup', pitDoesGroundPickup],
      ['sourcePickup', pitDoesSourcePickup],
      ['turretShoot', pitDoesTurretShoot],
      ['extendShoot', pitDoesExtendShoot],
      ['repairability', pitRepairabilityScore],
    ];
  }

  void onPitScoutSave() async {
    final fileData =
        const ListToCsvConverter().convert(getPitKVFormattedData());

    setState(() {
      saveDisabled = true;
    });

    if (Platform.isAndroid | Platform.isIOS) {
      await saveFileMobile(
          Uint8List.fromList(fileData.codeUnits), "output.csv");
    } else if (Platform.isLinux | Platform.isMacOS | Platform.isWindows) {
      await saveFileDesktop(
          Uint8List.fromList(fileData.codeUnits), "output.csv");
    } else {
      return;
    }
  }

  void onFieldScoutSave() async {
    final fileData =
        const ListToCsvConverter().convert(getFieldKVFormattedData());

    setState(() {
      saveDisabled = true;
    });

    if (Platform.isAndroid | Platform.isIOS) {
      await saveFileMobile(Uint8List.fromList(fileData.codeUnits), "field.csv");
    } else if (Platform.isLinux | Platform.isMacOS | Platform.isWindows) {
      await saveFileDesktop(
          Uint8List.fromList(fileData.codeUnits), "field.csv");
    } else {
      return;
    }
  }

  Future<void> saveFileMobile(Uint8List data, String fileName) async {
    final params = SaveFileDialogParams(data: data, fileName: fileName);
    await FlutterFileDialog.saveFile(params: params);
    setState(() {
      saveDisabled = false;
    });
  }

  Future<void> saveFileDesktop(Uint8List data, String fileName) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Export data',
      fileName: fileName,
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
