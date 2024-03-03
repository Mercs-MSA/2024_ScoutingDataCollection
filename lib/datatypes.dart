enum Alliances { red, blue }

enum StartPositions { left, middle, right }

class ScoutingTask {
  final int team;
  final int match;
  final Alliances alliance;

  // Constructor
  ScoutingTask(
      {required this.team, required this.match, required this.alliance});

  Map<String, dynamic> toJson() {
    return {
      'team': team,
      'match': match,
      'alliance': alliance.toString(), // Convert enum to string
    };
  }

  factory ScoutingTask.fromJson(Map<String, dynamic> json) {
    return ScoutingTask(
      team: json['team'],
      match: json['match'],
      alliance: Alliances.values.byName(json['alliance']),
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'team': team,
    };
  }

  factory PitScoutingTask.fromJson(Map<String, dynamic> json) {
    return PitScoutingTask(
      team: json['team'],
    );
  }

  // toString method for easy printing
  @override
  String toString() {
    return 'Team: $team';
  }
}
