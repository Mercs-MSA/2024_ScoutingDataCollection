import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:mercs_scout/settingspage.dart';
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
  int matchPageIndex = 0;
  int appMode = 0;

  String eventId = "unknown";
  bool transposedExport = true;
  bool exportHeaders = true;

  int? pitTeamNumber;
  List<String> pitScouters = ["", ""];

  int? matchTeamNumber;
  String matchScouter = "";

  Map<String, dynamic> pitScoutingDefaultData = {
    "form": "pit",
    "team": null,
    "scouters": ["null", "null"],
    "width": null,
    "length": null,
    "height": null,
    "weight": null,
    "lOne": false,
    "lTwo": false,
    "lThree": false,
    "lFour": false,
    "processor": false,
    "barge": false,
    "descore": false,
    "deepClimb": false,
    "shallowClimb": false,
    "driverYears": null,
    "operatorYears": null,
    "coachYears": null,
    "isCoachAdult": false,
    "drivebase": "Swerve",
    "autonExists": false,
    "notes": null,
    "justExit": false,
    "autonStrategy": null,
    "canAutoLeft": false,
    "canAutoMid": false,
    "canAutoRight": false 
  };

  Map<String, dynamic> pitScoutingData = {
    "form": "pit",
    "team": null,
    "scouters": ["null", "null"],
    "width": null,
    "length": null,
    "height": null,
    "weight": null,
    "lOne": false,
    "lTwo": false,
    "lThree": false,
    "lFour": false,
    "processor": false,
    "barge": false,
    "descore": false,
    "deepClimb": false,
    "shallowClimb": false,
    "driverYears": null,
    "operatorYears": null,
    "coachYears": null,
    "isCoachAdult": false,
    "drivebase": "Swerve",
    "autonExists": false,
    "notes": null,
    "justExit": false,
    "autonStrategy": null,
    "canAutoLeft": false,
    "canAutoMid": false,
    "canAutoRight": false 
  };

  Map<String, dynamic> matchScoutingDefaultData = {};

  Map<String, dynamic> matchScoutingData = {};

  bool saveDisabled = false;

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
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SettingsPage(
                                initialTransposedExport: transposedExport,
                                initialExportHeaders: exportHeaders,
                                initialEventId: eventId,
                                onTransposeChanged: (value) {
                                  setState(() {
                                    transposedExport = value;
                                    attemptSaveTranspose();
                                  });
                                },
                                onExportHeadersChanged: (value) {
                                  setState(() {
                                    exportHeaders = value;
                                    attemptSaveHeaders();
                                  });
                                },
                                onEventIdChanged: (value) {
                                  setState(() {
                                    eventId = value;
                                    attemptSaveEventId();
                                  });
                                },
                              );
                            });
                      },
                      icon: const Icon(Icons.settings_outlined)),
                  IconButton(
                      onPressed: () {
                        showAboutDialog(
                          context: context,
                          applicationIcon: Image.asset(
                            "images/mercs.png",
                            scale: 4,
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
                              Icons.flag_rounded,
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
                    const SizedBox(height: 8.0),
                    const Spacer(),
                    const Image(
                      image: AssetImage('images/mercs.png'),
                      fit: BoxFit.scaleDown,
                      width: 300,
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
                    icon: const Icon(Icons.home)),
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
                    icon: Icon(Icons.save),
                    label: 'Export',
                  )
                ],
                selectedIndex: pitPageIndex,
                onDestinationSelected: (int index) {
                  if (index == 2 &&
                      !(pitTeamNumber == null || pitScouters.contains("")) &&
                      pitPageIndex != 2) {
                    var count = 0;
                    Timer.periodic(Duration(milliseconds: 120), (timer) {
                      if (count > 4) {
                        timer.cancel();
                      }

                      Confetti.launch(
                        context,
                        options: const ConfettiOptions(
                          particleCount: 20,
                          spread: 85,
                          y: 1,
                          flat: true,
                          decay: 0.82,
                          colors: [Colors.red, Colors.black, Colors.white],
                        ),
                      );
                      count++;
                    });
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                data.forEach((k, v) {
                                  pitScoutingData[k] = v;
                                });
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
                        if (pitTeamNumber == null || pitScouters.contains(""))
                          const Center(child: TeamNumberError())
                        else
                          const SizedBox(),
                        if (pitTeamNumber != null)
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        return QrImageView(
                                          data: getPitKVFormattedData(
                                                  transpose: true,
                                                  header: false)[0]
                                              .join("||"),
                                          backgroundColor: Colors.white,
                                          size: min(constraints.maxHeight,
                                              constraints.maxWidth),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Expanded(child: Divider()),
                                    Padding(
                                        padding: EdgeInsets.only(right: 8.0)),
                                    Text("or"),
                                    Padding(
                                        padding: EdgeInsets.only(left: 8.0)),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: saveDisabled == false
                                          ? onPitScoutSave
                                          : null,
                                      label:
                                          const Text("Export CSV to Directory"),
                                      icon: const Icon(Icons.save),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            barrierDismissible: true,
                                            builder: (context) {
                                              return Scaffold(
                                                appBar: AppBar(
                                                  title:
                                                      Text("Debug Information"),
                                                ),
                                                body: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextField(
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          fillColor:
                                                              Color(0xff0d0d0d),
                                                          filled: true,
                                                          labelText:
                                                              'JSON Data',
                                                        ),
                                                        readOnly: true,
                                                        minLines: 2,
                                                        maxLines: 20,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xffffffff),
                                                          fontFamily:
                                                              "RobotoMono",
                                                        ),
                                                        controller: TextEditingController(
                                                            text: JsonEncoder
                                                                    .withIndent(
                                                                        " " * 4)
                                                                .convert(
                                                                    pitScoutingData)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextField(
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          fillColor:
                                                              Color(0xff0d0d0d),
                                                          filled: true,
                                                          labelText:
                                                              'KV/QR Data',
                                                        ),
                                                        readOnly: true,
                                                        minLines: 2,
                                                        maxLines: 5,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xffffffff),
                                                          fontFamily:
                                                              "RobotoMono",
                                                        ),
                                                        controller:
                                                            TextEditingController(
                                                          text: getPitKVFormattedData(
                                                                  transpose:
                                                                      true,
                                                                  header:
                                                                      false)[0]
                                                              .join("||"),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      label: const Text("Show Debug Data"),
                                      icon: const Icon(Icons.bug_report),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                const Divider(
                                  thickness: 4.0,
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                FilledButton(
                                    onPressed: () {
                                      setState(() {
                                        pitPageIndex = 0;
                                      });
                                      resetPit();
                                    },
                                    child: const Text(
                                      "Reset Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
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
          if (appMode == 2) const SizedBox()
        ],
      ),
    );
  }

  List<List> getPitKVFormattedData(
      {bool transpose = false, bool header = true}) {
    List<List<dynamic>> data = [];
    pitScoutingData.forEach((key, value) {
      data.add([key, (value is List ? value.join(",") : value.toString())]);
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
                setState(() {
                  pitPageIndex = 0;
                });
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
