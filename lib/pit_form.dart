import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets.dart';

class PitForm extends StatefulWidget {
  const PitForm({
    super.key,
    required this.teamNumberPresent,
    required this.onDataChanged,
    required this.formData,
  });

  final bool teamNumberPresent;

  final Function(Map<String, dynamic>) onDataChanged;
  final Map formData;

  @override
  State<PitForm> createState() => _PitFormState();
}

enum CoralPositions { lOne, lTwo, lThree, lFour }

Set<CoralPositions> selection = {CoralPositions.lOne};

class _PitFormState extends State<PitForm> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.teamNumberPresent == true ? 1 : 0,
      children: [
        if (!widget.teamNumberPresent)
          const Center(child: TeamNumberError())
        else
          const SizedBox(),
        if (widget.teamNumberPresent)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 8.0),
                  Card(
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                          title: Text(
                            "Weight must include battery and bumper",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onTertiary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Width',
                            suffixText: "in",
                          ),
                          keyboardType: TextInputType.number,
                          // inputFormatters: <TextInputFormatter>[
                          //   FilteringTextInputFormatter.digitsOnly,
                          //   LengthLimitingTextInputFormatter(2),
                          // ],
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*'))
                          ],
                          onChanged: (value) {
                            widget
                                .onDataChanged({"width": int.tryParse(value)});
                          },
                          controller: TextEditingController(
                            text: widget.formData["width"] == null
                                ? ''
                                : widget.formData["width"].toString(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Length',
                            suffixText: 'in',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          onChanged: (value) {
                            widget
                                .onDataChanged({"length": int.tryParse(value)});
                          },
                          controller: TextEditingController(
                            text: widget.formData["length"] == null
                                ? ''
                                : widget.formData["length"].toString(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Height',
                            suffixText: 'in',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          onChanged: (value) {
                            widget
                                .onDataChanged({"height": int.tryParse(value)});
                          },
                          controller: TextEditingController(
                            text: widget.formData["height"] == null
                                ? ''
                                : widget.formData["height"].toString(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Weight',
                            suffixText: 'lbs',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          onChanged: (value) {
                            widget
                                .onDataChanged({"weight": int.tryParse(value)});
                          },
                          controller: TextEditingController(
                            text: widget.formData["weight"] == null
                                ? ''
                                : widget.formData["weight"].toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  ChoiceInput(
                    title: "Drivebase",
                    onChoiceUpdate: (value) {
                      setState(() {
                        widget.onDataChanged({"drivebase": value!});
                      });
                    },
                    choice: widget.formData["drivebase"],
                    options: const ["Swerve", "Tank", "Other"],
                  ),
                  const SizedBox(height: 8.0),
                  const Text("Coral Capabilities:"),
                  const SizedBox(height: 8.0),
                  Expanded(
                      child: SegmentedButton<CoralPositions>(
                    segments: <ButtonSegment<CoralPositions>>[
                      ButtonSegment(
                          value: CoralPositions.lOne, label: Text('L1')),
                      ButtonSegment(
                          value: CoralPositions.lTwo, label: Text('L2')),
                      ButtonSegment(
                          value: CoralPositions.lThree, label: Text('L3')),
                      ButtonSegment(
                          value: CoralPositions.lFour, label: Text('L4')),
                    ],
                    selected: selection,
                    onSelectionChanged: (Set<CoralPositions> newSelection) {
                      setState(() {
                        selection = newSelection;
                      });
                    },
                    multiSelectionEnabled: true,
                  )),
                  Row(
                    children: [
                      Expanded(
                          child: CheckboxListTile(
                        tristate: false,
                        title: Text("L1?"),
                        value: widget.formData["lOne"],
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDataChanged({"lOne": newValue});
                          });
                        },
                      )),
                      const SizedBox(width: 8.0),
                      Expanded(
                          child: CheckboxListTile(
                        tristate: false,
                        title: Text("L2?"),
                        value: widget.formData["lTwo"],
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDataChanged({"lTwo": newValue});
                          });
                        },
                      )),
                      const SizedBox(width: 8.0),
                      Expanded(
                          child: CheckboxListTile(
                        tristate: false,
                        title: Text("L3?"),
                        value: widget.formData["lThree"],
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDataChanged({"lThree": newValue});
                          });
                        },
                      )),
                      const SizedBox(width: 8.0),
                      Expanded(
                          child: CheckboxListTile(
                        tristate: false,
                        title: Text("L4?"),
                        value: widget.formData["lFour"],
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDataChanged({"lFour": newValue});
                          });
                        },
                      )),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Divider(),
                  const Text(
                      "How long has each member of the drive team been in their role?"),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Driver",
                            suffixText: "Years"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          widget.onDataChanged(
                              {"driverYears": int.tryParse(value)});
                        },
                        controller: TextEditingController(
                          text: widget.formData["driverYears"] == null
                              ? ''
                              : widget.formData["driverYears"].toString(),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Operator",
                            suffixText: "Years"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          widget.onDataChanged(
                              {"operatorYears": int.tryParse(value)});
                        },
                        controller: TextEditingController(
                          text: widget.formData["operatorYears"] == null
                              ? ''
                              : widget.formData["operatorYears"].toString(),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Coach",
                            suffixText: "Years"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          widget.onDataChanged(
                              {"coachYears": int.tryParse(value)});
                        },
                        controller: TextEditingController(
                          text: widget.formData["coachYears"] == null
                              ? ''
                              : widget.formData["coachYears"].toString(),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: CheckboxListTile(
                        tristate: false,
                        title: Text("Adult Coach?"),
                        value: widget.formData["isCoachAdult"],
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDataChanged({"isCoachAdult": newValue});
                          });
                        },
                      )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Has Auton'),
                          value: widget.formData["autonExists"],
                          onChanged: (bool? newValue) {
                            setState(() {
                              widget.onDataChanged({"autonExists": newValue!});
                            });
                          },
                        ),
                        if (widget.formData["autonExists"])
                          Column(
                            children: [
                              const Text(
                                "Auton HERE!!!",
                                style:
                                    TextStyle(fontSize: 36, color: Colors.red),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
