import 'package:flutter/material.dart';
import 'package:mercs_scout/datatypes.dart';
import 'package:flutter/services.dart';

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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(
                title: "Algae Descore", color: Theme.of(context).dividerColor),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: NumberInput(
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
                enableSpacer: true,
              ),
            ),
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
                    inputType: InputType.coral,
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
                    inputType: InputType.coral,
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
                    inputType: InputType.coral,
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
                    inputType: InputType.coral,
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
              ),
            )
          ],
        ),
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
                      "teleNetScored": widget.form.formData["teleNetScored"] + 1
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(
                title: "Human Net Scoring",
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
                      "teleNetScoredHuman":
                          widget.form.formData["teleNetScoredHuman"] + 1
                    });
                  });
                },
                prefix: Icon(Icons.directions_walk),
                title: "Net Scored",
                value: widget.form.formData["teleNetScoredHuman"],
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["teleNetScoredHuman"] > 0) {
                      widget.form.onDataChanged({
                        "teleNetScoredHuman":
                            widget.form.formData["teleNetScoredHuman"] - 1
                      });
                    }
                  });
                },
                enableSpacer: true,
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
              ),
            ),
            Expanded(
              child: NumberInput(
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({
                      "teleNetMissedHuman":
                          widget.form.formData["teleNetMissedHuman"] + 1
                    });
                  });
                },
                title: "Net Missed",
                prefix: Icon(Icons.directions_walk),
                value: widget.form.formData["teleNetMissedHuman"],
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["teleNetMissedHuman"] > 0) {
                      widget.form.onDataChanged({
                        "teleNetMissedHuman":
                            widget.form.formData["teleNetMissedHuman"] - 1
                      });
                    }
                  });
                },
                enableSpacer: true,
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(
                title: "Algae Descore", color: Theme.of(context).dividerColor),
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
              ),
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
                        if (widget.form.formData["teleL4Missed"] > 0) {
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
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
                inputType:
                    (widget.colorDebug) ? InputType.algae : InputType.altAlgae,
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
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(
                title: "Algae Descore", color: Theme.of(context).dividerColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
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
                          style: TextStyle(color: Colors.white, fontSize: 15)),
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
                          style: TextStyle(color: Colors.white, fontSize: 15)),
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
            Padding(
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
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Park",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                      )),
                  ButtonSegment(
                      value: EndgamePositions.none,
                      icon: Icon(Icons.not_interested_rounded),
                      label: Padding(
                        padding: const EdgeInsets.all(16.0),
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
                isDisabled: !(widget.form.formData["endgamePos"] == "shallow" ||
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
                      widget.form.onDataChanged(
                          {"climbTime": widget.form.formData["climbTime"] - 1});
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
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: NumberInput(
                  enableSpacer: true,
                  inputType: InputType.yellow,
                  title: "Yellow Cards",
                  value: widget.form.formData["yellowCards"],
                  onValueAdd: () {
                    if (widget.form.formData["yellowCards"] < 2) {
                      setState(() {
                        widget.form.onDataChanged({
                          "yellowCards": widget.form.formData["yellowCards"] + 1
                        });
                      });
                      if (widget.form.formData["yellowCards"] == 2) {
                        widget.form.onDataChanged({"redCard": true});
                      }
                    }
                  },
                  onValueSubtract: () {
                    if (widget.form.formData["yellowCards"] > 0) {
                      setState(() {
                        widget.form.onDataChanged({
                          "yellowCards": widget.form.formData["yellowCards"] - 1
                        });
                      });
                    }
                  }),
            ),
            Expanded(
                child: LabeledSwitch(
              label: Text(
                "Red Card?",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              padding: EdgeInsets.only(top: 30, bottom: 30),
              value: widget.form.formData["redCard"],
              onChanged: (bool? newValue) {
                setState(() {
                  widget.form.onDataChanged({"redCard": newValue!});
                });
              },
            )
                // child: SwitchListTile(
                //     title: Padding(
                //       padding: EdgeInsets.only(top: 20, bottom: 20),
                //       child: Text("Red Card?"),
                //     ),
                //     value: widget.form.formData["redCard"],
                //     onChanged: (bool? newValue) {
                //       setState(() {
                //         widget.form.onDataChanged({"redCard": newValue});
                //       });
                //     })
                )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(
                title: "Extras", color: Theme.of(context).dividerColor),
          ],
        ),
        Row(
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText:
                  'Optional Notes (Subsystem malfunction, coral stuck, etc.)',
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(500),
              FilteringTextInputFormatter(RegExp(r'[^|*]+'), allow: true)
            ],
            onChanged: (value) {
              widget.form
                  .onDataChanged({"notes": value.replaceAll("\n", "**")});
            },
            minLines: 3,
            maxLines: 7,
            controller: TextEditingController(
              text: widget.form.formData["notes"] == null
                  ? ''
                  : widget.form.formData["notes"]
                      .toString()
                      .replaceAll("**", "\n"),
            ),
          ),
        ),
      ],
    );
  }
}
