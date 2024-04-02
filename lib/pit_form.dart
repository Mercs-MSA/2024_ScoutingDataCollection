import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datatypes.dart';
import 'widgets.dart';

Map pitClimberMap = {
  "No Climber": "no",
  "Tube-in-Tube": "tt",
  "Lead Screw": "ls",
  "Hook and Winch": "hw",
  "Elevator": "e",
  "Other": "o"
};

class PitForm extends StatefulWidget {
  const PitForm(
      {super.key,
      required this.teamNumberPresent,
      required this.onRepairabilityChanged,
      required this.onManeuverabilityChanged,
      required this.onDrivebaseChanged,
      required this.onAltDrivebaseChanged,
      required this.onLengthChanged,
      required this.onWidthChanged,
      required this.onHeightChanged,
      required this.onWeightChanged,
      required this.onIntakeInBumperChanged,
      required this.onKitbotChanged,
      required this.onKitbotModsChanged,
      required this.onClimberTypeChanged,
      required this.onAltClimberTypeChanged,
      required this.onDoesSpeakerChanged,
      required this.onDoesAmpChanged,
      required this.onScoringPrefChanged,
      required this.onDoesTrapChanged,
      required this.onDoesSourcePickupChanged,
      required this.onDoesGroundPickupChanged,
      required this.onAlternateFunctionChanged,
      required this.onDoesExtendShootChanged,
      required this.onDoesBlockChanged,
      required this.onAutoAimChanged,
      required this.onDoesTurretShootChanged,
      required this.onAutonExistsChanged,
      required this.onAutonSpeakerNotesChanged,
      required this.onAutonAmpNotesChanged,
      required this.onAutonConsistencyChanged,
      required this.onAutonVersatilityChanged,
      required this.onAutonRoutesChanged,
      required this.onAutonRouteDescriptionChanged,
      required this.onAutonStratChanged,
      required this.onPlayerPreferAmpChanged,
      required this.onPlayerPreferSourceChanged,
      required this.onDriverYearsChanged,
      required this.onOperatorYearsChanged,
      required this.onCoachYearsChanged,
      required this.onPrefStartChanged,
      required this.onTeleopStratChnaged,
      required this.repairability,
      required this.maneuverability,
      required this.drivebase,
      required this.altDrivebase,
      required this.length,
      required this.width,
      required this.height,
      required this.weight,
      required this.intakeInBumper,
      required this.kitbot,
      required this.kitbotMods,
      required this.climberType,
      required this.altClimberType,
      required this.doesSpeaker,
      required this.doesAmp,
      required this.doesTrap,
      required this.scoringPreference,
      required this.doesSourcePickup,
      required this.doesGroundPickup,
      required this.alternateFunction,
      required this.doesExtendShoot,
      required this.doesBlock,
      required this.doesAutoAim,
      required this.doesTurretShoot,
      required this.autonExists,
      required this.autonSpeakerNotes,
      required this.autonAmpNotes,
      required this.autonConsistency,
      required this.autonVersatility,
      required this.autonStrat,
      required this.autonRoutes,
      required this.autonRouteDescription,
      required this.playerPreferAmp,
      required this.playerPreferSource,
      required this.driverYears,
      required this.operatorYears,
      required this.coachYears,
      required this.prefStart,
      required this.teleopStrat});

  final bool teamNumberPresent;

