import 'package:flutter/material.dart';

import 'match_sections.dart';
import 'widgets.dart';

class MatchForm extends StatefulWidget {
  const MatchForm({
    super.key,
    required this.teamNumberPresent,
    required this.onDataChanged,
    required this.formData,
    required this.colorDebug
  });

  final bool teamNumberPresent;

  final Function(Map<String, dynamic>) onDataChanged;
  final Map formData;
  final bool colorDebug;
  

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
              labelColor: Colors.white,
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.auto_awesome, color: Colors.blue),
                  text: "Auton",
                ),
                Tab(
                  icon: Icon(Icons.videogame_asset_rounded, color: Colors.orange),
                  text: "Teleop",
                ),
                Tab(
                  icon: Icon(Icons.bolt, color: Colors.green),
                  text: "Endgame",
                ),
              ],
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                MatchAutonSection(form: widget, colorDebug: widget.colorDebug),
                MatchTeleopSection(form: widget, colorDebug: widget.colorDebug),
                MatchEndgameSection(form: widget, colorDebug: widget.colorDebug),
              ],
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
