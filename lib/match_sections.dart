import 'package:flutter/material.dart';
import 'package:mercs_scout/datatypes.dart';

import 'match_form.dart';

class MatchAutonSection extends StatefulWidget {
  final MatchForm form;

  const MatchAutonSection({
    super.key,
    required this.form,
  });

  @override
  State<MatchAutonSection> createState() => _MatchAutonSectionState();
}

class _MatchAutonSectionState extends State<MatchAutonSection> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Row(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary))),
                    onPressed: () {
                      setState(() {
                        if (widget.form.formData["autoL4scored"] > 0) {
                          widget.form.onDataChanged({
                            "autoL4scored":
                                widget.form.formData["autoL4scored"] - 1
                          });
                        } else {
                          widget.form.onDataChanged({"autoL4scored": 0});
                        }
                      });
                    },
                    iconAlignment: IconAlignment.end,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text("-",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20.0)),
                    )),
                const Spacer(),
                Text(
                  "L4: ${widget.form.formData["autoL4scored"]}",
                  style: TextStyle(fontSize: 20.0),
                ),
                const Spacer(),
                TextButton(
                    style: TextButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary))),
                    onPressed: () {
                      setState(() {
                        widget.form.onDataChanged({
                          "autoL4scored":
                              widget.form.formData["autoL4scored"] + 1
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text("+",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20.0,
                              color: Colors.green)),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MatchTeleopSection extends StatefulWidget {
  final MatchForm form;

  const MatchTeleopSection({
    super.key,
    required this.form,
  });
  @override
  State<MatchTeleopSection> createState() => _MatchTeleopSectionState();
}

class _MatchTeleopSectionState extends State<MatchTeleopSection> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("TeleopSection\nParent form data: ${widget.form.formData}"),
          ],
        ),
      ),
    );
  }
}

class MatchEndgameSection extends StatefulWidget {
  final MatchForm form;

  const MatchEndgameSection({
    super.key,
    required this.form,
  });
  @override
  State<MatchEndgameSection> createState() => _MatchEndgameSectionState();
}

class _MatchEndgameSectionState extends State<MatchEndgameSection> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Climb"),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: SegmentedButton<EndgamePositions>(
                      showSelectedIcon: false,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      emptySelectionAllowed: true,
                      multiSelectionEnabled: false,
                      segments: <ButtonSegment<EndgamePositions>>[
                        ButtonSegment(
                          value: EndgamePositions.shallow,
                          label: Text("Shallow Climb",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image(
                              image: widget.form.formData["alliance"] == "red"
                                  ? AssetImage('images/shallow_cage_r.png')
                                  : AssetImage('images/shallow_cage_b.png'),
                              fit: BoxFit.scaleDown,
                              height: 200,
                              isAntiAlias: true,
                            ),
                          ),
                        ),
                        ButtonSegment(
                          value: EndgamePositions.deep,
                          label: Text("Deep Climb",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image(
                              image: widget.form.formData["alliance"] == "red"
                                  ? AssetImage('images/deep_cage_r.png')
                                  : AssetImage('images/deep_cage_b.png'),
                              fit: BoxFit.scaleDown,
                              height: 200,
                              isAntiAlias: true,
                            ),
                          ),
                        ),
                      ],
                      selected: {
                        if (widget.form.formData["endgamePos"] == "shallow")
                          EndgamePositions.shallow,
                        if (widget.form.formData["endgamePos"] == "deep")
                          EndgamePositions.deep,
                      },
                      onSelectionChanged: (Set<EndgamePositions> newSelection) {
                        setState(() {
                          if (newSelection.contains(EndgamePositions.shallow)) {
                            widget.form.formData["endgamePos"] = "shallow";
                          }
                          if (newSelection.contains(EndgamePositions.deep)) {
                            widget.form.formData["endgamePos"] = "deep";
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SegmentedButton(
                    showSelectedIcon: false,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    emptySelectionAllowed: true,
                    segments: <ButtonSegment<EndgamePositions>>[
                      ButtonSegment(
                          value: EndgamePositions.park,
                          label: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Park",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          )),
                    ],
                    selected: {
                      if (widget.form.formData["endgamePos"] == "park")
                        EndgamePositions.park,
                    },
                    onSelectionChanged: (Set<EndgamePositions> newSelection) {
                      setState(() {
                        if (newSelection.contains(EndgamePositions.park)) {
                          widget.form.formData["endgamePos"] = "park";
                        }
                      });
                    },
                  ),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SegmentedButton(
                    showSelectedIcon: false,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    emptySelectionAllowed: true,
                    segments: <ButtonSegment<EndgamePositions>>[
                      ButtonSegment(
                          value: EndgamePositions.none,
                          label: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("No Park/Climb",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          )),
                    ],
                    selected: {
                      if (widget.form.formData["endgamePos"] == "none")
                        EndgamePositions.none,
                    },
                    onSelectionChanged: (Set<EndgamePositions> newSelection) {
                      setState(() {
                        if (newSelection.contains(EndgamePositions.none)) {
                          widget.form.formData["endgamePos"] = "none";
                        }
                      });
                    },
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
