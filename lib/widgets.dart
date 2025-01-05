import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'datatypes.dart';

enum NumberInputStyle { multi, red, green }

class ScoutSelection extends StatelessWidget {
  const ScoutSelection({
    super.key,
    required this.team,
    required this.match,
    required this.alliance,
    required this.position,
    required this.onSelected,
    required this.teamNames,
    this.completed = false,
  });

  final int team;
  final int match;
  final Alliances alliance;
  final int position;
  final Function() onSelected;
  final Map teamNames;

  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onSelected,
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(120)),
            maximumSize: MaterialStateProperty.all(const Size.fromHeight(130)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                  width: 4,
                  color: completed
                      ? Colors.green
                      : alliance == Alliances.red
                          ? Colors.redAccent
                          : Colors.blueAccent),
            ))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Team $team - ${teamNames[team.toString()] ?? "Unknown Team"}",
                  style: const TextStyle(fontSize: 22)),
              Text("Match $match", style: const TextStyle(fontSize: 18)),
              Text("${alliance.name.capitalize} ${position + 1}",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class PitScoutSelection extends StatelessWidget {
  const PitScoutSelection({
    super.key,
    required this.team,
    required this.onSelected,
    required this.teamNames,
    this.completed = false,
  });

  final int team;
  final Function() onSelected;
  final bool completed;
  final Map teamNames;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onSelected,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size.fromHeight(80)),
          maximumSize: MaterialStateProperty.all(const Size.fromHeight(100)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                width: 4,
                color: completed ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Team $team - ${teamNames[team.toString()] ?? "Unknown Team"}",
                  style: const TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamNumberError extends StatelessWidget {
  const TeamNumberError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          size: 180,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Team, match number, or scouter names have not been set",
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class RatingInput extends StatelessWidget {
  const RatingInput({
    super.key,
    required this.title,
    required this.onRatingUpdate,
    required this.initialRating,
    this.itemCount = 5,
    this.enableHalves = true,
  });

  final String title;
  final Function(double) onRatingUpdate;
  final double initialRating;
  final int itemCount;
  final bool enableHalves;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: RatingBar.builder(
        initialRating: initialRating,
        minRating: 1,
        itemBuilder: (context, _) => Icon(
          Icons.star_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        onRatingUpdate: onRatingUpdate,
        glow: true,
        itemCount: itemCount,
        allowHalfRating: enableHalves,
      ),
    );
  }
}

class ChoiceInput extends StatelessWidget {
  const ChoiceInput({
    super.key,
    required this.title,
    required this.onChoiceUpdate,
    required this.choice,
    required this.options,
  });

  final String title;
  final Function(String?) onChoiceUpdate;
  final String choice;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration:
          InputDecoration(border: const OutlineInputBorder(), labelText: title),
      focusNode: FocusNode(canRequestFocus: false),
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: choice,
      onChanged: onChoiceUpdate,
    );
  }
}

class NumberInput extends StatelessWidget {
  final String title;
  final bool miniStyle;

  final int value;
  final void Function() onValueAdd;
  final void Function() onValueSubtract;

  final NumberInputStyle style;

  final bool enableSpacer;

  const NumberInput({
    super.key,
    required this.title,
    required this.value,
    required this.onValueAdd,
    required this.onValueSubtract,
    this.miniStyle = false,
    this.style = NumberInputStyle.multi,
    this.enableSpacer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Row(
          children: [
            if (!miniStyle)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            enableSpacer ? const Spacer() : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value.toString(),
                style: TextStyle(
                    fontSize: miniStyle ? 28 : 36, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              onPressed: onValueSubtract,
              style: style == NumberInputStyle.multi
                  ? ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                          Size.square(miniStyle ? 42 : 56)),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          MaterialStateProperty.all(ColorScheme.fromSeed(
                        seedColor: Colors.orange,
                        brightness: Brightness.dark,
                      ).primary),
                      foregroundColor:
                          MaterialStateProperty.all(ColorScheme.fromSeed(
                        seedColor: Colors.orange,
                        brightness: Brightness.dark,
                      ).onPrimary),
                    )
                  : style == NumberInputStyle.red
                      ? ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                              Size.square(miniStyle ? 42 : 56)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          backgroundColor:
                              MaterialStateProperty.all(ColorScheme.fromSeed(
                            seedColor: Colors.red,
                            brightness: Brightness.dark,
                          ).primary),
                          foregroundColor:
                              MaterialStateProperty.all(ColorScheme.fromSeed(
                            seedColor: Colors.red,
                            brightness: Brightness.dark,
                          ).onPrimary),
                        )
                      : style == NumberInputStyle.green
                          ? ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  Size.square(miniStyle ? 42 : 56)),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(
                                  ColorScheme.fromSeed(
                                seedColor: Colors.green,
                                brightness: Brightness.dark,
                              ).primary),
                              foregroundColor: MaterialStateProperty.all(
                                  ColorScheme.fromSeed(
                                seedColor: Colors.green,
                                brightness: Brightness.dark,
                              ).onPrimary),
                            )
                          : const ButtonStyle(),
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              onPressed: onValueAdd,
              style: style == NumberInputStyle.multi
                  ? ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                          Size.square(miniStyle ? 42 : 56)),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          MaterialStateProperty.all(ColorScheme.fromSeed(
                        seedColor: Colors.green,
                        brightness: Brightness.dark,
                      ).primary),
                      foregroundColor:
                          MaterialStateProperty.all(ColorScheme.fromSeed(
                        seedColor: Colors.green,
                        brightness: Brightness.dark,
                      ).onPrimary),
                    )
                  : style == NumberInputStyle.red
                      ? ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                              Size.square(miniStyle ? 42 : 56)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          backgroundColor:
                              MaterialStateProperty.all(ColorScheme.fromSeed(
                            seedColor: Colors.red,
                            brightness: Brightness.dark,
                          ).primary),
                          foregroundColor:
                              MaterialStateProperty.all(ColorScheme.fromSeed(
                            seedColor: Colors.red,
                            brightness: Brightness.dark,
                          ).onPrimary),
                        )
                      : style == NumberInputStyle.green
                          ? ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  Size.square(miniStyle ? 42 : 56)),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(
                                  ColorScheme.fromSeed(
                                seedColor: Colors.green,
                                brightness: Brightness.dark,
                              ).primary),
                              foregroundColor: MaterialStateProperty.all(
                                  ColorScheme.fromSeed(
                                seedColor: Colors.green,
                                brightness: Brightness.dark,
                              ).onPrimary),
                            )
                          : const ButtonStyle(),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.item,
    required this.data,
    this.type,
  });

  final String item;
  final String data;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item),
            const Spacer(),
            Text((data.length <= 20) ? data : '${data.substring(0, 20)}...'),
            const Spacer(),
            Text(type == null ? "Unknown" : type!),
          ],
        ),
      ),
    );
  }
}
