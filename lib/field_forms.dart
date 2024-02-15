import 'package:flutter/material.dart';
import 'package:flutter_form_elements/widgets.dart';

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