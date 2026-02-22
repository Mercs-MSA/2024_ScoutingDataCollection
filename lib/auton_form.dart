import 'package:flutter/material.dart';

import 'match_sections.dart';
import 'widgets.dart';

class AutonForm extends StatefulWidget {
  const AutonForm({
    super.key,
    required this.teamNumberPresent,
    required this.onDataChanged,
    required this.formData,
    required this.allianceColor,
  });

  final bool teamNumberPresent;

  final Function(Map<String, dynamic>) onDataChanged;
  final Map formData;
  
  final String allianceColor;

  @override
  State<AutonForm> createState() => _AutonFormState();
}

class _AutonFormState extends State<AutonForm>{
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile (
                    title: const Text('Has Auto?'),
                    value: widget.formData['autoLeave'] ?? false, 
                    onChanged: (value) {
                      setState(() {
                        widget
                            .onDataChanged({"autoLeave": value});
                      });
                    }
                  ),
                  const SizedBox(height: 12.0),
                  if (widget.formData['autoLeave'] == true) ... [
                    if (widget.allianceColor == "blue")
                      FittedBox(
                        alignment: Alignment.topLeft,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'images/blue_field_2026.png',
                                fit: BoxFit.scaleDown,
                                width: 500,
                                isAntiAlias: true,
                                errorBuilder: (context, error, stackTrace) => SizedBox(width: 500, height: 300),
                              ),
                            ),
                            Positioned(
                              left: 265,
                              top: 15,
                              child: SizedBox(
                                height: 465,
                                child: RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  activeColor: Color.fromARGB(0, 191, 185, 185),
                                  inactiveColor: Color.fromARGB(0, 191, 185, 185),
                                  thumbColor: Color.fromARGB(255, 170, 18, 34),
                                  max: 465,
                                  value: widget.formData["startPos"], 
                                  onChanged: (value) {
                                    setState(() {
                                      widget.onDataChanged({"startPos": value});
                                    });
                                  }
                                ),
                              ),
                              )
                            ),
                            Positioned(
                              left: 295,
                              bottom: widget.formData["startPos"] * 465 / 500,
                              child: Text("Start")
                            ),
                            Positioned(
                              left: 385,
                              top: 325,
                              child: Checkbox(
                                value: widget.formData['depotDisrupted'] ?? false, 
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"depotDisrupted": value});
                                    });
                                  }
                              ),
                            ),
                            Positioned(
                              right: 45,
                              top: 45,
                              child: Checkbox(
                                value: widget.formData['outpostDisrupted'] ?? false, 
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"outpostDisrupted": value});
                                    });
                                  }
                              ),
                            ),
                            Positioned(
                              left: 75,
                              top: 100,
                              child: Checkbox(
                                value: widget.formData['topDisrupted'] ?? false, 
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"topDisrupted": value});
                                    });
                                  }
                              ),
                            ),
                            Positioned(
                              left: 75,
                              top: 230,
                              child: Checkbox(
                                value: widget.formData['middleDisrupted'] ?? false, 
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"middleDisrupted": value});
                                    });
                                  }
                              ),
                            ),
                            Positioned(
                              left: 75,
                              top: 350,
                              child: Checkbox(
                                value: widget.formData['bottomDisrupted'] ?? false, 
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"bottomDisrupted": value});
                                    });
                                  }
                              ),
                            ),
                            Positioned(
                              left: 370,
                              top: 228,
                              child: Checkbox(
                                value: widget.formData['rightClimb'], 
                                tristate: true,
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"rightClimb": value});
                                      if (value != false) {
                                        widget.onDataChanged({"leftClimb": false});
                                        widget.onDataChanged({"middleClimb": false});
                                      }
                                    });
                                  }
                                ),
                              ),
                              Positioned(
                              left: 370,
                              top: 208,
                              child: Checkbox(
                                value: widget.formData['middleClimb'], 
                                tristate: true,
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"middleClimb": value});
                                      if (value != false) {
                                        widget.onDataChanged({"leftClimb": false});
                                        widget.onDataChanged({"rightClimb": false});
                                      }
                                    });
                                  }
                                ),
                              ),
                              Positioned(
                              left: 370,
                              top: 188,
                              child: Checkbox(
                                value: widget.formData['leftClimb'], 
                                tristate: true,
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"leftClimb": value});
                                      if (value != false) {
                                        widget.onDataChanged({"rightClimb": false});
                                        widget.onDataChanged({"middleClimb": false});
                                      }
                                    });
                                  }
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        FittedBox(
                          alignment: Alignment.topLeft,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  'images/red_field_2026.png',
                                  width: 500,
                                  fit: BoxFit.scaleDown,
                                  isAntiAlias: true,
                                  errorBuilder: (context, error, stackTrace) => SizedBox(width: 500, height: 300),
                                ),
                              ),
                              Positioned(
                              right: 265,
                              top: 15,
                              child: SizedBox(
                                height: 465,
                                child: RotatedBox(
                                quarterTurns: 1,
                                child: Slider(
                                  activeColor: Color.fromARGB(0, 191, 185, 185),
                                  inactiveColor: Color.fromARGB(0, 191, 185, 185),
                                  thumbColor: Color.fromARGB(255, 170, 18, 34),
                                  max: 465,
                                  value: widget.formData["startPos"], 
                                  onChanged: (value) {
                                    setState(() {
                                      widget.onDataChanged({"startPos": value});
                                    });
                                  }
                                ),
                              ),
                              )
                            ),
                            Positioned(
                              right: 295,
                              top: widget.formData["startPos"] * 465 / 500,
                              child: Text("Start")
                            ),
                              Positioned(
                              right: 385,
                              bottom: 325,
                              child: Checkbox(
                                value: widget.formData['depotDisrupted'] ?? false, 
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"depotDisrupted": value});
                                    });
                                  }
                                ),
                              ),
                              Positioned(
                                left: 45,
                                bottom: 45,
                                child: Checkbox(
                                  value: widget.formData['outpostDisrupted'] ?? false, 
                                  onChanged: (value) {
                                      setState(() {
                                        widget
                                            .onDataChanged({"outpostDisrupted": value});
                                      });
                                    }
                                ),
                              ),
                              Positioned(
                                right: 75,
                                bottom: 100,
                                child: Checkbox(
                                  value: widget.formData['topDisrupted'] ?? false, 
                                  onChanged: (value) {
                                      setState(() {
                                        widget
                                            .onDataChanged({"topDisrupted": value});
                                      });
                                    }
                                ),
                              ),
                              Positioned(
                                right: 75,
                                bottom: 230,
                                child: Checkbox(
                                  value: widget.formData['middleDisrupted'] ?? false, 
                                  onChanged: (value) {
                                      setState(() {
                                        widget
                                            .onDataChanged({"middleDisrupted": value});
                                      });
                                    }
                                ),
                              ),
                              Positioned(
                                right: 75,
                                bottom: 350,
                                child: Checkbox(
                                  value: widget.formData['bottomDisrupted'] ?? false, 
                                  onChanged: (value) {
                                      setState(() {
                                        widget
                                            .onDataChanged({"bottomDisrupted": value});
                                      });
                                    }
                                ),
                              ),
                              Positioned(
                              right: 370,
                              bottom: 228,
                              child: Checkbox(
                                value: widget.formData['rightClimb'], 
                                tristate: true,
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"rightClimb": value});
                                      if (value != false) {
                                        widget.onDataChanged({"leftClimb": false});
                                        widget.onDataChanged({"middleClimb": false});
                                      }
                                    });
                                  }
                                ),
                              ),
                              Positioned(
                              right: 370,
                              bottom: 208,
                              child: Checkbox(
                                value: widget.formData['middleClimb'], 
                                tristate: true,
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"middleClimb": value});
                                      if (value != false) {
                                        widget.onDataChanged({"leftClimb": false});
                                        widget.onDataChanged({"rightClimb": false});
                                      }
                                    });
                                  }
                                ),
                              ),
                              Positioned(
                              right: 370,
                              bottom: 188,
                              child: Checkbox(
                                value: widget.formData['leftClimb'], 
                                tristate: true,
                                onChanged: (value) {
                                    setState(() {
                                      widget
                                          .onDataChanged({"leftClimb": value});
                                      if (value != false) {
                                        widget.onDataChanged({"rightClimb": false});
                                        widget.onDataChanged({"middleClimb": false});
                                      }
                                    });
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Flexible(
                            child: NumberInput(
                              title: "Cycles",
                              enableSpacer: true,
                              value: widget.formData["autoCycles"],
                              onValueAdd: () {
                                setState(() {
                                  widget.onDataChanged({
                                    "autoCycles": widget.formData[
                                            "autoCycles"] +
                                        1
                                  });
                                });
                              },
                              onValueSubtract: () {
                                setState(() {
                                  if (widget
                                          .formData["autoCycles"] >
                                      0) {
                                    widget.onDataChanged({
                                      "autoCycles": widget.formData[
                                              "autoCycles"] -
                                          1
                                    });
                                  } else {
                                    widget.onDataChanged(
                                        {"autoCycles": 0});
                                  }
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: NumberInput(
                              title: "Fuel Scored",
                              enableSpacer: true,
                              value: widget.formData["estimatedFuel"],
                              onValueAdd: () {
                                setState(() {
                                  widget.onDataChanged({
                                    "estimatedFuel": widget.formData[
                                            "estimatedFuel"] +
                                        2
                                  });
                                });
                              },
                              onValueSubtract: () {
                                setState(() {
                                  if (widget
                                          .formData["estimatedFuel"] >
                                      0) {
                                    widget.onDataChanged({
                                      "estimatedFuel": widget.formData[
                                              "estimatedFuel"] -
                                          2
                                    });
                                  } else {
                                    widget.onDataChanged(
                                        {"estimatedFuel": 0});
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row (
                        children: [
                          Flexible(
                            child: CheckboxListTile(
                              title: const Text('Went Over Bump?'),
                              value: widget.formData['overBumb'], 
                              onChanged: (value) {
                                setState(() {
                                  widget
                                      .onDataChanged({"overBumb": value});
                                });
                              }
                            ),
                          ),
                          Flexible(
                            child: CheckboxListTile(
                              title: const Text('Went Under Trench?'),
                              value: widget.formData['underTrench'], 
                              onChanged: (value) {
                                setState(() {
                                  widget
                                      .onDataChanged({"underTrench": value});
                                });
                              }
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 8.0),
                      CheckboxListTile(
                        title: const Text('Crossed Center Line?'),
                        value: widget.formData['centerLineCrossed'], 
                        onChanged: (value) {
                          setState(() {
                            widget
                                .onDataChanged({"centerLineCrossed": value});
                          });
                        }
                      ),
                  ] else 
                    const SizedBox(height: 1),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
