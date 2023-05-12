import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Form Elements'),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Column(children: [
                const Icon(
                  Icons.poll_outlined,
                  size: 192,
                ),
                DataTable(columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                        child: Text(
                      'Field',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )),
                  ),
                  DataColumn(
                    label: Expanded(
                        child: Text(
                      'Data',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )),
                  ),
                  DataColumn(
                    label: Expanded(
                        child: Text(
                      'Type',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )),
                  ),
                ], rows: <DataRow>[
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('Text Field')),
                    DataCell(
                        Text(textFieldData == '' ? 'Empty' : textFieldData)),
                    const DataCell(Text('String')),
                  ]),
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('Team Number')),
                    DataCell(Text(teamNumberData.toString())),
                    const DataCell(Text('Int?')),
                  ]),
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('Checkbox')),
                    DataCell(Text(checkBoxIsChecked.toString())),
                    const DataCell(Text('Bool')),
                  ]),
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('Switch')),
                    DataCell(Text(switchIsToggled.toString())),
                    const DataCell(Text('Bool')),
                  ]),
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('Color')),
                    DataCell(Text(colorSelectData.hex.toString())),
                    const DataCell(Text('Color')),
                  ]),
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('Rating')),
                    DataCell(Text(ratingData.toString())),
                    const DataCell(Text('Double')),
                  ]),
                ]),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final fileData = const ListToCsvConverter().convert([
                            ['item', 'value'],
                            ['team', teamNumberData],
                            ['checkbox', checkBoxIsChecked],
                            ['switch', switchIsToggled],
                            ['color', colorSelectData.hex.toString()],
                            ['rating', ratingData.toString()],
                          ]);
                          if (Platform.isAndroid | Platform.isIOS) {
                            saveFileMobile(
                                Uint8List.fromList(fileData.codeUnits));
                          } else if (Platform.isLinux |
                              Platform.isMacOS |
                              Platform.isWindows) {
                            saveFileDesktop(
                                Uint8List.fromList(fileData.codeUnits));
                          }
                        },
                        label: const Text("Save"),
                        icon: const Icon(Icons.save),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ],
        ));
  }

  Future<void> saveFileMobile(Uint8List data) async {
    final params = SaveFileDialogParams(data: data, fileName: "output.csv");
    await FlutterFileDialog.saveFile(params: params);
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
  }
}

class RatingInput extends StatelessWidget {
  const RatingInput({
    super.key,
    required this.title,
    required this.onRatingUpdate,
    required this.initialRating,
  });

  final String title;
  final Function(double) onRatingUpdate;
  final double initialRating;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: RatingBar.builder(
        initialRating: initialRating,
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Theme.of(context).colorScheme.primary,
        ),
        onRatingUpdate: onRatingUpdate,
        glow: false,
      ),
    );
  }
}

class ColorInput extends StatefulWidget {
  const ColorInput({
    super.key,
    required this.title,
    required this.onColorChanged,
  });

  final String title;
  final Function(Color) onColorChanged;

  @override
  State<ColorInput> createState() => _ColorInputState();
}

class _ColorInputState extends State<ColorInput> {
  Color currentColor = Colors.red;
  Color beforeColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: ColorIndicator(
        onSelect: () async {
          beforeColor = currentColor;
          if (!(await colorPickerDialog())) {
            setState(() {
              currentColor = beforeColor;
              widget.onColorChanged(currentColor);
            });
          }
        },
        color: currentColor,
        width: 36,
        height: 36,
      ),
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: currentColor,
      onColorChanged: (Color color) {
        setState(() {
          currentColor = color;
          widget.onColorChanged(currentColor);
        });
      },
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showColorName: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(context);
  }
}
