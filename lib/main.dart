import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_form_elements/datatypes.dart';
import 'package:flutter_form_elements/field_forms.dart';
import 'package:flutter_form_elements/pit_form.dart';
import 'package:path/path.dart' as path;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ScoutingApp(),
  );
}

class ScoutingApp extends StatelessWidget {
  const ScoutingApp({
    super.key,
  });

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
      home: FormAppPage(),
    );
  }
}

class FormAppPage extends StatefulWidget {
  const FormAppPage({
    super.key,
  });

  @override
  State<FormAppPage> createState() => _FormAppPageState();
}

class _FormAppPageState extends State<FormAppPage> {
  bool switchIsToggled = false;

  int pitPageIndex = 0;
  int fieldPageIndex = 0;
  int appMode = 0;

  String eventId = "";
  bool transposedExport = true;
  bool exportHeaders = true;

  int? fieldTeamNumber;
  int? pitTeamNumber;

  int? fieldMatchNumber;

  Alliances fieldAlliance = Alliances.blue;
  int fieldRobotPosition = 1;

  String? fieldPosition = "red 1";

  double pitRepairabilityScore = 0;
  double pitManeuverabilityScore = 0;
  String pitDrivebaseType = "Swerve";
  String? pitAltDrivebaseType;

  int? pitWidthData;
  int? pitLengthData;
  int? pitHeightData;
  int? pitWeightData;
  bool pitCanPassStage = false;

  bool pitIntakeInBumper = false;
  bool pitIsKitbot = false;
  String pitClimberType = "Tube-in-Tube";
  String? pitAltClimberType;

  bool fieldLeave = false;

  bool fieldAutonExists = false;
  bool pitAutonExists = false;
  int pitAutonSpeakerNotes = 0;
  int pitAutonAmpNotes = 0;
  double pitAutonConsistency = 0.0;
  double pitAutonVersatility = 0.0;
  int pitAutonRoutes = 0;
  String pitAutonStrat = "";

  bool pitDoesSpeaker = true;
  bool pitDoesAmp = true;
  bool pitDoesTrap = false;

  bool pitDoesGroundPickup = false;
  bool pitDoesSourcePickup = false;

  bool pitDoesTurretShoot = false;
  bool pitDoesExtendShoot = true;

  bool pitPlayerPreferAmp = false;
  bool pitPlayerPreferSource = false;

  int? pitDriverYears;
  int? pitOperatorYears;
  int? pitCoachYears;

  String pitTeleopStrat = "";

  StartPositions pitPrefStart = StartPositions.middle;

  int fieldAutonSpeakerNotes = 0;
  int fieldAutonAmpNotes = 0;

  int fieldAutonSpeakerNotesMissed = 0;
  int fieldAutonAmpNotesMissed = 0;

  bool saveDisabled = false;
  bool importerSaveCompletes = false;

  List<ScoutingTask> incompleteFieldScoutingTasks = [];

  List<PitScoutingTask> incompletePitScoutingTasks = [];

  List<ScoutingTask> completeFieldScoutingTasks = [];

  List<PitScoutingTask> completePitScoutingTasks = [];

