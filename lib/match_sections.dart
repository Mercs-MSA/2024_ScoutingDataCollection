import 'package:flutter/material.dart';
import 'package:mercs_scout/datatypes.dart';

import 'match_form.dart';
import 'widgets.dart';

class MatchAutonSection extends StatefulWidget {
  final MatchForm form;

  const MatchAutonSection({
    super.key,
    required this.form,
    required this.colorDebug,
  });

  final bool colorDebug;
  @override
  State<MatchAutonSection> createState() => _MatchAutonSectionState();
}

class _MatchAutonSectionState extends State<MatchAutonSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(
                title: "Net Scoring", color: Theme.of(context).dividerColor),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: NumberInput(
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({
                      "autoNetScored": widget.form.formData["autoNetScored"] + 1
                    });
                  });
                },
                title: "Net Scored",
                value: widget.form.formData["autoNetScored"],
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["autoNetScored"] > 0) {
                      widget.form.onDataChanged({
                        "autoNetScored":
                            widget.form.formData["autoNetScored"] - 1
                      });
                    }
                  });
                },
                enableSpacer: true,
                inputType: InputType.algae,
                currColor: widget.colorDebug,
              ),
            ),
            Expanded(
              child: NumberInput(
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({
                      "autoNetMissed": widget.form.formData["autoNetMissed"] + 1
                    });
                  });
                },
                title: "Net Missed",
                value: widget.form.formData["autoNetMissed"],
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["autoNetMissed"] > 0) {
                      widget.form.onDataChanged({
                        "autoNetMissed":
                            widget.form.formData["autoNetMissed"] - 1
                      });
                    }
                  });
                },
                enableSpacer: true,
                inputType: InputType.missed,
                currColor: widget.colorDebug,
              ),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            NumberInput(
              title: "Algae De-scored",
              value: widget.form.formData["autoAlgaeDescored"],
              onValueAdd: () {
                setState(() {
                  widget.form.onDataChanged({
                    "autoAlgaeDescored":
                        widget.form.formData["autoAlgaeDescored"] + 1
                  });
                });
              },
              onValueSubtract: () {
                setState(() {
                  if (widget.form.formData["autoAlgaeDescored"] > 0) {
                    widget.form.onDataChanged({
                      "autoAlgaeDescored":
                          widget.form.formData["autoAlgaeDescored"] - 1
                    });
                  }
                });
              },
              inputType: InputType.algae,
              currColor: widget.colorDebug,
              enableSpacer: false,
            )
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
                          "autoL4scored":
                              widget.form.formData["autoL4scored"] + 1
                        });
                      });
                    },
                    title: "L4",
                    value: widget.form.formData["autoL4scored"],
                    onValueSubtract: () {
                      setState(() {
                        if (widget.form.formData["autoL4scored"] > 0) {
                          widget.form.onDataChanged({
                            "autoL4scored":
                                widget.form.formData["autoL4scored"] - 1
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
                          "autoL3Scored":
                              widget.form.formData["autoL3Scored"] + 1
                        });
                      });
                    },
                    title: "L3",
                    value: widget.form.formData["autoL3Scored"],
                    onValueSubtract: () {
                      setState(() {
                        if (widget.form.formData["autoL3Scored"] > 0) {
                          widget.form.onDataChanged({
                            "autoL3Scored":
                                widget.form.formData["autoL3Scored"] - 1
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
                          "autoL2Scored":
                              widget.form.formData["autoL2Scored"] + 1
                        });
                      });
                    },
                    title: "L2",
                    value: widget.form.formData["autoL2Scored"],
                    onValueSubtract: () {
                      setState(() {
                        if (widget.form.formData["autoL2Scored"] > 0) {
                          widget.form.onDataChanged({
                            "autoL2Scored":
                                widget.form.formData["autoL2Scored"] - 1
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
                          "autoL1Scored":
                              widget.form.formData["autoL1Scored"] + 1
                        });
                      });
                    },
                    title: "L1",
                    value: widget.form.formData["autoL1Scored"],
                    onValueSubtract: () {
                      setState(() {
                        if (widget.form.formData["autoL1Scored"] > 0) {
                          widget.form.onDataChanged({
                            "autoL1Scored":
                                widget.form.formData["autoL1Scored"] - 1
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
                          "autoL4Missed":
                              widget.form.formData["autoL4Missed"] + 1
                        });
                      });
                    },
                    title: "L4",
                    value: widget.form.formData["autoL4Missed"],
                    onValueSubtract: () {
                      setState(() {
                        if (widget.form.formData["autoL4Missed"] > 0) {
                          widget.form.onDataChanged({
                            "autoL4Missed":
                                widget.form.formData["autoL4Missed"] - 1
                          });
                        }
                      });
                    },
                    enableSpacer: true,
                    inputType: InputType.missed,
                    currColor: widget.colorDebug,
                  ),
                  NumberInput(
                    onValueAdd: () {
                      setState(() {
                        widget.form.onDataChanged({
                          "autoL3Missed":
                              widget.form.formData["autoL3Missed"] + 1
                        });
                      });
                    },
                    title: "L3",
                    value: widget.form.formData["autoL3Missed"],
                    onValueSubtract: () {
                      setState(() {
                        if (widget.form.formData["autoL3Missed"] > 0) {
                          widget.form.onDataChanged({
                            "autoL3Missed":
                                widget.form.formData["autoL3Missed"] - 1
                          });
                        }
                      });
                    },
                    enableSpacer: true,
                    inputType: InputType.missed,
                    currColor: widget.colorDebug,
                  ),
                  NumberInput(
                    onValueAdd: () {
                      setState(() {
                        widget.form.onDataChanged({
                          "autoL2Missed":
                              widget.form.formData["autoL2Missed"] + 1
                        });
                      });
                    },
                    title: "L2",
                    value: widget.form.formData["autoL2Missed"],
                    onValueSubtract: () {
                      setState(() {
                        if (widget.form.formData["autoL2Missed"] > 0) {
                          widget.form.onDataChanged({
                            "autoL2Missed":
                                widget.form.formData["autoL2Missed"] - 1
                          });
                        }
                      });
                    },
                    enableSpacer: true,
                    inputType: InputType.missed,
                    currColor: widget.colorDebug,
                  ),
                  NumberInput(
                    onValueAdd: () {
                      setState(() {
                        widget.form.onDataChanged({
                          "autoL1Missed":
                              widget.form.formData["autoL1Missed"] + 1
                        });
                      });
                    },
                    title: "L1",
                    value: widget.form.formData["autoL1Missed"],
                    onValueSubtract: () {
                      setState(() {
                        if (widget.form.formData["autoL4Missed"] > 0) {
                          widget.form.onDataChanged({
                            "autoL1Missed":
                                widget.form.formData["autoL1Missed"] - 1
                          });
                        }
                      });
                    },
                    enableSpacer: true,
                    inputType: InputType.missed,
                    currColor: widget.colorDebug,
                  ),
                ],
              ),
            ),
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
                value: widget.form.formData["autoProcessorScored"],
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({
                      "autoProcessorScored":
                          widget.form.formData["autoProcessorScored"] + 1
                    });
                  });
                },
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["autoProcessorScored"] > 0) {
                      widget.form.onDataChanged({
                        "autoProcessorScored":
                            widget.form.formData["autoProcessorScored"] - 1
                      });
                    }
                  });
                },
                enableSpacer: true,
                inputType: InputType.algae,
                currColor: widget.colorDebug,
              ),
            ),
            Expanded(
              child: NumberInput(
                title: "Processor Missed",
                value: widget.form.formData["autoProcessorMissed"],
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({
                      "autoProcessorMissed":
                          widget.form.formData["autoProcessorMissed"] + 1
                    });
                  });
                },
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["autoProcessorMissed"] > 0) {
                      widget.form.onDataChanged({
                        "autoProcessorMissed":
                            widget.form.formData["autoProcessorMissed"] - 1
                      });
                    }
                  });
                },
                enableSpacer: true,
                inputType: InputType.missed,
                currColor: widget.colorDebug,
              ),
            )
          ],
        )
      ],
    );
  }
}

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
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(
                title: "Net Scoring", color: Theme.of(context).dividerColor),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: NumberInput(
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({
                      "teleNetScored": widget.form.formData["teleNetScored"] + 1
                    });
                  });
                },
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
                inputType: InputType.algae,
                currColor: true,
              ),
            ),
            Expanded(
              child: NumberInput(
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({
                      "teleNetMissed": widget.form.formData["teleNetMissed"] + 1
                    });
                  });
                },
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
                inputType: InputType.missed,
                currColor: widget.colorDebug,
              ),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            NumberInput(
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
              enableSpacer: false,
              inputType: InputType.algae,
              currColor: widget.colorDebug,
            )
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
                    inputType: InputType.missed,
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
                    inputType: InputType.missed,
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
                    inputType: InputType.missed,
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
                        if (widget.form.formData["teleL4Missed"] > 0) {
                          widget.form.onDataChanged({
                            "teleL1Missed":
                                widget.form.formData["teleL1Missed"] - 1
                          });
                        }
                      });
                    },
                    enableSpacer: true,
                    inputType: InputType.missed,
                  ),
                ],
              ),
            ),
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
                inputType: InputType.algae,
                currColor: widget.colorDebug,
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
                inputType: InputType.missed,
              ),
            )
          ],
        )
      ],
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
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NumberInput(
                title: "Climb Time (Seconds)",
                value: (widget.form.formData["endgamePos"] == "shallow" ||
                        widget.form.formData["endgamePos"] == "deep")
                    ? widget.form.formData["climbTime"]
                    : 0,
                onValueAdd: () {
                  if (widget.form.formData["endgamePos"] == "shallow" ||
                      widget.form.formData["endgamePos"] == "deep") {
                    setState(() {
                      widget.form.onDataChanged(
                          {"climbTime": widget.form.formData["climbTime"] + 1});
                    });
                  }
                },
                onValueSubtract: () {
                  if (widget.form.formData["climbTime"] > 0 &&
                      widget.form.formData["endgamePos"] == "shallow" &&
                      widget.form.formData["endgamePos"] == "deep") {
                    setState(() {
                      widget.form.onDataChanged(
                          {"climbTime": widget.form.formData["climbTime"] - 1});
                    });
                  }
                },
                enableSpacer: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
