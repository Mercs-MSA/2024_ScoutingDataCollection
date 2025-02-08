import 'package:flutter/material.dart';

import 'match_form.dart';
import 'widgets.dart';

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
    return 
    ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(title: "Net Scoring", color: Theme.of(context).dividerColor),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: NumberInput(
                onValueAdd: () { setState(() {
                  widget.form.onDataChanged({"autoNetScored" : widget.form.formData["autoNetScored"] + 1});
                });},
                title: "Net Scored",
                value: widget.form.formData["autoNetScored"],
                onValueSubtract: () {setState(() {
                  if (widget.form.formData["autoNetScored"] > 0) widget.form.onDataChanged({"autoNetScored" : widget.form.formData["autoNetScored"] - 1});
                });},
                enableSpacer: true,
              ),
            ),
            Expanded(
              child: NumberInput(
                onValueAdd: () { setState(() {
                  widget.form.onDataChanged({"autoNetMissed" : widget.form.formData["autoNetMissed"] + 1});
                });},
                title: "Net Missed",
                value: widget.form.formData["autoNetMissed"],
                onValueSubtract: () {setState(() {
                  if (widget.form.formData["autoNetMissed"] > 0) widget.form.onDataChanged({"autoNetMissed" : widget.form.formData["autoNetMissed"] - 1});
                });},
                enableSpacer: true,
              ),
            ),
          ],
        ),
        Divider(color: Theme.of(context).dividerColor,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
                NumberInput(
                  title: "Algae De-scored", 
                  value: widget.form.formData["autoAlgaeDescored"], 
                  onValueAdd: () {
                    setState(() {
                      widget.form.onDataChanged({"autoAlgaeDescored" : widget.form.formData["autoAlgaeDescored"] + 1});
                    });
                  }, 
                  onValueSubtract: () {
                    setState(() {
                      if (widget.form.formData["autoAlgaeDescored"] > 0) widget.form.onDataChanged({"autoAlgaeDescored" : widget.form.formData["autoAlgaeDescored"] - 1});
                    });
                  },
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
                      SectionHeader(title: "Coral Scored", color: Theme.of(context).dividerColor)
                    ],
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"autoL4scored" : widget.form.formData["autoL4scored"] + 1});
                    });},
                    title: "L4",
                    value: widget.form.formData["autoL4scored"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["autoL4scored"] > 0) widget.form.onDataChanged({"autoL4scored" : widget.form.formData["autoL4scored"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"autoL3Scored" : widget.form.formData["autoL3Scored"] + 1});
                    });},
                    title: "L3",
                    value: widget.form.formData["autoL3Scored"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["autoL3Scored"] > 0) widget.form.onDataChanged({"autoL3Scored" : widget.form.formData["autoL3Scored"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"autoL2Scored" : widget.form.formData["autoL2Scored"] + 1});
                    });},
                    title: "L2",
                    value: widget.form.formData["autoL2Scored"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["autoL2Scored"] > 0)  widget.form.onDataChanged({"autoL2Scored" : widget.form.formData["autoL2Scored"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"autoL1Scored" : widget.form.formData["autoL1Scored"] + 1});
                    });},
                    title: "L1",
                    value: widget.form.formData["autoL1Scored"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["autoL1Scored"] > 0) widget.form.onDataChanged({"autoL1Scored" : widget.form.formData["autoL1Scored"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox(),),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SectionHeader(
                        title: "Coral Missed", color: Theme.of(context).dividerColor
                      ),
                    ],
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"autoL4Missed" : widget.form.formData["autoL4Missed"] + 1});
                    });},
                    title: "L4",
                    value: widget.form.formData["autoL4Missed"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["autoL4Missed"] > 0) widget.form.onDataChanged({"autoL4Missed" : widget.form.formData["autoL4Missed"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"autoL3Missed" : widget.form.formData["autoL3Missed"] + 1});
                    });},
                    title: "L3",
                    value: widget.form.formData["autoL3Missed"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["autoL3Missed"] > 0) widget.form.onDataChanged({"autoL3Missed" : widget.form.formData["autoL3Missed"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"autoL2Missed" : widget.form.formData["autoL2Missed"] + 1});
                    });},
                    title: "L2",
                    value: widget.form.formData["autoL2Missed"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["autoL2Missed"] > 0) widget.form.onDataChanged({"autoL2Missed" : widget.form.formData["autoL2Missed"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"autoL1Missed" : widget.form.formData["autoL1Missed"] + 1});
                    });},
                    title: "L1",
                    value: widget.form.formData["autoL1Missed"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["autoL4Missed"] > 0) widget.form.onDataChanged({"autoL1Missed" : widget.form.formData["autoL1Missed"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SectionHeader(title: "Processor", color: Theme.of(context).dividerColor)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: NumberInput(title: "Processor Scored", value: widget.form.formData["autoProcessorScored"], 
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({"autoProcessorScored": widget.form.formData["autoProcessorScored"] + 1});
                  });
                }, 
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["autoProcessorScored"] > 0) widget.form.onDataChanged({"autoProcessorScored": widget.form.formData["autoProcessorScored"] - 1});
                  });
                },
                enableSpacer: true,
              ),
            ),
            Expanded(
              child: NumberInput(title: "Processor Missed", value: widget.form.formData["autoProcessorMissed"], 
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({"autoProcessorMissed": widget.form.formData["autoProcessorMissed"] + 1});
                  });
                }, 
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["autoProcessorMissed"] > 0) widget.form.onDataChanged({"autoProcessorMissed": widget.form.formData["autoProcessorMissed"] - 1});
                  });
                },
                enableSpacer: true,
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
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SectionHeader(title: "Net Scoring", color: Theme.of(context).dividerColor),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: NumberInput(
                onValueAdd: () { setState(() {
                  widget.form.onDataChanged({"teleNetScored" : widget.form.formData["teleNetScored"] + 1});
                });},
                title: "Net Scored",
                value: widget.form.formData["teleNetScored"],
                onValueSubtract: () {setState(() {
                  if (widget.form.formData["teleNetScored"] > 0) widget.form.onDataChanged({"teleNetScored" : widget.form.formData["teleNetScored"] - 1});
                });},
                enableSpacer: true,
              ),
            ),
            Expanded(
              child: NumberInput(
                onValueAdd: () { setState(() {
                  widget.form.onDataChanged({"teleNetMissed" : widget.form.formData["teleNetMissed"] + 1});
                });},
                title: "Net Missed",
                value: widget.form.formData["teleNetMissed"],
                onValueSubtract: () {setState(() {
                  if (widget.form.formData["teleNetMissed"] > 0) widget.form.onDataChanged({"teleNetMissed" : widget.form.formData["teleNetMissed"] - 1});
                });},
                enableSpacer: true,
              ),
            ),
          ],
        ),
        Divider(color: Theme.of(context).dividerColor,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
                NumberInput(
                  title: "Algae De-scored", 
                  value: widget.form.formData["teleAlgaeDescored"], 
                  onValueAdd: () {
                    setState(() {
                      widget.form.onDataChanged({"teleAlgaeDescored" : widget.form.formData["teleAlgaeDescored"] + 1});
                    });
                  }, 
                  onValueSubtract: () {
                    setState(() {
                      if (widget.form.formData["teleAlgaeDescored"] > 0) widget.form.onDataChanged({"teleAlgaeDescored" : widget.form.formData["teleAlgaeDescored"] - 1});
                    });
                  },
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
                      SectionHeader(title: "Coral Scored", color: Theme.of(context).dividerColor)
                    ],
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"teleL4Scored" : widget.form.formData["teleL4Scored"] + 1});
                    });},
                    title: "L4",
                    value: widget.form.formData["teleL4Scored"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["teleL4Scored"] > 0) widget.form.onDataChanged({"teleL4Scored" : widget.form.formData["teleL4Scored"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"teleL3Scored" : widget.form.formData["teleL3Scored"] + 1});
                    });},
                    title: "L3",
                    value: widget.form.formData["teleL3Scored"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["teleL3Scored"] > 0) widget.form.onDataChanged({"teleL3Scored" : widget.form.formData["teleL3Scored"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"teleL2Scored" : widget.form.formData["teleL2Scored"] + 1});
                    });},
                    title: "L2",
                    value: widget.form.formData["teleL2Scored"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["teleL2Scored"] > 0)  widget.form.onDataChanged({"teleL2Scored" : widget.form.formData["teleL2Scored"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"teleL1Scored" : widget.form.formData["teleL1Scored"] + 1});
                    });},
                    title: "L1",
                    value: widget.form.formData["teleL1Scored"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["teleL1Scored"] > 0) widget.form.onDataChanged({"teleL1Scored" : widget.form.formData["teleL1Scored"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox(),),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SectionHeader(
                        title: "Coral Missed", color: Theme.of(context).dividerColor
                      ),
                    ],
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"teleL4Missed" : widget.form.formData["teleL4Missed"] + 1});
                    });},
                    title: "L4",
                    value: widget.form.formData["teleL4Missed"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["teleL4Missed"] > 0) widget.form.onDataChanged({"teleL4Missed" : widget.form.formData["teleL4Missed"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"teleL3Missed" : widget.form.formData["teleL3Missed"] + 1});
                    });},
                    title: "L3",
                    value: widget.form.formData["teleL3Missed"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["teleL3Missed"] > 0) widget.form.onDataChanged({"teleL3Missed" : widget.form.formData["teleL3Missed"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"teleL2Missed" : widget.form.formData["teleL2Missed"] + 1});
                    });},
                    title: "L2",
                    value: widget.form.formData["teleL2Missed"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["teleL2Missed"] > 0) widget.form.onDataChanged({"teleL2Missed" : widget.form.formData["teleL2Missed"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                  NumberInput(
                    onValueAdd: () { setState(() {
                      widget.form.onDataChanged({"teleL1Missed" : widget.form.formData["teleL1Missed"] + 1});
                    });},
                    title: "L1",
                    value: widget.form.formData["teleL1Missed"],
                    onValueSubtract: () {setState(() {
                      if (widget.form.formData["teleL4Missed"] > 0) widget.form.onDataChanged({"teleL1Missed" : widget.form.formData["teleL1Missed"] - 1});
                    });},
                    enableSpacer: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SectionHeader(title: "Processor", color: Theme.of(context).dividerColor)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: NumberInput(title: "Processor Scored", value: widget.form.formData["teleProcessorScored"], 
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({"teleProcessorScored": widget.form.formData["teleProcessorScored"] + 1});
                  });
                }, 
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["teleProcessorScored"] > 0) widget.form.onDataChanged({"teleProcessorScored": widget.form.formData["teleProcessorScored"] - 1});
                  });
                },
                enableSpacer: true,
              ),
            ),
            Expanded(
              child: NumberInput(title: "Processor Missed", value: widget.form.formData["teleProcessorMissed"], 
                onValueAdd: () {
                  setState(() {
                    widget.form.onDataChanged({"teleProcessorMissed": widget.form.formData["teleProcessorMissed"] + 1});
                  });
                }, 
                onValueSubtract: () {
                  setState(() {
                    if (widget.form.formData["teleProcessorMissed"] > 0) widget.form.onDataChanged({"teleProcessorMissed": widget.form.formData["teleProcessorMissed"] - 1});
                  });
                },
                enableSpacer: true,
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
            Text("EndgameSection\nParent form data: ${widget.form.formData}"),
          ],
        ),
      ),
    );
  }
}