  final Function(double) onRepairabilityChanged;
  final Function(double) onManeuverabilityChanged;
  final Function(String) onDrivebaseChanged;
  final Function(String) onAltDrivebaseChanged;
  final Function(int?) onLengthChanged;
  final Function(int?) onWidthChanged;
  final Function(int?) onHeightChanged;
  final Function(int?) onWeightChanged;
  final Function(bool) onIntakeInBumperChanged;
  final Function(KitBotTypes) onKitbotChanged;
  final Function(String) onKitbotModsChanged;
  final Function(String) onClimberTypeChanged;
  final Function(String) onAltClimberTypeChanged;
  final Function(bool) onDoesSpeakerChanged;
  final Function(bool) onDoesAmpChanged;
  final Function(ScoringPreference) onScoringPrefChanged;
  final Function(bool) onDoesTrapChanged;
  final Function(bool) onDoesSourcePickupChanged;
  final Function(bool) onDoesGroundPickupChanged;
  final Function(String) onAlternateFunctionChanged;
  final Function(bool) onDoesExtendShootChanged;
  final Function(bool) onDoesBlockChanged;
  final Function(bool) onAutoAimChanged;
  final Function(bool) onDoesTurretShootChanged;
  final Function(bool) onAutonExistsChanged;
  final Function(int) onAutonSpeakerNotesChanged;
  final Function(int) onAutonAmpNotesChanged;
  final Function(double) onAutonConsistencyChanged;
  final Function(double) onAutonVersatilityChanged;
  final Function(int) onAutonRoutesChanged;
  final Function(String) onAutonStratChanged;
  final Function(String) onAutonRouteDescriptionChanged;
  final Function(bool) onPlayerPreferAmpChanged;
  final Function(bool) onPlayerPreferSourceChanged;
  final Function(int?) onDriverYearsChanged;
  final Function(int?) onOperatorYearsChanged;
  final Function(int?) onCoachYearsChanged;
  final Function(StartPositions) onPrefStartChanged;
  final Function(String) onTeleopStratChnaged;

  final double repairability;
  final double maneuverability;
  final String drivebase;
  final String? altDrivebase;
  final int? length;
  final int? width;
  final int? height;
  final int? weight;
  final KitBotTypes kitbot;
  final String kitbotMods;
  final bool intakeInBumper;
  final String climberType;
  final String? altClimberType;
  final bool doesSpeaker;
  final bool doesAmp;
  final ScoringPreference scoringPreference;
  final bool doesTrap;
  final bool doesSourcePickup;
  final bool doesGroundPickup;
  final String alternateFunction;
  final bool doesExtendShoot;
  final bool doesBlock;
  final bool doesAutoAim;
  final bool doesTurretShoot;
  final bool autonExists;
  final int autonSpeakerNotes;
  final int autonAmpNotes;
  final double autonConsistency;
  final double autonVersatility;
  final int autonRoutes;
  final String autonRouteDescription;
  final String autonStrat;
  final bool playerPreferAmp;
  final bool playerPreferSource;
  final int? driverYears;
  final int? operatorYears;
  final int? coachYears;
  final StartPositions prefStart;
  final String teleopStrat;

  @override
  State<PitForm> createState() => _PitFormState();
}

class _PitFormState extends State<PitForm> {
  String kitbotMods = "";

  String alternateFunction = "";

  int autonSpeakerNotes = 0;
  int autonAmpNotes = 0;
  int autonRoutes = 0;

