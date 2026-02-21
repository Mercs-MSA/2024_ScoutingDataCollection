import 'datatypes.dart';

bool colorDebug = false;

Map<String, dynamic> getPitDataMap() {
  return {
    "form": "pit",
    "team": null,
    "scouters": ["null", "null"],
    "weight": null,
    "canShoot": false,
    "minStorage": 0,
    "maxStorage": 0,
    "climbFrontL1": false,
    "climbFrontL2": false,
    "climbFrontL3": false,
    "climbBackL1": false,
    "climbBackL2": false,
    "climbBackL3": false,
    "climbTime": 0,
    "groundIntake": false,
    "shooter": false,
    "defense": false,
    "feed": false,
    "driverYears": null,
    "operatorYears": null,
    "coachYears": null,
    "isCoachAdult": false,
    "numShooters": 1,
    "drivebase": "Swerve",
    "repairability": 3.0,
    "autonExists": false,
    "notes": null,
    "autonExit": false,
    "autonStrategy": null,
    "canAutoLeft": false,
    "canAutoMid": false,
    "canAutoRight": false,
    "canDepot": false,
    "canOutpost": false,
    "canNeutral": false,
    "canClimb": false,
    "autonFuel": 0,
    "kitbotType": "not",
    "isModifiedKit": false,
  };
}

Map<String, dynamic> getAutonDataMap() {
  return {
    "form": "auton",
    "team": null,
    "scouter": "",
    "match": null,
    "alliance": "blue",
    "startPos": "middle",

    "autoLeave": true,
    "depotDisrupted": false,
    "outpostDisrupted": false,
    "topDisrupted": false,
    "middleDisrupted": false,
    "bottomDisrupted": false,
    "autoCycles": 0,
    "estimatedFuel": 0,
    "rightClimb": false,
    "middleClimb": false,
    "leftClimb": false,
    "centerLineCrossed": false,
    "overBumb": false,
    "underTrench": false,
  };
}

Map<String, dynamic> getMatchDataMap() {
  return {
    "form": "match",
    "team1": null,
    "team2": null,
    "team3": null,
    "scouter": "",
    "alliance": "blue",
    "match": null,

    "team1Shooter": false,
    "team2Shooter": false,
    "team3Shooter": false,
    "team1Defender": false,
    "team2Defender": false,
    "team3Defender": false,
    "team1Feeder": false,
    "team2Feeder": false,
    "team3Feeder": false,
    "team1ShootingAccuracy": 0.0,
    "team2ShootingAccuracy": 0.0,
    "team3ShootingAccuracy": 0.0,
    "team1ShootingRate": 0.0,
    "team2ShootingRate": 0.0,
    "team3ShootingRate": 0.0,
    "team1FeederAccuracy": 0.0,
    "team2FeedergAccuracy": 0.0,
    "team3FeederAccuracy": 0.0,
    "team1FeederRate": 0.0,
    "team2FeederRate": 0.0,
    "team3FeederRate": 0.0,
    "team1DefenderEfficiency": 0.0,
    "team2DefenderEfficiency": 0.0,
    "team3DefenderEfficiency": 0.0,
    "team1DefendLocations": [false, false, false, false, false],
    "team2DefendLocations": [false, false, false, false, false],
    "team3DefendLocations": [false, false, false, false, false],


    "team1EndgameLevel": 0,
    "team2EndgameLevel": 0,
    "team3EndgameLevel": 0,
    "team1ClimbedFromRack": false,
    "team2ClimbedFromRack": false,
    "team3ClimbedFromRack": false,
    "team1ClimbSpeed": 0,
    "team2ClimbSpeed": 0,
    "team3ClimbSpeed": 0,
    "team1FailedClimb": false,
    "team2FailedClimb": false,
    "team3FailedClimb": false,

    "endgamePos": "none",
    "climbTime": 0,
    "yellowCard": false,
    "redCard": false,
    "noShow": false,
    "disabled": false,
    "performedDefense": false,
    "penalties": 0,
    "isMarkedForReview": false,
    "comments": // ** DO NOT REMOVE ** //
        "", // We will leave this here if the transfer person wants to add after scanning
  };
}

Map<String, dynamic> getKitbotData(KitBotTypes type) {
  if (type == KitBotTypes.kitbot) {
    return {
      "kitbotType": KitBotTypes.kitbot.name,
      "lOne": false,
      "lTwo": false,
      "lThree": false,
      "lFour": false,
      "climbFrontL1": false,
      "climbFrontL2": false,
      "climbFrontL3": false,
      "climbBackL1": false,
      "climbBackL2": false,
      "climbBackL3": false,
      "drivebase": "Swerve",
    };
  }
  if (type == KitBotTypes.rev) {
    return {
      "kitbotType": KitBotTypes.rev.name,
      "lOne": true,
      "lTwo": true,
      "lThree": true,
      "lFour": false,
      "climbFrontL1": false,
      "climbFrontL2": false,
      "climbFrontL3": false,
      "climbBackL1": false,
      "climbBackL2": false,
      "climbBackL3": false,
      "drivebase": "Swerve",
    };
  }
  if (type == KitBotTypes.everybot) {
    return {
      "kitbotType": KitBotTypes.everybot.name,
      "lOne": true,
      "lTwo": false,
      "lThree": false,
      "lFour": false,
      "climbFrontL1": true,
      "climbFrontL2": false,
      "climbFrontL3": false,
      "climbBackL1": false,
      "climbBackL2": false,
      "climbBackL3": false,
      "drivebase": "Tank",
    };
  }
  if (type == KitBotTypes.sigModifiedKitbot)
  {
    return 
    {
      "kitbotType": KitBotTypes.sigModifiedKitbot.name,
      "lOne": false,
      "lTwo": false,
      "lThree": false,
      "lFour": false,
      "climbFrontL1": false,
      "climbFrontL2": false,
      "climbFrontL3": false,
      "climbBackL1": false,
      "climbBackL2": false,
      "climbBackL3": false,
      "drivebase": "Swerve",
    };
  }
  if (type == KitBotTypes.wcp) {
    return {
      "kitbotType": KitBotTypes.wcp.name,
      "lOne": true,
      "lTwo": true,
      "lThree": true,
      "lFour": true,
      "climbFrontL1": false,
      "climbFrontL2": true,
      "climbFrontL3": true,
      "climbBackL1": true,
      "climbBackL2": true,
      "climbBackL3": true,
      "drivebase": "Swerve",
    };
  }
  if (type == KitBotTypes.not) {
    return {
      "kitbotType": KitBotTypes.not.name,
      "lOne": false,
      "lTwo": false,
      "lThree": false,
      "lFour": false,
      "climbFrontL1": false,
      "climbFrontL2": false,
      "climbFrontL3": false,
      "climbBackL1": false,
      "climbBackL2": false,
      "climbBackL3": false,
      "drivebase": "Swerve",
    };
  }
  return {};
}
