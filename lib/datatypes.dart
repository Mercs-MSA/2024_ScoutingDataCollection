// enum KitBotTypes { not, modded, kitbot } // TODO: is this useful anymore

// enum ScoringPreference { amp, speaker, none }  // TODO: is this useful anymore, and update for 2025

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
