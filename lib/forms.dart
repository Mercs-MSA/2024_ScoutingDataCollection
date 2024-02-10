import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_elements/widgets.dart';

class RobotForm extends StatefulWidget {
  const RobotForm({
    super.key,
    required this.onTeamNumberUpdated,
    required this.onRepairabilityChanged,
    required this.onDrivebaseChanged,
    required this.onLengthChanged,
    required this.onWidthChanged,
    required this.onStagePassChanged,
    required this.onIntakeInBumperChanged,
    required this.onClimberTypeChanged,
    required this.onDoesSpeakerChanged,
    required this.onDoesAmpChanged,
    required this.onDoesTrapChanged,
    required this.onDoesSourcePickupChanged,
    required this.onDoesGroundPickupChnaged,
    required this.onDoesExtendShootChanged,
    required this.onDoesTurretShootChanged,
    required this.onAutonExistsChanged
  });

  final Function(int?) onTeamNumberUpdated;
  final Function(double) onRepairabilityChanged;
  final Function(String) onDrivebaseChanged;
  final Function(int?) onLengthChanged;
  final Function(int?) onWidthChanged;
  final Function(bool) onStagePassChanged;
  final Function(bool) onIntakeInBumperChanged;
  final Function(String) onClimberTypeChanged;
  final Function(bool) onDoesSpeakerChanged;
  final Function(bool) onDoesAmpChanged;
  final Function(bool) onDoesTrapChanged;
  final Function(bool) onDoesSourcePickupChanged;
  final Function(bool) onDoesGroundPickupChnaged;
  final Function(bool) onDoesExtendShootChanged;
  final Function(bool) onDoesTurretShootChanged;
  final Function(bool) onAutonExistsChanged;

  @override
  State<RobotForm> createState() => _RobotFormState();
}

class _RobotFormState extends State<RobotForm> {
  String asigneeData = '';
  int? teamNumber;
  double repairabilityScore = 0;
  String drivebaseType = "Swerve";
  String? altDriveType;

  int? widthData;
  int? lengthData;
  bool canPassStage = false;

  bool intakeInBumper = false;
  String climberType = "Tube-in-Tube";

  bool autonExists = false;

  bool doesSpeaker = true;
  bool doesAmp = true;
  bool doesTrap = false;

  bool doesGroundPickup = false;
  bool doesSourcePickup = false;

