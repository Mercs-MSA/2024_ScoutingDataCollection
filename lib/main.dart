import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flex_color_picker/flex_color_picker.dart';
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

  int currentPageIndex = 0;
  int appMode = 0;

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
                icon: Icon(Icons.list_alt),
                label: 'General',
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
              RobotForm(
                onTeamNumberUpdated: (value){ teamNumberData = value; },
                onRepairabilityChanged: (value){ repairabilityScore = value; },
                onDrivebaseChanged: (value){ drivebaseType = value; },
                onLengthChanged: (value){ lengthData = value; },
                onWidthChanged: (value){ widthData = value; },
                onStagePassChanged: (value){ setState(() {
                  canPassStage = value;
                }); },
                onIntakeInBumperChanged: (value){ intakeInBumper = value; },
                onClimberTypeChanged: (value){ climberType = value; },
                onDoesSpeakerChanged: (value){ doesSpeaker = value; },
                onDoesAmpChanged: (value){ doesAmp = value; },
                onDoesTrapChanged: (value){ doesTrap = value; },
                onDoesGroundPickupChnaged: (value){ doesGroundPickup = value; },
                onDoesSourcePickupChanged: (value){ doesSourcePickup = value; },
                onDoesExtendShootChanged: (value){ doesExtendShoot = value; },
                onDoesTurretShootChanged: (value){ doesTurretShoot = value; },
                onAutonExistsChanged: (value){ autonExists = value; },
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
          ),
        )
      ],
    );
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
