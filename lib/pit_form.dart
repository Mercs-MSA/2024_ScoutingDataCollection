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
                        const Text("Is the robot a Kitbot, is so, what type?"),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-kitbot"),
                                title: Text("Non-Kitbot"),
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
                    options: const ["Swerve", "Tank", "Other"],
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
                                          seedColor: widget.colorDebug ? Colors.green : const Color.fromARGB(255, 78, 180, 127),)
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
                          padding: WidgetStateProperty.all(
                            EdgeInsets.all(18.0),
                          ),
                        ),
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
                              value: TeleopRole.coral, label: Text('Coral')),
                          ButtonSegment(
                              value: TeleopRole.algae, label: Text('Algae')),
                          ButtonSegment(
                              value: TeleopRole.defense,
                              label: Text('Defense')),
                          ButtonSegment(
                              value: TeleopRole.feed, label: Text('Feeding')),
                        ],
                        selected: {
                          if (widget.formData["coralCycle"] != null &&
                              widget.formData["coralCycle"])
                            TeleopRole.coral,
                          if (widget.formData["algaeCycle"] != null &&
                              widget.formData["algaeCycle"])
                            TeleopRole.algae,
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
                              "coralCycle":
                                  newSelection.contains(TeleopRole.coral),
                              "algaeCycle":
                                  newSelection.contains(TeleopRole.algae),
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
                        options: const ["Coral", "Processor", "Either"],
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
                                  SectionHeader(title: "Coral Scoring", color: Theme.of(context).dividerColor),
                                  SizedBox(width: 10.0),
                                  SectionHeader(title: "Algae Scoring", color: Theme.of(context).dividerColor)
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
                                            value:
                                                widget.formData["autonL4Num"],
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
                                                if (widget.formData[
                                                        "autonL4Num"] >
                                                    0) {
                                                  widget.onDataChanged({
                                                    "autonL4Num":
                                                        widget.formData[
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
                                            value:
                                                widget.formData["autonL3Num"],
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
                                                if (widget.formData[
                                                        "autonL3Num"] >
                                                    0) {
                                                  widget.onDataChanged({
                                                    "autonL3Num":
                                                        widget.formData[
                                                                "autonL3Num"] -
                                                            1
                                                  });
                                                } else {
                                                  widget.onDataChanged(
                                                      {"autonL3Num": 0});
                                                }
                                              });
                                            },
                                            inputType: InputType.coral,),
                                        NumberInput(
                                            title: "L2",
                                            enableSpacer: true,
                                            value:
                                                widget.formData["autonL2Num"],
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
                                                if (widget.formData[
                                                        "autonL2Num"] >
                                                    0) {
                                                  widget.onDataChanged({
                                                    "autonL2Num":
                                                        widget.formData[
                                                                "autonL2Num"] -
                                                            1
                                                  });
                                                } else {
                                                  widget.onDataChanged(
                                                      {"autonL2Num": 0});
                                                }
                                              });
                                            },
                                            inputType: InputType.coral,),
                                        NumberInput(
                                            title: "L1",
                                            enableSpacer: true,
                                            value:
                                                widget.formData["autonL1Num"],
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
                                                if (widget.formData[
                                                        "autonL1Num"] >
                                                    0) {
                                                  widget.onDataChanged({
                                                    "autonL1Num":
                                                        widget.formData[
                                                                "autonL1Num"] -
                                                            1
                                                  });
                                                } else {
                                                  widget.onDataChanged(
                                                      {"autonL1Num": 0});
                                                }
                                              });
                                            },
                                            inputType: InputType.coral,),
                                      ],
                                    ),
                                  ]),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    children: [
                                      NumberInput(
                                        title: "Upper\nDescore",
                                        enableSpacer: true,
                                        value: widget
                                            .formData["autonUpperAlgaeDescore"],
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
                                        title: "Lower\nDescore",
                                        enableSpacer: true,
                                        value: widget
                                            .formData["autonLowerAlgaeDescore"],
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
                                        title: "Processor",
                                        enableSpacer: true,
                                        value:
                                            widget.formData["autonProcessor"],
                                        onValueAdd: () {
                                          setState(() {
                                            widget.onDataChanged({
                                              "autonProcessor": widget.formData[
                                                      "autonProcessor"] +
                                                  1
                                            });
                                          });
                                        },
                                        onValueSubtract: () {
                                          setState(
                                            () {
                                              if (widget.formData[
                                                      "autonProcessor"] >
                                                  0) {
                                                widget.onDataChanged({
                                                  "autonProcessor": widget
                                                              .formData[
                                                          "autonProcessor"] -
                                                      1
                                                });
                                              } else {
                                                widget.onDataChanged(
                                                    {"autonProcessor": 0});
                                              }
                                            },
                                          );
                                        },
                                        inputType: InputType.algae,
                                        currColor: widget.colorDebug,
                                      ),
                                      NumberInput(
                                        title: "Direct\nNet",
                                        enableSpacer: true,
                                        value: widget.formData["autonNetScore"],
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
