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

class TabState extends ChangeNotifier {
  var tabController = TabController(vsync: _MatchFormState(), length: 5);
}

class _MatchFormState extends State<MatchForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
  }

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
          Scaffold(
            appBar: TabBar(
              controller: _tabController,
              tabs: const <Widget>[
                Tab(
                  icon: Icon(Icons.auto_awesome),
                  text: "Auton",
                ),
                Tab(
                  icon: Icon(Icons.videogame_asset_rounded),
                  text: "Teleop",
                ),
                Tab(
                  icon: Icon(Icons.bolt),
                  text: "Endgame",
                ),
              ],
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                Center(
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
                                    if (widget.formData["autoL4scored"] > 0) {
                                      widget.onDataChanged({
                                        "autoL4scored":
                                            widget.formData["autoL4scored"] - 1
                                      });
                                    } else {
                                      widget.onDataChanged({"autoL4scored": 0});
                                    }
                                  });
                                },
                                iconAlignment: IconAlignment.end,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: const Text("-",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20.0)),
                                )),
                            const Spacer(),
                            Text(
                              "L4: ${widget.formData["autoL4scored"]}",
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
                                    widget.onDataChanged({
                                      "autoL4scored":
                                          widget.formData["autoL4scored"] + 1
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
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