  @override
  void initState() {
    super.initState();

    loadPrefs();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      incompletePitScoutingTasks = convertJsonStringToTasksList(
          prefs.getString("jsonIncompletePitTasks") ?? "",
          (json) => PitScoutingTask.fromJson(json));
      completePitScoutingTasks = convertJsonStringToTasksList(
          prefs.getString("jsonCompletePitTasks") ?? "",
          (json) => PitScoutingTask.fromJson(json));

      incompleteFieldScoutingTasks = convertJsonStringToTasksList(
          prefs.getString("jsonIncompleteFieldTasks") ?? "",
          (json) => ScoutingTask.fromJson(json));
      completeFieldScoutingTasks = convertJsonStringToTasksList(
          prefs.getString("jsonCompleteFieldTasks") ?? "",
          (json) => ScoutingTask.fromJson(json));

      eventId = prefs.getString("eventId") ?? "";

      transposedExport = prefs.getBool("transposedExport") ?? true;
      exportHeaders = prefs.getBool("exportHeaders") ?? true;

      appMode = prefs.getInt('appMode') ?? 0;
    });
  }

  Future<void> setAppModePref(mode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('appMode', mode);
    });
  }

  Future<File?> fileImport(allowedExtensions) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> importTeamList() async {
    if (!context.mounted) return;

    List<PitScoutingTask> newIncompletePitScoutingTasks = [];
    List<ScoutingTask> newIncompleteFieldScoutingTasks = [];

    try {
      // Specify the file path (adjust it based on your actual file location)
      var file = await fileImport(["json"]);
      if (file == null) {
        return;
      }

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file as a string
        var contents = await file.readAsString();

        // Parse the JSON data using jsonDecode from dart:convert
        var jsonData = jsonDecode(contents);

        // Now you can work with the jsonData as needed
        if (jsonData is Map &&
            jsonData.containsKey("pit") &&
            jsonData.containsKey("field") &&
            jsonData["pit"] is List &&
            jsonData["field"] is List) {
          for (Map pitTeam in jsonData["pit"]) {
            if (pitTeam.containsKey("teamNumber")) {
              newIncompletePitScoutingTasks
                  .add(PitScoutingTask(team: pitTeam["teamNumber"]));
            } else {
              if (!mounted) return;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("JSON Formatting Error"),
                    icon: const Icon(
                      Icons.error_rounded,
                      size: 72,
                    ),
                    content: const Text(
                        "Imported json file is not correctly formatted"),
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
              return;
            }
          }
          for (Map fieldTeam in jsonData["field"]) {
            if (fieldTeam.containsKey("teamNumber") &&
                fieldTeam.containsKey("match") &&
                fieldTeam.containsKey("alliance") &&
                fieldTeam.containsKey("position")) {
              newIncompleteFieldScoutingTasks.add(ScoutingTask(
                team: fieldTeam["teamNumber"],
                match: fieldTeam["match"],
                alliance: Alliances.values[fieldTeam["alliance"]],
                position: fieldTeam["position"],
              ));
            } else {
              if (!mounted) return;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("JSON Formatting Error"),
                    icon: const Icon(
                      Icons.error_rounded,
                      size: 72,
                    ),
                    content: const Text(
                        "Imported json file is not correctly formatted"),
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
              return;
            }
          }
        } else {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("JSON Formatting Error"),
                icon: const Icon(
                  Icons.error_rounded,
                  size: 72,
                ),
                content:
                    const Text("Imported json file is not correctly formatted"),
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
          return;
        }
      }
    } catch (e) {
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
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Import"),
              icon: const Icon(
                Icons.download,
                size: 72,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      "Do you want to import and REMOVE ALL old pit and field scouting data"),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CheckboxListTile(
                      value: importerSaveCompletes,
                      onChanged: (value) {
                        setState(() {
                          importerSaveCompletes = value!;
                        });
                      },
                      title: const Text("Save Completed Data"),
                    ),
                  ),
                ],
              ),
              actionsOverflowButtonSpacing: 20,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      incompletePitScoutingTasks =
                          newIncompletePitScoutingTasks;
                      incompleteFieldScoutingTasks =
                          newIncompleteFieldScoutingTasks;
                      if (!importerSaveCompletes) {
                        completePitScoutingTasks = [];
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes, I'm Sure"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onBackPressed(bool x) {
    print(x);
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the app?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: appMode,
      children: [
        PopScope(
          canPop: false,
          onPopInvoked: _onBackPressed,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Welcome!"),
            ),
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
                        minimumSize: MaterialStateProperty.all(
                            const Size.fromHeight(150)),
                        maximumSize: MaterialStateProperty.all(
                            const Size.fromHeight(200)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        minimumSize: MaterialStateProperty.all(
                            const Size.fromHeight(150)),
                        maximumSize: MaterialStateProperty.all(
                            const Size.fromHeight(200)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Field Scouting",
                              style: TextStyle(fontSize: 24)),
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
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          appMode = 3;
                          setAppModePref(appMode);
                        });
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size.fromHeight(100)),
                        maximumSize: MaterialStateProperty.all(
                            const Size.fromHeight(200)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                icon: Icon(Icons.line_style_rounded),
                label: 'CSV',
              ),
              NavigationDestination(
                icon: Icon(Icons.qr_code_rounded),
                label: 'QR',
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
                onWeightChanged: (value) {
                  pitWeightData = value;
                },
                onRepairabilityChanged: (value) {
                  pitRepairabilityScore = value;
                },
                onManeuverabilityChanged: (value) {
                  pitManeuverabilityScore = value;
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
                onIsKitbotChanged: (value) {
                  setState(() {
                    pitIsKitbot = value;
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
                onAutonSpeakerNotesChanged: (value) {
                  setState(() {
                    pitAutonSpeakerNotes = value;
                  });
                },
                onAutonAmpNotesChanged: (value) {
                  setState(() {
                    pitAutonAmpNotes = value;
                  });
                },
                onAutonConsistencyChanged: (value) {
                  setState(() {
                    pitAutonConsistency = value;
                  });
                },
                onAutonVersatilityChanged: (value) {
                  setState(() {
                    pitAutonVersatility = value;
                  });
                },
                onAutonRoutesChanged: (value) {
                  setState(() {
                    pitAutonRoutes = value;
                  });
                },
                onAutonStratChanged: (value) {
                  pitAutonStrat = value;
                },
                onPlayerPreferAmpChanged: (value) {
                  setState(() {
                    pitPlayerPreferAmp = value;
                  });
                },
                onPlayerPreferSourceChanged: (value) {
                  setState(() {
                    pitPlayerPreferSource = value;
                  });
                },
                onDriverYearsChanged: (value) {
                  pitDriverYears = value;
                },
                onOperatorYearsChanged: (value) {
                  pitOperatorYears = value;
                },
                onCoachYearsChanged: (value) {
                  pitCoachYears = value;
                },
                onPrefStartChanged: (value) {
                  setState(() {
                    pitPrefStart = value;
                  });
                },
                onTeleopStratChnaged: (value) {
                  pitTeleopStrat = value;
                },
                repairability: pitRepairabilityScore,
                maneuverability: pitManeuverabilityScore,
                drivebase: pitDrivebaseType,
                altDrivebase: pitAltDrivebaseType,
                length: pitLengthData,
                width: pitWidthData,
                height: pitHeightData,
                weight: pitWeightData,
                isKitbot: pitIsKitbot,
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
                autonSpeakerNotes: pitAutonSpeakerNotes,
                autonAmpNotes: pitAutonAmpNotes,
                autonConsistency: pitAutonConsistency,
                autonVersatility: pitAutonVersatility,
                autonRoutes: pitAutonRoutes,
                autonStrat: pitAutonStrat,
                playerPreferAmp: pitPlayerPreferAmp,
                playerPreferSource: pitPlayerPreferSource,
                driverYears: pitDriverYears,
                operatorYears: pitOperatorYears,
                coachYears: pitCoachYears,
                prefStart: pitPrefStart,
                teleopStrat: pitTeleopStrat,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.output_rounded,
                    size: 180,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed:
                                  saveDisabled == false ? onPitScoutSave : null,
                              label: const Text("Export to Directory"),
                              icon: const Icon(Icons.save),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                resetPit();
                              },
                              child: const Text("Reset Data"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: QrImageView(
                      data: getPitKVFormattedData(
                              transpose: true, header: false)[0]
                          .join("||"),
                      backgroundColor: Colors.white,
                    ),
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
              ListView(
                children: [
                  Column(
                    children: [
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
                              position: entry.position,
                              onSelected: () {
                                setState(() {
                                  fieldTeamNumber = entry.team;
                                  fieldMatchNumber = entry.match;
                                  fieldAlliance = entry.alliance;
                                  fieldRobotPosition = entry.position;
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
                            const SizedBox(height: 8.0),
                            ChoiceInput(
                              title: "Field Position",
                              onChoiceUpdate: (value) {
                                setState(() {
                                  switch (value) {
                                    case "Red 1":
                                      fieldAlliance = Alliances.red;
                                      fieldRobotPosition = 0;
                                    case "Red 2":
                                      fieldAlliance = Alliances.red;
                                      fieldRobotPosition = 1;
                                    case "Red 3":
                                      fieldAlliance = Alliances.red;
                                      fieldRobotPosition = 2;
                                    case "Blue 1":
                                      fieldAlliance = Alliances.blue;
                                      fieldRobotPosition = 0;
                                    case "Blue 2":
                                      fieldAlliance = Alliances.blue;
                                      fieldRobotPosition = 1;
                                    case "Blue 3":
                                      fieldAlliance = Alliances.blue;
                                      fieldRobotPosition = 2;
                                  }
                                });
                              },
                              choice:
                                  "${fieldAlliance.name.toString().capitalize} ${(fieldRobotPosition + 1).toString()}",
                              options: const [
                                "Red 1",
                                "Red 2",
                                "Red 3",
                                "Blue 1",
                                "Blue 2",
                                "Blue 3"
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              FieldAutonForm(
                teamNumberPresent: fieldTeamNumber == null
                    ? false
                    : true && fieldMatchNumber == null
                        ? false
                        : true,
                allianceColor: fieldAlliance,
                robotPosition: fieldRobotPosition,
                autonExists: fieldAutonExists,
                onAutonExistsChanged: (value) {
                  setState(() {
                    fieldAutonExists = value!;
                  });
                },
                onLeaveChanged: (value) {
                  setState(() {
                    fieldLeave = value;
                  });
                },
                leave: fieldLeave,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed:
                              saveDisabled == false ? onFieldScoutSave : null,
                          label: const Text("Export CSV"),
                          icon: const Icon(Icons.save),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            fieldTeamNumber = null;
                            fieldMatchNumber = null;
                            fieldAutonExists = false;
                            fieldAutonSpeakerNotes = 0;
                            fieldAutonAmpNotes = 0;
                            fieldAutonSpeakerNotesMissed = 0;
                            fieldAutonAmpNotesMissed = 0;
                            setState(() {
                              fieldPageIndex = 0;
                            });
                          },
                          child: const Text("Reset Data"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Team Lists"),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: importTeamList,
                        child: const Text("Import team list"),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Are you sure?"),
                                icon: const Icon(
                                  Icons.error_rounded,
                                  size: 72,
                                ),
                                content: const Text(
                                    "Are you ABSOLUTELY SURE you want to remove ALL saved team lists"),
                                actionsOverflowButtonSpacing: 20,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      resetAllTeams();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("RESET ALL TEAMS"),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Are you sure?"),
                                icon: const Icon(
                                  Icons.error_rounded,
                                  size: 72,
                                ),
                                content: const Text(
                                    "Are you ABSOLUTELY SURE you want to add 3 nonsense teams to each list"),
                                actionsOverflowButtonSpacing: 20,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      loadTestTeams();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("Load debug teams"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text("Export Options"),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Event ID',
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(15),
                    ],
                    onChanged: (value) {
                      eventId = value;
                      attemptSaveEventId();
                    },
                    controller: TextEditingController(text: eventId),
                  ),
                  const SizedBox(height: 4.0),
                  CheckboxListTile(
                      value: transposedExport,
                      title: Text("Transpose Exported Data"),
                      subtitle: Text(
                          "Transpose rows and colums in exported data (recommended)"),
                      onChanged: (value) {
                        setState(() {
                          transposedExport = value!;
                          attemptSaveTranspose();
                        });
                      }),
                  CheckboxListTile(
                      value: exportHeaders,
                      title: Text("Export data headers"),
                      subtitle: Text("Add header to csv data exports"),
                      onChanged: (value) {
                        setState(() {
                          exportHeaders = value!;
                          attemptSaveHeaders();
                        });
                      }),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: Icon(
                              Icons.warning_rounded,
                              size: 180,
                            ),
                            title: const Text("Are you sure?"),
                            content: const Text(
                                "Do you want to reset all information on the app?"),
                            actions: [
                              TextButton(
                                child: const Text('Reset'),
                                onPressed: () {
                                  resetAll();
                                  resetPrefs();
                                  Navigator.of(context).pop();
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
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(100)),
                      maximumSize:
                          MaterialStateProperty.all(const Size.fromHeight(200)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          Text("Resets all stored information")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  List<List> getFieldKVFormattedData({bool transpose = false}) {
    var data = [
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

    if (!transpose) return data;

    List<List> transposedData = List.generate(
        data[0].length, (i) => List.generate(data.length, (j) => data[j][i]));

    return transposedData;
  }

  List<List> getPitKVFormattedData(
      {bool transpose = false, bool header = true}) {
    var data = [
      ["FORMNAME", "pit"],
      ["teamNumber", pitTeamNumber],
      ['botLength', pitLengthData],
      ['botWidth', pitWidthData],
      ['botHeight', pitLengthData],
      ['botWeight', pitWeightData],
      ['drivebase', pitDrivebaseType],
      ['drivebaseAlt', pitAltDrivebaseType],
      ['climber', pitClimberType],
      ['climberAlt', pitAltClimberType],
      ['isKitbot', pitIsKitbot],
      ['intakeInBumper', pitIntakeInBumper],
      ['speakerScore', pitDoesSpeaker],
      ['ampScore', pitDoesAmp],
      ['trapScore', pitDoesTrap],
      ['groundPickup', pitDoesGroundPickup],
      ['sourcePickup', pitDoesSourcePickup],
      ['turretShoot', pitDoesTurretShoot],
      ['extendShoot', pitDoesExtendShoot],
      ['hasAuton', pitAutonExists],
      ['autonSpeakerNotes', pitAutonSpeakerNotes],
      ['autonAmpNotes', pitAutonAmpNotes],
      ['autonConsistency', pitAutonConsistency],
      ['autonVersatility', pitAutonVersatility],
      ['autonRoutes', pitAutonRoutes],
      ['autonPrefStart', pitPrefStart.name],
      ['autonStrat', pitAutonStrat.replaceAll("\n", "*")],
      ['hasAuton', pitAutonExists],
      ['repairability', pitRepairabilityScore],
      ['maneuverability', pitManeuverabilityScore],
      ['teleopStrat', pitTeleopStrat.replaceAll("\n", "*")],
    ];

    if (!header) {
      data = data.map((row) => row.sublist(1)).toList();
    }

    if (!transpose) return data;

    List<List> transposedData = List.generate(
        data[0].length, (i) => List.generate(data.length, (j) => data[j][i]));

    return transposedData;
  }

  void onPitScoutSave() async {
    if (pitTeamNumber == null) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Team Number Required"),
            icon: const Icon(
              Icons.numbers_rounded,
              size: 72,
            ),
            content: const Text("Save operation cancelled"),
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
      return;
    }

    if (eventId == "") {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Event ID Required"),
            icon: const Icon(
              Icons.abc_rounded,
              size: 72,
            ),
            content: const Text("Save operation cancelled"),
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
      return;
    }

    final fileData = const ListToCsvConverter().convert(getPitKVFormattedData(
        transpose: transposedExport, header: exportHeaders));

    setState(() {
      saveDisabled = true;
    });

    final dirPath = await grabDir();

    if (dirPath != null) {
      File(path.join(dirPath,
              "${eventId}_frc${pitTeamNumber}_pit/${eventId}_frc${pitTeamNumber}_pit.csv"))
          .create(recursive: true)
          .onError((e, s) {
        print(e);
        throw Error;
      }).then((File file) {
        file.writeAsBytes(Uint8List.fromList(fileData.codeUnits));
      });
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Completed?"),
          icon: const Icon(
            Icons.question_mark_rounded,
            size: 72,
          ),
          content: const Text("Do you want to mark the task as complete?"),
          actionsOverflowButtonSpacing: 20,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                completePitScoutingTasks
                    .add(PitScoutingTask(team: pitTeamNumber!));
                incompletePitScoutingTasks
                    .removeWhere((task) => task.team == pitTeamNumber);
                setState(() {
                  pitPageIndex = 0;
                });
                updateTeamSaves();
                resetPit();
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
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

    // resetPit();
    updateTeamSaves();
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

  Future<String?> grabDir() async {
    String? outputFile = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Export directory',
    );

    setState(() {
      saveDisabled = false;
    });

    return outputFile;
  }

  Future<void> resetPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }

  void resetAll() {
    resetPit();
    setState(() {
      pitPageIndex = 0;
      fieldPageIndex = 0;
      appMode = 0;
      fieldTeamNumber = null;
      fieldMatchNumber = null;
      fieldAutonExists = false;
      fieldAutonSpeakerNotes = 0;
      fieldAutonAmpNotes = 0;
      fieldAutonSpeakerNotesMissed = 0;
      fieldAutonAmpNotesMissed = 0;
    });
  }

  void resetPit() {
    pitTeamNumber = null;
    pitRepairabilityScore = 0;
    pitManeuverabilityScore = 0;
    pitDrivebaseType = "Swerve";
    pitAltDrivebaseType = null;
    pitWidthData = null;
    pitLengthData = null;
    pitHeightData = null;
    pitWeightData = null;
    pitCanPassStage = false;
    pitIsKitbot = false;
    pitIntakeInBumper = false;
    pitClimberType = "Tube-in-Tube";
    pitAltClimberType = null;
    pitAutonExists = false;
    pitAutonSpeakerNotes = 0;
    pitAutonAmpNotes = 0;
    pitAutonConsistency = 0;
    pitAutonVersatility = 0;
    pitAutonRoutes = 0;
    pitAutonStrat = "";
    pitDoesSpeaker = true;
    pitDoesAmp = true;
    pitDoesTrap = false;
    pitDoesGroundPickup = false;
    pitDoesSourcePickup = false;
    pitDoesTurretShoot = false;
    pitDoesExtendShoot = true;
    pitPlayerPreferAmp = false;
    pitPlayerPreferSource = false;
    pitDriverYears = null;
    pitOperatorYears = null;
    pitCoachYears = null;
    pitPrefStart = StartPositions.middle;
    pitTeleopStrat = "";
    setState(() {
      pitPageIndex = 0;
    });
  }

  void loadTestTeams() {
    var rng = Random();
    for (var i = 0; i < 3; i++) {
      incompletePitScoutingTasks.add(PitScoutingTask(team: rng.nextInt(9999)));
    }

    for (var i = 0; i < 3; i++) {
      incompleteFieldScoutingTasks.add(ScoutingTask(
        team: rng.nextInt(9999),
        match: rng.nextInt(80),
        alliance: Alliances.values[rng.nextInt(2)],
        position: rng.nextInt(2),
      ));
    }

    updateTeamSaves();
  }

  void resetAllTeams() {
    incompleteFieldScoutingTasks = [];
    incompletePitScoutingTasks = [];
    completeFieldScoutingTasks = [];
    completePitScoutingTasks = [];
    updateTeamSaves();
  }

  String convertTasksListToJsonString<T>(List<T> tasks) {
    return json.encode(tasks.map((task) {
      if (task is ScoutingTask) {
        return (task as ScoutingTask).toJson();
      } else if (task is PitScoutingTask) {
        return (task as PitScoutingTask).toJson();
      }
      return null;
    }).toList());
  }

  List<T> convertJsonStringToTasksList<T>(
      String jsonString, T Function(Map<String, dynamic>) fromJson) {
    List jsonList = json.decode(jsonString);
    return jsonList.map((json) => fromJson(json)).toList();
  }

  Future<void> updateTeamSaves() async {
    final prefs = await SharedPreferences.getInstance();

    String jsonIncompleteFieldTasks =
        convertTasksListToJsonString(incompleteFieldScoutingTasks);
    String jsonCompleteFieldTasks =
        convertTasksListToJsonString(completeFieldScoutingTasks);

    String jsonIncompletePitTasks =
        convertTasksListToJsonString(incompletePitScoutingTasks);
    String jsonCompletePitTasks =
        convertTasksListToJsonString(completePitScoutingTasks);

    prefs.setString("jsonIncompleteFieldTasks", jsonIncompleteFieldTasks);
    prefs.setString("jsonCompleteFieldTasks", jsonCompleteFieldTasks);
    prefs.setString("jsonIncompletePitTasks", jsonIncompletePitTasks);
    prefs.setString("jsonCompletePitTasks", jsonCompletePitTasks);
  }

  Future<void> attemptSaveEventId() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("eventId", eventId);
  }

  Future<void> attemptSaveTranspose() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("transposedExport", transposedExport);
  }

  Future<void> attemptSaveHeaders() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("exportHeaders", exportHeaders);
  }
}
