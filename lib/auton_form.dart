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
          Center(
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
                              alignment: Alignment.topLeft,
                              child: Image.asset(
                                'images/blue_field_2026.png',
                                fit: BoxFit.scaleDown,
                                // width: 400,
                                isAntiAlias: true,
                                errorBuilder: (context, error, stackTrace) => SizedBox(width: 500, height: 300),
                              ),
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
                            ],
                          ),
                        )
                      else
                        FittedBox(
                          alignment: Alignment.topLeft,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Image.asset(
                                  'images/red_field_2026.png',
                                  // width: 400,
                                  fit: BoxFit.scaleDown,
                                  isAntiAlias: true,
                                  errorBuilder: (context, error, stackTrace) => SizedBox(width: 500, height: 300),
                                ),
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
                            ],
                          ),
                        ),
                      const SizedBox(height: 8.0),
                      NumberInput(
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
                      const SizedBox(height: 8.0),
                      // Row (
                      //   children: [
                          CheckboxListTile(
                            title: const Text('Climb?'),
                            tristate: true,
                            value: widget.formData['climb'], 
                            onChanged: (value) {
                              setState(() {
                                widget
                                    .onDataChanged({"climb": value});
                              });
                            }
                          ),
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
                      //   ]
                      // ),
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
