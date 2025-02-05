import 'datatypes.dart';

Map<String, dynamic> getPitDataMap() {
  return {
    "form": "pit",
    "team": null,
    "scouters": ["null", "null"],
    "width": null,
    "length": null,
    "height": null,
    "weight": null,
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
    "alliance": Alliance.blue,
    "match": null,
    "startPos": "middle",
    "autoL4scored": 0,
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
