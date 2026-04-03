import 'package:mercs_scout/datatypes.dart' as Datatypes;

import 'datatypes.dart';

bool colorDebug = false;

Map<String, dynamic> getPitDataMap() {
  return {
    "eventID": "",
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
    "intakeType": "",
    "turret": false,
    "hood": false,
    "drum": false,
    "static": false,
    "other": false,
    "numShooters": 1,
    "shooter": false,
    "defense": false,
    "feed": false,
    "hopperStorageEstimate": 0,
    "driverYears": null,
    "operatorYears": null,
    "coachYears": null,
    "isCoachAdult": false,
    "drivebase": "Swerve",
    // "repairability": 3.0,
    "notes": null,
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

// Map<String, dynamic> getAutonDataMap() {
//   return {
//     "eventID": "",
//     "form": "auton",
//     "team": null,
//     "scouter": "",
//     "match": null,
//     "alliance": "blue",
    
//     "startPos": Datatypes.AutoStartLocation.middle,

//     "autoLeave": true,
//     "depotDisrupted": false,
//     "outpostDisrupted": false,
//     "topDisrupted": false,
//     "middleDisrupted": false,
//     "bottomDisrupted": false,
//     "autoCycles": 0,
//     "estimatedFuel": 0,
//     "rightClimb": false,
//     "middleClimb": false,
//     "leftClimb": false,
//     "centerLineCrossed": false,
//     "overBumb": false,
//     "underTrench": false,
//   };
// }

Map<String, dynamic> getMatchDataMap() {
  return {
    "eventID": "",
    "form": "match",
    "team1": null,
    // "team2": null,
    // "team3": null,
    "scouter": "",
    "alliance": "blue",
    "match": null,

    "startPos": Datatypes.AutoStartLocation.middle,

    "autoLeave": true,
    "depotDisrupted": false,
    "outpostDisrupted": false,
    "autoSwipes": 0,
    "climb": false,
    "centerLineCrossed": false,
    "overBumb": false,
    "underTrench": false,

    "team1Shooter": false,
    // "team2Shooter": false,
    // "team3Shooter": false,
    "team1Defender": false,
    // "team2Defender": false,
    // "team3Defender": false,
    "team1Shunter": false,
    // "team2Shunter": false,
    // "team3Shunter": false,
    "team1TopTier": false,
    "team1MidTier": false,
    "team1LowTier": false,
    "team1Beached": false,
    
    // "team2CollectionRate": 0.0,
    // "team3CollectionRate": 0.0,




    "team1EndgameLevel": 0,
    // "team2EndgameLevel": 0,
    // "team3EndgameLevel": 0,
    // "team1ClimbPosition": "none",
    // "team2ClimbPosition": "none",
    // "team3ClimbPosition": "none",
    // "team1ClimbedFromRack": false,
    // "team2ClimbedFromRack": false,
    // "team3ClimbedFromRack": false,
    "team1ClimbSpeed": 0,
    // "team2ClimbSpeed": 0,
    // "team3ClimbSpeed": 0,

    "yellowCard": false,
    "redCard": false,
    "team1Broken": false,
    "team1NoShow": false,
    // "team2NoShow": false,
    // "team3NoShow": false,
    "team1Disabled": false,
    // "team2Disabled": false,
    // "team3Disabled": false,
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
