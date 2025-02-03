import 'package:flutter/material.dart';

import 'match_form.dart';

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Row(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary))),
                    onPressed: () {
                      setState(() {
                        if (widget.form.formData["autoL4scored"] > 0) {
                          widget.form.onDataChanged({
                            "autoL4scored":
                                widget.form.formData["autoL4scored"] - 1
                          });
                        } else {
                          widget.form.onDataChanged({"autoL4scored": 0});
                        }
                      });
                    },
                    iconAlignment: IconAlignment.end,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text("-",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20.0)),
                    )),
                const Spacer(),
                Text(
                  "L4: ${widget.form.formData["autoL4scored"]}",
                  style: TextStyle(fontSize: 20.0),
                ),
                const Spacer(),
                TextButton(
                    style: TextButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary))),
                    onPressed: () {
                      setState(() {
                        widget.form.onDataChanged({
                          "autoL4scored":
                              widget.form.formData["autoL4scored"] + 1
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text("+",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20.0,
                              color: Colors.green)),
                    )),
              ],
            ),
          ],
        ),
      ),
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("TeleopSection\nParent form data: ${widget.form.formData}"),
          ],
        ),
      ),
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
