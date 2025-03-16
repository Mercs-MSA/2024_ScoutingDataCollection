import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

enum InputType {
  def(Colors.green, Colors.red),
  coral(Colors.purple, Colors.red),
  algae(Color.fromRGBO(76, 175, 80, 1), Colors.red),
  altAlgae(Color.fromARGB(255, 78, 180, 148), Colors.red),
  stopwatch(Colors.grey, Colors.grey),
  yellow(Colors.amber, Colors.amber);

  final Color color;
  final Color subtractColor;

  const InputType(this.color, this.subtractColor);
}

class NumberInput extends StatelessWidget {
  final String title;
  final bool miniStyle;

  final int value;
  final void Function()? onValueAdd;
  final void Function()? onValueSubtract;

  final Widget? prefix;
  final Widget? suffix;

  final bool enableSpacer;

  final InputType inputType;

  final bool currColor;

  final bool isDisabled;

  final String disabledText;

  const NumberInput(
      {super.key,
      required this.title,
      required this.value,
      this.prefix,
      this.suffix,
      required this.onValueAdd,
      required this.onValueSubtract,
      this.miniStyle = true,
      this.enableSpacer = false,
      this.inputType = InputType.def,
      this.currColor = false,
      this.isDisabled = false,
      this.disabledText = "Disabled"});

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
        child: Column(
          children: [
            if (miniStyle)
              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Divider()
                ],
              ),
            Row(
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
                if (!isDisabled)
                  IconButton(
                    onPressed: onValueSubtract,
                    style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(
                          Size(miniStyle ? 40 : 48, miniStyle ? 42 : 56)),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      backgroundColor:
                          WidgetStateProperty.all(ColorScheme.fromSeed(
                        seedColor: inputType.subtractColor,
                        brightness: Brightness.dark,
                      ).primary),
                      foregroundColor:
                          WidgetStateProperty.all(ColorScheme.fromSeed(
                        seedColor: inputType.subtractColor,
                        brightness: Brightness.dark,
                      ).onPrimary),
                    ),
                    icon: const Icon(Icons.remove),
                  ),
                enableSpacer ? const Spacer() : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      prefix != null ? prefix! : const SizedBox(),
                      Text(
                        (!isDisabled ? value.toString() : disabledText),
                        style: TextStyle(
                          fontSize: miniStyle ? 28 : 36,
                          fontWeight: FontWeight.w600,
                          fontFamily: "RobotoMono",
                        ),
                      ),
                      suffix != null ? suffix! : const SizedBox(),
                    ],
                  ),
                ),
                enableSpacer ? const Spacer() : const SizedBox(),
                if (!isDisabled)
                  IconButton(
                    onPressed: onValueAdd,
                    style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(
                          Size(miniStyle ? 40 : 48, miniStyle ? 42 : 56)),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      backgroundColor:
                          WidgetStateProperty.all(ColorScheme.fromSeed(
                        seedColor: inputType.color,
                        brightness: Brightness.dark,
                      ).primary),
                      foregroundColor:
                          WidgetStateProperty.all(ColorScheme.fromSeed(
                        seedColor: inputType.color,
                        brightness: Brightness.dark,
                      ).onPrimary),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                const SizedBox(width: 8.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final Color color;
  final String title;
  final double fontSize;
  final double padding;

  const SectionHeader(
      {super.key,
      required this.title,
      this.color = Colors.white,
      this.fontSize = 21.0,
      this.padding = 5.0});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Row(children: [
          Expanded(child: Divider(color: color)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(title,
                style:
                    TextStyle(fontSize: fontSize, fontStyle: FontStyle.italic)),
          ),
          Expanded(child: Divider(color: color))
        ]),
      ),
    );
  }
}

class LabeledSwitch extends StatelessWidget {
  const LabeledSwitch({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
    required this.selectedColor,
  });

  final Widget label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(5.0),
        ),
        backgroundColor: value ? selectedColor : Theme.of(context).cardColor,
      ),
      onPressed: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: label),
            Switch(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
