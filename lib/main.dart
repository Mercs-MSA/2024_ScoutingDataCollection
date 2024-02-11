import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter_form_elements/forms.dart';

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

  double pitRepairabilityScore = 0;
  String pitDrivebaseType = "Swerve";

  int? pitWidthData;
  int? pitLengthData;
  bool pitCanPassStage = false;

  bool pitIntakeInBumper = false;
  String pitClimberType = "Tube-in-Tube";

  bool fieldAutonExists = false;

  bool pitDoesSpeaker = true;
  bool pitDoesAmp = true;
  bool pitDoesTrap = false;

  bool pitDoesGroundPickup = false;
  bool pitDoesSourcePickup = false;

  bool pitDoesTurretShoot = false;
  bool pitDoesExtendShoot = true;

  int fieldAutonSpeakerNotes = 0;
  int fieldAutonAmpNotes = 0;

  bool saveDisabled = false;

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
                      onPressed: (){ setState(() {
                        appMode = 1;
                      }); },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(const Size.fromHeight(150)),
                        maximumSize: MaterialStateProperty.all(const Size.fromHeight(200)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          )
                        )
                      ),
                      child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Pit Scouting", style: TextStyle(fontSize: 24),),
                            Text("Enter pit scouting mode.")
                          ]
                      )
                  ),
                ),
                const SizedBox(height: 8.0),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: FilledButton(
                      onPressed: (){ setState(() {
                        appMode = 2;
                      }); },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(const Size.fromHeight(150)),
                        maximumSize: MaterialStateProperty.all(const Size.fromHeight(200)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          )
                        )
                      ),
                      child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Field Scouting", style: TextStyle(fontSize: 24)),
                            Text("Enter field scouting mode.")
                          ]
                      )
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
                        onPressed: (){ setState(() {
                          appMode = 3;
                        }); },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(const Size.fromHeight(100)),
                          maximumSize: MaterialStateProperty.all(const Size.fromHeight(200)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            )
                          )
                        ),
                        child: const FittedBox(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("App Setup", style: TextStyle(fontSize: 24)),
                                Text("Configure app and team lists")
                              ]
                          ),
                        )
                    ),
                  )
              ],
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Pit Data Collection'),
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      appMode = 0;
                    });
                  },
                  icon: const Icon(Icons.start)
              )
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
                label: 'General',
              ),
              NavigationDestination(
                icon: Icon(Icons.outbox),
                label: 'Output',
              )
            ],
            selectedIndex: pitPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                pitPageIndex = index;
              });
            },
          ),
          body: IndexedStack(
            index: pitPageIndex,
            children: [
              Column(
                children: [
                  // TODO: Use real data from data import
                  ExpansionTile(
                  title: const Text("To Be Scouted"),
                  initiallyExpanded: true,
                  children: [
                    PitScoutSelection(team: 9999, onSelected: (){ setState(() {
                      pitTeamNumber = 9999;
                    }); }),
                    PitScoutSelection(team: 9998, onSelected: (){ setState(() {
                      pitTeamNumber = 9998;
                    }); })
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
                            pitTeamNumber = int.tryParse(value);
                          },
                          controller: TextEditingController(
                            text: pitTeamNumber == null ? '' : pitTeamNumber.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
              RobotForm(
                teamNumberPresent: pitTeamNumber == null ? false : true,
                onRepairabilityChanged: (value){ pitRepairabilityScore = value; },
                onDrivebaseChanged: (value){ pitDrivebaseType = value; },
                onLengthChanged: (value){ pitLengthData = value; },
                onWidthChanged: (value){ pitWidthData = value; },
                onStagePassChanged: (value){ setState(() {
                  pitCanPassStage = value;
                }); },
                onIntakeInBumperChanged: (value){ pitIntakeInBumper = value; },
                onClimberTypeChanged: (value){ pitClimberType = value; },
                onDoesSpeakerChanged: (value){ pitDoesSpeaker = value; },
                onDoesAmpChanged: (value){ pitDoesAmp = value; },
                onDoesTrapChanged: (value){ pitDoesTrap = value; },
                onDoesGroundPickupChnaged: (value){ pitDoesGroundPickup = value; },
                onDoesSourcePickupChanged: (value){ pitDoesSourcePickup = value; },
                onDoesExtendShootChanged: (value){ pitDoesExtendShoot = value; },
                onDoesTurretShootChanged: (value){ pitDoesTurretShoot = value; },
                onAutonExistsChanged: (value){ fieldAutonExists = value; },
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
                            item: "Team Number",
                            data: pitTeamNumber == null
                                ? "Empty"
                                : pitTeamNumber.toString()),
                        DataCard(
                            item: "Checkbox", data: fieldAutonExists.toString()),
                        DataCard(
                            item: "Switch", data: switchIsToggled.toString()),
                        DataCard(item: "Rating", data: pitRepairabilityScore.toString()),
                        DataCard(item: "Dropdown", data: pitDrivebaseType),
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
          )),
        Scaffold(
          appBar: AppBar(
            title: const Text('Field Data Collection'),
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      appMode = 0;
                    });
                  },
                  icon: const Icon(Icons.start)
              )
            ],
          ),
          body: IndexedStack(
            index: fieldPageIndex,
            children: [
              Column(
                children: [
                  // TODO: Use real data from data import
                  ExpansionTile(
                    title: const Text("To Be Scouted"),
                    initiallyExpanded: true,
                    children: [
                      ScoutSelection(team: 9999, match: 17, alliance: Alliances.red, onSelected: (){ setState(() {
                        fieldTeamNumber = 9999;
                      }); },),
                      ScoutSelection(team: 9998, match: 8, alliance: Alliances.blue, onSelected: (){ setState(() {
                        fieldTeamNumber = 9998;
                      }); }),
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
                            text: fieldTeamNumber == null ? '' : fieldTeamNumber.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
              AutonForm(
                autonExists: fieldAutonExists,
                onAutonExistsChanged: (value){ setState(() {
                  fieldAutonExists = value!;
                }); },
                speakerNotes: fieldAutonSpeakerNotes,
                onSpeakerNotesChanged: (value){ setState(() {
                  fieldAutonSpeakerNotes = value;
                }); },
                ampNotes: fieldAutonAmpNotes,
                onAmpNotesChanged: (value){ setState(() {
                  fieldAutonAmpNotes = value;
                }); },
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
              )
            ],
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Application Setup'),
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      appMode = 0;
                    });
                  },
                  icon: const Icon(Icons.start)
              )
            ],
          )
        )
      ],
    );
  }

  void onSave() async {
    final fileData = const ListToCsvConverter().convert([
      ['item', 'value', 'group'],
      ['team', pitTeamNumber, 'general'],
      ['bot_width', pitWidthData, 'general'],
      ['bot_length', pitLengthData, 'general'],
      ['drivebase', pitDrivebaseType, 'general'],
      ['climber', pitClimberType, 'general'],
      ['under_stage', pitCanPassStage, 'general'],
      ['intake_in_bumper', pitIntakeInBumper, 'general'],
      ['speaker_score', pitDoesSpeaker, 'general'],
      ['amp_score', pitDoesAmp, 'general'],
      ['trap_score', pitDoesTrap, 'general'],
      ['ground_pickup', pitDoesGroundPickup, 'general'],
      ['source_pickup', pitDoesSourcePickup, 'general'],
      ['turret_shoot', pitDoesTurretShoot, 'general'],
      ['extend_shoot', pitDoesExtendShoot, 'general'],
      ['repairability', pitRepairabilityScore, 'general']
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
