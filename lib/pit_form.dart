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
  late TextEditingController _wController;
  late TextEditingController _lController;
  late TextEditingController _hController;
  late TextEditingController _sController;
  @override
  void initState() {
    super.initState();
    _wController = TextEditingController(text: widget.formData["hopperWidth"]?.toString() ?? "");
    _lController = TextEditingController(text: widget.formData["hopperLength"]?.toString() ?? "");
    _hController = TextEditingController(text: widget.formData["hopperHeight"]?.toString() ?? "");
    _sController = TextEditingController(text: widget.formData["hopperStorageEstimate"]?.toString() ?? "");
  }
  void _updateTotal() {
  double w = (widget.formData["hopperWidth"] as num? ?? 0) - 2.955.toDouble();
  double l = (widget.formData["hopperLength"] as num? ?? 0) - 2.955.toDouble();
  double h = (widget.formData["hopperHeight"] as num? ?? 0) - 2.955.toDouble();
  

  if (w > 0 && l > 0 && h > 0) {
    double result = (w * l * h * 0.60) / 108.08;
    if (result < 0) {
      result = 0;
    }

    setState(() {
      _sController.text = result.toStringAsFixed(1);
      widget.onDataChanged({"hopperStorageEstimate": result});
    });
  }
}

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
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Height',
                            suffixText: 'inches',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
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
                            // Expanded
                            // (
                            //   child: RadioListTile(
                            //     key: Key("pit-kitbot"),
                            //     title: Text("Significantly Modified Kitbot"),
                            //     value: 
                            //     widget.formData["kitbotType"] == "sigModifiedKitbot",
                            //     groupValue: true,
                            //     onChanged: (value)
                            //     {
                            //       setState(() {
                            //         widget.onDataChanged(
                            //           getKitbotData(KitBotTypes.sigModifiedKitbot));
                            //       }
                            //       );
                            //     },
                            //   ),
                            //   ),
                          ],
                        ),
                        
                        if (widget.formData["kitbotType"] != "not" && widget.formData["kitbotType"] != "sigModifiedKitbot")
                          CheckboxListTile(
                              title: const Text("Significantly Modified?"),
                              value: widget.formData["isSigModifiedKit"] ?? false,
                              onChanged: (value) {
                                setState(() {
                                  widget
                                      .onDataChanged({"isSigModifiedKit": value});
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
                  // RatingInput(
                  //   enableHalves: false,
                  //   title: 'Repairability',
                  //   onRatingUpdate: (newValue) {
                  //     widget.onDataChanged({"repairability": newValue});
                  //   },
                  //   initialRating: widget.formData["repairability"],
                  // ),
                  // const SizedBox(height: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Movement"),
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
                        
                        _buildClimbRow(context, "Front", "Front"),
                        _buildClimbRow(context, "Side (Left or Right)", "Side (Left or Right)"),
                        
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  _buildClimbedBackCheckbox(context, "Climb From Back?"),
                  /*const SizedBox(height: 12.0),
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
                  ),*/
                  const SizedBox(height: 8.0),  
                  _buildSpeedControl(context, "Climb Speed (Seconds)"),     
                  
                  /*
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
                              title: "Average Storage",
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
                      */
                      const SizedBox(height: 8.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  
                  // ],
                  // ),
                  
                      const Text(
                      "Storage (Hopper) Dimensions"),
                  const SizedBox(height: 8.0),
                  
                  Row(
  children: [
    Expanded(
      child: TextField(
        controller: _wController, 
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Hopper Width",
          suffixText: "Inches",
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          LengthLimitingTextInputFormatter(5),
        ],
        onChanged: (value) {
          widget.onDataChanged({"hopperWidth": double.tryParse(value)});
          _updateTotal();
        },
      ),
    ),
    const SizedBox(width: 8),

    Expanded(
      child: TextField(
        controller: _lController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Hopper Length",
          suffixText: "Inches",
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          LengthLimitingTextInputFormatter(5),
        ],
        onChanged: (value) {
          widget.onDataChanged({"hopperLength": double.tryParse(value)});
          _updateTotal();
        },
      ),
    ),
    const SizedBox(width: 8),

    Expanded(
      child: TextField(
        controller: _hController, 
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Hopper Height",
          suffixText: "Inches",
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          LengthLimitingTextInputFormatter(5),
        ],
        onChanged: (value) {
          widget.onDataChanged({"hopperHeight": double.tryParse(value)});
          _updateTotal();
        },
      ),
    ),
    const SizedBox(width: 8),

    Expanded(
      child: TextField(
        controller: _sController, 
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Hopper Storage Estimate",
          suffixText: "Amount of Fuel",
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          LengthLimitingTextInputFormatter(5),
        ],
        onChanged: (value) {
          widget.onDataChanged({"hopperStorageEstimate": double.tryParse(value)});
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
                          ButtonSegment(
                            value: ShooterTypes.big,
                            label: Text('Big Shooter')),
                          ButtonSegment(
                            value: ShooterTypes.other,
                            label: Text('Other')),
                        ],
                        selected: {
                          if (widget.formData["turret"] != null && widget.formData["turret"])
                            ShooterTypes.turret,
                          if (widget.formData["hood"] != null && widget.formData["hood"])
                            ShooterTypes.hood,
                          if (widget.formData["bigShooter"] != null && widget.formData["bigShooter"])
                            ShooterTypes.big,
                          if (widget.formData["other"] != null && widget.formData["other"])
                            ShooterTypes.other,
                        },
                        onSelectionChanged: (Set<ShooterTypes> newSelection) {
                          setState(() {
                            widget.onDataChanged({
                              "turret": newSelection.contains(ShooterTypes.turret),
                              "hood": newSelection.contains(ShooterTypes.hood),
                              "bigShooter": newSelection.contains(ShooterTypes.big),
                              "other": newSelection.contains(ShooterTypes.other),
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
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Autonomous"),
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
                              const SizedBox(height: 8.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  
                  // ],
                  // ),
                              const Text(
                                  "What positions can they travel/do during auton?"),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SegmentedButton<AchievablePosition>(
                                      emptySelectionAllowed: true,
                                      multiSelectionEnabled: true,
                                      style: ButtonStyle(
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.all(18.0))),
                                      segments: <ButtonSegment<AchievablePosition>>[
                                        ButtonSegment(
                                            value: AchievablePosition.depot,
                                            label: Text("Depot")),
                                        ButtonSegment(
                                            value: AchievablePosition.outpost,
                                            label: Text("Outpost")),
                                        ButtonSegment(
                                            value: AchievablePosition.neutral,
                                            label: Text("Neutral")),
                                        ButtonSegment(
                                            value: AchievablePosition.climb,
                                            label: Text("Climb"))
                                      ],
                                      selected: {
                                        if (widget.formData['canDepot'])
                                          AchievablePosition.depot,
                                        if (widget.formData['canOutpost'])
                                          AchievablePosition.outpost,
                                        if (widget.formData['canNeutral'])
                                          AchievablePosition.neutral,
                                          if (widget.formData['canClimb'])
                                          AchievablePosition.climb
                                      },
                                      onSelectionChanged:
                                          (Set<AchievablePosition> value) {
                                        setState(() {
                                          widget.onDataChanged({
                                            "canDepot": value
                                                .contains(AchievablePosition.depot),
                                            "canOutpost": value
                                                .contains(AchievablePosition.outpost),
                                            "canNeutral": value
                                                .contains(AchievablePosition.neutral),
                                            "canClimb": value
                                            .contains(AchievablePosition.climb)
                                          });
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
                  const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Flexible(
                            child: NumberInput(
                              title: "Fuel Scored in Auton",
                              enableSpacer: true,
                              value: widget.formData["autonFuel"],
                              onValueAdd: () {
                                setState(() {
                                    widget.onDataChanged({
                                    "autonFuel": widget.formData[
                                            "autonFuel"] +
                                        4
                                  });
                                  
                                });
                              },
                              onValueSubtract: () {
                                setState(() {
                                  if (widget
                                          .formData["autonFuel"] >
                                      0) {
                                    widget.onDataChanged({
                                      "autonFuel": widget.formData[
                                              "autonFuel"] -
                                          4
                                    });
                                  } else {
                                    widget.onDataChanged(
                                        {"autonFuel": 0});
                                  }
                                });
                              },
                            ),
                          ),
                        ]
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
                  const SizedBox(height: 10),
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
                            "Remember to bring board to trace auton path and take pictures",
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
  
  Widget _buildClimbedBackCheckbox(
      BuildContext context, String dataKey) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Row(
        children: [
          Checkbox(
            value: widget.formData[dataKey] ?? false,
            onChanged: (bool? value) {
              setState(() {
                widget.onDataChanged({dataKey: value ?? false});
              });
            },
          ),
          Expanded(
            child: Text(
              dataKey,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedControl(BuildContext context, String climbSpeedLabel) {
  final speedKey = "climbSpeedLabel";
  var speed = widget.formData[speedKey] ?? 3;

  if (speed < 3) {
    speed = 3;
    widget.onDataChanged({speedKey: 3});
  }

  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Theme.of(context).dividerColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: const EdgeInsets.all(12.0),
    child: Column(
      children: [
        Text(
          climbSpeedLabel,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8.0),
        
        Row(
          children: [
            const Text(
              "3",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Slider(
                value: speed.toDouble(),
                min: 3,
                max: 30,
                divisions: 27,
                onChanged: (value) {
                  setState(() {
                    widget.onDataChanged({speedKey: value.toInt()});
                  });
                },
              ),
            ),
            const Text(
              "30",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        
        Text(
          speed.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    ),
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
@override
  void dispose() {
    _wController.dispose();
    _lController.dispose();
    _hController.dispose();
    _sController.dispose();
    super.dispose();
  }
  
}
