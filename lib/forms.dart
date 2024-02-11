import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_elements/widgets.dart';

class PitForm extends StatefulWidget {
  const PitForm({
    super.key,
    required this.teamNumberPresent,
    required this.onRepairabilityChanged,
    required this.onDrivebaseChanged,
    required this.onLengthChanged,
    required this.onWidthChanged,
    required this.onHeightChanged,
    required this.onIntakeInBumperChanged,
    required this.onClimberTypeChanged,
    required this.onDoesSpeakerChanged,
    required this.onDoesAmpChanged,
    required this.onDoesTrapChanged,
    required this.onDoesSourcePickupChanged,
    required this.onDoesGroundPickupChanged,
    required this.onDoesExtendShootChanged,
    required this.onDoesTurretShootChanged,
    required this.onAutonExistsChanged,
    required this.repairability,
    required this.drivebase,
    required this.length,
    required this.width,
    required this.height,
    required this.intakeInBumper,
    required this.climberType,
    required this.doesSpeaker,
    required this.doesAmp,
    required this.doesTrap,
    required this.doesSourcePickup,
    required this.doesGroundPickup,
    required this.doesExtendShoot,
    required this.doesTurretShoot,
    required this.autonExists,
  });

  final bool teamNumberPresent;

  final Function(double) onRepairabilityChanged;
  final Function(String) onDrivebaseChanged;
  final Function(int?) onLengthChanged;
  final Function(int?) onWidthChanged;
  final Function(int?) onHeightChanged;
  final Function(bool) onIntakeInBumperChanged;
  final Function(String) onClimberTypeChanged;
  final Function(bool) onDoesSpeakerChanged;
  final Function(bool) onDoesAmpChanged;
  final Function(bool) onDoesTrapChanged;
  final Function(bool) onDoesSourcePickupChanged;
  final Function(bool) onDoesGroundPickupChanged;
  final Function(bool) onDoesExtendShootChanged;
  final Function(bool) onDoesTurretShootChanged;
  final Function(bool) onAutonExistsChanged;

  final double repairability;
  final String drivebase;
  final int? length;
  final int? width;
  final int? height;
  final bool intakeInBumper;
  final String climberType;
  final bool doesSpeaker;
  final bool doesAmp;
  final bool doesTrap;
  final bool doesSourcePickup;
  final bool doesGroundPickup;
  final bool doesExtendShoot;
  final bool doesTurretShoot;
  final bool autonExists;

  @override
  State<PitForm> createState() => _PitFormState();
}

class _PitFormState extends State<PitForm> {
  double repairabilityScore = 0;
  String drivebaseType = "Swerve";
  String? altDriveType;
  String? altClimbType;