  bool doesTurretShoot = false;
  bool doesExtendShoot = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
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
                teamNumber = int.tryParse(value);
                widget.onTeamNumberUpdated(teamNumber);
              },
              controller: TextEditingController(
                text: teamNumber == null ? '' : teamNumber.toString(),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bot Width',
                      suffixText: "in",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    onChanged: (value) {
                      widthData = int.tryParse(value);
                      widget.onWidthChanged(widthData);
                    },
                    controller: TextEditingController(
                      text: widthData == null ? '' : widthData.toString(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bot Length',
                      suffixText: 'in',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    onChanged: (value) {
                      lengthData = int.tryParse(value);
                      widget.onLengthChanged(lengthData);
                    },
                    controller: TextEditingController(
                      text: lengthData == null ? '' : lengthData.toString(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ChoiceInput(
              title: "Drivebase",
              onChoiceUpdate: (value) {
                setState((){
                  drivebaseType = value!;
                  widget.onDrivebaseChanged(drivebaseType);
                });
              },
              choice: drivebaseType,
              options: const ["Swerve", "Tank", "Other"],
            ),
            const SizedBox(height: 8.0),
            Visibility(
              visible: drivebaseType == 'Other',
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Alternate Drivebase Type',
                      ),
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100),
                      ],
                      controller: TextEditingController(
                        text: altDriveType == null ? '' : altDriveType.toString(),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
            ),
            ChoiceInput(
              title: "Climber Type",
              onChoiceUpdate: (value) {
                setState(() {
                  climberType = value!;
                  widget.onClimberTypeChanged(climberType);
                });
              },
              choice: climberType,
              options: const ["Tube-in-Tube", "Lead Screw", "Hook and Winch", "Elevator", "Other"],
            ),
            const SizedBox(height: 8.0),
            CheckboxListTile(
                  title: const Text('Has Auton'),
                  value: autonExists,
                  onChanged: (bool? newValue) {
                    setState(() {
                      autonExists = newValue!;
                      widget.onAutonExistsChanged(autonExists);
                    });
                  },
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text('Can go under stage'),
              value: canPassStage,
              onChanged: (bool? newValue) {
                setState(() {
                  canPassStage = newValue!;
                  widget.onStagePassChanged(canPassStage);
                });
              },
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text('Inside Bumper Intake?'),
              value: intakeInBumper,
              onChanged: (bool? newValue) {
                setState(() {
                  intakeInBumper = newValue!;
                  widget.onIntakeInBumperChanged(intakeInBumper);
                });
              },
            ),
            const Divider(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Speaker'),
                      value: doesSpeaker,
                      onChanged: (bool? newValue) {
                        setState(() {
                          doesSpeaker = newValue!;
                          widget.onDoesSpeakerChanged(doesSpeaker);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Amp'),
                      value: doesAmp,
                      onChanged: (bool? newValue) {
                        setState(() {
                          doesAmp = newValue!;
                          widget.onDoesAmpChanged(doesAmp);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Trap'),
                      value: doesTrap,
                      onChanged: (bool? newValue) {
                        setState(() {
                          doesTrap = newValue!;
                          widget.onDoesTrapChanged(doesTrap);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Ground'),
                      value: doesGroundPickup,
                      onChanged: (bool? newValue) {
                        setState(() {
                          doesGroundPickup = newValue!;
                          widget.onDoesGroundPickupChnaged(doesGroundPickup);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Source'),
                      value: doesSourcePickup,
                      onChanged: (bool? newValue) {
                        setState(() {
                          doesSourcePickup = newValue!;
                          widget.onDoesSourcePickupChanged(doesSourcePickup);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Turret'),
                      value: doesTurretShoot,
                      onChanged: (bool? newValue) {
                        setState(() {
                          doesTurretShoot = newValue!;
                          widget.onDoesTurretShootChanged(doesTurretShoot);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Extend'),
                      value: doesExtendShoot,
                      onChanged: (bool? newValue) {
                        setState(() {
                          doesExtendShoot = newValue!;
                          widget.onDoesExtendShootChanged(doesExtendShoot);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            RatingInput(
              title: 'Repairability',
              onRatingUpdate: (rating) {
                setState(() {
                  repairabilityScore = rating;
                  widget.onRepairabilityChanged(repairabilityScore);
                });
              },
              initialRating: repairabilityScore,
            )
          ],
        ),
      ),
    );
  }
}

class AutonForm extends StatefulWidget {

  final Function(bool) onAutonExistsChanged;

  const AutonForm({
    super.key,
    required this.onAutonExistsChanged
  });

  @override
  State<AutonForm> createState() => _AutonFormState();
}

class _AutonFormState extends State<AutonForm> {
  bool autonExists = false;

  int speakerNotes = 0;
  int ampNotes = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: ListView(
            children: <Widget>[
                Visibility(
                  visible: autonExists,
                  child: NumberInput(
                    title: "Speaker Notes",
                    value: speakerNotes,
                    onValueAdd: (){ setState(() {
                      if (speakerNotes < 10) {
                        speakerNotes += 1;
                      }
                    }); },
                    onValueSubtract: (){ setState(() {
                      if (speakerNotes > 0) {
                        speakerNotes -= 1;
                      }
                    }); },
                  ),
                ),
                const SizedBox(height: 8.0),
                Visibility(
                  visible: autonExists,
                  child: NumberInput(
                    title: "Amp Notes",
                    value: ampNotes,
                    onValueAdd: (){ setState(() {
                      if (ampNotes < 10) {
                        ampNotes += 1;
                      }
                    }); },
                    onValueSubtract: (){ setState(() {
                      if (ampNotes > 0) {
                        ampNotes -= 1;
                      }
                    }); },
                  ),
                ),
                const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}