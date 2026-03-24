import 'package:flutter/material.dart';
import 'package:mercs_scout/datatypes.dart';

import 'match_form.dart';
import 'widgets.dart';

class MatchAutonSection extends StatefulWidget {
  final MatchForm form;
  
  const MatchAutonSection(
      {super.key, required this.form, required this.colorDebug, required this.allianceColor});

  final bool colorDebug;

  final String allianceColor;

  @override
  State<MatchAutonSection> createState() => _MatchAutonSectionState();
}

class _MatchAutonSectionState extends State<MatchAutonSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SwitchListTile (
                title: const Text('Has Auto?'),
                value: widget.form.formData['autoLeave'] ?? false, 
                onChanged: (value) {
                  setState(() {
                    widget.form
                        .onDataChanged({"autoLeave": value});
                  });
                }
              ),
              const SizedBox(height: 12.0),
              if (widget.form.formData['autoLeave'] == true) ... [
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
                          top: 35,
                          child: SizedBox(
                            height: 420,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: SegmentedButton<AutoStartLocation>(
                                emptySelectionAllowed: false,
                                multiSelectionEnabled: false,
                                style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.all(18.0))),
                                segments: <ButtonSegment<AutoStartLocation>>[
                                  ButtonSegment(
                                      label: Text("RR"),
                                      value: AutoStartLocation.farRight),
                                  ButtonSegment(
                                      label: Text("R"),
                                      value: AutoStartLocation.right),
                                  ButtonSegment(
                                      label: Text("M"),
                                      value: AutoStartLocation.middle),
                                  ButtonSegment(
                                      label: Text("L"),
                                      value: AutoStartLocation.left),
                                  ButtonSegment(
                                      label: Text("LL"),
                                      value: AutoStartLocation.farLeft)
                                ],
                                selected: <AutoStartLocation>{
                                  widget.form.formData['startPos'] ?? AutoStartLocation.middle
                                },
                                onSelectionChanged: (Set<AutoStartLocation> value) {
                                  setState(() {
                                    widget.form.onDataChanged({
                                      "startPos": value.first
                                    });
                                  });
                                },
                              ),
                            ),
                          )
                        ),
                        Positioned(
                          left: 370,
                          top: 208,
                          child: Checkbox(
                            value: widget.form.formData['climb'], 
                            tristate: true,
                            onChanged: (value) {
                                setState(() {
                                  widget.form
                                      .onDataChanged({"climb": value});
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
                          top: 35,
                          child: SizedBox(
                            height: 420,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: SegmentedButton<AutoStartLocation>(
                                emptySelectionAllowed: false,
                                multiSelectionEnabled: false,
                                style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.all(18.0))),
                                segments: <ButtonSegment<AutoStartLocation>>[
                                  ButtonSegment(
                                      label: Text("RR"),
                                      value: AutoStartLocation.farRight),
                                  ButtonSegment(
                                      label: Text("R"),
                                      value: AutoStartLocation.right),
                                  ButtonSegment(
                                      label: Text("M"),
                                      value: AutoStartLocation.middle),
                                  ButtonSegment(
                                      label: Text("L"),
                                      value: AutoStartLocation.left),
                                  ButtonSegment(
                                      label: Text("LL"),
                                      value: AutoStartLocation.farLeft)
                                ],
                                selected: <AutoStartLocation>{
                                  widget.form.formData['startPos'] ?? AutoStartLocation.middle
                                },
                                onSelectionChanged: (Set<AutoStartLocation> value) {
                                  setState(() {
                                    widget.form.onDataChanged({
                                      "startPos": value.first
                                    });
                                  });
                                },
                              ),
                            ),
                          )
                        ),
                        Positioned(
                          right: 370,
                          bottom: 208,
                          child: Checkbox(
                            value: widget.form.formData['climb'], 
                            tristate: true,
                            onChanged: (value) {
                                setState(() {
                                  widget.form
                                      .onDataChanged({"climb": value});
                                });
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8.0),Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<RebuiltFieldLocations>(
                          emptySelectionAllowed: true,
                          multiSelectionEnabled: true,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return ColorScheme.fromSeed(
                                    seedColor: widget.colorDebug
                                        ? Colors.green
                                        : const Color.fromARGB(
                                            255, 78, 180, 127),
                                  ).primary;
                                }
                                return Colors.transparent;
                              },
                            ),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.all(18.0))),
                          segments: <ButtonSegment<RebuiltFieldLocations>>[
                            ButtonSegment(
                                value: RebuiltFieldLocations.depot,
                                label: Text("Depot")),
                            ButtonSegment(
                                value: RebuiltFieldLocations.outpost,
                                label: Text("Outpost"))
                          ],
                          selected: {
                            if (widget.form.formData['depotDisrupted'])
                              RebuiltFieldLocations.depot,
                            if (widget.form.formData['outpostDisrupted'])
                              RebuiltFieldLocations.outpost,
                          },
                          onSelectionChanged:
                              (Set<RebuiltFieldLocations> value) {
                            setState(() {
                              widget.form.onDataChanged({
                                "depotDisrupted": value
                                    .contains(RebuiltFieldLocations.depot),
                                "outpostDisrupted": value
                                    .contains(RebuiltFieldLocations.outpost),
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Flexible(
                        child: NumberInput(
                          title: "Swipes",
                          enableSpacer: true,
                          value: widget.form.formData["autoSwipes"],
                          onValueAdd: () {
                            setState(() {
                              widget.form.onDataChanged({
                                "autoSwipes": widget.form.formData[
                                        "autoSwipes"] +
                                    1
                              });
                            });
                          },
                          onValueSubtract: () {
                            setState(() {
                              if (widget.form
                                      .formData["autoSwipes"] >
                                  0) {
                                widget.form.onDataChanged({
                                  "autoSwipes": widget.form.formData[
                                          "autoSwipes"] -
                                      1
                                });
                              } else {
                                widget.form.onDataChanged(
                                    {"autoSwipes": 0});
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
                          value: widget.form.formData['overBumb'], 
                          onChanged: (value) {
                            setState(() {
                              widget.form
                                  .onDataChanged({"overBumb": value});
                            });
                          }
                        ),
                      ),
                      Flexible(
                        child: CheckboxListTile(
                          title: const Text('Went Under Trench?'),
                          value: widget.form.formData['underTrench'], 
                          onChanged: (value) {
                            setState(() {
                              widget.form
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
                    value: widget.form.formData['centerLineCrossed'], 
                    onChanged: (value) {
                      setState(() {
                        widget.form
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
              // Expanded(
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           SectionHeader(
              //               title: "Team ${widget.form.formData["team2"]}",
              //               color: Theme.of(context).dividerColor),
              //         ],
              //       ),
              //     ]
              //   )
              // ),
              // Expanded(
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           SectionHeader(
              //               title: "Team ${widget.form.formData["team3"]}",
              //               color: Theme.of(context).dividerColor),
              //         ],
              //       ),
              //     ]
              //   )
              // ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
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
                          title: Text("Shunter?"),
                          value: widget.form.formData["team1Shunter"] ?? false, 
                          onChanged: (value) {
                            setState(() {
                              widget.form.onDataChanged({"team1Shunter": value});
                            });
                          }
                        ),
                        RatingInput(
                          title: "Collection Rate", 
                          fontSize: 16,
                          onRatingUpdate: (newValue) {
                            widget.form.onDataChanged({"team1CollectionRate": newValue});
                          },
                          initialRating: (widget.form.formData["team1CollectionRate"] ?? 0).toDouble(),
                          itemCount: 5,
                          enableHalves: false,
                          titleOnTop: true,
                        ),
                        if (widget.form.formData["team1Shooter"] == true) ... [
                          SizedBox(height: 16.0),
                          ShooterEvaluation2026(
                            ratingRange: 5,
                            shootingAccuracy: (widget.form.formData["team1ShootingAccuracy"] ?? 0).toDouble(),
                            onAccuracyChanged: (newValue) {
                              widget.form.onDataChanged({"team1ShootingAccuracy": newValue});
                            },
                            // onPrecisionChanged: (newValue) {
                            //   widget.form.onDataChanged({"team1ShootingPrecision": newValue});
                            // },
                            shootingRate: (widget.form.formData["team1ShootingRate"] ?? 0).toDouble(),
                            onSpeedChanged: (newValue) {
                              widget.form.onDataChanged({"team1ShootingRate": newValue});
                            },
                            // onCycleAbilityChanged: (newValue) {
                            //   widget.form.onDataChanged({"team1CycleAbility": newValue});
                            // },
                            counterdefense: widget.form.formData["team1Counterdefense"],
                            onCounterdefenseChanged: (newValue) {
                              setState(() {
                                widget.form.onDataChanged({"team1Counterdefense": newValue});
                              });
                            },
                            cyclesPerAllianceShift: widget.form.formData["team1CyclesPerAllianceShift"] ?? 0,
                            onCyclesPerAllianceShiftAdd: () {
                              setState(() {
                                widget.form.onDataChanged({"team1CyclesPerAllianceShift": (widget.form.formData["team1CyclesPerAllianceShift"] ?? 0) + 1});
                              });
                            },
                            onCyclesPerAllianceShiftSubtract: () {
                              setState(() {
                                if (widget.form.formData["team1CyclesPerAllianceShift"] > 0) {
                                  widget.form.onDataChanged({"team1CyclesPerAllianceShift": (widget.form.formData["team1CyclesPerAllianceShift"]) - 1});
                                } else {
                                  widget.form.onDataChanged({"team1CyclesPerAllianceShift": 0});
                                }                              
                              });
                            },
                          )
                        ] else 
                          SizedBox(),
                        if (widget.form.formData["team1Defender"] == true) ... [
                          SizedBox(height: 16.0),
                          DefenderEvaluation2026(
                            form: widget.form.formData,
                            onDataChanged: widget.form.onDataChanged,
                            team: "team1"
                          )
                        ] else 
                          SizedBox(),
                        if (widget.form.formData["team1Shunter"] == true) ... [
                          SizedBox(height: 16.0),
                          FeederEvaluation2026(
                            ratingRange: 5,
                            feedingRate: (widget.form.formData["team1ShunterRate"] ?? 0).toDouble(),
                            onFeedingRateChanged: (newValue) {
                              widget.form.onDataChanged({"team1ShunterRate": newValue});
                            },
                          )
                        ] else 
                          SizedBox(),

                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: Column(
                  //     children: [
                  //       CheckboxListTile(
                  //         title: Text("Shooter?"),
                  //         value: widget.form.formData["team2Shooter"] ?? false, 
                  //         onChanged: (value) {
                  //           setState(() {
                  //             widget.form.onDataChanged({"team2Shooter": value});
                  //           });
                  //         }
                  //       ),
                  //       CheckboxListTile(
                  //         title: Text("Defender?"),
                  //         value: widget.form.formData["team2Defender"] ?? false, 
                  //         onChanged: (value) {
                  //           setState(() {
                  //             widget.form.onDataChanged({"team2Defender": value});
                  //           });
                  //         }
                  //       ),
                  //       CheckboxListTile(
                  //         title: Text("Shunter?"),
                  //         value: widget.form.formData["team2Shunter"] ?? false, 
                  //         onChanged: (value) {
                  //           setState(() {
                  //             widget.form.onDataChanged({"team2Shunter": value});
                  //           });
                  //         }
                  //       ),
                  //       RatingInput(
                  //         title: "Collection Rate", 
                  //         fontSize: 16,
                  //         onRatingUpdate: (newValue) {
                  //           widget.form.onDataChanged({"team2CollectionRate": newValue});
                  //         },
                  //         initialRating: (widget.form.formData["team2CollectionRate"] ?? 0).toDouble(),
                  //         itemCount: 5,
                  //         enableHalves: false,
                  //         titleOnTop: true,
                  //       ),
                  //       if (widget.form.formData["team2Shooter"] == true) ... [
                  //         SizedBox(height: 16.0),
                  //         ShooterEvaluation2026(
                  //           ratingRange: 5,
                  //           shootingAccuracy: (widget.form.formData["team2ShootingAccuracy"] ?? 0).toDouble(),
                  //           onAccuracyChanged: (newValue) {
                  //             widget.form.onDataChanged({"team2ShootingAccuracy": newValue});
                  //           },
                  //           // onPrecisionChanged: (newValue) {
                  //           //   widget.form.onDataChanged({"team2ShootingPrecision": newValue});
                  //           // },
                  //           shootingRate: (widget.form.formData["team2ShootingRate"] ?? 0).toDouble(),
                  //           onSpeedChanged: (newValue) {
                  //             widget.form.onDataChanged({"team2ShootingRate": newValue});
                  //           },
                  //           // onCycleAbilityChanged: (newValue) {
                  //           //   widget.form.onDataChanged({"team2CycleAbility": newValue});
                  //           // },
                  //           counterdefense: widget.form.formData["team2Counterdefense"],
                  //           onCounterdefenseChanged: (newValue) {
                  //             setState(() {
                  //               widget.form.onDataChanged({"team2Counterdefense": newValue});
                  //             });
                  //           },
                  //           cyclesPerAllianceShift: widget.form.formData["team2CyclesPerAllianceShift"] ?? 0,
                  //           onCyclesPerAllianceShiftAdd: () {
                  //             setState(() {
                  //               widget.form.onDataChanged({"team2CyclesPerAllianceShift": (widget.form.formData["team2CyclesPerAllianceShift"] ?? 0) + 1});
                  //             });
                  //           },
                  //           onCyclesPerAllianceShiftSubtract: () {
                  //             setState(() {
                  //               if (widget.form.formData["team2CyclesPerAllianceShift"] > 0) {
                  //                 widget.form.onDataChanged({"team2CyclesPerAllianceShift": (widget.form.formData["team2CyclesPerAllianceShift"]) - 1});
                  //               } else {
                  //                 widget.form.onDataChanged({"team2CyclesPerAllianceShift": 0});
                  //               }
                  //             });
                  //           },
                  //         )
                  //       ] else 
                  //         SizedBox(),
                  //       if (widget.form.formData["team2Defender"] == true) ... [
                  //         SizedBox(height: 16.0),
                  //         DefenderEvaluation2026(
                  //           form: widget.form.formData,
                  //           onDataChanged: widget.form.onDataChanged,
                  //           team: "team2"
                  //         )
                  //       ] else 
                  //         SizedBox(),
                  //       if (widget.form.formData["team2Shunter"] == true) ... [
                  //         SizedBox(height: 16.0),
                  //         FeederEvaluation2026(
                  //           ratingRange: 5,
                  //           feedingRate: (widget.form.formData["team2ShunterRate"] ?? 0).toDouble(),
                  //           onFeedingRateChanged: (newValue) {
                  //             widget.form.onDataChanged({"team2ShunterRate": newValue});
                  //           },
                  //         )
                  //       ] else 
                  //         SizedBox(),
                  //     ],
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Column(
                  //     children: [
                  //       CheckboxListTile(
                  //         title: Text("Shooter?"),
                  //         value: widget.form.formData["team3Shooter"] ?? false, 
                  //         onChanged: (value) {
                  //           setState(() {
                  //             widget.form.onDataChanged({"team3Shooter": value});
                  //           });
                  //         }
                  //       ),
                  //       CheckboxListTile(
                  //         title: Text("Defender?"),
                  //         value: widget.form.formData["team3Defender"] ?? false, 
                  //         onChanged: (value) {
                  //           setState(() {
                  //             widget.form.onDataChanged({"team3Defender": value});
                  //           });
                  //         }
                  //       ),
                  //       CheckboxListTile(
                  //         title: Text("Shunter?"),
                  //         value: widget.form.formData["team3Shunter"] ?? false, 
                  //         onChanged: (value) {
                  //           setState(() {
                  //             widget.form.onDataChanged({"team3Shunter": value});
                  //           });
                  //         }
                  //       ),
                  //       RatingInput(
                  //         title: "Collection Rate", 
                  //         fontSize: 16,
                  //         onRatingUpdate: (newValue) {
                  //           widget.form.onDataChanged({"team3CollectionRate": newValue});
                  //         },
                  //         initialRating: 0,
                  //         itemCount: 5,
                  //         enableHalves: false,
                  //         titleOnTop: true,
                  //       ),
                  //       if (widget.form.formData["team3Shooter"] == true) ... [
                  //         SizedBox(height: 16.0),
                  //         ShooterEvaluation2026(
                  //           ratingRange: 5,
                  //           shootingAccuracy: (widget.form.formData["team3ShootingAccuracy"] ?? 0).toDouble(),
                  //           onAccuracyChanged: (newValue) {
                  //             widget.form.onDataChanged({"team3ShootingAccuracy": newValue});
                  //           },
                  //           // onPrecisionChanged: (newValue) {
                  //           //   widget.form.onDataChanged({"team3ShootingPrecision": newValue});
                  //           // },
                  //           shootingRate: (widget.form.formData["team3ShootingRate"] ?? 0).toDouble(),
                  //           onSpeedChanged: (newValue) {
                  //             widget.form.onDataChanged({"team3ShootingRate": newValue});
                  //           },
                  //           // onCycleAbilityChanged: (newValue) {
                  //           //   widget.form.onDataChanged({"team3CycleAbility": newValue});
                  //           // },
                  //           counterdefense: widget.form.formData["team3Counterdefense"],
                  //           onCounterdefenseChanged: (newValue) {
                  //             setState(() {
                  //               widget.form.onDataChanged({"team3Counterdefense": newValue});
                  //             });
                  //           },
                  //           cyclesPerAllianceShift: widget.form.formData["team3CyclesPerAllianceShift"] ?? 0,
                  //           onCyclesPerAllianceShiftAdd: () {
                  //             setState(() {
                  //               widget.form.onDataChanged({"team3CyclesPerAllianceShift": (widget.form.formData["team3CyclesPerAllianceShift"] ?? 0) + 1});
                  //             });
                  //           },
                  //           onCyclesPerAllianceShiftSubtract: () {
                  //             setState(() {
                  //               if (widget.form.formData["team3CyclesPerAllianceShift"] > 0) {
                  //                 widget.form.onDataChanged({"team3CyclesPerAllianceShift": (widget.form.formData["team3CyclesPerAllianceShift"]) - 1});
                  //               } else {
                  //                 widget.form.onDataChanged({"team3CyclesPerAllianceShift": 0});
                  //               }
                  //             });
                  //           },
                  //         )
                  //       ] else 
                  //         SizedBox(),
                  //       if (widget.form.formData["team3Defender"] == true) ... [
                  //         SizedBox(height: 16.0),
                  //         DefenderEvaluation2026(
                  //           form: widget.form.formData,
                  //           onDataChanged: widget.form.onDataChanged,
                  //           team: "team3"
                  //           // defendLocations: widget.form.formData["team3DefendLocations"],
                  //         )
                  //       ] else 
                  //         SizedBox(),
                  //       if (widget.form.formData["team3Shunter"] == true) ... [
                  //         SizedBox(height: 16.0),
                  //         FeederEvaluation2026(
                  //           ratingRange: 5,
                  //           feedingRate: (widget.form.formData["team3ShunterRate"] ?? 0).toDouble(),
                  //           onFeedingRateChanged: (newValue) {
                  //             widget.form.onDataChanged({"team3ShunterRate": newValue});
                  //           },
                  //         )
                  //       ] else 
                  //         SizedBox(),
                  //     ],
                  //   ),
                  // ),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Endgame Grid Title
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text("Endgame",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ),
              
              // Climb Level Grid
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    // Headers row (Team numbers)
                    Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Row(
                        children: [
                          // Expanded(
                          //   flex: 1,
                          //   child: Container(
                          //     padding: const EdgeInsets.all(12.0),
                          //     alignment: Alignment.center,
                          //     decoration: BoxDecoration(
                          //       border: Border(
                          //         right: BorderSide(
                          //           color: Theme.of(context).dividerColor,
                          //           width: 1,
                          //         ),
                          //       ),
                          //     ),
                          //     height: 50,
                          //   ),
                          // ),
                          // Expanded(
                          //   child: Container(
                          //     padding: const EdgeInsets.all(12.0),
                          //     alignment: Alignment.center,
                          //     decoration: BoxDecoration(
                          //       border: Border(
                          //         right: BorderSide(
                          //           color: Theme.of(context).dividerColor,
                          //           width: 1,
                          //         ),
                          //       ),
                          //     ),
                          //     height: 50,
                          //     child: Text(
                          //       "Team ${widget.form.formData["team1"]}",
                          //       style: const TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 14,
                          //       ),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                          // Expanded(
                          //   child: Container(
                          //     padding: const EdgeInsets.all(12.0),
                          //     alignment: Alignment.center,
                          //     decoration: BoxDecoration(
                          //       border: Border(
                          //         right: BorderSide(
                          //           color: Theme.of(context).dividerColor,
                          //           width: 1,
                          //         ),
                          //       ),
                          //     ),
                          //     height: 50,
                          //     child: Text(
                          //       "Team ${widget.form.formData["team2"]}",
                          //       style: const TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 14,
                          //       ),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                          // Expanded(
                          //   child: Container(
                          //     padding: const EdgeInsets.all(12.0),
                          //     alignment: Alignment.center,
                          //     height: 50,
                          //     child: Text(
                          //       "Team ${widget.form.formData["team3"]}",
                          //       style: const TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 14,
                          //       ),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // Level rows
                    _buildLevelRow(context, "Lvl 3", 3),
                    _buildLevelRow(context, "Lvl 2", 2),
                    _buildLevelRow(context, "Lvl 1", 1),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              
              // Climb Position section
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 12.0),
              //   child: Text("Climb Position",
              //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //             fontWeight: FontWeight.bold,
              //           )),
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildClimbPositionDropdown(context, "team1ClimbPosition",
              //           "Team ${widget.form.formData["team1"]}"),
              //     ),
              //     const SizedBox(width: 12.0),
              //     Expanded(
              //       child: _buildClimbPositionDropdown(context, "team2ClimbPosition",
              //           "Team ${widget.form.formData["team2"]}"),
              //     ),
              //     const SizedBox(width: 12.0),
              //     Expanded(
              //       child: _buildClimbPositionDropdown(context, "team3ClimbPosition",
              //           "Team ${widget.form.formData["team3"]}"),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 32.0),
              
              // Climbed from the back section
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text("Climbed from the back?",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTeamCheckbox(context, "team1ClimbedFromBack",
                        "Team ${widget.form.formData["team1"]}"),
                  ),
                  // const SizedBox(width: 12.0),
                  // Expanded(
                  //   child: _buildTeamCheckbox(context, "team2ClimbedFromBack",
                  //       "Team ${widget.form.formData["team2"]}"),
                  // ),
                  // const SizedBox(width: 12.0),
                  // Expanded(
                  //   child: _buildTeamCheckbox(context, "team3ClimbedFromBack",
                  //       "Team ${widget.form.formData["team3"]}"),
                  // ),
                ],
              ),
              const SizedBox(height: 32.0),
              
              // Speed of climb section
              if (widget.form.formData["team1EndgameLevel"] != 0) ... [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text("Speed of climb?",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildSpeedControl(context, "Team ${widget.form.formData["team1"]}", 1),
                  ),
                  // const SizedBox(width: 12.0),
                  // Expanded(
                  //   child: _buildSpeedControl(context, "Team ${widget.form.formData["team2"]}", 2),
                  // ),
                  // const SizedBox(width: 12.0),
                  // Expanded(
                  //   child: _buildSpeedControl(context, "Team ${widget.form.formData["team3"]}", 3),
                  // ),
                ],
              ),
              const SizedBox(height: 32.0),
              ],
              
              // Cards section
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text("Cards",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: LabeledSwitch(
                        label: Text(
                          "Yellow Card?",
                          style: TextStyle(
                              fontSize: 14,
                              color: widget.form.formData["yellowCard"]
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                      width: 12.0,
                    ),
                    Expanded(
                      child: LabeledSwitch(
                        label: Text(
                          "Red Card?",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
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
              const SizedBox(height: 32.0),
              
              // Extras section
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text("Extras",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ),
              CheckboxListTile(
                  dense: true,
                  title: const Text("Mark for Review?"),
                  value: widget.form.formData["isMarkedForReview"],
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.form.onDataChanged({"isMarkedForReview": newValue});
                    });
                  }),
              CheckboxListTile(
                  dense: true,
                  title: const Text("Penalties?"),
                  value: widget.form.formData["penalties"] ?? false,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.form.onDataChanged({"penalties": newValue ?? false});
                    });
                  }),

              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildLevelRow(BuildContext context, String levelName, int level) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            height: 70,
            child: Text(
              levelName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        // Expanded(
        //   child: _buildGridCell(context, "team1EndgameLevel", level),
        // ),
        // Expanded(
        //   child: _buildGridCell(context, "team2EndgameLevel", level),
        // ),
        // Expanded(
        //   child: _buildGridCell(context, "team3EndgameLevel", level),
        // ),
        Expanded(
          child: _buildGridCell(context, "left", level),
        ),
        // Expanded(
        //   child: _buildGridCell(context, "middle", level),
        // ),
        // Expanded(
        //   child: _buildGridCell(context, "right", level),
        // ),
      ],
    );
  }

  Container _buildGridCell(
      BuildContext context, String dataKey, int level) {
    // final currentValue = widget.form.formData[dataKey] ?? 0; //ALL OF THIS IS FOR 3 BOT SCOUTING
    // final isSelected = currentValue == level;
    // final isFailed = currentValue == -level;
    
    // return Container(
    //   decoration: BoxDecoration(
    //     border: Border(
    //       right: BorderSide(
    //         color: Theme.of(context).dividerColor,
    //         width: 1,
    //       ),
    //     ),
    //   ),
    //   height: 70,
    //   child: Material(
    //     color: Colors.transparent,
    //     child: InkWell(
    //       onTap: () {
    //         setState(() {
    //           if (isSelected) {
    //             widget.form.onDataChanged({dataKey: -level});
    //           } else if (isFailed) {
    //             widget.form.onDataChanged({dataKey: 0});
    //           } else {
    //             widget.form.onDataChanged({dataKey: level});
    //           }
    //         });
    //       },
    //       child: Container(
    //         color: isSelected
    //             ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
    //             : isFailed
    //                 ? Theme.of(context).colorScheme.error.withOpacity(0.2)
    //                 : Colors.transparent,
    //         alignment: Alignment.center,
    //         child: Icon(
    //           isSelected
    //               ? Icons.check_circle
    //               : isFailed
    //                   ? Icons.cancel
    //                   : Icons.circle_outlined,
    //           color: isSelected
    //               ? Theme.of(context).colorScheme.primary
    //               : isFailed
    //                   ? Theme.of(context).colorScheme.error
    //                   : Theme.of(context).colorScheme.primary,
    //           size: 32,
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    final currentLevel = widget.form.formData["team1EndgameLevel"] ?? 0;
    // final currentPosition = widget.form.formData["team1ClimbPosition"];
    final isSelected = (currentLevel == level); // && (currentPosition == dataKey);
    final isFailed = (currentLevel == -level); // && (currentPosition == dataKey);
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      height: 70,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                widget.form.onDataChanged({"team1EndgameLevel": -level});
                // widget.form.onDataChanged({"team1ClimbPosition": dataKey});
              } else if (isFailed) {
                widget.form.onDataChanged({"team1EndgameLevel": 0});
                // widget.form.onDataChanged({"team1ClimbPosition": "none"});
              } else {
                widget.form.onDataChanged({"team1EndgameLevel": level});
                // widget.form.onDataChanged({"team1ClimbPosition": dataKey});
              }
            });
          },
          child: Container(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : isFailed
                    ? Theme.of(context).colorScheme.error.withOpacity(0.2)
                    : Colors.transparent,
            alignment: Alignment.center,
            child: Icon(
              isSelected
                  ? Icons.check_circle
                  : isFailed
                      ? Icons.cancel
                      : Icons.circle_outlined,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : isFailed
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCheckbox(
      BuildContext context, String dataKey, String teamLabel) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Row(
        children: [
          Checkbox(
            value: widget.form.formData[dataKey] ?? false,
            onChanged: (bool? value) {
              setState(() {
                widget.form.onDataChanged({dataKey: value ?? false});
              });
            },
          ),
          Expanded(
            child: Text(
              teamLabel,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClimbPositionDropdown(
      BuildContext context, String dataKey, String teamLabel) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        children: [
          Text(
            teamLabel,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8.0),
          DropdownButton<String>(
            isExpanded: true,
            value: widget.form.formData[dataKey] ?? "none",
            items: const [
              DropdownMenuItem(value: "none", child: Text("None")),
              DropdownMenuItem(value: "left", child: Text("Left")),
              DropdownMenuItem(value: "center", child: Text("Center")),
              DropdownMenuItem(value: "right", child: Text("Right")),
            ],
            onChanged: (String? newValue) {
              setState(() {
                widget.form.onDataChanged({dataKey: newValue ?? "none"});
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedControl(BuildContext context, String teamLabel, int teamNumber) {
    final speedKey = "team${teamNumber}ClimbSpeed";
    var speed = widget.form.formData[speedKey] ?? 0;
    
    // Ensure speed is within valid range [3, 30]
    if (speed < 3) {
      speed = 3;
      widget.form.formData[speedKey] = 3;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
      children: [
        Text(
          teamLabel,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8.0),
        
        Row(
          children: [
            const Text(
              "3",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Slider(
                value: speed.toDouble(),
                min: 3,
                max: 30,
                divisions: 27,
                onChanged: (value) {
                  setState(() {
                    widget..form.onDataChanged({speedKey: value.toInt()});
                  });
                },
              ),
            ),
            const Text(
              "30",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        
        Text(
          speed.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    ));
  }
}
