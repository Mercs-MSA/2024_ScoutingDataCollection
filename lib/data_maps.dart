import 'datatypes.dart';

bool colorDebug = false;

Map<String, dynamic> getPitDataMap() {
  return {
    "form": "pit",
    "team": null,
    "scouters": ["null", "null"],
    "width": null,
    "length": null,
    "height": null,
    "lOne": false,
    "lTwo": false,
    "lThree": false,
    "lFour": false,
    "processor": false,
    "barge": false,
    "descore": false,
    "deepClimb": false,
    "shallowClimb": false,
    "coralCycle": false,
    "algaeCycle": false,
    "defense": false,
    "feed": false,
    "driverYears": null,
    "operatorYears": null,
    "coachYears": null,
    "isCoachAdult": false,
    "drivebase": "Swerve",
    "repairability": 3.0,
    "humanPlayerLocation": "Coral",
    "autonExists": false,
    "notes": null,
    "autonExit": false,
    "autonStrategy": null,
    "canAutoLeft": false,
    "canAutoMid": false,
    "canAutoRight": false,
    "autonL4Num": 0,
    "autonL3Num": 0,
    "autonL2Num": 0,
    "autonL1Num": 0,
    "autonUpperAlgaeDescore": 0,
    "autonLowerAlgaeDescore": 0,
    "autonProcessor": 0,
    "autonNetScore": 0,
    "kitbotType": "not",
    "isModifiedKit": false,
  };
}

Map<String, dynamic> getMatchDataMap() {
  return {
    "form": "match",
    "team": null,
    "scouter": "",
    "alliance": "blue",
    "match": null,
    "startPos": "middle",
    "autoL4scored": 0,
    "autoL4Missed": 0,
    "autoL3Scored": 0,
    "autoL3Missed": 0,
    "autoL2Scored": 0,
    "autoL2Missed": 0,
    "autoL1Scored": 0,
    "autoL1Missed": 0,
    "autoNetScored": 0,
    "autoNetMissed": 0,
    "autoAlgaeDescored": 0,
    "autoProcessorScored": 0,
    "autoProcessorMissed": 0,
    "teleL4Scored": 0,
    "teleL4Missed": 0,
    "teleL3Scored": 0,
    "teleL3Missed": 0,
    "teleL2Scored": 0,
    "teleL2Missed": 0,
    "teleL1Scored": 0,
    "teleL1Missed": 0,
    "teleNetScored": 0,
    "teleNetMissed": 0,
    "teleNetScoredHuman": 0,
    "teleNetMissedHuman": 0,
    "teleAlgaeDescored": 0,
    "teleProcessorScored": 0,
    "teleProcessorMissed": 0,
    "endgamePos": "none",
    "climbTime": 0,
    "yellowCards": 0,
    "redCard": false,
    "noShow": false,
    "disabled": false,
    "notes": null,
  };
}

Map<String, dynamic> getKitbotData(KitBotTypes type) {
  if (type == KitBotTypes.kitbot) {
    return {
      "kitbotType": KitBotTypes.kitbot.name,
      "lOne": true,
      "lTwo": false,
      "lThree": false,
      "lFour": false,
      "processor": false,
      "barge": false,
      "descore": false,
      "deepClimb": false,
      "shallowClimb": false,
      "drivebase": "Tank",
    };
  }
  if (type == KitBotTypes.rev) {
    return {
      "kitbotType": KitBotTypes.rev.name,
      "lOne": true,
      "lTwo": true,
      "lThree": true,
      "lFour": false,
      "processor": true,
      "descore": true,
      "barge": false,
      "deepClimb": false,
      "shallowClimb": false,
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
      "processor": true,
      "descore": false,
      "barge": false,
      "deepClimb": true,
      "shallowClimb": false,
      "drivebase": "Tank",
    };
  }
  if (type == KitBotTypes.wcp) {
    return {
      "kitbotType": KitBotTypes.wcp.name,
      "lOne": true,
      "lTwo": true,
      "lThree": true,
      "lFour": true,
      "processor": true,
      "descore": true,
      "barge": true,
      "deepClimb": false,
      "shallowClimb": true,
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
      "processor": false,
      "descore": false,
      "barge": false,
      "deepClimb": false,
      "shallowClimb": false,
      "drivebase": "Swerve",
    };
  }
  return {};
}
