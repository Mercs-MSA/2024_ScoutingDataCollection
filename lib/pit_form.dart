import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mercs_scout/data_maps.dart';
import 'package:mercs_scout/datatypes.dart';

import 'widgets.dart';

class PitForm extends StatefulWidget {
  const PitForm({
    super.key,
    required this.teamNumberPresent,
    required this.onDataChanged,
    required this.formData,
    required this.colorDebug,
  });

  final bool teamNumberPresent;

  final Function(Map<String, dynamic>) onDataChanged;
  final Map formData;
  final bool colorDebug;

  @override
  State<PitForm> createState() => _PitFormState();
}

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
                  const SizedBox(height: 8.0),
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
                      Text("Mechanical"),
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
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0, color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        const Text("Is the robot a Kitbot, if so, what type?"),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-kitbot"),
                                title: Text("Custom"),
                                value: widget.formData["kitbotType"] == "not",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged(
                                        getKitbotData(KitBotTypes.not));
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-kitbot"),
                                title: Text("Kitbot"),
                                value:
                                    widget.formData["kitbotType"] == "kitbot",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged(
                                      getKitbotData(KitBotTypes.kitbot),
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-kitbot"),
                                title: Text("WCP"),
                                value: widget.formData["kitbotType"] == "wcp",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged(
                                        getKitbotData(KitBotTypes.wcp));
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-kitbot"),
                                title: Text("REV"),
                                value: widget.formData["kitbotType"] == "rev",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged(
                                        getKitbotData(KitBotTypes.rev));
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-kitbot"),
                                title: Text("Everybot"),
                                value:
                                    widget.formData["kitbotType"] == "everybot",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged(
                                        getKitbotData(KitBotTypes.everybot));
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        if (widget.formData["kitbotType"] != "not")
                          CheckboxListTile(
                              title: const Text("Modified?"),
                              value: widget.formData["isModifiedKit"],
                              onChanged: (value) {
                                setState(() {
                                  widget
                                      .onDataChanged({"isModifiedKit": value});
                                });
                              }),
                      ],
                    ),
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
                    options: const ["Swerve", "Tank", "Mecanum", "Omni", "H-Drive"],
                  ),
                  const SizedBox(height: 8.0),
                  RatingInput(
                    enableHalves: false,
                    title: 'Repairability',
                    onRatingUpdate: (newValue) {
                      widget.onDataChanged({"repairability": newValue});
                    },
                    initialRating: widget.formData["repairability"],
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
                                    seedColor: widget.colorDebug
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 78, 180, 127),
                                  ).primary;
                                }
                                return Colors.transparent;
                              },
                            ),
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(18.0))),
                        segments: <ButtonSegment<AlgaePositions>>[
                          ButtonSegment(
                              value: AlgaePositions.trench,
                              label: Text('Trench')),
                          ButtonSegment(
                              value: AlgaePositions.bump,
                              label: Text('Bump')),
                          // Descore removed
                        ],
                        selected: {
                          if (widget.formData["trench"] != null &&
                              widget.formData["trench"])
                            AlgaePositions.trench,
                          if (widget.formData["bump"] != null &&
                              widget.formData["bump"])
                            AlgaePositions.bump,
                          // descore removed
                        },
                        onSelectionChanged: (Set<AlgaePositions> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "trench": newSelection
                                  .contains(AlgaePositions.trench),
                              "bump": newSelection.contains(AlgaePositions.bump),
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
                              value: ClimbPositions.one,
                              label: Text('Shallow Climb')),
                          ButtonSegment(
                              value: ClimbPositions.two,
                              label: Text('Deep Climb')),
                        ],
                        selected: {
                          if (widget.formData["shallowClimb"] != null &&
                              widget.formData["shallowClimb"])
                            ClimbPositions.one,
                          if (widget.formData["deepClimb"] != null &&
                              widget.formData["deepClimb"])
                            ClimbPositions.two,
                        },
                        onSelectionChanged: (Set<ClimbPositions> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "shallowClimb":
                                  newSelection.contains(ClimbPositions.one),
                              "deepClimb":
                                  newSelection.contains(ClimbPositions.two),
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
                        children: [
                          Flexible(
                            child: NumberInput(
                              title: "Minimum",
                              enableSpacer: true,
                              value: widget.formData["minStorage"],
                              onValueAdd: () {
                                setState(() {
                                  widget.onDataChanged({
                                    "minStorage": widget.formData[
                                            "minStorage"] +
                                        5
                                  });
                                });
                              },
                              onValueSubtract: () {
                                setState(() {
                                  if (widget
                                          .formData["minStorage"] >
                                      0) {
                                    widget.onDataChanged({
                                      "minStorage": widget.formData[
                                              "minStorage"] -
                                          5
                                    });
                                  } else {
                                    widget.onDataChanged(
                                        {"minStorage": 0});
                                  }
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: NumberInput(
                              title: "Maximum",
                              enableSpacer: true,
                              value: widget.formData["maxStorage"],
                              onValueAdd: () {
                                setState(() {
                                  widget.onDataChanged({
                                    "maxStorage": widget.formData[
                                            "maxStorage"] +
                                        5
                                  });
                                });
                              },
                              onValueSubtract: () {
                                setState(() {
                                  if (widget
                                          .formData["maxStorage"] >
                                      0) {
                                    widget.onDataChanged({
                                      "maxStorage": widget.formData[
                                              "maxStorage"] -
                                          5
                                    });
                                  } else {
                                    widget.onDataChanged(
                                        {"maxStorage": 0});
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(height: 8.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  CheckboxListTile(
                    title: Text("Ground intake?"),
                    value: widget.formData["groundIntake"],
                    onChanged: (bool? newValue) {
                      setState(() {
                        widget.onDataChanged({"groundIntake": newValue});
                      });
                    },
                  ),
                  // ],
                  // ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("TeleOp Strategy"),
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
                      const Text("Role (Cycle)"),
                      const SizedBox(width: 8.0),
                      SegmentedButton<TeleopRole>(
                        style: ButtonStyle(
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(18.0))),
                        segments: <ButtonSegment<TeleopRole>>[
                          ButtonSegment(
                              value: TeleopRole.shooter, label: Text('Coral')),
                          ButtonSegment(
                              value: TeleopRole.defense,
                              label: Text('Defense')),
                          ButtonSegment(
                              value: TeleopRole.feed, label: Text('Feeding')),
                        ],
                        selected: {
                          if (widget.formData["coralCycle"] != null &&
                              widget.formData["coralCycle"])
                            TeleopRole.shooter,
                          if (widget.formData["defense"] != null &&
                              widget.formData["defense"])
                            TeleopRole.defense,
                          if (widget.formData["feed"] != null &&
                              widget.formData["feed"])
                            TeleopRole.feed,
                        },
                        onSelectionChanged: (Set<TeleopRole> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "shooter":
                                  newSelection.contains(TeleopRole.shooter),
                              "defense":
                                  newSelection.contains(TeleopRole.defense),
                              "feed": newSelection.contains(TeleopRole.feed),
                            });
                          });
                        },
                        multiSelectionEnabled: true,
                        emptySelectionAllowed: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(children: [
                    const Text("Human Player"),
                    const SizedBox(width: 10.0),
                    Flexible(
                      child: ChoiceInput(
                        title: "Preferred Location",
                        onChoiceUpdate: (value) {
                          setState(() {
                            widget
                                .onDataChanged({"humanPlayerLocation": value!});
                          });
                        },
                        choice: widget.formData["humanPlayerLocation"],
                        options: const ["Coral", "Trench", "Either"],
                      ),
                    ),
                  ]),
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
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Software"),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(),
                        ),
                      ),
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
                              SwitchListTile(
                                title: const Text("Exits?"),
                                value: widget.formData["autonExit"],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    widget.onDataChanged(
                                        {"autonExit": newValue!});
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              const Text(
                                  "What positions are they capable of starting an auto?"),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SegmentedButton<StartPosition>(
                                      emptySelectionAllowed: true,
                                      multiSelectionEnabled: true,
                                      style: ButtonStyle(
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.all(18.0))),
                                      segments: <ButtonSegment<StartPosition>>[
                                        ButtonSegment(
                                            value: StartPosition.left,
                                            label: Text("Left")),
                                        ButtonSegment(
                                            value: StartPosition.middle,
                                            label: Text("Middle")),
                                        ButtonSegment(
                                            value: StartPosition.right,
                                            label: Text("Right"))
                                      ],
                                      selected: {
                                        if (widget.formData['canAutoLeft'])
                                          StartPosition.left,
                                        if (widget.formData['canAutoMid'])
                                          StartPosition.middle,
                                        if (widget.formData['canAutoRight'])
                                          StartPosition.right
                                      },
                                      onSelectionChanged:
                                          (Set<StartPosition> value) {
                                        setState(() {
                                          widget.onDataChanged({
                                            "canAutoLeft": value
                                                .contains(StartPosition.left),
                                            "canAutoMid": value
                                                .contains(StartPosition.middle),
                                            "canAutoRight": value
                                                .contains(StartPosition.right),
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SectionHeader(
                                      title: "Coral Scoring",
                                      color: Theme.of(context).dividerColor),
                                  SizedBox(width: 10.0),
                                  SectionHeader(
                                      title: "Algae Scoring",
                                      color: Theme.of(context).dividerColor)
                                ],
                              ),
                              Row(mainAxisSize: MainAxisSize.max, children: [
                                Expanded(
                                  child: Column(children: [
                                    Column(
                                      children: [
                                        NumberInput(
                                          title: "L4",
                                          enableSpacer: true,
                                        value: widget.formData["autonL4Num"] ?? 0,
                                          onValueAdd: () {
                                            setState(() {
                                              widget.onDataChanged({
                                                "autonL4Num": widget.formData[
                                                        "autonL4Num"] +
                                                    1
                                              });
                                            });
                                          },
                                          onValueSubtract: () {
                                            setState(() {
                                              if (widget
                                                      .formData["autonL4Num"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonL4Num": widget.formData[
                                                          "autonL4Num"] -
                                                      1
                                                });
                                              } else {
                                                widget.onDataChanged(
                                                    {"autonL4Num": 0});
                                              }
                                            });
                                          },
                                          inputType: InputType.coral,
                                        ),
                                        NumberInput(
                                          title: "L3",
                                          enableSpacer: true,
                                          value: widget.formData["autonL3Num"] ?? 0,
                                          onValueAdd: () {
                                            setState(() {
                                              widget.onDataChanged({
                                                "autonL3Num": widget.formData[
                                                        "autonL3Num"] +
                                                    1
                                              });
                                            });
                                          },
                                          onValueSubtract: () {
                                            setState(() {
                                              if (widget
                                                      .formData["autonL3Num"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonL3Num": widget.formData[
                                                          "autonL3Num"] -
                                                      1
                                                });
                                              } else {
                                                widget.onDataChanged(
                                                    {"autonL3Num": 0});
                                              }
                                            });
                                          },
                                          inputType: InputType.coral,
                                        ),
                                        NumberInput(
                                          title: "L2",
                                          enableSpacer: true,
                                          value: widget.formData["autonL2Num"] ?? 0,
                                          onValueAdd: () {
                                            setState(() {
                                              widget.onDataChanged({
                                                "autonL2Num": widget.formData[
                                                        "autonL2Num"] +
                                                    1
                                              });
                                            });
                                          },
                                          onValueSubtract: () {
                                            setState(() {
                                              if (widget
                                                      .formData["autonL2Num"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonL2Num": widget.formData[
                                                          "autonL2Num"] -
                                                      1
                                                });
                                              } else {
                                                widget.onDataChanged(
                                                    {"autonL2Num": 0});
                                              }
                                            });
                                          },
                                          inputType: InputType.coral,
                                        ),
                                        NumberInput(
                                          title: "L1",
                                          enableSpacer: true,
                                          value: widget.formData["autonL1Num"] ?? 0,
                                          onValueAdd: () {
                                            setState(() {
                                              widget.onDataChanged({
                                                "autonL1Num": widget.formData[
                                                        "autonL1Num"] +
                                                    1
                                              });
                                            });
                                          },
                                          onValueSubtract: () {
                                            setState(() {
                                              if (widget
                                                      .formData["autonL1Num"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonL1Num": widget.formData[
                                                          "autonL1Num"] -
                                                      1
                                                });
                                              } else {
                                                widget.onDataChanged(
                                                    {"autonL1Num": 0});
                                              }
                                            });
                                          },
                                          inputType: InputType.coral,
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    children: [
                                      NumberInput(
                                        title: "Upper Descore",
                                        enableSpacer: true,
                                        value: widget.formData["autonUpperAlgaeDescore"] ?? 0,
                                        onValueAdd: () {
                                          setState(() {
                                            widget.onDataChanged({
                                              "autonUpperAlgaeDescore": widget
                                                          .formData[
                                                      "autonUpperAlgaeDescore"] +
                                                  1
                                            });
                                          });
                                        },
                                        onValueSubtract: () {
                                          setState(
                                            () {
                                              if (widget.formData[
                                                      "autonUpperAlgaeDescore"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonUpperAlgaeDescore": widget
                                                              .formData[
                                                          "autonUpperAlgaeDescore"] -
                                                      1
                                                });
                                              } else {
                                                widget.onDataChanged({
                                                  "autonUpperAlgaeDescore": 0
                                                });
                                              }
                                            },
                                          );
                                        },
                                        inputType: InputType.algae,
                                        currColor: widget.colorDebug,
                                      ),
                                      NumberInput(
                                        title: "Lower Descore",
                                        enableSpacer: true,
                                        value: widget.formData["autonLowerAlgaeDescore"] ?? 0,
                                        onValueAdd: () {
                                          setState(() {
                                            widget.onDataChanged({
                                              "autonLowerAlgaeDescore": widget
                                                          .formData[
                                                      "autonLowerAlgaeDescore"] +
                                                  1
                                            });
                                          });
                                        },
                                        onValueSubtract: () {
                                          setState(
                                            () {
                                              if (widget.formData[
                                                      "autonLowerAlgaeDescore"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonLowerAlgaeDescore": widget
                                                              .formData[
                                                          "autonLowerAlgaeDescore"] -
                                                      1
                                                });
                                              } else {
                                                widget.onDataChanged({
                                                  "autonLowerAlgaeDescore": 0
                                                });
                                              }
                                            },
                                          );
                                        },
                                        inputType: InputType.algae,
                                        currColor: widget.colorDebug,
                                      ),
                                      NumberInput(
                                        title: "Trench",
                                        enableSpacer: true,
                                        value: widget.formData["autonTrench"] ?? 0,
                                        onValueAdd: () {
                                          setState(() {
                                            widget.onDataChanged({
                                              "autonTrench": widget.formData[
                                                      "autonTrench"] +
                                                  1
                                            });
                                          });
                                        },
                                        onValueSubtract: () {
                                          setState(
                                            () {
                                              if (widget.formData[
                                                      "autonTrench"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonTrench": widget
                                                              .formData[
                                                          "autonTrench"] -
                                                      1
                                                });
                                              } else {
                                                widget.onDataChanged(
                                                    {"autonTrench": 0});
                                              }
                                            },
                                          );
                                        },
                                        inputType: InputType.algae,
                                        currColor: widget.colorDebug,
                                      ),
                                      NumberInput(
                                        title: "Direct Net",
                                        enableSpacer: true,
                                        value: widget.formData["autonNetScore"] ?? 0,
                                        onValueAdd: () {
                                          setState(() {
                                            widget.onDataChanged({
                                              "autonNetScore": widget.formData[
                                                      "autonNetScore"] +
                                                  1
                                            });
                                          });
                                        },
                                        onValueSubtract: () {
                                          setState(
                                            () {
                                              if (widget.formData[
                                                      "autonNetScore"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonNetScore":
                                                      widget.formData[
                                                              "autonNetScore"] -
                                                          1
                                                });
                                              } else {
                                                widget.onDataChanged(
                                                    {"autonNetScore": 0});
                                              }
                                            },
                                          );
                                        },
                                        inputType: InputType.algae,
                                        currColor: widget.colorDebug,
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                              Column()
                            ],
                          ),
                        if (widget.formData["autonExists"])
                          Column(
                            children: [
                              const SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Autonomous Strategy"),
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(300),
                                  FilteringTextInputFormatter(RegExp(r'[^|*]+'),
                                      allow: true)
                                ],
                                onChanged: (value) {
                                  widget.onDataChanged({
                                    "autonStrategy":
                                        value.replaceAll("\n", "**")
                                  });
                                },
                                minLines: 2,
                                maxLines: 6,
                                controller: TextEditingController(
                                  text: widget.formData["autonStrategy"] == null
                                      ? ''
                                      : widget.formData["autonStrategy"]
                                          .toString()
                                          .replaceAll("**", "\n"),
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
                  const SizedBox(height: 8),
                  Card(
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: Text(
                            "Remember to take robot pictures",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold),
                          ),
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
