import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datatypes.dart';
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
  int pitPageIndex = 0;
  int appMode = 0;

  String eventId = "unknown";
  bool transposedExport = true;
  bool exportHeaders = true;

  int? pitTeamNumber;
  List<String> pitScouters = ["", ""];

  Map<String, dynamic> pitScoutingDefaultData = {
    "form": "pit",
    "team": null,
    "scouters": ["null", "null"],
    "width": null,
    "length": null,
    "height": null,
    "weight": null,
    "driverYears": null,
    "operatorYears": null,
    "coachYears": null,
    "isCoachAdult": false,
    "drivebase": "Swerve",
    "autonExists": false,
  };

  Map<String, dynamic> pitScoutingData = {
    "form": "pit",
    "team": null,
    "scouters": ["null", "null"],
    "width": null,
    "length": null,
    "height": null,
    "weight": null,
    "driverYears": null,
    "operatorYears": null,
    "coachYears": null,
    "isCoachAdult": false,
    "drivebase": "Swerve",
    "autonExists": false,
  };

  bool saveDisabled = false;

  bool importerSaveCompletes = false;

  List<PitScoutingTask> incompletePitScoutingTasks = [];
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

    teamNameMap = json.decode(prefs.getString("teamNamesMap") ?? "{}");

    eventId = prefs.getString("eventId") ?? "unknown";

    transposedExport = prefs.getBool("transposedExport") ?? true;
    exportHeaders = prefs.getBool("exportHeaders") ?? true;

    setState(() {
      appMode = 0;
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
            jsonData.containsKey("teamnames") &&
            jsonData["pit"] is List) {
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
                      "Do you want to import and REMOVE ALL old scouting data"),
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

  void _onBackPressed() {
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
      onPopInvokedWithResult: (bool didPop, Object? result) {
        _onBackPressed();
      },
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
                          appMode = 2;
                          setAppModePref(appMode);
                        });
                      },
                      icon: const Icon(Icons.settings_outlined)),
                  IconButton(
                      onPressed: () {
                        showAboutDialog(
                          context: context,
                          applicationIcon: Image.asset(
                            "images/mercs.png",
                            scale: 2.5,
                          ),
                          applicationVersion: _packageInfo.version,
                        );
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
                          minimumSize: WidgetStateProperty.all(
                              const Size.fromHeight(150)),
                          maximumSize: WidgetStateProperty.all(
                              const Size.fromHeight(200)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
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
                                  pitScoutingData["team"] = null;
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
                                          pitScoutingData["team"] = entry.team;
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
                                                      pitScoutingData["team"] =
                                                          null;
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
                                          pitScoutingData["team"] = entry.team;
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
                                  pitScoutingData["team"] = int.tryParse(value);
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
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(30),
                                        FilteringTextInputFormatter(
                                          RegExp(r'[a-zA-Z]'),
                                          allow: true,
                                        ),
                                      ],
                                      onChanged: (value) {
                                        pitScouters[0] = value;
                                        pitScoutingData["scouters"][0] = value;
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
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(30),
                                        FilteringTextInputFormatter(
                                          RegExp(r'[a-zA-Z]'),
                                          allow: true,
                                        ),
                                      ],
                                      onChanged: (value) {
                                        pitScouters[1] = value;
                                        pitScoutingData["scouters"][1] = value;
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
                              formData: pitScoutingData,
                              onDataChanged: (data) {
                                pitScoutingData[data.keys.first] =
                                    data.values.first;
                              },
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
                            Material(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'JSON Data',
                                  ),
                                  readOnly: true,
                                  minLines: 2,
                                  maxLines: 10,
                                  controller: TextEditingController(
                                      text: JsonEncoder.withIndent(" " * 4)
                                          .convert(pitScoutingData)),
                                ),
                              ),
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
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: SizedBox.square(
                                  dimension: 500,
                                  child: QrImageView(
                                    data: getPitKVFormattedData(
                                            transpose: true, header: false)[0]
                                        .join("||"),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const Divider(),
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
                    ],
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }

  List<List> getPitKVFormattedData(
      {bool transpose = false, bool header = true}) {
    List<List<dynamic>> data = [];
    pitScoutingData.forEach((key, value) {
      data.add([key, (value is List ? value.join(",") : value)]);
    });

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
  }

  void resetPit() {
    pitTeamNumber = null;
    pitScoutingData = Map.from(pitScoutingDefaultData);
    setState(() {
      pitPageIndex = 0;
    });
  }

  void loadTestTeams() {
    var rng = Random();
    for (var i = 0; i < 3; i++) {
      incompletePitScoutingTasks.add(PitScoutingTask(team: rng.nextInt(9999)));
    }

    updateTeamSaves();
  }

  void resetAllTeams() {
    incompletePitScoutingTasks = [];
    completePitScoutingTasks = [];
    updateTeamSaves();
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
      if (task is PitScoutingTask) {
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

    String jsonIncompletePitTasks =
        convertTasksListToJsonString(incompletePitScoutingTasks);
    String jsonCompletePitTasks =
        convertTasksListToJsonString(completePitScoutingTasks);

    String jsonTeamNames = json.encode(teamNameMap);

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
}
