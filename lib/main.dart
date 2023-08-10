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
  bool checkBoxIsChecked = false;
  bool switchIsToggled = false;

  int currentPageIndex = 0;

  String textFieldData = '';
  int? teamNumberData;
  Color colorSelectData = Colors.red;
  int ratingData = 0;
  String dropdownChoice = "Option A";

  bool saveDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Form Elements'),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.list_alt),
              label: 'Form',
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
                        labelText: 'Text Field',
                      ),
                      onChanged: (value) {
                        textFieldData = value;
                      },
                      controller: TextEditingController(text: textFieldData),
                    ),
                    const SizedBox(height: 8.0),
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
                    CheckboxListTile(
                      title: const Text('Checkbox'),
                      value: checkBoxIsChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          checkBoxIsChecked = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    SwitchListTile(
                        title: const Text('Switch'),
                        value: switchIsToggled,
                        onChanged: (bool? newValue) {
                          setState(() {
                            switchIsToggled = newValue!;
                          });
                        }),
                    const SizedBox(height: 8.0),
                    ColorInput(
                      title: 'Color Select',
                      onColorChanged: (Color color) {
                        colorSelectData = color;
                      },
                    ),
                    RatingInput(
                      title: 'Rating',
                      onRatingUpdate: (rating) {
                        ratingData = rating.toInt();
                      },
                      initialRating: ratingData.toDouble(),
                    ),
                    ChoiceInput(
                      title: "Dropdown",
                      onChoiceUpdate: (value) {
                        setState(() {
                          dropdownChoice = value!;
                        });
                      },
                      choice: dropdownChoice,
                      options: const ["Option A", "Option B", "Option C"],
                    )
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
                          data: textFieldData == "" ? "Empty" : textFieldData),
                      DataCard(
                          item: "Team Number",
                          data: teamNumberData == null
                              ? "Empty"
                              : teamNumberData.toString()),
                      DataCard(
                          item: "Checkbox", data: checkBoxIsChecked.toString()),
                      DataCard(
                          item: "Switch", data: switchIsToggled.toString()),
                      DataCard(
                          item: "Color Select",
                          data: colorSelectData.hex.toString()),
                      DataCard(item: "Rating", data: ratingData.toString()),
                      DataCard(item: "Dropdown", data: dropdownChoice),
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
      ['item', 'value'],
      ['team', teamNumberData],
      ['checkbox', checkBoxIsChecked],
      ['switch', switchIsToggled],
      ['color', colorSelectData.hex.toString()],
      ['rating', ratingData.toString()],
      ['dropdown', dropdownChoice],
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
