enum Alliances { red, blue }

enum StartPositions { left, middle, right }

class ScoutingTask {
  final int team;
  final int match;
  final Alliances alliance;

  // Constructor
  ScoutingTask(
      {required this.team, required this.match, required this.alliance});

  // toString method for easy printing
  @override
  String toString() {
    return 'Team: $team, Match: $match, Alliance: $alliance';
  }
}

class PitScoutingTask {
  final int team;

  // Constructor
  PitScoutingTask({required this.team});

  // toString method for easy printing
  @override
  String toString() {
    return 'Team: $team';
  }
}
