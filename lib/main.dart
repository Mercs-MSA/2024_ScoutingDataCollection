import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:collection/collection.dart';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:mercs_scout/data_maps.dart';
import 'package:mercs_scout/reassemble_tools.dart';
import 'package:mercs_scout/settingspage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dummyweb.dart' if (dart.library.html) 'package:web/web.dart' as web;

import 'datatypes.dart';
import 'match_form.dart';
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
      title: 'Sleepy Ron',
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
  bool devMode = false;
  bool showWebWarning = true;

  int? pitTeamNumber;
  List<String> pitScouters = ["", ""];

  int? matchTeamNumber;

  final bool colorDebug = Random.secure().nextBool();

  Map<String, dynamic> pitScoutingDefaultData = getPitDataMap();
  Map<String, dynamic> pitScoutingData = getPitDataMap();

  Map<String, dynamic> matchScoutingDefaultData = getMatchDataMap();
  Map<String, dynamic> matchScoutingData = getMatchDataMap();

  bool saveDisabled = false;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  bool cheerConfetti = true;
  ConfettiController killableCheerConfetti = ConfettiController();
  List<ConfettiController> killableConfetti = [];
  Timer? cheerConfettiTimer;

  Alliance cheeringAlliance = Alliance.red;
  List<String> customCheeringStrings = [];

  WidgetsToImageController pitPngController = WidgetsToImageController();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    loadPrefs().whenComplete(() {
      if (!kIsWeb) {
        return;
      }

      if (!showWebWarning) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Get the Android App'),
              icon: Icon(
                Icons.android_rounded,
                size: 64,
              ),
              content: const Text(
                  'Use the Sleepy Ron Android app for improved performance'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    launchUrlString(
                        "https://github.com/Mercs-MSA/FRC_ScoutingDataCollection/releases");
                    Navigator.of(context).pop();
                  },
                  child: const Text("App Releases"),
                ),
                FilledButton(
                  onPressed: () {
                    showWebWarning = false;
                    attemptSaveShowWebWarning();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Don't show again",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ));
    });
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
    devMode = prefs.getBool("develMode") ?? false;
    showWebWarning = prefs.getBool("showWebWarning") ?? true;
    customCheeringStrings = prefs.getStringList("customCheeringStrings") ?? [];

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
    if (appMode != 0) {
      setState(() {
        appMode = 0;
      });
      return;
    }
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
    return ReassembleListener(
      onReassemble: () {
        if (const ListEquality().equals(matchScoutingData.keys.toList(),
                getMatchDataMap().keys.toList()) &&
            const ListEquality().equals(
                getPitDataMap().keys.toList(), pitScoutingData.keys.toList())) {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Hot Reload Issue'),
                icon: Icon(
                  Icons.app_registration_rounded,
                  size: 64,
                ),
                content: const Text('App must be reset to work properly'),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Dismiss"),
                  ),
                  FilledButton(
                    onPressed: () {
                      resetPit();
                      resetMatch();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Reset",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ));
      },
      child: PopScope(
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
                  title: const Text("Sleepy Ron"),
                  actions: [
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            showDragHandle: true,
                            useSafeArea: true,
                            builder: (BuildContext context) {
                              return SettingsPage(
                                initialTransposedExport: transposedExport,
                                initialExportHeaders: exportHeaders,
                                initialEventId: eventId,
                                initialDevMode: devMode,
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
                                onResetPrefs: () {
                                  resetPrefs();
                                  loadPrefs();
                                  Navigator.pop(context);
                                },
                                onDevModeChanged: (value) {
                                  setState(() {
                                    devMode = value;
                                    attemptSaveDevMode();
                                  });
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.settings_outlined)),
                    IconButton(
                        onPressed: () {
                          showAboutDialog(
                              context: context,
                              applicationIcon: Image.asset(
                                "images/icon.png",
                                scale: 2,
                              ),
                              applicationVersion: _packageInfo.version,
                              children: [
                                Image.asset(
                                  "images/ron.png",
                                  height: 300,
                                ),
                              ]);
                        },
                        icon: const Icon(Icons.info_outline_rounded))
                  ],
                ),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 720) {
                      // Use BottomNavigationBar for small screens
                      return Padding(
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
                                    // pit
                                    if (devMode) {
                                      pitTeamNumber = 9999;
                                      pitScoutingData["team"] = 9999;
                                      pitScouters = [
                                        "RonCollins",
                                        "RonCollins"
                                      ];
                                      pitScoutingData["scouters"] =
                                          "RonCollins,RonCollins";
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                      const Size.fromHeight(150)),
                                  maximumSize: WidgetStateProperty.all(
                                      const Size.fromHeight(200)),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Pit Scouting",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                    // match
                                    if (devMode) {
                                      matchTeamNumber = 9999;
                                      matchScoutingData["match"] = 1;
                                      matchScoutingData["team"] = 9999;
                                      matchScoutingData["scouter"] =
                                          "RonCollins";
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                      const Size.fromHeight(150)),
                                  maximumSize: WidgetStateProperty.all(
                                      const Size.fromHeight(200)),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.flag_rounded,
                                      size: 72,
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Match Scouting",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 2,
                              child: FilledButton(
                                onPressed: () {
                                  setState(() {
                                    appMode = 3;
                                    setAppModePref(appMode);
                                  });
                                },
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                      const Size.fromHeight(150)),
                                  maximumSize: WidgetStateProperty.all(
                                      const Size.fromHeight(200)),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.celebration_rounded,
                                      size: 72,
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Playoff Cheering",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("Enter playoff cheering mode")
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
                      );
                    } else {
                      // Use NavigationRail for larger screens
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.chevron_right,
                                      size: 56,
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Text(
                                      "Welcome!",
                                      style: TextStyle(
                                          fontSize: 56,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Choose a mode to get started",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: const Image(
                                    image: AssetImage('images/mercs.png'),
                                    fit: BoxFit.scaleDown,
                                    width: 300,
                                    isAntiAlias: true,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(
                              width: 24.0,
                            ),
                            Expanded(
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
                                          // pit
                                          if (devMode) {
                                            pitTeamNumber = 9999;
                                            pitScoutingData["team"] = 9999;
                                            pitScouters = [
                                              "RonCollins",
                                              "RonCollins"
                                            ];
                                            pitScoutingData["scouters"] =
                                                "RonCollins,RonCollins";
                                          }
                                        });
                                      },
                                      style: ButtonStyle(
                                        minimumSize: WidgetStateProperty.all(
                                            const Size.fromHeight(150)),
                                        maximumSize: WidgetStateProperty.all(
                                            const Size.fromHeight(200)),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Pit Scouting",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                                          // match
                                          if (devMode) {
                                            matchTeamNumber = 9999;
                                            matchScoutingData["match"] = 1;
                                            matchScoutingData["team"] = 9999;
                                            matchScoutingData["scouter"] =
                                                "RonCollins";
                                          }
                                        });
                                      },
                                      style: ButtonStyle(
                                        minimumSize: WidgetStateProperty.all(
                                            const Size.fromHeight(150)),
                                        maximumSize: WidgetStateProperty.all(
                                            const Size.fromHeight(200)),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.flag_rounded,
                                            size: 72,
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Match Scouting",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: FilledButton(
                                      onPressed: () {
                                        setState(() {
                                          appMode = 3;
                                          setAppModePref(appMode);
                                        });
                                      },
                                      style: ButtonStyle(
                                        minimumSize: WidgetStateProperty.all(
                                            const Size.fromHeight(150)),
                                        maximumSize: WidgetStateProperty.all(
                                            const Size.fromHeight(200)),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.celebration_rounded,
                                            size: 72,
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Playoff Cheering",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "Enter playoff cheering mode")
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
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

                      for (var element in killableConfetti.reversed) {
                        element.kill();
                      }
                      killableConfetti.clear();

                      Timer.periodic(Duration(milliseconds: 120), (timer) {
                        if (count > 4) {
                          timer.cancel();
                        }

                        final c = Confetti.launch(
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
                        killableConfetti.add(c);
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
                                LengthLimitingTextInputFormatter(5),
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
                                colorDebug: colorDebug,
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      const SizedBox(),
                    if (pitPageIndex == 2)
                      IndexedStack(
                        index:
                            (pitTeamNumber == null || pitScouters.contains(""))
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
                                          return WidgetsToImage(
                                            controller: pitPngController,
                                            child: QrImageView(
                                              data: getPitKVFormattedData(
                                                      transpose: true,
                                                      header: false)[0]
                                                  .join("||"),
                                              backgroundColor: Colors.white,
                                              size: min(constraints.maxHeight,
                                                  constraints.maxWidth),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: saveDisabled == false
                                        ? onPitScoutQrSave
                                        : null,
                                    label: const Text("Export QR Code PNG"),
                                    icon: const Icon(Icons.save),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
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
                                        label: const Text("Export CSV"),
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
                                                    title: Text(
                                                        "Debug Information"),
                                                  ),
                                                  body: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            fillColor: Color(
                                                                0xff0d0d0d),
                                                            filled: true,
                                                            labelText:
                                                                'JSON Data',
                                                          ),
                                                          readOnly: true,
                                                          minLines: 2,
                                                          maxLines: 20,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xffffffff),
                                                            fontFamily:
                                                                "RobotoMono",
                                                          ),
                                                          controller: TextEditingController(
                                                              text: JsonEncoder
                                                                      .withIndent(
                                                                          " " *
                                                                              4)
                                                                  .convert(
                                                                      pitScoutingData)),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            fillColor: Color(
                                                                0xff0d0d0d),
                                                            filled: true,
                                                            labelText:
                                                                'KV/QR Data',
                                                          ),
                                                          readOnly: true,
                                                          minLines: 2,
                                                          maxLines: 5,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xffffffff),
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
                                      resetPrompt(() {
                                        setState(() {
                                          pitPageIndex = 0;
                                        });
                                        resetPit();
                                      });
                                    },
                                    child: const Text(
                                      "Reset Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
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
            if (appMode == 2)
              // Pit Scouting
              Scaffold(
                appBar: AppBar(
                  title: const Text('Match Data Collection'),
                  leading: IconButton(
                      onPressed: () {
                        setState(() {
                          appMode = 0;
                          matchPageIndex = 0;
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
                  selectedIndex: matchPageIndex,
                  onDestinationSelected: (int index) {
                    // if (index == 2 &&
                    //     !(matchTeamNumber == null ||
                    //         matchScoutingData["scouter"] == "") &&
                    //     matchPageIndex != 2) {
                    //   var count = 0;

                    //   for (var element in killableConfetti.reversed) {
                    //     element.kill();
                    //   }
                    //   killableConfetti.clear();

                    //   Timer.periodic(Duration(milliseconds: 120), (timer) {
                    //     if (count > 4) {
                    //       timer.cancel();
                    //     }

                    //     final c = Confetti.launch(
                    //       context,
                    //       options: ConfettiOptions(
                    //         particleCount: 20,
                    //         spread: 85,
                    //         y: 1,
                    //         flat: true,
                    //         decay: 0.82,
                    //         colors: [
                    //           matchScoutingData["alliance"] == "red"
                    //               ? Colors.red
                    //               : Colors.blue,
                    //           Colors.black,
                    //           Colors.white
                    //         ],
                    //       ),
                    //     );
                    //     killableConfetti.add(c);
                    //     count++;
                    //   });
                    // }
                    setState(() {
                      matchPageIndex = index;
                    });
                  },
                ),
                body: IndexedStack(
                  index: matchPageIndex,
                  children: [
                    if (matchPageIndex == 0)
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
                                LengthLimitingTextInputFormatter(5),
                              ],
                              onChanged: (value) {
                                matchTeamNumber = int.tryParse(value);
                                matchScoutingData["team"] = int.tryParse(value);
                              },
                              controller: TextEditingController(
                                text: matchTeamNumber == null
                                    ? ''
                                    : matchTeamNumber.toString(),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Scouter Name',
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(30),
                                      FilteringTextInputFormatter(
                                        RegExp(r'[a-zA-Z]'),
                                        allow: true,
                                      ),
                                    ],
                                    onChanged: (value) {
                                      matchScoutingData["scouter"] = value;
                                    },
                                    controller: TextEditingController(
                                      text: matchScoutingData["scouter"],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Match Number',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    onChanged: (value) {
                                      matchScoutingData["match"] =
                                          int.tryParse(value);
                                    },
                                    controller: TextEditingController(
                                      text: matchScoutingData["match"] == null
                                          ? ''
                                          : matchScoutingData["match"]
                                              .toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Expanded(
                                  child: SegmentedButton<Alliance>(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return ColorScheme.fromSeed(
                                                    seedColor: matchScoutingData[
                                                                "alliance"] ==
                                                            "red"
                                                        ? Colors.red
                                                        : Colors.blue)
                                                .primary;
                                          }
                                          return Colors.transparent;
                                        },
                                      ),
                                      padding: WidgetStateProperty.all(
                                        EdgeInsets.all(40.0),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                      ),
                                    ),
                                    segments: [
                                      ButtonSegment(
                                        value: Alliance.blue,
                                        label: Text("Blue"),
                                      ),
                                      ButtonSegment(
                                        value: Alliance.red,
                                        label: Text("Red"),
                                      ),
                                    ],
                                    selected:
                                        matchScoutingData["alliance"] == "red"
                                            ? {Alliance.red}
                                            : {Alliance.blue},
                                    onSelectionChanged: (selection) {
                                      setState(() {
                                        matchScoutingData["alliance"] =
                                            selection.first == Alliance.red
                                                ? "red"
                                                : "blue";
                                      });
                                    },
                                    multiSelectionEnabled: false,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 2, right: 8),
                                  child: Column(
                                    children: [
                                      Text("Auto Start"),
                                      Text("Position")
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: SegmentedButton<MatchStartPos>(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return ColorScheme.fromSeed(
                                                    seedColor: matchScoutingData[
                                                                "alliance"] ==
                                                            "red"
                                                        ? Colors.red
                                                        : Colors.blue)
                                                .primary;
                                          }
                                          return Colors.transparent;
                                        },
                                      ),
                                      padding: WidgetStateProperty.all(
                                        EdgeInsets.all(24.0),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                      ),
                                    ),
                                    emptySelectionAllowed: false,
                                    multiSelectionEnabled: false,
                                    segments: <ButtonSegment<MatchStartPos>>[
                                      ButtonSegment(
                                          value: MatchStartPos.left,
                                          label: Text("Left")),
                                      ButtonSegment(
                                          value: MatchStartPos.middle,
                                          label: Text("Middle")),
                                      ButtonSegment(
                                          value: MatchStartPos.right,
                                          label: Text("Right"))
                                    ],
                                    selected: {
                                      if (matchScoutingData["startPos"] ==
                                          "left")
                                        MatchStartPos.left,
                                      if (matchScoutingData["startPos"] ==
                                          "middle")
                                        MatchStartPos.middle,
                                      if (matchScoutingData["startPos"] ==
                                          "right")
                                        MatchStartPos.right,
                                    },
                                    onSelectionChanged: (selection) {
                                      setState(() {
                                        if (selection.first ==
                                            MatchStartPos.left) {
                                          matchScoutingData["startPos"] =
                                              "left";
                                        }
                                        if (selection.first ==
                                            MatchStartPos.right) {
                                          matchScoutingData["startPos"] =
                                              "right";
                                        }
                                        if (selection.first ==
                                            MatchStartPos.middle) {
                                          matchScoutingData["startPos"] =
                                              "middle";
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(),
                    if (matchPageIndex == 1)
                      MatchForm(
                        teamNumberPresent:
                            (matchTeamNumber == null ? false : true) &&
                                !(matchScoutingData["scouter"] == ""),
                        formData: matchScoutingData,
                        onDataChanged: (data) {
                          data.forEach((k, v) {
                            matchScoutingData[k] = v;
                          });
                        },
                        colorDebug: colorDebug,
                      )
                    else
                      const SizedBox(),
                    if (matchPageIndex == 2)
                      IndexedStack(
                        index: (matchTeamNumber == null ||
                                matchScoutingData["scouter"] == "")
                            ? 0
                            : 1,
                        children: [
                          if (matchTeamNumber == null ||
                              matchScoutingData["scouter"] == "")
                            const Center(child: TeamNumberError())
                          else
                            const SizedBox(),
                          if (matchTeamNumber != null)
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (matchScoutingData["isMarkedForReview"] ==
                                      true)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Icon(
                                                Icons.flag_rounded,
                                                size: 64,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiary,
                                              ),
                                              const Spacer(),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Review Session",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 32,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "This session is marked for review",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LayoutBuilder(
                                        builder: (BuildContext context,
                                            BoxConstraints constraints) {
                                          return QrImageView(
                                            data: getMatchKVFormattedData(
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
                                            ? onMatchScoutSave
                                            : null,
                                        label: const Text("Export CSV"),
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
                                                    title: Text(
                                                        "Debug Information"),
                                                  ),
                                                  body: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            fillColor: Color(
                                                                0xff0d0d0d),
                                                            filled: true,
                                                            labelText:
                                                                'JSON Data',
                                                          ),
                                                          readOnly: true,
                                                          minLines: 2,
                                                          maxLines: 20,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xffffffff),
                                                            fontFamily:
                                                                "RobotoMono",
                                                          ),
                                                          controller: TextEditingController(
                                                              text: JsonEncoder
                                                                      .withIndent(
                                                                          " " *
                                                                              4)
                                                                  .convert(
                                                                      matchScoutingData)),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            fillColor: Color(
                                                                0xff0d0d0d),
                                                            filled: true,
                                                            labelText:
                                                                'KV/QR Data',
                                                          ),
                                                          readOnly: true,
                                                          minLines: 2,
                                                          maxLines: 5,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xffffffff),
                                                            fontFamily:
                                                                "RobotoMono",
                                                          ),
                                                          controller:
                                                              TextEditingController(
                                                            text: getMatchKVFormattedData(
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
                                      resetPrompt(() {
                                        setState(() {
                                          matchPageIndex = 0;
                                        });
                                        resetMatch();
                                      });
                                    },
                                    child: const Text(
                                      "Reset Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
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
            if (appMode == 3)
              // Pit Scouting
              Scaffold(
                appBar: AppBar(
                  title: const Text('Cheering'),
                  leading: IconButton(
                      onPressed: () {
                        setState(() {
                          appMode = 0;
                          matchPageIndex = 0;
                          setAppModePref(appMode);
                        });
                      },
                      icon: const Icon(Icons.home)),
                ),
                body: ListView(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SectionHeader(
                            title: "Choose a letter and hold your device up!"),
                      ],
                    ),
                    SegmentedButton<Alliance>(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return ColorScheme.fromSeed(
                                      seedColor:
                                          cheeringAlliance == Alliance.red
                                              ? Colors.red
                                              : Colors.blue)
                                  .primary;
                            }
                            return Colors.transparent;
                          },
                        ),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.all(40.0),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                      ),
                      segments: [
                        ButtonSegment(
                          value: Alliance.blue,
                          label: Text("Blue"),
                        ),
                        ButtonSegment(
                          value: Alliance.red,
                          label: Text("Red"),
                        ),
                      ],
                      selected: {cheeringAlliance},
                      onSelectionChanged: (selection) {
                        setState(() {
                          cheeringAlliance = selection.first;
                        });
                      },
                      multiSelectionEnabled: false,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ExpansionTile(
                        title: Row(
                          children: [
                            Icon(Icons.celebration),
                            const SizedBox(width: 8.0),
                            Text("Alliance Cheering"),
                          ],
                        ),
                        children: [
                          cheeringAlliance == Alliance.red
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "G",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: const Text(
                                            "G",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "O",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: const Text(
                                            "O",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 25.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "R",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "R",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "E",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "E",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "D",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "D",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "!",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "!",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "G",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: const Text(
                                            "G",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "O",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: const Text(
                                            "O",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 25.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "B",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "B",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "L",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "L",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "U",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "U",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "E",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "E",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            backgroundColor: Colors
                                                .white, // Custom primary color
                                            foregroundColor: Colors
                                                .black, // Ensure good contrast
                                          ),
                                          onPressed: () {
                                            showFullscreenLetter(
                                                "!",
                                                cheeringAlliance == Alliance.red
                                                    ? Colors.red
                                                    : Colors.blue);
                                          },
                                          child: Text(
                                            "!",
                                            softWrap: false,
                                            style: TextStyle(fontSize: 46),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ]),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ExpansionTile(
                      title: Row(
                        children: [
                          Icon(Icons.dashboard_customize),
                          const SizedBox(width: 8.0),
                          Text("Custom Cheering"),
                        ],
                      ),
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 8,
                              children: [
                                for (String cheer in customCheeringStrings)
                                  Row(
                                    children: [
                                      for (String letter in cheer.split(","))
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                                backgroundColor: Colors
                                                    .white, // Custom primary color
                                                foregroundColor: Colors
                                                    .black, // Ensure good contrast
                                              ),
                                              onPressed: () {
                                                showFullscreenLetter(
                                                    letter.replaceAll(
                                                        "*", "\n"),
                                                    cheeringAlliance ==
                                                            Alliance.red
                                                        ? Colors.red
                                                        : Colors.blue);
                                              },
                                              child: Text(
                                                letter.replaceAll("*", "\n"),
                                                softWrap: false,
                                                style: TextStyle(fontSize: 46),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ExpansionTile(
                      title: Row(
                        children: [
                          Icon(Icons.settings),
                          const SizedBox(width: 8.0),
                          Text("Custom Cheering Config"),
                        ],
                      ),
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              CheeringStringPage(
                                cheeringStrings: customCheeringStrings,
                                onCheeringStringsChanged: (value) {
                                  setState(() {
                                    customCheeringStrings = value;
                                    attemptSaveCheeringStrings();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }

  double randomInRange(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  void resetPrompt(Function onReset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Data?'),
        icon: Icon(
          Icons.app_registration_rounded,
          size: 64,
        ),
        content: const Text(
            'Have you screenshotted the QR Code?\nRESET DATA IS NOT RECOVERABLE OTHERWISE!'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              onReset();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Yes, Reset Data",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void showFullscreenLetter(String letter, Color background) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: false,
      anchorPoint: Offset.zero,
      barrierLabel: "Test",
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            /// call the kill method to kill the confetti
            /// controller.kill();
            ///

            WidgetsBinding.instance.addPostFrameCallback((timestamp) {
              if (cheerConfettiTimer == null || !cheerConfettiTimer!.isActive) {
                cheerConfettiTimer = Timer.periodic(
                  Duration(milliseconds: 1500),
                  (timer) {
                    if (!cheerConfetti) {
                      return;
                    }
                    killableCheerConfetti = Confetti.launch(
                      context,
                      options: ConfettiOptions(
                        particleCount: 80,
                        spread: 360,
                        startVelocity: 30,
                        ticks: 60,
                        x: randomInRange(0.1, 0.9),
                        y: Random().nextDouble() - 0.2,
                        gravity: -0.3,
                        flat: true,
                        colors: [
                          Color.fromARGB(
                              255,
                              (background.r * 127).round(),
                              (background.g * 127).round(),
                              (background.b * 127).round()),
                          Colors.black,
                          Colors.white
                        ],
                      ),
                    );
                  },
                );
              }
            });

            return Dialog(
              backgroundColor: background,
              insetPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 3,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double maxFontSize =
                            constraints.maxHeight; // 80% of height
                        return Center(
                          child: FittedBox(
                            fit: BoxFit
                                .scaleDown, // Ensures text shrinks if needed
                            child: Text(
                              letter,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    maxFontSize, // Dynamically scale font size
                                fontWeight: FontWeight.bold,
                                color: background.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (cheerConfettiTimer != null) {
                              cheerConfettiTimer?.cancel();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(18),
                          ),
                          child: Icon(Icons.close, size: 32),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              cheerConfetti = !cheerConfetti;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(72)),
                            padding: EdgeInsets.all(18),
                          ),
                          child: Row(children: [
                            Icon(Icons.celebration_rounded, size: 32),
                            Icon(
                              cheerConfetti ? Icons.check : Icons.close,
                              size: 32,
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((x) {
      if (cheerConfettiTimer != null) {
        cheerConfettiTimer?.cancel();
      }
    });
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

  void onPitScoutQrSave() async {
    final pngBytes = await pitPngController.capture();

    if (kIsWeb) {
      saveFileWeb(pngBytes!,
          "${eventId}_frc${pitTeamNumber}_pit/${eventId}_frc${pitTeamNumber}_pit.png");
    } else {
      saveFileNative(pngBytes!,
          "${eventId}_frc${pitTeamNumber}_pit/${eventId}_frc${pitTeamNumber}_pit.png");
    }
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

    if (kIsWeb) {
      saveFileWeb(Uint8List.fromList(fileData.codeUnits),
          "${eventId}_frc${pitTeamNumber}_pit/${eventId}_frc${pitTeamNumber}_pit.csv");
    } else {
      saveFileNative(Uint8List.fromList(fileData.codeUnits),
          "${eventId}_frc${pitTeamNumber}_pit/${eventId}_frc${pitTeamNumber}_pit.csv");
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

  List<List> getMatchKVFormattedData(
      {bool transpose = false, bool header = true}) {
    List<List<dynamic>> data = [];
    matchScoutingData.forEach((key, value) {
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

  void onMatchScoutSave() async {
    if (matchTeamNumber == null) {
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

    if (kIsWeb) {
      saveFileWeb(Uint8List.fromList(fileData.codeUnits),
          "${eventId}_frc${pitTeamNumber}_pit/${eventId}_frc${pitTeamNumber}_pit.csv");
    } else {
      saveFileNative(Uint8List.fromList(fileData.codeUnits),
          "${eventId}_frc${pitTeamNumber}_pit/${eventId}_frc${pitTeamNumber}_pit.csv");
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
                  matchPageIndex = 0;
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

  Future<void> saveFileNative(Uint8List data, String fileName) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Export data',
      fileName: fileName,
      bytes: data,
    );

    if (outputFile != null) {
      File file = File(outputFile);
      file.writeAsBytes(data);
    }

    setState(() {
      saveDisabled = false;
    });
  }

  Future<void> saveFileWeb(Uint8List data, String fileName) async {
    if (!kIsWeb) {
      return;
    }

    final web.HTMLAnchorElement anchor =
        web.document.createElement('a') as web.HTMLAnchorElement
          ..href = "data:application/octet-stream;base64,${base64Encode(data)}"
          ..style.display = 'none'
          ..download = fileName;

    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);
    setState(() {
      saveDisabled = false;
    });
  }

  Future<void> resetPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void resetPit() {
    pitTeamNumber = null;
    pitScoutingData = Map.from(pitScoutingDefaultData);
    setState(() {
      pitPageIndex = 0;
    });
  }

  void resetMatch() {
    matchTeamNumber = null;
    matchScoutingData = Map.from(matchScoutingDefaultData);
    setState(() {
      matchPageIndex = 0;
    });
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

  Future<void> attemptSaveDevMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('develMode', devMode);
    });
  }

  Future<void> attemptSaveCheeringStrings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('customCheeringStrings', customCheeringStrings);
    });
  }

  Future<void> attemptSaveShowWebWarning() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('showWebWarning', showWebWarning);
    });
  }
}

extension on String {
  set display(String display) {}
}
