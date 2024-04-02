import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datatypes.dart';
import 'field_forms.dart';
import 'pit_form.dart';
import 'widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ScoutingApp(),
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
      home: const FormAppPage(),
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

  String eventId = "2024txama";
  bool transposedExport = true;
  bool exportHeaders = true;

  bool playoffMode = false;

  int? fieldTeamNumber;
  int? pitTeamNumber;
  List<String> pitScouters = ["", ""];

  int? fieldMatchNumber;

  Alliances fieldAlliance = Alliances.blue;
  int fieldRobotPosition = 1;

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
  KitBotTypes pitIsKitbot = KitBotTypes.not;
  String pitClimberType = "Tube-in-Tube";
  String? pitAltClimberType;

  bool fieldLeave = false;
  bool fieldCrossLine = false;
  bool fieldAStop = false;

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
  ScoringPreference pitScoringPref = ScoringPreference.speaker;

  bool pitDoesGroundPickup = false;
  bool pitDoesSourcePickup = false;

  bool pitDoesTurretShoot = false;
  bool pitDoesExtendShoot = true;
  bool pitDoesBlock = false;
  bool pitDoesAutoAim = false;

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

  bool fieldPickupFloor = false;
  bool fieldPickupSource = false;

  int fieldTeleopAmpNotesScored = 0;
  int fieldTeleopAmpNotesMissed = 0;

  int fieldTeleopSpeakerNotesScored = 0;
  int fieldTeleopSpeakerNotesMissed = 0;

  int fieldTeleopDroppedNotes = 0;
  int fieldTeleopNotesFed = 0;
  int fieldTeleopAmps = 0;

  List<bool?> fieldWingNotes = [false, false, false];
  List<bool?> fieldCenterNotes = [false, false, false, false, false];
  bool? fieldPreload = true;

  double fieldClimbSpeed = 2;
  StagePositions fieldStagePos = StagePositions.none;
  String fieldTrap = "Did Not Trap";
  String fieldHarmony = "Did Not Harmonize";

  bool fieldDefenseBot = false;

  double fieldDriverRating = 0;
  double fieldDefenseRating = 0;

  bool fieldHighnote = false;
  bool? fieldCoOp = false;

  String fieldCard = "No Card";
  String fieldNoShow = "They Showed Up";

  String fieldComments = "";

  bool saveDisabled = false;

  bool importerSaveCompletes = false;

  List<ScoutingTask> incompleteFieldScoutingTasks = [];

  List<PitScoutingTask> incompletePitScoutingTasks = [];

  List<ScoutingTask> completeFieldScoutingTasks = [];

  List<PitScoutingTask> completePitScoutingTasks = [];

  Map teamNameMap = {};

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    loadPrefs();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    incompletePitScoutingTasks = convertJsonStringToTasksList(
        prefs.getString("jsonIncompletePitTasks"),
        (json) => PitScoutingTask.fromJson(json));

    completePitScoutingTasks = convertJsonStringToTasksList(
        prefs.getString("jsonCompletePitTasks"),
        (json) => PitScoutingTask.fromJson(json));

    incompleteFieldScoutingTasks = convertJsonStringToTasksList(
        prefs.getString("jsonIncompleteFieldTasks"),
        (json) => ScoutingTask.fromJson(json));

    completeFieldScoutingTasks = convertJsonStringToTasksList(
        prefs.getString("jsonCompleteFieldTasks"),
        (json) => ScoutingTask.fromJson(json));

    teamNameMap = json.decode(prefs.getString("teamNamesMap") ?? "{}");

    eventId = prefs.getString("eventId") ?? "unknown";
    playoffMode = prefs.getBool("playoffMode") ?? false;

    transposedExport = prefs.getBool("transposedExport") ?? true;
    exportHeaders = prefs.getBool("exportHeaders") ?? true;

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
            jsonData.containsKey("teamnames") &&
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
          teamNameMap = jsonData["teamnames"].reduce((a, b) {
            a.addAll(b);
            return a;
          });
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
        updateTeamSaves();
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
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
    return PopScope(
      canPop: false,
      onPopInvoked: _onBackPressed,
      child: IndexedStack(
        index: appMode,
        children: [
          if (appMode == 0)
            // Main Menu
            Scaffold(
              appBar: AppBar(
                title: const Text("Welcome!"),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          appMode = 3;
                          setAppModePref(appMode);
                        });
                      },
                      icon: const Icon(Icons.settings_outlined)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          appMode = 4;
                          setAppModePref(appMode);
                        });
                      },
                      icon: const Icon(Icons.info_outline_rounded))
                ],
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
                        child: const Row(
                          children: [
                            Icon(
                              Icons.smart_toy_outlined,
                              size: 72,
                            ),
                            Spacer(),
                            Column(
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
                            Spacer(),
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
                        child: const Row(
                          children: [
                            Icon(
                              Icons.sports_rounded,
                              size: 72,
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Match Scouting",
                                  style: TextStyle(fontSize: 24),
                                ),
                                Text("Enter match scouting mode.")
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Image(
                      image: AssetImage('images/mercs.png'),
                      fit: BoxFit.scaleDown,
                      width: 380,
                      isAntiAlias: true,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          else
            const SizedBox(),
          if (appMode == 1)
            // Pit Scouting
            Scaffold(
              appBar: AppBar(
                title: const Text('Pit Data Collection'),
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        appMode = 0;
                        pitPageIndex = 0;
                        setAppModePref(appMode);
                      });
                    },
                    icon: const Icon(Icons.arrow_back)),
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
                  if (pitPageIndex == 0)
                    Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              ExpansionTile(
                                title: const Text("To Be Scouted"),
                                initiallyExpanded: true,
                                children: [
                                  for (final entry
                                      in incompletePitScoutingTasks)
                                    PitScoutSelection(
                                      team: entry.team,
                                      onSelected: () {
                                        setState(() {
                                          pitTeamNumber = entry.team;
                                        });
                                      },
                                      teamNames: teamNameMap,
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
                                                  child: const Text(
                                                      "Yes, I'm Sure"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        setState(() {
                                          pitTeamNumber = entry.team;
                                        });
                                      },
                                      teamNames: teamNameMap,
                                      completed: true,
                                    )
                                ],
                              ),
                            ],
                          ),
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
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Scouter A',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(30),
                                        FilteringTextInputFormatter(
                                          RegExp(r'[a-zA-Z]'),
                                          allow: true,
                                        ),
                                      ],
                                      onChanged: (value) {
                                        pitScouters[0] = value;
                                      },
                                      controller: TextEditingController(
                                        text: pitScouters[0],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Flexible(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Scouter B',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(30),
                                        FilteringTextInputFormatter(
                                          RegExp(r'[a-zA-Z]'),
                                          allow: true,
                                        ),
                                      ],
                                      onChanged: (value) {
                                        pitScouters[1] = value;
                                      },
                                      controller: TextEditingController(
                                        text: pitScouters[1],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  if (pitPageIndex == 1)
                    ListView(
                      children: [
                        Column(
                          children: [
                            PitForm(
                              teamNumberPresent:
                                  (pitTeamNumber == null ? false : true) &&
                                      !pitScouters.contains(""),
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
                                pitAltDrivebaseType = value;
                              },
                              onKitbotChanged: (value) {
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
                                pitAltClimberType = value;
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
                              onScoringPrefChanged: (value) {
                                setState(() {
                                  pitScoringPref = value;
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
                              onDoesBlockChanged: (value) {
                                setState(() {
                                  pitDoesBlock = value;
                                });
                              },
                              onAutoAimChanged: (value) {
                                setState(() {
                                  pitDoesAutoAim = value;
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
                              kitbot: pitIsKitbot,
                              intakeInBumper: pitIntakeInBumper,
                              climberType: pitClimberType,
                              altClimberType: pitAltClimberType,
                              doesSpeaker: pitDoesSpeaker,
                              doesAmp: pitDoesAmp,
                              doesTrap: pitDoesTrap,
                              scoringPreference: pitScoringPref,
                              doesSourcePickup: pitDoesSourcePickup,
                              doesGroundPickup: pitDoesGroundPickup,
                              doesExtendShoot: pitDoesExtendShoot,
                              doesTurretShoot: pitDoesTurretShoot,
                              doesBlock: pitDoesBlock,
                              doesAutoAim: pitDoesAutoAim,
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
                            if (!(pitTeamNumber == null ||
                                pitScouters.contains("")))
                              Column(
                                children: getPitWarningCards(),
                              ),
                            if (!(pitTeamNumber == null ||
                                pitScouters.contains("")))
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {});
                                },
                                label: const Text("Check Data"),
                                icon: const Icon(Icons.playlist_add_check),
                              ),
                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  if (pitPageIndex == 2)
                    IndexedStack(
                      index: (pitTeamNumber == null || pitScouters.contains(""))
                          ? 0
                          : 1,
                      children: [
                        const Center(child: TeamNumberError()),
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
                                        onPressed: saveDisabled == false
                                            ? onPitScoutSave
                                            : null,
                                        label:
                                            const Text("Export to Directory"),
                                        icon: const Icon(Icons.save),
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          completePitScoutingTasks.add(
                                              PitScoutingTask(
                                                  team: pitTeamNumber!));
                                          incompletePitScoutingTasks
                                              .removeWhere((task) =>
                                                  task.team == pitTeamNumber);
                                          setState(() {
                                            pitPageIndex = 0;
                                          });
                                          updateTeamSaves();
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
                      ],
                    )
                  else
                    const SizedBox(),
                  if (pitPageIndex == 3)
                    IndexedStack(
                      index: (pitTeamNumber == null || pitScouters.contains(""))
                          ? 0
                          : 1,
                      children: [
                        if (pitTeamNumber == null || pitScouters.contains(""))
                          const Center(child: TeamNumberError())
                        else
                          const SizedBox(),
                        if (pitTeamNumber != null)
                          Column(
                            children: [
                              Column(
                                children: getPitWarningCards(),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: QrImageView(
                                  data: getPitKVFormattedData(
                                          transpose: true, header: false)[0]
                                      .join("||"),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              const Divider(),
                              const SizedBox(height: 8.0),
                              ElevatedButton(
                                  onPressed: () {
                                    completePitScoutingTasks.add(
                                        PitScoutingTask(team: pitTeamNumber!));
                                    incompletePitScoutingTasks.removeWhere(
                                        (task) => task.team == pitTeamNumber);
                                    setState(() {
                                      pitPageIndex = 0;
                                    });
                                    updateTeamSaves();
                                    resetPit();
                                  },
                                  child: const Text("Reset Data")),
                              const SizedBox(height: 8.0),
                            ],
                          )
                        else
                          const SizedBox(),
                      ],
                    )
                  else
                    const SizedBox(),
                ],
              ),
            )
          else
            const SizedBox(),
          if (appMode == 2)
            // Field Scouting
            Scaffold(
              appBar: AppBar(
                title: const Text('Match Data Collection'),
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      appMode = 0;
                      fieldPageIndex = 0;
                      setAppModePref(appMode);
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              body: IndexedStack(
                index: fieldPageIndex,
                children: [
                  if (fieldPageIndex == 0)
                    ListView(
                      children: [
                        Column(
                          children: [
                            if (!playoffMode)
                              Column(
                                children: [
                                  ExpansionTile(
                                    title: const Text("To Be Scouted"),
                                    initiallyExpanded: true,
                                    children: [
                                      for (final entry
                                          in incompleteFieldScoutingTasks)
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
                                              fieldRobotPosition =
                                                  entry.position;
                                            });
                                          },
                                          teamNames: teamNameMap,
                                        )
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: const Text("Scouted"),
                                    initiallyExpanded: false,
                                    children: [
                                      for (final entry
                                          in completeFieldScoutingTasks)
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
                                              fieldRobotPosition =
                                                  entry.position;
                                            });
                                          },
                                          teamNames: teamNameMap,
                                        )
                                    ],
                                  ),
                                ],
                              )
                            else
                              const Column(
                                children: [
                                  Icon(
                                    Icons.info_rounded,
                                    size: 180,
                                  ),
                                  Text(
                                    "Team Assignments are not available in playoff mode",
                                    style: TextStyle(fontSize: 18),
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
                    )
                  else
                    const SizedBox(),
                  if (fieldPageIndex == 1)
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
                      crossLine: fieldCrossLine,
                      onCrossLineChanged: (value) {
                        setState(() {
                          fieldCrossLine = value;
                        });
                      },
                      aStop: fieldAStop,
                      onAStopChanged: (value) {
                        setState(() {
                          fieldAStop = value;
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
                      wingNotes: fieldWingNotes,
                      onWingNotesChanged: (index, value) {
                        setState(() {
                          fieldWingNotes[index] = value;
                        });
                      },
                      centerNotes: fieldCenterNotes,
                      onCenterNotesChanged: (index, value) {
                        setState(() {
                          fieldCenterNotes[index] = value;
                        });
                      },
                      preload: fieldPreload,
                      onPreloadChanged: (value) {
                        setState(() {
                          fieldPreload = value;
                        });
                      },
                    )
                  else
                    const SizedBox(),
                  if (fieldPageIndex == 2)
                    FieldTeleopForm(
                      teamNumberPresent: fieldTeamNumber == null
                          ? false
                          : true && fieldMatchNumber == null
                              ? false
                              : true,
                      allianceColor: fieldAlliance,
                      robotPosition: fieldRobotPosition,
                      pickupFloor: fieldPickupFloor,
                      onPickupFloorChanged: (value) {
                        setState(() {
                          fieldPickupFloor = value;
                        });
                      },
                      pickupSource: fieldPickupSource,
                      onPickupSourceChanged: (value) {
                        setState(() {
                          fieldPickupSource = value;
                        });
                      },
                      ampNotesScored: fieldTeleopAmpNotesScored,
                      onAmpNotesScoredChanged: (value) {
                        setState(() {
                          fieldTeleopAmpNotesScored = value;
                        });
                      },
                      ampNotesMissed: fieldTeleopAmpNotesMissed,
                      onAmpNotesMissedChanged: (value) {
                        setState(() {
                          fieldTeleopAmpNotesMissed = value;
                        });
                      },
                      speakerNotesScored: fieldTeleopSpeakerNotesScored,
                      onSpeakerNotesScoredChanged: (value) {
                        setState(() {
                          fieldTeleopSpeakerNotesScored = value;
                        });
                      },
                      speakerNotesMissed: fieldTeleopSpeakerNotesMissed,
                      onSpeakerNotesMissedChanged: (value) {
                        setState(() {
                          fieldTeleopSpeakerNotesMissed = value;
                        });
                      },
                      droppedNotes: fieldTeleopDroppedNotes,
                      onDroppedNotesChanged: (value) {
                        setState(() {
                          fieldTeleopDroppedNotes = value;
                        });
                      },
                      notesFed: fieldTeleopNotesFed,
                      onNotesFedChanged: (value) {
                        setState(() {
                          fieldTeleopNotesFed = value;
                        });
                      },
                      amps: fieldTeleopAmps,
                      onAmpsChanged: (value) {
                        setState(() {
                          fieldTeleopAmps = value;
                        });
                      },
                    )
                  else
                    const SizedBox(),
                  if (fieldPageIndex == 3)
                    PostMatchForm(
                      teamNumberPresent: fieldTeamNumber == null
                          ? false
                          : true && fieldMatchNumber == null
                              ? false
                              : true,
                      allianceColor: fieldAlliance,
                      robotPosition: fieldRobotPosition,
                      climbSpeed: fieldClimbSpeed,
                      onClimbSpeedUpdate: (value) {
                        setState(() {
                          fieldClimbSpeed = value;
                        });
                      },
                      stagePos: fieldStagePos,
                      onStagePosUpdate: (value) {
                        setState(() {
                          fieldStagePos = value;
                        });
                      },
                      trap: fieldTrap,
                      onTrapUpdate: (value) {
                        setState(() {
                          fieldTrap = value;
                        });
                      },
                      harmony: fieldHarmony,
                      onHarmonyChanged: (value) {
                        setState(() {
                          fieldHarmony = value;
                        });
                      },
                      defenseBot: fieldDefenseBot,
                      onDefenseBotChanged: (value) {
                        setState(() {
                          fieldDefenseBot = value;
                        });
                      },
                      driverRating: fieldDriverRating,
                      onDriverRatingChanged: (value) {
                        setState(() {
                          fieldDriverRating = value;
                        });
                      },
                      defenseRating: fieldDefenseRating,
                      onDefenseRatingChanged: (value) {
                        setState(() {
                          fieldDefenseRating = value;
                        });
                      },
                      highnote: fieldHighnote,
                      onHighnoteChanged: (value) {
                        setState(() {
                          fieldHighnote = value;
                        });
                      },
                      coOp: fieldCoOp,
                      onCoOpChanged: (value) {
                        setState(() {
                          fieldCoOp = value;
                        });
                      },
                      card: fieldCard,
                      onCardChanged: (value) {
                        setState(() {
                          fieldCard = value;
                        });
                      },
                      noShow: fieldNoShow,
                      onNoShowChanged: (value) {
                        setState(() {
                          fieldNoShow = value;
                        });
                      },
                      comments: fieldComments,
                      onCommentsChanged: (value) {
                        fieldComments = value;
                      },
                    )
                  else
                    const SizedBox(),
                  if (fieldPageIndex == 4)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.output_rounded,
                          size: 180,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: saveDisabled == false
                                    ? onFieldScoutSave
                                    : null,
                                label: const Text("Export to Directory"),
                                icon: const Icon(Icons.save),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  completeFieldScoutingTasks.add(ScoutingTask(
                                      team: fieldTeamNumber!,
                                      match: fieldMatchNumber!,
                                      alliance: fieldAlliance,
                                      position: fieldRobotPosition));
                                  incompleteFieldScoutingTasks.removeWhere(
                                      (task) => (task.team == fieldTeamNumber &&
                                          task.match == fieldMatchNumber! &&
                                          task.alliance == fieldAlliance &&
                                          task.position == fieldRobotPosition));
                                  resetField();
                                },
                                child: const Text("Reset Data"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  if (fieldPageIndex == 5)
                    Column(
                      children: [
                        const Spacer(),
                        Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: QrImageView(
                              data: getFieldKVFormattedData(
                                      transpose: true, header: false)[0]
                                  .join("||"),
                              backgroundColor: Colors.white,
                            )),
                        const Spacer(),
                        const Divider(),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                            onPressed: () {
                              completeFieldScoutingTasks.add(ScoutingTask(
                                  team: fieldTeamNumber!,
                                  match: fieldMatchNumber!,
                                  alliance: fieldAlliance,
                                  position: fieldRobotPosition));
                              incompleteFieldScoutingTasks.removeWhere((task) =>
                                  (task.team == fieldTeamNumber &&
                                      task.match == fieldMatchNumber! &&
                                      task.alliance == fieldAlliance &&
                                      task.position == fieldRobotPosition));
                              resetField();
                            },
                            child: const Text("Reset Data")),
                        const SizedBox(height: 8.0),
                      ],
                    )
                  else
                    const SizedBox(),
                ],
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: fieldPageIndex,
                onDestinationSelected: (index) {
                  if (index != fieldPageIndex) {
                    setState(() {
                      fieldPageIndex = index;
                    });
                    if ((!playoffMode) &&
                        (fieldTeamNumber != null) &&
                        (fieldMatchNumber != null) &&
                        ((index == 1) || (index == 2) || (index == 3)) &&
                        !(incompleteFieldScoutingTasks.any((entry) =>
                            entry.team == fieldTeamNumber &&
                            entry.match == fieldMatchNumber &&
                            entry.alliance == fieldAlliance &&
                            entry.position == fieldRobotPosition))) {
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
                                "You are selecting a team, match number, or starting position that you are not assigned to scout. Are you sure you want to continue?"),
                            actionsOverflowButtonSpacing: 20,
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    fieldPageIndex = 0;
                                    fieldTeamNumber = null;
                                    fieldMatchNumber = null;
                                    fieldAlliance = Alliances.red;
                                    fieldRobotPosition = 0;
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
                  }
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
                    label: "End",
                    icon: Icon(Icons.sports_score),
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
              ),
            )
          else
            const SizedBox(),
          if (appMode == 3)
            // Settings
            Scaffold(
              appBar: AppBar(
                  title: const Text('Application Setup'),
                  leading: IconButton(
                    onPressed: () {
                      setState(() {
                        appMode = 0;
                        setAppModePref(appMode);
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  )),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Team Lists"),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 15.0),
                                child: const Divider()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      ElevatedButton.icon(
                          onPressed: importTeamList,
                          label: const Text("Import team list"),
                          icon: const Icon(Icons.upload)),
                      const SizedBox(height: 8.0),
                      ElevatedButton.icon(
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
                          label: const Text("RESET ALL TEAMS"),
                          icon: const Icon(Icons.delete_forever)),
                      const SizedBox(height: 8.0),
                      ElevatedButton.icon(
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
                        label: const Text("Load debug teams"),
                        icon: const Icon(Icons.bug_report),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Text("Export Options"),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 15.0),
                                child: const Divider()),
                          ),
                        ],
                      ),
                      SwitchListTile(
                          value: transposedExport,
                          title: const Text("Transpose Exported Data"),
                          subtitle: const Text(
                              "Transpose rows and colums in exported data (recommended)"),
                          onChanged: (value) {
                            setState(() {
                              transposedExport = value;
                              attemptSaveTranspose();
                            });
                          }),
                      SwitchListTile(
                          value: exportHeaders,
                          title: const Text("Export data headers"),
                          subtitle:
                              const Text("Add header to csv data exports"),
                          onChanged: (value) {
                            setState(() {
                              exportHeaders = value;
                              attemptSaveHeaders();
                            });
                          }),
                      Row(
                        children: [
                          const Text("Game Options"),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 15.0),
                                child: const Divider()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
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
                      const SizedBox(height: 8.0),
                      SwitchListTile(
                          value: playoffMode,
                          title: const Text("Playoff Mode"),
                          subtitle: const Text(
                              "Switch from qualification to playoff match mode"),
                          onChanged: (value) {
                            setState(() {
                              playoffMode = value;
                              attemptSavePlayoff();
                            });
                          }),
                    ],
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
          if (appMode == 4)
            Scaffold(
              appBar: AppBar(
                title: const Text("About"),
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        appMode = 0;
                        setAppModePref(appMode);
                      });
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              body: ListView(
                children: [
                  const Image(
                    image: AssetImage('images/mercs.png'),
                    width: 380,
                    height: 380,
                    isAntiAlias: true,
                  ),
                  const Text(
                    "Mercs Scouting App",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    "Version: ${_packageInfo.version}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }

  List<List> getFieldKVFormattedData(
      {bool transpose = false, bool header = true}) {
    var data = [
      ["form", playoffMode ? "playoff" : "qual"],
      ["event", eventId],
      ["teamNumber", "frc$fieldTeamNumber"],
      ["matchNumber", fieldMatchNumber],
      ["startingPosition", "${fieldAlliance.name}$fieldRobotPosition"],
      ["hasAuton", fieldAutonExists],
      ["autonLeave", fieldLeave],
      ["autonCrossCenter", fieldCrossLine],
      ["autonAStop", fieldAStop],
      [
        "autonPreload",
        fieldPreload == true
            ? "yes"
            : fieldPreload == false
                ? "no"
                : "missed"
      ],
      ["autonSpeakerNotesScored", fieldAutonSpeakerNotes],
      ["autonSpeakerNotesMissed", fieldAutonSpeakerNotesMissed],
      ["autonAmpNotesScored", fieldAutonAmpNotes],
      ["autonAmpNotesMissed", fieldAutonAmpNotesMissed],
      [
        "autonWingNotes",
        fieldWingNotes.map((element) {
          if (element == true) {
            return "yes";
          } else if (element == false) {
            return "no";
          } else {
            return "missed";
          }
        }).join(",")
      ],
      [
        "autonCenterNotes",
        fieldCenterNotes.map((element) {
          if (element == true) {
            return "yes";
          } else if (element == false) {
            return "no";
          } else {
            return "missed";
          }
        }).join(",")
      ],
      ["teleopFloorPickup", fieldPickupFloor],
      ["teleopSourcePickup", fieldPickupSource],
      ["teleopAmpScored", fieldTeleopAmpNotesScored],
      ["teleopAmpMissed", fieldTeleopAmpNotesMissed],
      ["teleopSpeakerScored", fieldTeleopSpeakerNotesScored],
      ["teleopSpeakerMissed", fieldTeleopSpeakerNotesMissed],
      ["teleopDroppedNotes", fieldTeleopDroppedNotes],
      ["teleopFedNotes", fieldTeleopNotesFed],
      ["teleopAmps", fieldTeleopAmps],
      ["endgameClimbSpeed", fieldClimbSpeed],
      ["endgameClimbPos", climbPos[fieldStagePos]],
      ["endgameDidTheyTrap", trapMap[fieldTrap]],
      ["endgameDidTheyHarmony", harmMap[fieldHarmony]],
      ["endgameDefenseBot", fieldDefenseBot],
      ["endgameDriverRating", fieldDriverRating],
      ["endgameDefenseRating", fieldDefenseRating],
      ["endgameHighnote", fieldHighnote],
      [
        "endgameCoOp",
        fieldCoOp == true
            ? "yes"
            : fieldCoOp == false
                ? "no"
                : "failed"
      ],
      ["endgameDidTheyGetACard", cardMap[fieldCard]],
      ["endgameDidTheyNoShow", showMap[fieldNoShow]],
      ["endgameComments", fieldComments]
    ];

    if (!header) {
      data = data.map((row) => row.sublist(1)).toList();
    }

    if (!transpose) return data;

    List<List> transposedData = List.generate(
        data[0].length, (i) => List.generate(data.length, (j) => data[j][i]));

    return transposedData;
  }

  bool validatePitData() {
    for (final value in [
      pitLengthData,
      pitWidthData,
      pitLengthData,
      pitWeightData
    ]) {
      if (value == null) {
        return false;
      }
    }
    return true;
  }

  List<List> getPitKVFormattedData(
      {bool transpose = false, bool header = true}) {
    var data = [
      ["form", "pit"],
      ["event", eventId],
      ["teamNumber", "frc$pitTeamNumber"],
      ["scouters", pitScouters.join(",")],
      ['botLength', pitLengthData],
      ['botWidth', pitWidthData],
      ['botHeight', pitLengthData],
      ['botWeight', pitWeightData],
      ['drivebase', pitDrivebaseType],
      ['drivebaseAlt', pitAltDrivebaseType],
      ['climber', CLIMBER_MAP[pitClimberType]],
      ['climberAlt', pitAltClimberType],
      ['isKitbot', pitIsKitbot.name],
      ['intakeInBumper', pitIntakeInBumper],
      ['speakerScore', pitDoesSpeaker],
      ['ampScore', pitDoesAmp],
      [
        'scorePref',
        (pitDoesAmp && pitDoesSpeaker) ? pitScoringPref.name : "none"
      ],
      ['trapScore', pitDoesTrap],
      ['groundPickup', pitDoesGroundPickup],
      ['sourcePickup', pitDoesSourcePickup],
      ['turretShoot', pitDoesTurretShoot],
      ['extendShoot', pitDoesExtendShoot],
      ['hasBlocker', pitDoesBlock],
      ['hasAutoAim', pitDoesAutoAim],
      ['hasAuton', pitAutonExists],
      ['autonSpeakerNotes', pitAutonSpeakerNotes],
      ['autonAmpNotes', pitAutonAmpNotes],
      ['autonConsistency', pitAutonConsistency],
      ['autonVersatility', pitAutonVersatility],
      ['autonRoutes', pitAutonRoutes],
      ['autonPrefStart', pitPrefStart.name],
      ['autonStrat', pitAutonStrat.replaceAll("\n", "*")],
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
    if (fieldTeamNumber == null || fieldMatchNumber == null) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Team and Match Number Required"),
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

    final fileData = const ListToCsvConverter().convert(getFieldKVFormattedData(
        transpose: transposedExport, header: exportHeaders));

    setState(() {
      saveDisabled = true;
    });

    final dirPath = await grabDir();

    if (dirPath != null) {
      File(path.join(dirPath,
              "${eventId}_frc_${fieldTeamNumber}_${playoffMode ? "playoff" : "qual"}/${eventId}_frc${fieldTeamNumber}_${playoffMode ? "playoff" : "qual"}.csv"))
          .create(recursive: true)
          .onError((e, s) {
        throw Error;
      }).then((File file) {
        file.writeAsBytes(Uint8List.fromList(fileData.codeUnits));
      });
    }

    if (!mounted) return;
    if (!playoffMode) {
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
                  completeFieldScoutingTasks.add(ScoutingTask(
                      team: fieldTeamNumber!,
                      match: fieldMatchNumber!,
                      alliance: fieldAlliance,
                      position: fieldRobotPosition));
                  incompleteFieldScoutingTasks.removeWhere((task) =>
                      (task.team == fieldTeamNumber &&
                          task.match == fieldMatchNumber! &&
                          task.alliance == fieldAlliance &&
                          task.position == fieldRobotPosition));
                  setState(() {
                    pitPageIndex = 0;
                  });
                  updateTeamSaves();
                  resetField();
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        pitPageIndex = 0;
      });
      updateTeamSaves();
      resetField();
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
    appMode = 0;
    resetPit();
    resetField();
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
    pitIsKitbot = KitBotTypes.not;
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
    pitDoesBlock = false;
    pitDoesAutoAim = false;
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

  void resetField() {
    fieldTeamNumber = null;
    fieldMatchNumber = null;
    fieldAlliance = Alliances.red;
    fieldRobotPosition = 0;
    fieldAutonExists = false;
    fieldLeave = false;
    fieldCrossLine = false;
    fieldAStop = false;
    fieldAutonSpeakerNotes = 0;
    fieldAutonAmpNotes = 0;
    fieldAutonSpeakerNotesMissed = 0;
    fieldAutonAmpNotesMissed = 0;
    fieldLeave = false;
    fieldCenterNotes = [false, false, false, false, false];
    fieldWingNotes = [false, false, false];
    fieldPreload = true;
    fieldTeleopAmpNotesScored = 0;
    fieldTeleopAmpNotesMissed = 0;
    fieldTeleopSpeakerNotesScored = 0;
    fieldTeleopAmpNotesMissed = 0;
    fieldPickupFloor = false;
    fieldPickupSource = false;
    fieldTeleopDroppedNotes = 0;
    fieldTeleopNotesFed = 0;
    fieldTeleopAmps = 0;
    fieldClimbSpeed = 1;
    fieldStagePos = StagePositions.none;
    fieldTrap = "Did Not Trap";
    fieldHarmony = "Did Not Harmonize";
    fieldDefenseBot = false;
    fieldDriverRating = 0;
    fieldDefenseRating = 0;
    fieldHighnote = false;
    fieldCoOp = false;
    fieldCard = "No Card";
    fieldNoShow = "They Showed Up";
    fieldComments = "";
    setState(() {
      fieldPageIndex = 0;
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
        position: rng.nextInt(3),
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

  List<Card> getPitWarningCards() {
    final pitFields = [
      pitWidthData,
      pitLengthData,
      pitHeightData,
      pitWeightData,
      pitDriverYears,
      pitOperatorYears,
      pitCoachYears,
      pitAutonExists ? pitAutonStrat : false,
      pitTeleopStrat,
    ];

    final pitQuestionables = {
      "pitWeightData":
          (pitWeightData != null ? (pitWeightData! > 150) : false) ||
              (pitWeightData != null ? (pitWeightData! < 45) : false),
      "pitDoesBlock": pitDoesBlock
    };

    List<String> warnings = [];

    if (pitFields.contains(null) || pitFields.contains("")) {
      warnings.add("m");
    }

    if (pitQuestionables.values.contains(true)) {
      warnings.add("q");
    }

    List<Card> cards = [];

    for (final warning in warnings) {
      var card = Card(
        color: Colors.yellow,
        child: Column(
          children: [
            ListTile(
              leading: warning == "q"
                  ? const Icon(
                      Icons.question_mark_rounded,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.warning_rounded,
                      color: Colors.black,
                    ),
              title: warning == "q"
                  ? const Text(
                      "Questionable Data Detected!",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      "Missing Data Detected",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
              subtitle: warning == "q"
                  ? const Text(
                      "Some data is out of a reasonable limit.",
                      style: TextStyle(color: Colors.black),
                    )
                  : const Text(
                      "Check for any missing or blank fields",
                      style: TextStyle(color: Colors.black),
                    ),
            ),
            if (warning == "q")
              Text(
                "Offending items: ${getKeysWithTrueValues(pitQuestionables).join(", ")}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
          ],
        ),
      );
      cards.add(card);
    }

    return cards;
  }

  List<String> getKeysWithTrueValues(Map<String, bool> map) {
    var trueKeys = <String>[];

    map.forEach((key, value) {
      if (value == true) {
        trueKeys.add(key);
      }
    });

    return trueKeys;
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
      String? jsonString, T Function(Map<String, dynamic>) fromJson) {
    if (jsonString != null) {
      List jsonList = json.decode(jsonString);
      return jsonList.map((json) => fromJson(json)).toList();
    } else {
      return [];
    }
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

    String jsonTeamNames = json.encode(teamNameMap);

    await prefs.setString("jsonIncompleteFieldTasks", jsonIncompleteFieldTasks);
    await prefs.setString("jsonCompleteFieldTasks", jsonCompleteFieldTasks);
    await prefs.setString("jsonIncompletePitTasks", jsonIncompletePitTasks);
    await prefs.setString("jsonCompletePitTasks", jsonCompletePitTasks);
    await prefs.setString("teamNamesMap", jsonTeamNames);
  }

  Future<void> attemptSaveEventId() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("eventId", eventId);
  }

  Future<void> attemptSaveTranspose() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("transposedExport", transposedExport);
  }

  Future<void> attemptSaveHeaders() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("exportHeaders", exportHeaders);
  }

  Future<void> attemptSavePlayoff() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("playoffMode", playoffMode);
  }
}
