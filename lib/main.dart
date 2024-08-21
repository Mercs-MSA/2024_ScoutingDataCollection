import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int appMode = 0;

  String eventId = "2024txama";
  bool transposedExport = true;
  bool exportHeaders = true;
  bool playoffMode = false;
  Map teamNameMap = {};

  static String configuration = '''
  {
    "sections": {
      "pit": {
        "export": [
          "test1,\$TEST1",
          "test2,\$TEST2",
          "test3,\$TEST3",
          "test4,\$TEST4"
        ],
        "tabs": [
          {
            "name": "PITTEST",
            "id": "\$PIT",
            "icon": "mdi:inventory_2",
            "content": [
              {"type": "checkbox_tile", "id": "\$TEST1", "name": "Test 1", "tristate": false},
              {
                "type": "layout",
                "mode": "row",
                "content": [
                  {"type": "checkbox_tile", "id": "\$TEST2", "name": "Test 2", "tristate": true},
                  {"type": "divider", "direction": "vertical"},
                  {"type": "checkbox_tile", "id": "\$TEST3", "name": "Test 3", "tristate": true},
                  {"type": "checkbox_tile", "id": "\$TEST4", "name": "Test 4", "tristate": false}
                ]
              },
              {"type": "divider", "direction": "horizontal"}
            ]
          }
        ]
      }
    }
  }
  ''';

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

    teamNameMap = json.decode(prefs.getString("teamNamesMap") ?? "{}");

    eventId = prefs.getString("eventId") ?? "unknown";
    playoffMode = prefs.getBool("playoffMode") ?? false;

    transposedExport = prefs.getBool("transposedExport") ?? true;
    exportHeaders = prefs.getBool("exportHeaders") ?? true;

    setState(() {
      appMode = prefs.getInt('appMode') ?? 0;
    });
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
      child: Builder(
        builder: (BuildContext context) {
          if (appMode == 0) {
            // Main Menu
            return Scaffold(
              appBar: AppBar(
                title: const Text("Welcome!"),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          appMode = 1;
                          setState(() {});
                        });
                      },
                      icon: const Icon(Icons.settings_outlined)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          appMode = 2;
                          setState(() {});
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
                            setState(() {});
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
                                  "\$name",
                                  style: TextStyle(fontSize: 24),
                                ),
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
            );
          } else if (appMode == 1) {
            // Settings
            return Scaffold(
              appBar: AppBar(
                  title: const Text('Application Setup'),
                  leading: IconButton(
                    onPressed: () {
                      setState(() {
                        appMode = 0;
                        setState(() {});
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
            );
          } else if (appMode == 2) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("About"),
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        appMode = 0;
                        setState(() {});
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
                    "Recon",
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
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  void resetAll() {
    // TODO: Implement this
  }

  void resetForm(int formIndex) {
    // TODO: Implement this
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
