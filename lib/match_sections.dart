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
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SectionHeader(
                            title: "Coral Scored",
                            color: Theme.of(context).dividerColor)
                      ],
                    ),
                    NumberInput(
                      onValueAdd: () {
                        setState(() {
                          widget.form.onDataChanged({
                            "teleL4Scored":
                                widget.form.formData["teleL4Scored"] + 1
                          });
                        });
                      },
                      title: "L4",
                      value: widget.form.formData["teleL4Scored"],
                      onValueSubtract: () {
                        setState(() {
                          if (widget.form.formData["teleL4Scored"] > 0) {
                            widget.form.onDataChanged({
                              "teleL4Scored":
                                  widget.form.formData["teleL4Scored"] - 1
                            });
                          }
                        });
                      },
                      enableSpacer: true,
                      inputType: InputType.coral,
                    ),
                    NumberInput(
                      onValueAdd: () {
                        setState(() {
                          widget.form.onDataChanged({
                            "teleL3Scored":
                                widget.form.formData["teleL3Scored"] + 1
                          });
                        });
                      },
                      title: "L3",
                      value: widget.form.formData["teleL3Scored"],
                      onValueSubtract: () {
                        setState(() {
                          if (widget.form.formData["teleL3Scored"] > 0) {
                            widget.form.onDataChanged({
                              "teleL3Scored":
                                  widget.form.formData["teleL3Scored"] - 1
                            });
                          }
                        });
                      },
                      enableSpacer: true,
                      inputType: InputType.coral,
                    ),
                    NumberInput(
                      onValueAdd: () {
                        setState(() {
                          widget.form.onDataChanged({
                            "teleL2Scored":
                                widget.form.formData["teleL2Scored"] + 1
                          });
                        });
                      },
                      title: "L2",
                      value: widget.form.formData["teleL2Scored"],
                      onValueSubtract: () {
                        setState(() {
                          if (widget.form.formData["teleL2Scored"] > 0) {
                            widget.form.onDataChanged({
                              "teleL2Scored":
                                  widget.form.formData["teleL2Scored"] - 1
                            });
                          }
                        });
                      },
                      enableSpacer: true,
                      inputType: InputType.coral,
                    ),
                    NumberInput(
                      onValueAdd: () {
                        setState(() {
                          widget.form.onDataChanged({
                            "teleL1Scored":
                                widget.form.formData["teleL1Scored"] + 1
                          });
                        });
                      },
                      title: "L1",
                      value: widget.form.formData["teleL1Scored"],
                      onValueSubtract: () {
                        setState(() {
                          if (widget.form.formData["teleL1Scored"] > 0) {
                            widget.form.onDataChanged({
                              "teleL1Scored":
                                  widget.form.formData["teleL1Scored"] - 1
                            });
                          }
                        });
                      },
                      enableSpacer: true,
                      inputType: InputType.coral,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SectionHeader(
                            title: "Coral Missed",
                            color: Theme.of(context).dividerColor),
                      ],
                    ),
                    NumberInput(
                      onValueAdd: () {
                        setState(() {
                          widget.form.onDataChanged({
                            "teleL4Missed":
                                widget.form.formData["teleL4Missed"] + 1
                          });
                        });
                      },
                      title: "L4",
                      value: widget.form.formData["teleL4Missed"],
                      onValueSubtract: () {
                        setState(() {
                          if (widget.form.formData["teleL4Missed"] > 0) {
                            widget.form.onDataChanged({
                              "teleL4Missed":
                                  widget.form.formData["teleL4Missed"] - 1
                            });
                          }
                        });
                      },
                      enableSpacer: true,
                      inputType: InputType.coral,
                    ),
                    NumberInput(
                      onValueAdd: () {
                        setState(() {
                          widget.form.onDataChanged({
                            "teleL3Missed":
                                widget.form.formData["teleL3Missed"] + 1
                          });
                        });
                      },
                      title: "L3",
                      value: widget.form.formData["teleL3Missed"],
                      onValueSubtract: () {
                        setState(() {
                          if (widget.form.formData["teleL3Missed"] > 0) {
                            widget.form.onDataChanged({
                              "teleL3Missed":
                                  widget.form.formData["teleL3Missed"] - 1
                            });
                          }
                        });
                      },
                      enableSpacer: true,
                      inputType: InputType.coral,
                    ),
                    NumberInput(
                      onValueAdd: () {
                        setState(() {
                          widget.form.onDataChanged({
                            "teleL2Missed":
                                widget.form.formData["teleL2Missed"] + 1
                          });
                        });
                      },
                      title: "L2",
                      value: widget.form.formData["teleL2Missed"],
                      onValueSubtract: () {
                        setState(() {
                          if (widget.form.formData["teleL2Missed"] > 0) {
                            widget.form.onDataChanged({
                              "teleL2Missed":
                                  widget.form.formData["teleL2Missed"] - 1
                            });
                          }
                        });
                      },
                      enableSpacer: true,
                      inputType: InputType.coral,
                    ),
                    NumberInput(
                      onValueAdd: () {
                        setState(() {
                          widget.form.onDataChanged({
                            "teleL1Missed":
                                widget.form.formData["teleL1Missed"] + 1
                          });
                        });
                      },
                      title: "L1",
                      value: widget.form.formData["teleL1Missed"],
                      onValueSubtract: () {
                        setState(() {
                          if (widget.form.formData["teleL1Missed"] > 0) {
                            widget.form.onDataChanged({
                              "teleL1Missed":
                                  widget.form.formData["teleL1Missed"] - 1
                            });
                          }
                        });
                      },
                      enableSpacer: true,
                      inputType: InputType.coral,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     // Expanded(
          //     Expanded(
          //       child: NumberInput(
          //         title: "Coral Dropped",
          //         value: widget.form.formData["teleCoralDropped"],
          //         onValueAdd: () {
          //           setState(() {
          //             widget.form.onDataChanged({
          //               "teleCoralDropped":
          //                   widget.form.formData["teleCoralDropped"] + 1
          //             });
          //           });
          //         },
          //         onValueSubtract: () {
          //           setState(() {
          //             if (widget.form.formData["teleCoralDropped"] > 0) {
          //               widget.form.onDataChanged({
          //                 "teleCoralDropped":
          //                     widget.form.formData["teleCoralDropped"] - 1
          //               });
          //             }
          //           });
          //         },
          //         enableSpacer: true,
          //         inputType: InputType.coral,
          //       ),
          //     )
          //   ],
          // ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SectionHeader(
                  title: "Algae Descore",
                  color: Theme.of(context).dividerColor),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Expanded(
              Expanded(
                child: NumberInput(
                  title: "Algae De-scored",
                  value: widget.form.formData["teleAlgaeDescored"],
                  onValueAdd: () {
                    setState(() {
                      widget.form.onDataChanged({
                        "teleAlgaeDescored":
                            widget.form.formData["teleAlgaeDescored"] + 1
                      });
                    });
                  },
                  onValueSubtract: () {
                    setState(() {
                      if (widget.form.formData["teleAlgaeDescored"] > 0) {
                        widget.form.onDataChanged({
                          "teleAlgaeDescored":
                              widget.form.formData["teleAlgaeDescored"] - 1
                        });
                      }
                    });
                  },
                  enableSpacer: true,
                  inputType: (widget.colorDebug)
                      ? InputType.algae
                      : InputType.altAlgae,
                ),
              )
            ],
          ),
          Row(
            children: [
              SectionHeader(
                  title: "Processor", color: Theme.of(context).dividerColor)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: NumberInput(
                  title: "Processor Scored",
                  value: widget.form.formData["teleProcessorScored"],
                  onValueAdd: () {
                    setState(() {
                      widget.form.onDataChanged({
                        "teleProcessorScored":
                            widget.form.formData["teleProcessorScored"] + 1
                      });
                    });
                  },
                  onValueSubtract: () {
                    setState(() {
                      if (widget.form.formData["teleProcessorScored"] > 0) {
                        widget.form.onDataChanged({
                          "teleProcessorScored":
                              widget.form.formData["teleProcessorScored"] - 1
                        });
                      }
                    });
                  },
                  enableSpacer: true,
                  inputType: (widget.colorDebug)
                      ? InputType.algae
                      : InputType.altAlgae,
                ),
              ),
              Expanded(
                child: NumberInput(
                  title: "Processor Missed",
                  value: widget.form.formData["teleProcessorMissed"],
                  onValueAdd: () {
                    setState(() {
                      widget.form.onDataChanged({
                        "teleProcessorMissed":
                            widget.form.formData["teleProcessorMissed"] + 1
                      });
                    });
                  },
                  onValueSubtract: () {
                    setState(() {
                      if (widget.form.formData["teleProcessorMissed"] > 0) {
                        widget.form.onDataChanged({
                          "teleProcessorMissed":
                              widget.form.formData["teleProcessorMissed"] - 1
                        });
                      }
                    });
                  },
                  enableSpacer: true,
                  inputType: (widget.colorDebug)
                      ? InputType.algae
                      : InputType.altAlgae,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SectionHeader(
                  title: "Robot Net Scoring",
                  color: Theme.of(context).dividerColor),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: NumberInput(
                  onValueAdd: () {
                    setState(() {
                      widget.form.onDataChanged({
                        "teleNetScored":
                            widget.form.formData["teleNetScored"] + 1
                      });
                    });
                  },
                  prefix: Icon(Icons.precision_manufacturing),
                  title: "Net Scored",
                  value: widget.form.formData["teleNetScored"],
                  onValueSubtract: () {
                    setState(() {
                      if (widget.form.formData["teleNetScored"] > 0) {
                        widget.form.onDataChanged({
                          "teleNetScored":
                              widget.form.formData["teleNetScored"] - 1
                        });
                      }
                    });
                  },
                  enableSpacer: true,
                  inputType: (widget.colorDebug)
                      ? InputType.algae
                      : InputType.altAlgae,
                ),
              ),
              Expanded(
                child: NumberInput(
                  onValueAdd: () {
                    setState(() {
                      widget.form.onDataChanged({
                        "teleNetMissed":
                            widget.form.formData["teleNetMissed"] + 1
                      });
                    });
                  },
                  prefix: Icon(Icons.precision_manufacturing),
                  title: "Net Missed",
                  value: widget.form.formData["teleNetMissed"],
                  onValueSubtract: () {
                    setState(() {
                      if (widget.form.formData["teleNetMissed"] > 0) {
                        widget.form.onDataChanged({
                          "teleNetMissed":
                              widget.form.formData["teleNetMissed"] - 1
                        });
                      }
                    });
                  },
                  enableSpacer: true,
                  inputType: (widget.colorDebug)
                      ? InputType.algae
                      : InputType.altAlgae,
                ),
              ),
            ],
          ),
        ],
      ),
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
