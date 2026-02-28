import 'datatypes.dart';

bool colorDebug = false;

Map<String, dynamic> getPitDataMap() {
  return {
    "form": "pit",
    "team": null,
    "scouters": ["null", "null"],
    "weight": null,
    "height": null,
    "canShoot": false,
    //"minStorage": 0,
    //"maxStorage": 0,
    "climbFrontL1": false,
    "climbFrontL2": false,
    "climbFrontL3": false,
    "climbSideL1": false,
    "climbSideL2": false,
    "climbSideL3": false,
    "climbTime": 0,
    "groundIntake": false,
    "shooter": false,
    "defense": false,
    "feed": false,
    "hopperWidth": 0,
    "hopperLength": 0,
    "hopperHeight": 0,
    "hopperStorageEstimate": 0,
    "driverYears": null,
    "operatorYears": null,
    "coachYears": null,
    "isCoachAdult": false,
    "numShooters": 1,
    "drivebase": "Swerve",
    // "repairability": 3.0,
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
    "isSigModifiedKit": false,
  };
}

Map<String, dynamic> getAutonDataMap() {
  return {
    "form": "auton",
    "team": null,
    "scouter": "",
    "match": null,
    "alliance": "blue",
    
    "startPos": 250.0,

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
    "team1ShootingPrecision": 0.0,
    "team2ShootingPrecision": 0.0,
    "team3ShootingPrecision": 0.0,
    "team1ShootingRate": 0.0,
    "team2ShootingRate": 0.0,
    "team3ShootingRate": 0.0,
    "team1CycleAbility": 0.0,
    "team2CycleAbility": 0.0,
    "team3CycleAbility": 0.0,
    "team1Counterdefense": 0.0,
    "team2Counterdefense": 0.0,
    "team3Counterdefense": 0.0,
    "team1CyclesPerAllianceShift": 0,
    "team2CyclesPerAllianceShift": 0,
    "team3CyclesPerAllianceShift": 0,

    "team1FeederRate": 0.0,
    "team2FeederRate": 0.0,
    "team3FeederRate": 0.0,
    "team1FeederCollectionSpeed": 0.0,
    "team2FeederCollectionSpeed": 0.0,
    "team3FeederCollectionSpeed": 0.0,
    "team1AccurateFeeding": false,
    "team2AccurateFeeding": false,
    "team3AccurateFeeding": false,

    "team1DefenderEfficiency": 0.0,
    "team2DefenderEfficiency": 0.0,
    "team3DefenderEfficiency": 0.0,
    "team1DefendLocations": [false, false, false, false, false],
    "team2DefendLocations": [false, false, false, false, false],
    "team3DefendLocations": [false, false, false, false, false],


    "team1EndgameLevel": 0,
    "team2EndgameLevel": 0,
    "team3EndgameLevel": 0,
    "team1ClimbPosition": "none",
    "team2ClimbPosition": "none",
    "team3ClimbPosition": "none",
    "team1ClimbedFromRack": false,
    "team2ClimbedFromRack": false,
    "team3ClimbedFromRack": false,
    "team1ClimbSpeed": 0,
    "team2ClimbSpeed": 0,
    "team3ClimbSpeed": 0,

    "endgamePos": "none",
    "climbTime": 0,
    "yellowCard": false,
    "redCard": false,
    "team1NoShow": false,
    "team2NoShow": false,
    "team3NoShow": false,
    "team1Disabled": false,
    "team2Disabled": false,
    "team3Disabled": false,
    "performedDefense": false,
    "penalties": false,
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
