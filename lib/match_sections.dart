import 'package:flutter/material.dart';
import 'package:mercs_scout/datatypes.dart';

import 'match_form.dart';
import 'widgets.dart';

class MatchTeleopSection extends StatefulWidget {
  final MatchForm form;

  const MatchTeleopSection(
      {super.key, required this.form, required this.colorDebug});

  final bool colorDebug;

  @override
  State<MatchTeleopSection> createState() => _MatchTeleopSectionState();
}

class _MatchTeleopSectionState extends State<MatchTeleopSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const HSVColor.fromAHSV(1, 30, 1, 0.2).toColor(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SectionHeader(
                            title: "Team ${widget.form.formData["team1"]}",
                            color: Theme.of(context).dividerColor),
                      ],
                    ),
                  ]
                )
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SectionHeader(
                            title: "Team ${widget.form.formData["team2"]}",
                            color: Theme.of(context).dividerColor),
                      ],
                    ),
                  ]
                )
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SectionHeader(
                            title: "Team ${widget.form.formData["team3"]}",
                            color: Theme.of(context).dividerColor),
                      ],
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text("Shooter?"),
                          value: widget.form.formData["team1Shooter"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team1Shooter": value});
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: Text("Defender?"),
                          value: widget.form.formData["team1Defender"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team1Defender": value});
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: Text("Feeder?"),
                          value: widget.form.formData["team1Feeder"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team1Feeder": value});
                            });
                          }
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text("Shooter?"),
                          value: widget.form.formData["team2Shooter"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team2Shooter": value});
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: Text("Defender?"),
                          value: widget.form.formData["team2Defender"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team2Defender": value});
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: Text("Feeder?"),
                          value: widget.form.formData["team2Feeder"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team2Feeder": value});
                            });
                          }
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text("Shooter?"),
                          value: widget.form.formData["team3Shooter"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team3Shooter": value});
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: Text("Defender?"),
                          value: widget.form.formData["team3Defender"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team3Defender": value});
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: Text("Feeder?"),
                          value: widget.form.formData["team3Feeder"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team3Feeder": value});
                            });
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}

class MatchEndgameSection extends StatefulWidget {
  final MatchForm form;

  const MatchEndgameSection(
      {super.key, required this.form, required this.colorDebug});

  final bool colorDebug;

  @override
  State<MatchEndgameSection> createState() => _MatchEndgameSectionState();
}

class _MatchEndgameSectionState extends State<MatchEndgameSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const HSVColor.fromAHSV(1, 110, 1, 0.2).toColor(),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SectionHeader(
                  title: "Endgame Position",
                  color: Theme.of(context).dividerColor),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(2.0),
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
                            height: 100,
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
                            height: 100,
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
          const SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(2.0),
                child: SegmentedButton(
                  showSelectedIcon: false,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  emptySelectionAllowed: true,
                  direction: Axis.vertical,
                  segments: <ButtonSegment<EndgamePositions>>[
                    ButtonSegment(
                        value: EndgamePositions.park,
                        icon: Icon(Icons.local_parking_rounded),
                        label: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Park",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        )),
                    ButtonSegment(
                        value: EndgamePositions.none,
                        icon: Icon(Icons.not_interested_rounded),
                        label: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("No Park/Climb",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        )),
                  ],
                  selected: {
                    if (widget.form.formData["endgamePos"] == "park")
                      EndgamePositions.park,
                    if (widget.form.formData["endgamePos"] == "none")
                      EndgamePositions.none,
                  },
                  onSelectionChanged: (Set<EndgamePositions> newSelection) {
                    setState(() {
                      if (newSelection.contains(EndgamePositions.park)) {
                        widget.form.formData["endgamePos"] = "park";
                      } else if (newSelection.contains(EndgamePositions.none)) {
                        widget.form.formData["endgamePos"] = "none";
                      }
                      widget.form.formData["climbTime"] = 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: NumberInput(
                  isDisabled:
                      !(widget.form.formData["endgamePos"] == "shallow" ||
                          widget.form.formData["endgamePos"] == "deep"),
                  disabledText: "N/A",
                  inputType: InputType.def,
                  title: "Approx. Climb Time",
                  value: widget.form.formData["climbTime"],
                  suffix: (widget.form.formData["endgamePos"] == "shallow" ||
                          widget.form.formData["endgamePos"] == "deep")
                      ? Text(
                          "s",
                          style:
                              TextStyle(fontSize: 28, fontFamily: "RobotoMono"),
                        )
                      : null,
                  onValueAdd: () {
                    setState(() {
                      widget.form.onDataChanged(
                          {"climbTime": widget.form.formData["climbTime"] + 1});
                    });
                  },
                  onValueSubtract: () {
                    if (widget.form.formData["climbTime"] > 0) {
                      setState(() {
                        widget.form.onDataChanged({
                          "climbTime": widget.form.formData["climbTime"] - 1
                        });
                      });
                    }
                  },
                  enableSpacer: true,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SectionHeader(
                  title: "Cards", color: Theme.of(context).dividerColor),
            ],
          ),
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: LabeledSwitch(
                    label: Text(
                      "Yellow Card?",
                      style: TextStyle(
                          fontSize: 15,
                          color: widget.form.formData["yellowCard"]
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.only(top: 30, bottom: 30),
                    value: widget.form.formData["yellowCard"],
                    selectedColor: const Color.fromARGB(255, 244, 226, 73),
                    onChanged: (bool? newValue) {
                      setState(() {
                        widget.form.onDataChanged({"yellowCard": newValue!});
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: LabeledSwitch(
                    label: Text(
                      "Red Card?",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.only(top: 30, bottom: 30),
                    value: widget.form.formData["redCard"],
                    selectedColor: const Color.fromARGB(255, 217, 84, 74),
                    onChanged: (bool? newValue) {
                      setState(() {
                        widget.form.onDataChanged({"redCard": newValue!});
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SectionHeader(
                  title: "Extras", color: Theme.of(context).dividerColor),
            ],
          ),
          CheckboxListTile(
              title: Text("Mark for Review?"),
              value: widget.form.formData["isMarkedForReview"],
              onChanged: (bool? newValue) {
                setState(() {
                  widget.form.onDataChanged({"isMarkedForReview": newValue});
                });
              }),
          CheckboxListTile(
            title: Text("Did they do any defense?"),
            value: widget.form.formData["performedDefense"],
            onChanged: (bool? newValue) {
              setState(() {
                widget.form.onDataChanged({"performedDefense": newValue});
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: CheckboxListTile(
                      title: Text("Didn't Show Up?"),
                      value: widget.form.formData["noShow"],
                      onChanged: (bool? newValue) {
                        setState(() {
                          widget.form.onDataChanged({"noShow": newValue});
                        });
                      },
                    )),
                Expanded(
                    flex: 2,
                    child: CheckboxListTile(
                      title: Text("Disabled?"),
                      value: widget.form.formData["disabled"],
                      onChanged: (bool? newValue) {
                        setState(() {
                          widget.form.onDataChanged({"disabled": newValue});
                        });
                      },
                    )),
              ],
            ),
          ),
          NumberInput(
              title: "Penalties",
              value: widget.form.formData["penalties"],
              onValueAdd: () {
                setState(() {
                  widget.form.onDataChanged(
                      {"penalties": widget.form.formData["penalties"] + 1});
                });
              },
              onValueSubtract: () {
                setState(() {
                  widget.form.onDataChanged(
                      {"penalties": widget.form.formData["penalties"] - 1});
                });
              },
              enableSpacer: true)
        ],
      ),
    );
  }
}
