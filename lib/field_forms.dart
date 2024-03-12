import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_elements/datatypes.dart';
import 'package:flutter_form_elements/widgets.dart';

class FieldAutonForm extends StatefulWidget {
  final bool teamNumberPresent;
  final Alliances allianceColor;
  final int robotPosition;

  final Function(bool?) onAutonExistsChanged;
  final bool autonExists;

  final Function(bool) onLeaveChanged;
  final bool leave;

  final Function(int) onSpeakerNotesChanged;
  final int speakerNotes;

  final Function(int) onSpeakerNotesMissedChanged;
  final int speakerNotesMissed;

  final Function(int) onAmpNotesChanged;
  final int ampNotes;

  final Function(int) onAmpNotesMissedChanged;
  final int ampNotesMissed;

  final Function(bool?) onPodiumNoteChanged;
  final bool? podiumNote;

  const FieldAutonForm({
    super.key,
    required this.teamNumberPresent,
    required this.allianceColor,
    required this.robotPosition,
    required this.onAutonExistsChanged,
    required this.autonExists,
    required this.onLeaveChanged,
    required this.leave,
    required this.onSpeakerNotesChanged,
    required this.speakerNotes,
    required this.onSpeakerNotesMissedChanged,
    required this.speakerNotesMissed,
    required this.onAmpNotesChanged,
    required this.ampNotes,
    required this.onAmpNotesMissedChanged,
    required this.ampNotesMissed,
    required this.onPodiumNoteChanged,
    required this.podiumNote,
  });

  @override
  State<FieldAutonForm> createState() => _FieldAutonFormState();
}

class _FieldAutonFormState extends State<FieldAutonForm> {
  final GlobalKey imageKey = GlobalKey();

  bool leave = false;

  int speakerNotes = 0;
  int ampNotes = 0;

  int speakerNotesMissed = 0;
  int ampNotesMissed = 0;

  bool? podiumNote = false;

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
                    child: CheckboxListTile(
                      title: const Text('Did they leave wing?'),
                      value: widget.leave,
                      onChanged: (bool? newValue) {
                        setState(() {
                          widget.onLeaveChanged(newValue!);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 400,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("SPEAKER"),
                            NumberInput(
                              title: "Speaker Notes",
                              miniStyle: true,
                              style: NumberInputStyle.green,
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
                            NumberInput(
                              title: "Speaker Notes Missed",
                              miniStyle: true,
                              style: NumberInputStyle.red,
                              value: widget.speakerNotesMissed,
                              onValueAdd: () {
                                setState(() {
                                  if (widget.speakerNotesMissed < 10) {
                                    speakerNotesMissed =
                                        widget.speakerNotesMissed + 1;
                                  }
                                  widget.onSpeakerNotesMissedChanged(
                                      speakerNotesMissed);
                                });
                              },
                              onValueSubtract: () {
                                setState(() {
                                  if (widget.speakerNotesMissed > 0) {
                                    speakerNotesMissed =
                                        widget.speakerNotesMissed - 1;
                                  }
                                  widget.onSpeakerNotesMissedChanged(
                                      speakerNotesMissed);
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("AMP"),
                            NumberInput(
                              title: "Amp Notes",
                              miniStyle: true,
                              style: NumberInputStyle.green,
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
                            NumberInput(
                              title: "Amp Notes Missed",
                              miniStyle: true,
                              style: NumberInputStyle.red,
                              value: widget.ampNotesMissed,
                              onValueAdd: () {
                                setState(() {
                                  if (widget.ampNotesMissed < 10) {
                                    ampNotesMissed = widget.ampNotesMissed + 1;
                                  }
                                  widget
                                      .onAmpNotesMissedChanged(ampNotesMissed);
                                });
                              },
                              onValueSubtract: () {
                                setState(() {
                                  if (widget.ampNotesMissed > 0) {
                                    ampNotesMissed = widget.ampNotesMissed - 1;
                                  }
                                  widget
                                      .onAmpNotesMissedChanged(ampNotesMissed);
                                });
                              },
                            ),
                          ],
                        ),
                        VerticalDivider(
                          color: Colors.white,
                          width: 4,
                          thickness: 4,
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // RingedCheckbox(
                            //   tristate: true,
                            //   value: widget.podiumNote,
                            //   onChanged: () {
                            //     setState(() {
                            //       podiumNote = newValue;
                            //     });
                            //   },
                            // ),
                            SizedBox(height: 32),
                            RingedCheckbox(value: true, onChanged: (x) {}),
                            SizedBox(height: 32),
                            RingedCheckbox(value: true, onChanged: (x) {}),
                            SizedBox(height: 48),
                          ],
                        ),
                        Spacer(),
                        RotatedTriangle(
                          rotationAngle: -pi / 2, // radians
                          color: Colors.transparent,
                          borderColor: Colors.red,
                          borderWidth: 5.0,
                        ),
                        VerticalDivider(
                          color: Colors.red,
                          width: 4,
                          thickness: 4,
                        ),
                        Spacer(),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            VerticalDivider(
                              color: Colors.white,
                              width: 4,
                              thickness: 4,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RingedCheckbox(value: true, onChanged: (x) {}),
                                SizedBox(height: 32),
                                RingedCheckbox(value: true, onChanged: (x) {}),
                                SizedBox(height: 32),
                                RingedCheckbox(value: true, onChanged: (x) {}),
                                SizedBox(height: 32),
                                RingedCheckbox(value: true, onChanged: (x) {}),
                                SizedBox(height: 32),
                                RingedCheckbox(value: true, onChanged: (x) {}),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
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

  double getImageHeight(BuildContext context) {
    final RenderBox renderBox =
        imageKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  double getImageWidth(BuildContext context) {
    final RenderBox renderBox =
        imageKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.width;
  }
}
