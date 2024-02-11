enum Alliances {
  red,
  blue
}

class MatchData {
  final int team;
  final int match;
  final Alliances alliance;

  // Constructor
  MatchData({required this.team, required this.match, required this.alliance});

  // toString method for easy printing
  @override
  String toString() {
    return 'Team: $team, Match: $match, Alliance: $alliance';
  }
}