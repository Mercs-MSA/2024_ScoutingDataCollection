import 'package:flutter/material.dart';

import 'widgets.dart';

class MatchForm extends StatefulWidget {
  const MatchForm({
    super.key,
    required this.teamNumberPresent,
    required this.onDataChanged,
    required this.formData,
  });

  final bool teamNumberPresent;

  final Function(Map<String, dynamic>) onDataChanged;
  final Map formData;

  @override
  State<MatchForm> createState() => _MatchFormState();
}

enum CoralPositions { lOne, lTwo, lThree, lFour }

enum AlgaePositions { processor, barge, descore }

enum ClimbPositions { shallow, deep }

class _MatchFormState extends State<MatchForm> {
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
            child: Column(children: <Widget>[
              Stepper(steps: [
                Step(title: Text("The Step"), content: Placeholder()),
                Step(title: Text("The Other Step"), content: FlutterLogo()),
              ])
            ]),
          ))
        else
          const SizedBox(),
      ],
    );
  }
}