  String teleopStrat = "";
  String autonStrat = "";
  String autonRouteDescription = "";

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

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
                            widget.onWidthChanged(int.tryParse(value));
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
                            widget.onLengthChanged(int.tryParse(value));
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
                            widget.onHeightChanged(int.tryParse(value));
                          },
                          controller: TextEditingController(
                            text: widget.height == null
                                ? ''
                                : widget.height.toString(),
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
                            widget.onWeightChanged(int.tryParse(value));
                          },
                          controller: TextEditingController(
                            text: widget.weight == null
                                ? ''
                                : widget.weight.toString(),
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
                  if (widget.drivebase == 'Other')
                    Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Alternate Drivebase Type',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(15),
                            FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|-| '),
                                allow: true)
                          ],
                          onChanged: (value) {
                            widget.onAltDrivebaseChanged(value);
                          },
                          controller: TextEditingController(
                            text: widget.altDrivebase == null
                                ? ''
                                : widget.altDrivebase.toString(),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
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
                  if (widget.climberType == 'Other')
                    Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Alternate Climber Type',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(15),
                            FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|-| '),
                                allow: true)
                          ],
                          onChanged: (value) {
                            widget.onAltClimberTypeChanged(value);
                          },
                          controller: TextEditingController(
                            text: widget.altClimberType == null
                                ? ''
                                : widget.altClimberType.toString(),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  const Divider(),
                  SegmentedButton<KitBotTypes>(
                      segments: const <ButtonSegment<KitBotTypes>>[
                        ButtonSegment<KitBotTypes>(
                            value: KitBotTypes.not,
                            label: Text('Non-KitBot'),
                            icon: Icon(Icons.auto_awesome)),
                        ButtonSegment<KitBotTypes>(
                            value: KitBotTypes.modded,
                            label: Text('Modded KitBot'),
                            icon: Icon(Icons.construction)),
                        ButtonSegment<KitBotTypes>(
                            value: KitBotTypes.kitbot,
                            label: Text('KitBot'),
                            icon: Icon(Icons.pallet)),
                      ],
                      selected: {
                        widget.kitbot
                      },
                      onSelectionChanged: (newSelection) {
                        widget.onKitbotChanged(newSelection.first);
                      }),
                  if (widget.kitbot == KitBotTypes.modded)
                    const SizedBox(height: 8.0),
                  if (widget.kitbot == KitBotTypes.modded)
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Kitbot Mods',
                      ),
                      maxLines: 5,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100),
                        FilteringTextInputFormatter(
                          RegExp(r'[0-9]|[a-zA-Z]|-| |\n'),
                          allow: true,
                        )
                      ],
                      onChanged: (value) {
                        kitbotMods = value;
                        widget.onKitbotModsChanged(value);
                      },
                      controller: TextEditingController(
                        text: kitbotMods == "" ? widget.kitbotMods : kitbotMods,
                      ),
                    ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Inside Bumper Intake?'),
                    value: widget.intakeInBumper,
                    onChanged: (bool? newValue) {
                      setState(() {
                        widget.onIntakeInBumperChanged(newValue!);
                      });
                    },
                    thumbIcon: thumbIcon,
                  ),
                  const Divider(),
                  const Text(
                      "Can their robot pick up from the ground, source or both?"),
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
                  if (!widget.doesGroundPickup && !widget.doesSourcePickup)
                    const SizedBox(height: 8.0),
                  if (!widget.doesGroundPickup && !widget.doesSourcePickup)
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'What is their alternate function?',
                      ),
                      maxLines: 3,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100),
                        FilteringTextInputFormatter(
                          RegExp(r'[0-9]|[a-zA-Z]|-| |\n'),
                          allow: true,
                        )
                      ],
                      onChanged: (value) {
                        alternateFunction = value;
                        widget.onAlternateFunctionChanged(value);
                      },
                      controller: TextEditingController(
                        text: alternateFunction == ""
                            ? widget.alternateFunction
                            : alternateFunction,
                      ),
                    ),
                  const Divider(),
                  const Text("Can they score speaker, amp or both?"),
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
                  if (widget.doesSpeaker && widget.doesAmp)
                    const SizedBox(height: 4.0),
                  if (widget.doesSpeaker && widget.doesAmp)
                    const Text("Scoring preference"),
                  if (widget.doesSpeaker && widget.doesAmp)
                    const SizedBox(height: 4.0),
                  if (widget.doesSpeaker && widget.doesAmp)
                    SegmentedButton<ScoringPreference>(
                        segments: const <ButtonSegment<ScoringPreference>>[
                          ButtonSegment<ScoringPreference>(
                              value: ScoringPreference.speaker,
                              label: Text('Speaker'),
                              icon: Icon(Icons.volume_up)),
                          ButtonSegment<ScoringPreference>(
                              value: ScoringPreference.amp,
                              label: Text('Amp'),
                              icon: Icon(Icons.bolt)),
                        ],
                        selected: {
                          widget.scoringPreference
                        },
                        onSelectionChanged: (newSelection) {
                          widget.onScoringPrefChanged(newSelection.first);
                        }),
                  const Divider(),
                  const Text(
                      "Does their shooter have any of these special functions?"),
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
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Block'),
                          value: widget.doesBlock,
                          onChanged: (bool? newValue) {
                            setState(() {
                              widget.onDoesBlockChanged(newValue!);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Auto-Aim'),
                          value: widget.doesAutoAim,
                          onChanged: (bool? newValue) {
                            setState(() {
                              widget.onAutoAimChanged(newValue!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text(
                      "Where is their human player most comfortable? (if they don't care check both boxes)"),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Amp'),
                          value: widget.playerPreferAmp,
                          onChanged: (bool? newValue) {
                            setState(() {
                              widget.onPlayerPreferAmpChanged(newValue!);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Source'),
                          value: widget.playerPreferSource,
                          onChanged: (bool? newValue) {
                            setState(() {
                              widget.onPlayerPreferSourceChanged(newValue!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
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
                            labelText: 'Driver',
                            suffixText: "Years",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          onChanged: (value) {
                            widget.onDriverYearsChanged(int.tryParse(value));
                          },
                          controller: TextEditingController(
                            text: widget.driverYears == null
                                ? ''
                                : widget.driverYears.toString(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Operator',
                            suffixText: "Years",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          onChanged: (value) {
                            widget.onOperatorYearsChanged(int.tryParse(value));
                          },
                          controller: TextEditingController(
                            text: widget.operatorYears == null
                                ? ''
                                : widget.operatorYears.toString(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Coach',
                            suffixText: "Years",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          onChanged: (value) {
                            widget.onCoachYearsChanged(int.tryParse(value));
                          },
                          controller: TextEditingController(
                            text: widget.coachYears == null
                                ? ''
                                : widget.coachYears.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
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
                          thumbIcon: thumbIcon,
                          value: widget.autonExists,
                          onChanged: (bool? newValue) {
                            setState(() {
                              widget.onAutonExistsChanged(newValue!);
                            });
                          },
                        ),
                        if (widget.autonExists)
                          Column(
                            children: [
                              const SizedBox(height: 8.0),
                              const Text(
                                  "What is their prefered auton start position?"),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<StartPositions>(
                                      title: const Text('Left'),
                                      value: StartPositions.left,
                                      groupValue: widget.prefStart,
                                      onChanged: (StartPositions? value) {
                                        widget.onPrefStartChanged(
                                            value ?? StartPositions.middle);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<StartPositions>(
                                      title: const Text('Mid'),
                                      value: StartPositions.middle,
                                      groupValue: widget.prefStart,
                                      onChanged: (StartPositions? value) {
                                        widget.onPrefStartChanged(
                                            value ?? StartPositions.middle);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<StartPositions>(
                                      title: const Text('Right'),
                                      value: StartPositions.right,
                                      groupValue: widget.prefStart,
                                      onChanged: (StartPositions? value) {
                                        widget.onPrefStartChanged(
                                            value ?? StartPositions.middle);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              NumberInput(
                                title: "Speaker Notes",
                                enableSpacer: true,
                                value: widget.autonSpeakerNotes,
                                onValueAdd: () {
                                  setState(() {
                                    if (widget.autonSpeakerNotes < 10) {
                                      autonSpeakerNotes =
                                          widget.autonSpeakerNotes + 1;
                                    }
                                    widget.onAutonSpeakerNotesChanged(
                                        autonSpeakerNotes);
                                  });
                                },
                                onValueSubtract: () {
                                  setState(() {
                                    if (widget.autonSpeakerNotes > 0) {
                                      autonSpeakerNotes =
                                          widget.autonSpeakerNotes - 1;
                                    }
                                    widget.onAutonSpeakerNotesChanged(
                                        autonSpeakerNotes);
                                  });
                                },
                              ),
                              const SizedBox(height: 8.0),
                              NumberInput(
                                title: "Amp Notes",
                                enableSpacer: true,
                                value: widget.autonAmpNotes,
                                onValueAdd: () {
                                  setState(() {
                                    if (widget.autonAmpNotes < 10) {
                                      autonAmpNotes = widget.autonAmpNotes + 1;
                                    }
                                    widget
                                        .onAutonAmpNotesChanged(autonAmpNotes);
                                  });
                                },
                                onValueSubtract: () {
                                  setState(() {
                                    if (widget.autonAmpNotes > 0) {
                                      autonAmpNotes = widget.autonAmpNotes - 1;
                                    }
                                    widget
                                        .onAutonAmpNotesChanged(autonAmpNotes);
                                  });
                                },
                              ),
                              const SizedBox(height: 8.0),
                              NumberInput(
                                title: "Auto Routines",
                                enableSpacer: true,
                                value: widget.autonRoutes,
                                onValueAdd: () {
                                  setState(() {
                                    if (widget.autonRoutes < 10) {
                                      autonRoutes = widget.autonRoutes + 1;
                                    }
                                    widget.onAutonRoutesChanged(autonRoutes);
                                  });
                                },
                                onValueSubtract: () {
                                  setState(() {
                                    if (widget.autonRoutes > 0) {
                                      autonRoutes = widget.autonRoutes - 1;
                                    }
                                    widget.onAutonRoutesChanged(autonRoutes);
                                  });
                                },
                              ),
                              if (widget.autonRoutes > 3)
                                const SizedBox(height: 8.0),
                              if (widget.autonRoutes > 3)
                                TextField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Auton Route Descriptions',
                                  ),
                                  maxLines: 5,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(100),
                                    FilteringTextInputFormatter(
                                      RegExp(r'[0-9]|[a-zA-Z]|-| |\n'),
                                      allow: true,
                                    )
                                  ],
                                  onChanged: (value) {
                                    autonRouteDescription = value;
                                    widget
                                        .onAutonRouteDescriptionChanged(value);
                                  },
                                  controller: TextEditingController(
                                    text: autonRouteDescription == ""
                                        ? widget.autonRouteDescription
                                        : autonRouteDescription,
                                  ),
                                ),
                              const SizedBox(height: 8.0),
                              RatingInput(
                                title: "Auto Consistency",
                                onRatingUpdate: (value) {
                                  widget.onAutonConsistencyChanged(value);
                                },
                                initialRating: widget.autonConsistency,
                                enableHalves: false,
                              ),
                              const SizedBox(height: 8.0),
                              RatingInput(
                                title: "Auto Versatility",
                                onRatingUpdate: (value) {
                                  widget.onAutonVersatilityChanged(value);
                                },
                                initialRating: widget.autonVersatility,
                                enableHalves: false,
                              ),
                              const SizedBox(height: 8.0),
                              TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Auton Strategy',
                                ),
                                maxLines: 5,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(100),
                                  FilteringTextInputFormatter(
                                    RegExp(r'[0-9]|[a-zA-Z]|-| |\n'),
                                    allow: true,
                                  )
                                ],
                                onChanged: (value) {
                                  autonStrat = value;
                                  widget.onAutonStratChanged(value);
                                },
                                controller: TextEditingController(
                                  text: autonStrat == ""
                                      ? widget.autonStrat
                                      : autonStrat,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
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
                    enableHalves: false,
                  ),
                  const Divider(),
                  RatingInput(
                    title: 'Maneuverability',
                    onRatingUpdate: (rating) {
                      setState(() {
                        widget.onManeuverabilityChanged(rating);
                      });
                    },
                    initialRating: widget.maneuverability,
                    enableHalves: false,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Teleop Strategy',
                    ),
                    maxLines: 5,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                      FilteringTextInputFormatter(
                        RegExp(r'[0-9]|[a-zA-Z]|-| |\n'),
                        allow: true,
                      ),
                    ],
                    onChanged: (value) {
                      teleopStrat = value;
                      widget.onTeleopStratChnaged(value);
                    },
                    controller: TextEditingController(
                      text:
                          teleopStrat == "" ? widget.teleopStrat : teleopStrat,
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
