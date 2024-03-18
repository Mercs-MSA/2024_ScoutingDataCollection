import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datatypes.dart';
import 'widgets.dart';

class FieldAutonForm extends StatefulWidget {
  final bool teamNumberPresent;
  final Alliances allianceColor;
  final int robotPosition;

  final Function(bool?) onAutonExistsChanged;
  final bool autonExists;

  final Function(bool) onLeaveChanged;
  final bool leave;

  final Function(bool) onCrossLineChanged;
  final bool crossLine;

  final Function(bool) onAStopChanged;
  final bool aStop;

  final Function(int) onSpeakerNotesChanged;
  final int speakerNotes;

  final Function(int) onSpeakerNotesMissedChanged;
  final int speakerNotesMissed;

  final Function(int) onAmpNotesChanged;
  final int ampNotes;

  final Function(int) onAmpNotesMissedChanged;
  final int ampNotesMissed;

  final Function(int, bool?) onWingNotesChanged;
  final List<bool?> wingNotes;

  final Function(int, bool?) onCenterNotesChanged;
  final List<bool?> centerNotes;

  final Function(bool?) onPreloadChanged;
  final bool? preload;

  const FieldAutonForm({
    super.key,
    required this.teamNumberPresent,
    required this.allianceColor,
    required this.robotPosition,
    required this.onAutonExistsChanged,
    required this.autonExists,
    required this.onLeaveChanged,
    required this.leave,
    required this.onCrossLineChanged,
    required this.crossLine,
    required this.onAStopChanged,
    required this.aStop,
    required this.onSpeakerNotesChanged,
    required this.speakerNotes,
    required this.onSpeakerNotesMissedChanged,
    required this.speakerNotesMissed,
    required this.onAmpNotesChanged,
    required this.ampNotes,
    required this.onAmpNotesMissedChanged,
    required this.ampNotesMissed,
    required this.onWingNotesChanged,
    required this.wingNotes,
    required this.onCenterNotesChanged,
    required this.centerNotes,
    required this.onPreloadChanged,
    required this.preload,
  });

  @override
  State<FieldAutonForm> createState() => _FieldAutonFormState();
}

class _FieldAutonFormState extends State<FieldAutonForm> {
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  bool leave = false;

  int speakerNotes = 0;
  int ampNotes = 0;

  int speakerNotesMissed = 0;
  int ampNotesMissed = 0;

