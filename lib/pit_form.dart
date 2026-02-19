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
                      Text("General Robot Information"),
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
                    children: [
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
                      const Text("Movement"),
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
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Climbing"),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        // Header row (Level labels)
                        Container(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  height: 50,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  height: 50,
                                  child: const Text(
                                    "Level 1",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  height: 50,
                                  child: const Text(
                                    "Level 2",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: const Text(
                                    "Level 3",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Front row
                        _buildClimbRow(context, "Front", "Front"),
                        // Back row
                        _buildClimbRow(context, "Back", "Back"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Climb Time Increment',
                      suffixText: "seconds",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      widget.onDataChanged({"climbTime": int.tryParse(value)});
                    },
                    controller: TextEditingController(
                      text: widget.formData["climbTime"] == null
                          ? ''
                          : widget.formData["climbTime"].toString(),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Storage"),
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
                        children: [
                          Flexible(
                            child: NumberInput(
                              title: "Minimum Storage",
                              enableSpacer: true,
                              value: widget.formData["minStorage"],
                              onValueAdd: () {
                                setState(() {
                                  widget.onDataChanged({
                                    "minStorage": widget.formData[
                                            "minStorage"] +
                                        5
                                        
                                  });
                                  if (widget.formData["minStorage"] >
                                      widget.formData["maxStorage"]) {
                                    widget.onDataChanged({
                                      "maxStorage": widget.formData[
                                              "minStorage"]
                                    });
                                  }
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
                              title: "Maximum Storage",
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
                  
                  // ],
                  // ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Intake"),
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
                        
                        const Text("Type of intake?"),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-intake"),
                                title: Text("Slapdown"),
                                value: widget.formData["intakeType"] == "slapdown",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged({
                                      "intakeType": "slapdown"
                                    });
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-intake"),
                                title: Text("Four-Bar"),
                                value:
                                    widget.formData["intakeType"] == "fourbar",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged({
                                      "intakeType": "fourbar"
                                    });
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
                                key: Key("pit-intake"),
                                title: Text("Open-Bumper"),
                                value: widget.formData["intakeType"] == "openbumper",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged(
                                        {"intakeType": "openbumper"});
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                key: Key("pit-intake"),
                                title: Text("Bucket"),
                                value: widget.formData["intakeType"] == "bucket",
                                groupValue: true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.onDataChanged(
                                        {"intakeType": "bucket"});
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Shooter"),
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
                      const Text("Shooter"),
                      const SizedBox(width: 8.0),
                      SegmentedButton<ShooterTypes>(
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
                        segments: <ButtonSegment<ShooterTypes>>[
                          ButtonSegment(
                              value: ShooterTypes.turret,
                              label: Text('Turret')),
                          ButtonSegment(
                              value: ShooterTypes.hood,
                              label: Text('Hood')),

                        ],
                        selected: {
                          if (widget.formData["turret"] != null &&
                              widget.formData["turret"])
                            ShooterTypes.turret,
                          if (widget.formData["hood"] != null &&
                              widget.formData["hood"])
                            ShooterTypes.hood,
                        },
                        onSelectionChanged: (Set<ShooterTypes> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "turret": newSelection.contains(ShooterTypes.turret),
                              "hood": newSelection.contains(ShooterTypes.hood),
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
                              title: "Number of Shooters",
                              enableSpacer: true,
                              value: widget.formData["numShooters"],
                              onValueAdd: () {
                                setState(() {
                                  if (widget.formData["numShooters"] < 3)
                                  {
                                    widget.onDataChanged({
                                    "numShooters": widget.formData[
                                            "numShooters"] +
                                        1
                                  });
                                  }
                                });
                              },
                              onValueSubtract: () {
                                setState(() {
                                  if (widget
                                          .formData["numShooters"] >
                                      0) {
                                    widget.onDataChanged({
                                      "numShooters": widget.formData[
                                              "numShooters"] -
                                          1
                                    });
                                  } else {
                                    widget.onDataChanged(
                                        {"numShooters": 1});
                                  }
                                });
                              },
                            ),
                          ),
                        ]
                      ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Strategy"),
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
                      const Text("Role"),
                      const SizedBox(width: 8.0),
                      SegmentedButton<TeleopRole>(
                        style: ButtonStyle(
                            padding:
                                WidgetStateProperty.all(EdgeInsets.all(18.0))),
                        segments: <ButtonSegment<TeleopRole>>[
                          ButtonSegment(
                              value: TeleopRole.score, label: Text('Score')),
                          ButtonSegment(
                              value: TeleopRole.shunt,
                              label: Text('Shunt')),
                          ButtonSegment(
                              value: TeleopRole.defense, label: Text('Defense')),
                        ],
                        selected: {
                          if (widget.formData["score"] != null &&
                              widget.formData["score"])
                            TeleopRole.score,
                          if (widget.formData["shunt"] != null &&
                              widget.formData["shunt"])
                            TeleopRole.shunt,
                          if (widget.formData["defense"] != null &&
                              widget.formData["defense"])
                            TeleopRole.defense,
                        },
                        onSelectionChanged: (Set<TeleopRole> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "score":
                                  newSelection.contains(TeleopRole.score),
                              "shunt":
                                  newSelection.contains(TeleopRole.shunt),
                              "defense": newSelection.contains(TeleopRole.defense),
                            });
                          });
                        },
                        multiSelectionEnabled: true,
                        emptySelectionAllowed: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
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
                      "Grade levels of drive team members (coach if applicable, otherwise leave blank)"),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Driver",
                            suffixText: "Grade"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          widget.onDataChanged(
                              {"driverGrade": int.tryParse(value)});
                        },
                        controller: TextEditingController(
                          text: widget.formData["driverGrade"] == null
                              ? ''
                              : widget.formData["driverGrade"].toString(),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Operator",
                            suffixText: "Grade"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          widget.onDataChanged(
                              {"operatorGrade": int.tryParse(value)});
                        },
                        controller: TextEditingController(
                          text: widget.formData["operatorGrade"] == null
                              ? ''
                              : widget.formData["operatorGrade"].toString(),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Coach",
                            suffixText: "Grade"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          widget.onDataChanged(
                              {"coachGrade": int.tryParse(value)});
                        },
                        controller: TextEditingController(
                          text: widget.formData["coachGrade"] == null
                              ? ''
                              : widget.formData["coachGrade"].toString(),
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

  Row _buildClimbRow(BuildContext context, String rowLabel, String position) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            height: 70,
            child: Text(
              rowLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          child: _buildClimbCell(context, "climb${position}L1"),
        ),
        Expanded(
          child: _buildClimbCell(context, "climb${position}L2"),
        ),
        Expanded(
          child: _buildClimbCell(context, "climb${position}L3"),
        ),
      ],
    );
  }

  Container _buildClimbCell(BuildContext context, String dataKey) {
    final isChecked = widget.formData[dataKey] ?? false;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      height: 70,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              widget.onDataChanged({dataKey: !isChecked});
            });
          },
          child: Container(
            color: isChecked
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Colors.transparent,
            alignment: Alignment.center,
            child: Checkbox(
              value: isChecked,
              onChanged: (bool? newValue) {
                setState(() {
                  widget.onDataChanged({dataKey: newValue ?? false});
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
