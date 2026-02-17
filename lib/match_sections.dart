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
          padding: EdgeInsets.all(8),
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
                        if (widget.form.formData["team1Shooter"] == true) ... [
                          SizedBox(height: 16.0),
                          ShooterEvaluation2026(
                            ratingRange: 3, 
                            onAccuracyChanged: (newValue) {
                              widget.form.onDataChanged({"team1ShootingAccuracy": newValue});
                            },
                            onSpeedChanged: (newValue) {
                              widget.form.onDataChanged({"team1ShootingRate": newValue});
                            },
                          )
                        ] else 
                          SizedBox(),
                        if (widget.form.formData["team1Defender"] == true) ... [
                          SizedBox(height: 16.0),
                          DefenderEvaluation2026(
                            ratingRange: 3, 
                            onEfficiencyChanged: (newValue) {
                              widget.form.onDataChanged({"team1DefenderEfficiency": newValue});
                            },
                            form: widget.form.formData,
                            onDataChanged: widget.form.onDataChanged,
                            team: "team1"
                          )
                        ] else 
                          SizedBox(),
                        if (widget.form.formData["team1Feeder"] == true) ... [
                          SizedBox(height: 16.0),
                          FeederEvaluation2026(
                            ratingRange: 3, 
                            onAccuracyChanged: (newValue) {
                              widget.form.onDataChanged({"team1FeederAccuracy": newValue});
                            },
                            onSpeedChanged: (newValue) {
                              widget.form.onDataChanged({"team1FeederRate": newValue});
                            },
                          )
                        ] else 
                          SizedBox(),

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
                        if (widget.form.formData["team2Shooter"] == true) ... [
                          SizedBox(height: 16.0),
                          ShooterEvaluation2026(
                            ratingRange: 3, 
                            onAccuracyChanged: (newValue) {
                              widget.form.onDataChanged({"team2ShootingAccuracy": newValue});
                            },
                            onSpeedChanged: (newValue) {
                              widget.form.onDataChanged({"team2ShootingRate": newValue});
                            },
                          )
                        ] else 
                          SizedBox(),
                        if (widget.form.formData["team2Defender"] == true) ... [
                          SizedBox(height: 16.0),
                          DefenderEvaluation2026(
                            ratingRange: 3, 
                            onEfficiencyChanged: (newValue) {
                              widget.form.onDataChanged({"team2DefenderEfficiency": newValue});
                            },
                            form: widget.form.formData,
                            onDataChanged: widget.form.onDataChanged,
                            team: "team2"
                          )
                        ] else 
                          SizedBox(),
                        if (widget.form.formData["team2Feeder"] == true) ... [
                          SizedBox(height: 16.0),
                          FeederEvaluation2026(
                            ratingRange: 3, 
                            onAccuracyChanged: (newValue) {
                              widget.form.onDataChanged({"team2FeederAccuracy": newValue});
                            },
                            onSpeedChanged: (newValue) {
                              widget.form.onDataChanged({"team2FeederRate": newValue});
                            },
                          )
                        ] else 
                          SizedBox(),

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
                        if (widget.form.formData["team3Shooter"] == true) ... [
                          SizedBox(height: 16.0),
                          ShooterEvaluation2026(
                            ratingRange: 3, 
                            onAccuracyChanged: (newValue) {
                              widget.form.onDataChanged({"team3ShootingAccuracy": newValue});
                            },
                            onSpeedChanged: (newValue) {
                              widget.form.onDataChanged({"team3ShootingRate": newValue});
                            },
                          )
                        ] else 
                          SizedBox(),
                        if (widget.form.formData["team3Defender"] == true) ... [
                          SizedBox(height: 16.0),
                          DefenderEvaluation2026(
                            ratingRange: 3, 
                            onEfficiencyChanged: (newValue) {
                              widget.form.onDataChanged({"team3DefenderEfficiency": newValue});
                            },
                            form: widget.form.formData,
                            onDataChanged: widget.form.onDataChanged,
                            team: "team3"
                            // defendLocations: widget.form.formData["team3DefendLocations"],
                          )
                        ] else 
                          SizedBox(),
                        if (widget.form.formData["team3Feeder"] == true) ... [
                          SizedBox(height: 16.0),
                          FeederEvaluation2026(
                            ratingRange: 3, 
                            onAccuracyChanged: (newValue) {
                              widget.form.onDataChanged({"team3FeederAccuracy": newValue});
                            },
                            onSpeedChanged: (newValue) {
                              widget.form.onDataChanged({"team3FeederRate": newValue});
                            },
                          )
                        ] else 
                          SizedBox(),
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
              
              // Failed climb section
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text("Failed climb?",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTeamCheckbox(context, "team1FailedClimb",
                        "Team ${widget.form.formData["team1"]}"),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTeamCheckbox(context, "team2FailedClimb",
                        "Team ${widget.form.formData["team2"]}"),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTeamCheckbox(context, "team3FailedClimb",
                        "Team ${widget.form.formData["team3"]}"),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              
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
                              height: 50,
                            ),
                          ),
                          Expanded(
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
                              height: 50,
                              child: Text(
                                "Team ${widget.form.formData["team1"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
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
                              height: 50,
                              child: Text(
                                "Team ${widget.form.formData["team2"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              alignment: Alignment.center,
                              height: 50,
                              child: Text(
                                "Team ${widget.form.formData["team3"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
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
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTeamCheckbox(context, "team2ClimbedFromBack",
                        "Team ${widget.form.formData["team2"]}"),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTeamCheckbox(context, "team3ClimbedFromBack",
                        "Team ${widget.form.formData["team3"]}"),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              
              // Speed of climb section
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
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildSpeedControl(context, "Team ${widget.form.formData["team2"]}", 2),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildSpeedControl(context, "Team ${widget.form.formData["team3"]}", 3),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              
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

              Row(
                children: [
                  Expanded(
                      child: CheckboxListTile(
                        dense: true,
                        title: const Text("Didn't Show Up?"),
                        value: widget.form.formData["noShow"],
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.form.onDataChanged({"noShow": newValue});
                          });
                        },
                      )),
                  Expanded(
                      child: CheckboxListTile(
                        dense: true,
                        title: const Text("Disabled?"),
                        value: widget.form.formData["disabled"],
                        onChanged: (bool? newValue) {
                          setState(() {
                            widget.form.onDataChanged({"disabled": newValue});
                          });
                        },
                      )),
                ],
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
                  enableSpacer: true),
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
        Expanded(
          child: _buildGridCell(context, "team1EndgameLevel", level),
        ),
        Expanded(
          child: _buildGridCell(context, "team2EndgameLevel", level),
        ),
        Expanded(
          child: _buildGridCell(context, "team3EndgameLevel", level),
        ),
      ],
    );
  }

  Container _buildGridCell(
      BuildContext context, String dataKey, int level) {
    final isSelected = widget.form.formData[dataKey] == level;
    
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
                widget.form.onDataChanged({dataKey: 0});
              } else {
                widget.form.onDataChanged({dataKey: level});
              }
            });
          },
          child: Container(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Colors.transparent,
            alignment: Alignment.center,
            child: Icon(
              isSelected ? Icons.circle : Icons.circle_outlined,
              color: Theme.of(context).colorScheme.primary,
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
          const SizedBox(height: 12.0),
          Text(
            "30",
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: speed.toDouble(),
            min: 3,
            max: 30,
            divisions: 27,
            onChanged: (value) {
              setState(() {
                widget.form.onDataChanged({speedKey: value.toInt()});
              });
            },
          ),
          Text(
            "3",
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            speed.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
