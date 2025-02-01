import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';

import 'widgets.dart';

class PitForm extends StatefulWidget { //TODO: Human player preferences
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

enum AlgaePositions { processor, barge, descore }

enum ClimbPositions { shallow, deep }

enum Role { coral, algae, defense, feed }

enum StartPosition { Left, Middle, Right }

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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Physical Size"),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(),
                        ),
                      ),
                    ],
                  ),
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
                            "Weight must NOT include battery and bumper",
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Mechanisms"),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(),
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
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Repairability:  "),
                      StarRating(
                      rating: widget.formData["repairability"],
                      size: 40,
                      color: Theme.of(context).indicatorColor,
                      allowHalfRating: true,
                      onRatingChanged: (rating) => setState(() {widget.onDataChanged({"repairability": rating});})
                    
                    )],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Scoring"),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Algae"),
                      const SizedBox(width: 8.0),
                      SegmentedButton<AlgaePositions>(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return ColorScheme.fromSeed(
                                          seedColor: Colors.green)
                                      .primary;
                                }
                                return Colors.transparent;
                              },
                            ),
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(18.0))),
                        segments: <ButtonSegment<AlgaePositions>>[
                          ButtonSegment(
                              value: AlgaePositions.processor,
                              label: Text('Processor')),
                          ButtonSegment(
                              value: AlgaePositions.barge,
                              label: Text('Barge')),
                          ButtonSegment(
                              value: AlgaePositions.descore,
                              label: Text('Descore')),
                        ],
                        selected: {
                          if (widget.formData["processor"] != null &&
                              widget.formData["processor"])
                            AlgaePositions.processor,
                          if (widget.formData["barge"] != null &&
                              widget.formData["barge"])
                            AlgaePositions.barge,
                          if (widget.formData["descore"] != null &&
                              widget.formData["descore"])
                            AlgaePositions.descore,
                        },
                        onSelectionChanged: (Set<AlgaePositions> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "processor": newSelection
                                  .contains(AlgaePositions.processor),
                              "barge":
                                  newSelection.contains(AlgaePositions.barge),
                              "descore":
                                  newSelection.contains(AlgaePositions.descore)
                            });
                          });
                        },
                        multiSelectionEnabled: true,
                        emptySelectionAllowed: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Coral"),
                      const SizedBox(width: 8.0),
                      SegmentedButton<CoralPositions>(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return ColorScheme.fromSeed(
                                          seedColor: Colors.purple)
                                      .primary;
                                }
                                return Colors.transparent;
                              },
                            ),
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(18.0))),
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
                        selected: {
                          if (widget.formData["lOne"] != null &&
                              widget.formData["lOne"])
                            CoralPositions.lOne,
                          if (widget.formData["lTwo"] != null &&
                              widget.formData["lTwo"])
                            CoralPositions.lTwo,
                          if (widget.formData["lThree"] != null &&
                              widget.formData["lThree"])
                            CoralPositions.lThree,
                          if (widget.formData["lFour"] != null &&
                              widget.formData["lFour"])
                            CoralPositions.lFour,
                        },
                        onSelectionChanged: (Set<CoralPositions> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "lOne":
                                  newSelection.contains(CoralPositions.lOne),
                              "lTwo":
                                  newSelection.contains(CoralPositions.lTwo),
                              "lThree":
                                  newSelection.contains(CoralPositions.lThree),
                              "lFour":
                                  newSelection.contains(CoralPositions.lFour)
                            });
                          });
                        },
                        multiSelectionEnabled: true,
                        emptySelectionAllowed: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Climbing"),
                      const SizedBox(width: 8.0),
                      SegmentedButton<ClimbPositions>(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return ColorScheme.fromSeed(
                                          seedColor: Colors.blue)
                                      .primary;
                                }
                                return Colors.transparent;
                              },
                            ),
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(18.0))),
                        segments: <ButtonSegment<ClimbPositions>>[
                          ButtonSegment(
                              value: ClimbPositions.shallow,
                              label: Text('Shallow Climb')),
                          ButtonSegment(
                              value: ClimbPositions.deep,
                              label: Text('Deep Climb')),
                        ],
                        selected: {
                          if (widget.formData["shallowClimb"] != null &&
                              widget.formData["shallowClimb"])
                            ClimbPositions.shallow,
                          if (widget.formData["deepClimb"] != null &&
                              widget.formData["deepClimb"])
                            ClimbPositions.deep,
                        },
                        onSelectionChanged: (Set<ClimbPositions> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "shallowClimb":
                                  newSelection.contains(ClimbPositions.shallow),
                              "deepClimb":
                                  newSelection.contains(ClimbPositions.deep),
                            });
                          });
                        },
                        multiSelectionEnabled: true,
                        emptySelectionAllowed: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Role (Cycle)"),
                      const SizedBox(width: 8.0),
                      SegmentedButton<Role>(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return ColorScheme.fromSeed(
                                          seedColor: Colors.red)
                                      .primary;
                                }
                                return Colors.transparent;
                              },
                            ),
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(18.0))),
                        segments: <ButtonSegment<Role>>[
                          ButtonSegment(
                              value: Role.coral,
                              label: Text('Coral')
                          ),
                          ButtonSegment(
                              value: Role.algae,
                              label: Text('Algae')
                          ),
                          ButtonSegment(
                              value: Role.defense,
                              label: Text('Defense')
                          ),
                          ButtonSegment(
                              value: Role.feed,
                              label: Text('Feeding')
                          ),
                        ],
                        selected: {
                          if (widget.formData["coralCycle"] != null &&
                              widget.formData["coralCycle"])
                            Role.coral,
                          if (widget.formData["algaeCycle"] != null &&
                              widget.formData["algaeCycle"])
                            Role.algae,
                          if (widget.formData["defense"] != null &&
                              widget.formData["defense"])
                            Role.defense,
                          if (widget.formData["feed"] != null &&
                              widget.formData["feed"])
                            Role.feed,
                        },
                        onSelectionChanged: (Set<Role> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "coralCycle":
                                  newSelection.contains(Role.coral),
                              "algaeCycle":
                                  newSelection.contains(Role.algae),
                              "defense":
                                  newSelection.contains(Role.defense),
                              "feed":
                                  newSelection.contains(Role.feed),
                            });
                          });
                        },
                        multiSelectionEnabled: true,
                        emptySelectionAllowed: true,
                      ),
                    ],
                  ),
                  const SizedBox(width: 100.0),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Drive Team"),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(),
                        ),
                      ),
                    ],
                  ),
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
                          flex: 2,
                          child: CheckboxListTile(
                            tristate: false,
                            title: Text("Adult Coach?"),
                            value: widget.formData["isCoachAdult"],
                            onChanged: (bool? newValue) {
                              setState(() {
                                widget
                                    .onDataChanged({"isCoachAdult": newValue});
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
                        if (widget.formData["autonExists"]) SwitchListTile(
                          title: const Text("Just Exit?"),
                          value: widget.formData["justExit"],
                          onChanged: (bool? newValue) {
                            setState(() {
                              widget.onDataChanged({"justExit": newValue!});
                            });
                          },
                        ),
                        if (!widget.formData["justExit"] && widget.formData["autonExists"])
                          Column(
                            children: [
                              
                              Row(
                                children: [
                                  Expanded(
                                    child: SegmentedButton(
                                      emptySelectionAllowed: true,
                                      multiSelectionEnabled: true,
                                      segments: <ButtonSegment<StartPosition>>[
                                        ButtonSegment(value: StartPosition.Left, label: Text("LEFT")),
                                        ButtonSegment(value: StartPosition.Middle, label: Text("MIDDLE")),
                                        ButtonSegment(value: StartPosition.Right, label: Text("RIGHT"))
                                      ], 
                                      selected: {
                                        if (widget.formData['canAutoLeft'])
                                          StartPosition.Left,
                                        if (widget.formData['canAutoMid'])
                                          StartPosition.Middle,
                                        if (widget.formData['canAutoRight'])
                                          StartPosition.Right
                                      },
                                      onSelectionChanged: (Set<StartPosition> value) {
                                        setState(() {
                                          widget.onDataChanged(
                                            {
                                              "canAutoLeft" : value.contains(StartPosition.Left),
                                              "canAutoMid" : value.contains(StartPosition.Middle),
                                              "canAutoRight" : value.contains(StartPosition.Right),                                      
                                            }
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Autonomous Strategy"
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(250),
                                ],
                                onChanged: (value) {
                                  widget.onDataChanged(
                                      {"autonStrategy": value});
                                },
                                controller: TextEditingController(
                                  text: 
                                  widget.formData["autonStrategy"] == null
                                  ? '' : widget.formData["autonStrategy"].toString(),
                                ),

                              ),
                              
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'General Comments (Optional)',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(500),
                      FilteringTextInputFormatter(RegExp(r'[^|*]+'),
                          allow: true)
                    ],
                    onChanged: (value) {
                      widget.onDataChanged(
                          {"notes": value.replaceAll("\n", "**")});
                    },
                    minLines: 3,
                    maxLines: 7,
                    controller: TextEditingController(
                      text: widget.formData["notes"] == null
                          ? ''
                          : widget.formData["notes"]
                              .toString()
                              .replaceAll("**", "\n"),
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