  int? widthData;
  int? lengthData;
  int? heightData;

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
    return IndexedStack(
      index: widget.teamNumberPresent == true ? 1 : 0,
      children: [
        const Center(child: TeamNumberError()),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: <Widget>[
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          widget.onWidthChanged(widthData);
                        },
                        controller: TextEditingController(
                          text: widget.width == null
                              ? ''
                              : widget.width.toString(),
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
                          widget.onLengthChanged(lengthData);
                        },
                        controller: TextEditingController(
                          text: widget.length == null
                              ? ''
                              : widget.length.toString(),
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
                          widget.onHeightChanged(heightData);
                        },
                        controller: TextEditingController(
                          text: widget.height == null
                              ? ''
                              : widget.height.toString(),
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
                      widget.onDrivebaseChanged(value!);
                    });
                  },
                  choice: widget.drivebase,
                  options: const ["Swerve", "Tank", "Other"],
                ),
                const SizedBox(height: 8.0),
                Visibility(
                  visible: widget.drivebase == 'Other',
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Alternate Drivebase Type',
                        ),
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                          FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|-| '),
                              allow: true)
                        ],
                        controller: TextEditingController(
                          text: altDriveType == null
                              ? ''
                              : altDriveType.toString(),
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
                      widget.onClimberTypeChanged(value!);
                    });
                  },
                  choice: widget.climberType,
                  options: const [
                    "No Climber",
                    "Tube-in-Tube",
                    "Lead Screw",
                    "Hook and Winch",
                    "Elevator",
                    "Other"
                  ],
                ),
                const SizedBox(height: 8.0),
                Visibility(
                  visible: widget.climberType == 'Other',
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Alternate Climber Type',
                        ),
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100),
                          FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|-| '),
                              allow: true)
                        ],
                        controller: TextEditingController(
                          text: altClimbType == null
                              ? ''
                              : altClimbType.toString(),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                CheckboxListTile(
                  title: const Text('Has Auton'),
                  value: widget.autonExists,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.onAutonExistsChanged(newValue!);
                    });
                  },
                ),
                const Divider(),
                CheckboxListTile(
                  title: const Text('Inside Bumper Intake?'),
                  value: widget.intakeInBumper,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.onIntakeInBumperChanged(newValue!);
                    });
                  },
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Speaker'),
                        value: widget.doesSpeaker,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDoesSpeakerChanged(newValue!);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Amp'),
                        value: widget.doesAmp,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDoesAmpChanged(newValue!);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Trap'),
                        value: widget.doesTrap,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDoesTrapChanged(newValue!);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Ground'),
                        value: widget.doesGroundPickup,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDoesGroundPickupChanged(newValue!);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Source'),
                        value: widget.doesSourcePickup,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDoesSourcePickupChanged(newValue!);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Turret'),
                        value: widget.doesTurretShoot,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDoesTurretShootChanged(newValue!);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Extend'),
                        value: widget.doesExtendShoot,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onDoesExtendShootChanged(newValue!);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                RatingInput(
                  title: 'Repairability',
                  onRatingUpdate: (rating) {
                    setState(() {
                      widget.onRepairabilityChanged(rating);
                    });
                  },
                  initialRating: widget.repairability,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FieldAutonForm extends StatefulWidget {
  final bool teamNumberPresent;

  final Function(bool?) onAutonExistsChanged;
  final bool autonExists;

  final Function(int) onSpeakerNotesChanged;
  final int speakerNotes;

  final Function(int) onSpeakerNotesMissedChanged;
  final int speakerNotesMissed;

  final Function(int) onAmpNotesChanged;
  final int ampNotes;

  final Function(int) onAmpNotesMissedChanged;
  final int ampNotesMissed;

  const FieldAutonForm(
      {super.key,
      required this.teamNumberPresent,
      required this.onAutonExistsChanged,
      required this.autonExists,
      required this.onSpeakerNotesChanged,
      required this.speakerNotes,
      required this.onSpeakerNotesMissedChanged,
      required this.speakerNotesMissed,
      required this.onAmpNotesChanged,
      required this.ampNotes,
      required this.onAmpNotesMissedChanged,
      required this.ampNotesMissed});

  @override
  State<FieldAutonForm> createState() => _FieldAutonFormState();
}

class _FieldAutonFormState extends State<FieldAutonForm> {
  int speakerNotes = 0;
  int ampNotes = 0;

  int speakerNotesMissed = 0;
  int ampNotesMissed = 0;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.teamNumberPresent ? 1 : 0,
      children: [
        const Center(child: TeamNumberError()),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: ListView(
                children: <Widget>[
                  CheckboxListTile(
                      title: const Text("Has Auton"),
                      value: widget.autonExists,
                      onChanged: widget.onAutonExistsChanged),
                  const Divider(),
                  Visibility(
                    visible: widget.autonExists,
                    child: NumberInput(
                      title: "Speaker Notes",
                      value: widget.speakerNotes,
                      onValueAdd: () {
                        setState(() {
                          if (widget.speakerNotes < 10) {
                            speakerNotes = widget.speakerNotes + 1;
                          }
                          widget.onSpeakerNotesChanged(speakerNotes);
                        });
                      },
                      onValueSubtract: () {
                        setState(() {
                          if (widget.speakerNotes > 0) {
                            speakerNotes = widget.speakerNotes - 1;
                          }
                          widget.onSpeakerNotesChanged(speakerNotes);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Visibility(
                    visible: widget.autonExists,
                    child: NumberInput(
                      title: "Speaker Notes Missed",
                      value: widget.speakerNotesMissed,
                      onValueAdd: () {
                        setState(() {
                          if (widget.speakerNotesMissed < 10) {
                            speakerNotesMissed = widget.speakerNotesMissed + 1;
                          }
                          widget
                              .onSpeakerNotesMissedChanged(speakerNotesMissed);
                        });
                      },
                      onValueSubtract: () {
                        setState(() {
                          if (widget.speakerNotesMissed > 0) {
                            speakerNotesMissed = widget.speakerNotesMissed - 1;
                          }
                          widget
                              .onSpeakerNotesMissedChanged(speakerNotesMissed);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: widget.autonExists,
                    child: NumberInput(
                      title: "Amp Notes",
                      value: widget.ampNotes,
                      onValueAdd: () {
                        setState(() {
                          if (widget.ampNotes < 10) {
                            ampNotes = widget.ampNotes + 1;
                          }
                          widget.onAmpNotesChanged(ampNotes);
                        });
                      },
                      onValueSubtract: () {
                        setState(() {
                          if (widget.ampNotes > 0) {
                            ampNotes = widget.ampNotes - 1;
                          }
                          widget.onAmpNotesChanged(ampNotes);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Visibility(
                    visible: widget.autonExists,
                    child: NumberInput(
                      title: "Amp Notes Missed",
                      value: widget.ampNotesMissed,
                      onValueAdd: () {
                        setState(() {
                          if (widget.ampNotesMissed < 10) {
                            ampNotesMissed = widget.ampNotesMissed + 1;
                          }
                          widget.onAmpNotesMissedChanged(ampNotesMissed);
                        });
                      },
                      onValueSubtract: () {
                        setState(() {
                          if (widget.ampNotesMissed > 0) {
                            ampNotesMissed = widget.ampNotesMissed - 1;
                          }
                          widget.onAmpNotesMissedChanged(ampNotesMissed);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