  bool crossLine = false;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.teamNumberPresent ? 1 : 0,
      children: [
        if (!widget.teamNumberPresent)
          const Center(child: TeamNumberError())
        else
          const SizedBox(),
        if (widget.teamNumberPresent)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ListView(
                  children: <Widget>[
                    SwitchListTile(
                        title: const Text("Has Auton"),
                        thumbIcon: thumbIcon,
                        value: widget.autonExists,
                        onChanged: widget.onAutonExistsChanged),
                    IndexedStack(
                      index: widget.autonExists ? 0 : 1,
                      children: [
                        if (widget.autonExists)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 8.0),
                                SwitchListTile(
                                  title: const Text(
                                      'Did they leave the starting zone?'),
                                  thumbIcon: thumbIcon,
                                  value: widget.leave,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      widget.onLeaveChanged(newValue!);
                                    });
                                  },
                                ),
                                const SizedBox(height: 8.0),
                                SwitchListTile(
                                  title: const Text(
                                      "Did they cross the center line?"),
                                  thumbIcon: thumbIcon,
                                  subtitle: const Text(
                                      "(this isn't a good thing btw)"),
                                  value: widget.crossLine,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      widget.onCrossLineChanged(newValue!);
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text("Did they A-Stop?"),
                                  thumbIcon: thumbIcon,
                                  subtitle: const Text(
                                      "(this isn't a good thing btw)"),
                                  value: widget.aStop,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      widget.onAStopChanged(newValue!);
                                    });
                                  },
                                ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  height: 400,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      textDirection:
                                          widget.allianceColor == Alliances.red
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("PRELOAD"),
                                            const SizedBox(height: 24.0),
                                            Transform.scale(
                                              scale: 2.0,
                                              child: Checkbox(
                                                  value: widget.preload,
                                                  onChanged: (x) {
                                                    widget.onPreloadChanged(x);
                                                  },
                                                  tristate: true,
                                                  activeColor: widget.preload ==
                                                          true
                                                      ? ColorScheme.fromSeed(
                                                          seedColor:
                                                              Colors.green,
                                                          brightness:
                                                              Brightness.dark,
                                                        ).primary
                                                      : ColorScheme.fromSeed(
                                                          seedColor: Colors.red,
                                                          brightness:
                                                              Brightness.dark,
                                                        ).primary,
                                                  checkColor: widget.preload ==
                                                          true
                                                      ? ColorScheme.fromSeed(
                                                          seedColor:
                                                              Colors.green,
                                                          brightness:
                                                              Brightness.dark,
                                                        ).onPrimary
                                                      : ColorScheme.fromSeed(
                                                          seedColor: Colors.red,
                                                          brightness:
                                                              Brightness.dark,
                                                        ).onPrimary),
                                            ),
                                            const Spacer(),
                                            const Text("SPEAKER"),
                                            NumberInput(
                                              title: "Speaker Notes",
                                              miniStyle: true,
                                              style: NumberInputStyle.green,
                                              value: widget.speakerNotes,
                                              onValueAdd: () {
                                                setState(() {
                                                  if (widget.speakerNotes <
                                                      10) {
                                                    speakerNotes =
                                                        widget.speakerNotes + 1;
                                                  }
                                                  widget.onSpeakerNotesChanged(
                                                      speakerNotes);
                                                });
                                              },
                                              onValueSubtract: () {
                                                setState(() {
                                                  if (widget.speakerNotes > 0) {
                                                    speakerNotes =
                                                        widget.speakerNotes - 1;
                                                  }
                                                  widget.onSpeakerNotesChanged(
                                                      speakerNotes);
                                                });
                                              },
                                            ),
                                            NumberInput(
                                              title: "Speaker Notes Missed",
                                              miniStyle: true,
                                              style: NumberInputStyle.red,
                                              value: widget.speakerNotesMissed,
                                              onValueAdd: () {
                                                setState(() {
                                                  if (widget
                                                          .speakerNotesMissed <
                                                      10) {
                                                    speakerNotesMissed = widget
                                                            .speakerNotesMissed +
                                                        1;
                                                  }
                                                  widget
                                                      .onSpeakerNotesMissedChanged(
                                                          speakerNotesMissed);
                                                });
                                              },
                                              onValueSubtract: () {
                                                setState(() {
                                                  if (widget
                                                          .speakerNotesMissed >
                                                      0) {
                                                    speakerNotesMissed = widget
                                                            .speakerNotesMissed -
                                                        1;
                                                  }
                                                  widget
                                                      .onSpeakerNotesMissedChanged(
                                                          speakerNotesMissed);
                                                });
                                              },
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Text("AMP"),
                                            NumberInput(
                                              title: "Amp Notes",
                                              miniStyle: true,
                                              style: NumberInputStyle.green,
                                              value: widget.ampNotes,
                                              onValueAdd: () {
                                                setState(() {
                                                  if (widget.ampNotes < 10) {
                                                    ampNotes =
                                                        widget.ampNotes + 1;
                                                  }
                                                  widget.onAmpNotesChanged(
                                                      ampNotes);
                                                });
                                              },
                                              onValueSubtract: () {
                                                setState(() {
                                                  if (widget.ampNotes > 0) {
                                                    ampNotes =
                                                        widget.ampNotes - 1;
                                                  }
                                                  widget.onAmpNotesChanged(
                                                      ampNotes);
                                                });
                                              },
                                            ),
                                            NumberInput(
                                              title: "Amp Notes Missed",
                                              miniStyle: true,
                                              style: NumberInputStyle.red,
                                              value: widget.ampNotesMissed,
                                              onValueAdd: () {
                                                setState(() {
                                                  if (widget.ampNotesMissed <
                                                      10) {
                                                    ampNotesMissed =
                                                        widget.ampNotesMissed +
                                                            1;
                                                  }
                                                  widget
                                                      .onAmpNotesMissedChanged(
                                                          ampNotesMissed);
                                                });
                                              },
                                              onValueSubtract: () {
                                                setState(() {
                                                  if (widget.ampNotesMissed >
                                                      0) {
                                                    ampNotesMissed =
                                                        widget.ampNotesMissed -
                                                            1;
                                                  }
                                                  widget
                                                      .onAmpNotesMissedChanged(
                                                          ampNotesMissed);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
                                          color: Colors.white,
                                          width: 4,
                                          thickness: 4,
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            NoteCheckbox(
                                              value: widget.wingNotes[0],
                                              onChanged: (x) {
                                                widget.onWingNotesChanged(0, x);
                                              },
                                              tristate: true,
                                            ),
                                            const SizedBox(height: 32),
                                            NoteCheckbox(
                                              value: widget.wingNotes[1],
                                              onChanged: (x) {
                                                widget.onWingNotesChanged(1, x);
                                              },
                                              tristate: true,
                                            ),
                                            const SizedBox(height: 32),
                                            NoteCheckbox(
                                              value: widget.wingNotes[2],
                                              onChanged: (x) {
                                                widget.onWingNotesChanged(2, x);
                                              },
                                              tristate: true,
                                            ),
                                            const SizedBox(height: 48),
                                          ],
                                        ),
                                        const Spacer(),
                                        RotatedTriangle(
                                          rotationAngle: widget.allianceColor ==
                                                  Alliances.blue
                                              ? pi / 2
                                              : -pi / 2, // radians
                                          color: Colors.transparent,
                                          borderColor: widget.allianceColor ==
                                                  Alliances.blue
                                              ? Colors.blue
                                              : Colors.red,
                                          borderWidth: 5.0,
                                        ),
                                        VerticalDivider(
                                          color: widget.allianceColor ==
                                                  Alliances.blue
                                              ? Colors.blue
                                              : Colors.red,
                                          width: 4,
                                          thickness: 4,
                                        ),
                                        const Spacer(),
                                        Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            const VerticalDivider(
                                              color: Colors.white,
                                              width: 4,
                                              thickness: 4,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                NoteCheckbox(
                                                  value: widget.centerNotes[0],
                                                  onChanged: (x) {
                                                    widget.onCenterNotesChanged(
                                                        0, x);
                                                  },
                                                  tristate: true,
                                                ),
                                                const SizedBox(height: 32),
                                                NoteCheckbox(
                                                  value: widget.centerNotes[1],
                                                  onChanged: (x) {
                                                    widget.onCenterNotesChanged(
                                                        1, x);
                                                  },
                                                  tristate: true,
                                                ),
                                                const SizedBox(height: 32),
                                                NoteCheckbox(
                                                  value: widget.centerNotes[2],
                                                  onChanged: (x) {
                                                    widget.onCenterNotesChanged(
                                                        2, x);
                                                  },
                                                  tristate: true,
                                                ),
                                                const SizedBox(height: 32),
                                                NoteCheckbox(
                                                  value: widget.centerNotes[3],
                                                  onChanged: (x) {
                                                    widget.onCenterNotesChanged(
                                                        3, x);
                                                  },
                                                  tristate: true,
                                                ),
                                                const SizedBox(height: 32),
                                                NoteCheckbox(
                                                  value: widget.centerNotes[4],
                                                  onChanged: (x) {
                                                    widget.onCenterNotesChanged(
                                                        4, x);
                                                  },
                                                  tristate: true,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox(),
                        if (!widget.autonExists)
                          const Center(
                            child: Icon(
                              Icons.sentiment_very_dissatisfied_rounded,
                              size: 240,
                            ),
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}

class FieldTeleopForm extends StatefulWidget {
  final bool teamNumberPresent;
  final Alliances allianceColor;
  final int robotPosition;

  final Function(bool) onPickupFloorChanged;
  final bool pickupFloor;

  final Function(bool) onPickupSourceChanged;
  final bool pickupSource;

  final Function(int) onAmpNotesScoredChanged;
  final int ampNotesScored;

  final Function(int) onAmpNotesMissedChanged;
  final int ampNotesMissed;

  final Function(int) onSpeakerNotesScoredChanged;
  final int speakerNotesScored;

  final Function(int) onSpeakerNotesMissedChanged;
  final int speakerNotesMissed;

  final Function(int) onDroppedNotesChanged;
  final int droppedNotes;

  final Function(int) onNotesFedChanged;
  final int notesFed;

  const FieldTeleopForm({
    super.key,
    required this.teamNumberPresent,
    required this.allianceColor,
    required this.robotPosition,
    required this.onPickupFloorChanged,
    required this.pickupFloor,
    required this.onPickupSourceChanged,
    required this.pickupSource,
    required this.onAmpNotesScoredChanged,
    required this.ampNotesScored,
    required this.onAmpNotesMissedChanged,
    required this.ampNotesMissed,
    required this.onSpeakerNotesScoredChanged,
    required this.speakerNotesScored,
    required this.onSpeakerNotesMissedChanged,
    required this.speakerNotesMissed,
    required this.onDroppedNotesChanged,
    required this.droppedNotes,
    required this.onNotesFedChanged,
    required this.notesFed,
  });

  @override
  State<FieldTeleopForm> createState() => _FieldTeleopFormState();
}

class _FieldTeleopFormState extends State<FieldTeleopForm> {
  int ampNotesScored = 0;
  int ampNotesMissed = 0;

  int speakerNotesScored = 0;
  int speakerNotesMissed = 0;

  int droppedNotes = 0;
  int notesFed = 0;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.teamNumberPresent ? 1 : 0,
      children: [
        if (!widget.teamNumberPresent)
          const Center(child: TeamNumberError())
        else
          const SizedBox(),
        if (widget.teamNumberPresent)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: <Widget>[
                //Floor or Source intake
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Floor Pickup'),
                        value: widget.pickupFloor,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onPickupFloorChanged(newValue!);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Source Pickup'),
                        value: widget.pickupSource,
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.onPickupSourceChanged(newValue!);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                //Amp Score
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const SizedBox(width: 80, child: Text("AMP")),
                    NumberInput(
                      title: "Amp Notes",
                      miniStyle: true,
                      style: NumberInputStyle.green,
                      value: widget.ampNotesScored,
                      onValueAdd: () {
                        setState(() {
                          if (widget.ampNotesScored < 50) {
                            ampNotesScored = widget.ampNotesScored + 1;
                          }
                          widget.onAmpNotesScoredChanged(ampNotesScored);
                        });
                      },
                      onValueSubtract: () {
                        setState(() {
                          if (widget.ampNotesScored > 0) {
                            ampNotesScored = widget.ampNotesScored - 1;
                          }
                          widget.onAmpNotesScoredChanged(ampNotesScored);
                        });
                      },
                    ),
                    NumberInput(
                      title: "Amp Notes Missed",
                      miniStyle: true,
                      style: NumberInputStyle.red,
                      value: widget.ampNotesMissed,
                      onValueAdd: () {
                        setState(() {
                          if (widget.ampNotesMissed < 50) {
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
                    const Spacer(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const SizedBox(width: 80, child: Text("SPEAKER")),
                    NumberInput(
                      title: "Speaker Notes",
                      miniStyle: true,
                      style: NumberInputStyle.green,
                      value: widget.speakerNotesScored,
                      onValueAdd: () {
                        setState(() {
                          if (widget.speakerNotesScored < 50) {
                            speakerNotesScored = widget.speakerNotesScored + 1;
                          }
                          widget
                              .onSpeakerNotesScoredChanged(speakerNotesScored);
                        });
                      },
                      onValueSubtract: () {
                        setState(() {
                          if (widget.speakerNotesScored > 0) {
                            speakerNotesScored = widget.speakerNotesScored - 1;
                          }
                          widget
                              .onSpeakerNotesScoredChanged(speakerNotesScored);
                        });
                      },
                    ),
                    NumberInput(
                      title: "Speaker Notes Missed",
                      miniStyle: true,
                      style: NumberInputStyle.red,
                      value: widget.speakerNotesMissed,
                      onValueAdd: () {
                        setState(() {
                          if (widget.speakerNotesMissed < 50) {
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
                    const Spacer(),
                  ],
                ),
                const Divider(),
                NumberInput(
                  title: "Dropped Notes",
                  miniStyle: false,
                  style: NumberInputStyle.red,
                  enableSpacer: true,
                  value: widget.droppedNotes,
                  onValueAdd: () {
                    setState(() {
                      if (widget.droppedNotes < 50) {
                        droppedNotes = widget.droppedNotes + 1;
                      }
                      widget.onDroppedNotesChanged(droppedNotes);
                    });
                  },
                  onValueSubtract: () {
                    setState(() {
                      if (widget.droppedNotes > 0) {
                        droppedNotes = widget.droppedNotes - 1;
                      }
                      widget.onDroppedNotesChanged(droppedNotes);
                    });
                  },
                ),
                NumberInput(
                  title: "Notes Fed",
                  miniStyle: false,
                  style: NumberInputStyle.multi,
                  enableSpacer: true,
                  value: widget.notesFed,
                  onValueAdd: () {
                    setState(() {
                      if (widget.notesFed < 50) {
                        notesFed = widget.notesFed + 1;
                      }
                      widget.onNotesFedChanged(notesFed);
                    });
                  },
                  onValueSubtract: () {
                    setState(() {
                      if (widget.notesFed > 0) {
                        notesFed = widget.notesFed - 1;
                      }
                      widget.onNotesFedChanged(notesFed);
                    });
                  },
                ),
              ],
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}

class PostMatchForm extends StatefulWidget {
  final bool teamNumberPresent;
  final Alliances allianceColor;
  final int robotPosition;

  final Function(String) onHowClimbUpdate;
  final String howClimb;

  final Function(String) onTrapUpdate;
  final String trap;

  final Function(String) onHarmonyChanged;
  final String harmony;

  final Function(double) onDriverRatingChanged;
  final double driverRating;

  final Function(String) onCardChanged;
  final String card;

  final Function(String) onNoShowChanged;
  final String noShow;

  final Function(String) onCommentsChanged;
  final String comments;

  final Function(bool) onDefenseBotChanged;
  final bool defenseBot;

  const PostMatchForm({
    super.key,
    required this.teamNumberPresent,
    required this.allianceColor,
    required this.robotPosition,
    required this.onHowClimbUpdate,
    required this.howClimb,
    required this.onTrapUpdate,
    required this.trap,
    required this.onHarmonyChanged,
    required this.harmony,
    required this.onDriverRatingChanged,
    required this.driverRating,
    required this.onCardChanged,
    required this.card,
    required this.onNoShowChanged,
    required this.noShow,
    required this.onCommentsChanged,
    required this.comments,
    required this.onDefenseBotChanged,
    required this.defenseBot,
  });

  @override
  State<PostMatchForm> createState() => _PostMatchFormState();
}

class _PostMatchFormState extends State<PostMatchForm> {
  String howClimb = "No Climb, No Park";
  String trap = "Did Not Trap";
  String harmony = "Did Not Harmony";

  bool defenseBot = false;

  double driverRating = 0;

  String card = "No Card";
  String noShow = "They Showed Up";

  String comments = "";

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.teamNumberPresent ? 1 : 0,
      children: [
        if (!widget.teamNumberPresent)
          const Center(child: TeamNumberError())
        else
          const SizedBox(),
        if (widget.teamNumberPresent)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: <Widget>[
                Expanded(
                  child: ChoiceInput(
                      title: "(How) Did they climb?",
                      onChoiceUpdate: (value) {
                        setState(() {
                          widget.onHowClimbUpdate(value!);
                        });
                      },
                      choice: howClimb,
                      options: const [
                        "Fast Climb",
                        "Normal Climb",
                        "Slow Climb",
                        "Failed",
                        "Parked, No Climb",
                        "No Climb, No Park"
                      ]),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: ChoiceInput(
                      title: "Did they trap?",
                      onChoiceUpdate: (value) {
                        setState(() {
                          widget.onTrapUpdate(value!);
                        });
                      },
                      choice: widget.trap,
                      options: const [
                        "Fast Trap",
                        "Normal Trap",
                        "Slow Trap",
                        "Failed Trap",
                        "Did Not Trap"
                      ]),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: ChoiceInput(
                      title: "Did they do harmonize?",
                      onChoiceUpdate: (value) {
                        setState(() {
                          widget.onHarmonyChanged(value!);
                        });
                      },
                      choice: widget.harmony,
                      options: const [
                        "Double Harmony",
                        "Single Harmony",
                        "Failed",
                        "Did Not Harmonize"
                      ]),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Defense Bot?'),
                    value: widget.defenseBot,
                    onChanged: (bool? newValue) {
                      setState(() {
                        widget.onDefenseBotChanged(newValue!);
                      });
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: RatingInput(
                    itemCount: 5,
                    enableHalves: false,
                    title: 'Driver Rating',
                    onRatingUpdate: (rating) {
                      setState(() {
                        widget.onDriverRatingChanged(rating);
                      });
                    },
                    initialRating: widget.driverRating,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: ChoiceInput(
                      title: "Did they get a card?",
                      onChoiceUpdate: (value) {
                        setState(() {
                          widget.onCardChanged(value!);
                        });
                      },
                      choice: widget.card,
                      options: const ["No Card", "Yellow Card", "Red Card"]),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: ChoiceInput(
                      title: "Did they no show?",
                      onChoiceUpdate: (value) {
                        setState(() {
                          widget.onNoShowChanged(value!);
                        });
                      },
                      choice: widget.noShow,
                      options: const [
                        "No Show :(",
                        "No Show w/Representatives",
                        "They Showed Up"
                      ]),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                    child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Comments',
                  ),
                  maxLines: 5,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                    FilteringTextInputFormatter(
                      RegExp(r'[a-zA-Z]|-| |\n'),
                      allow: true,
                    ),
                  ],
                  onChanged: (value) {
                    widget.onCommentsChanged(value);
                  },
                  controller: TextEditingController(
                    text: widget.comments,
                  ),
                ))
              ],
            ),
          ),
      ],
    );
  }
}
