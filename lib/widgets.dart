import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

enum NumberInputStyle { multi, red, green }

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
          minimumSize: WidgetStateProperty.all(const Size.fromHeight(80)),
          maximumSize: WidgetStateProperty.all(const Size.fromHeight(100)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
            const SizedBox(width: 8.0),
            IconButton(
              onPressed: onValueSubtract,
              style: style == NumberInputStyle.multi
                  ? ButtonStyle(
                      fixedSize: WidgetStateProperty.all(
                          Size.square(miniStyle ? 42 : 56)),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          WidgetStateProperty.all(ColorScheme.fromSeed(
                        seedColor: Colors.orange,
                        brightness: Brightness.dark,
                      ).primary),
                      foregroundColor:
                          WidgetStateProperty.all(ColorScheme.fromSeed(
                        seedColor: Colors.orange,
                        brightness: Brightness.dark,
                      ).onPrimary),
                    )
                  : style == NumberInputStyle.red
                      ? ButtonStyle(
                          fixedSize: WidgetStateProperty.all(
                              Size.square(miniStyle ? 42 : 56)),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          backgroundColor:
                              WidgetStateProperty.all(ColorScheme.fromSeed(
                            seedColor: Colors.red,
                            brightness: Brightness.dark,
                          ).primary),
                          foregroundColor:
                              WidgetStateProperty.all(ColorScheme.fromSeed(
                            seedColor: Colors.red,
                            brightness: Brightness.dark,
                          ).onPrimary),
                        )
                      : style == NumberInputStyle.green
                          ? ButtonStyle(
                              fixedSize: WidgetStateProperty.all(
                                  Size.square(miniStyle ? 42 : 56)),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              backgroundColor:
                                  WidgetStateProperty.all(ColorScheme.fromSeed(
                                seedColor: Colors.green,
                                brightness: Brightness.dark,
                              ).primary),
                              foregroundColor:
                                  WidgetStateProperty.all(ColorScheme.fromSeed(
                                seedColor: Colors.green,
                                brightness: Brightness.dark,
                              ).onPrimary),
                            )
                          : const ButtonStyle(),
              icon: const Icon(Icons.remove),
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
            enableSpacer ? const Spacer() : const SizedBox(),
            IconButton(
              onPressed: onValueAdd,
              style: style == NumberInputStyle.multi
                  ? ButtonStyle(
                      fixedSize: WidgetStateProperty.all(
                          Size.square(miniStyle ? 42 : 56)),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          WidgetStateProperty.all(ColorScheme.fromSeed(
                        seedColor: Colors.green,
                        brightness: Brightness.dark,
                      ).primary),
                      foregroundColor:
                          WidgetStateProperty.all(ColorScheme.fromSeed(
                        seedColor: Colors.green,
                        brightness: Brightness.dark,
                      ).onPrimary),
                    )
                  : style == NumberInputStyle.red
                      ? ButtonStyle(
                          fixedSize: WidgetStateProperty.all(
                              Size.square(miniStyle ? 42 : 56)),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          backgroundColor:
                              WidgetStateProperty.all(ColorScheme.fromSeed(
                            seedColor: Colors.red,
                            brightness: Brightness.dark,
                          ).primary),
                          foregroundColor:
                              WidgetStateProperty.all(ColorScheme.fromSeed(
                            seedColor: Colors.red,
                            brightness: Brightness.dark,
                          ).onPrimary),
                        )
                      : style == NumberInputStyle.green
                          ? ButtonStyle(
                              fixedSize: WidgetStateProperty.all(
                                  Size.square(miniStyle ? 42 : 56)),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              backgroundColor:
                                  WidgetStateProperty.all(ColorScheme.fromSeed(
                                seedColor: Colors.green,
                                brightness: Brightness.dark,
                              ).primary),
                              foregroundColor:
                                  WidgetStateProperty.all(ColorScheme.fromSeed(
                                seedColor: Colors.green,
                                brightness: Brightness.dark,
                              ).onPrimary),
                            )
                          : const ButtonStyle(),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}
