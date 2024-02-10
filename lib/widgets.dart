import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

enum Alliances {
  red,
  blue
}

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.item,
    required this.data,
  });

  final String item;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item),
            const Spacer(),
            Text(data),
          ],
        ),
      ),
    );
  }
}

class ScoutSelection extends StatelessWidget {
  const ScoutSelection({
    super.key,
    required this.team,
    required this.match,
    required this.alliance,
  });

  final int team;
  final int match;
  final Alliances alliance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: (){},
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size.fromHeight(120)),
          maximumSize: MaterialStateProperty.all(const Size.fromHeight(130)),

          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(width: 4, color: alliance == Alliances.red ? Colors.redAccent : Colors.blueAccent),
            )
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Team $team", style: const TextStyle(fontSize: 22)),
              Text("Match $match", style: const TextStyle(fontSize: 18)),
              Text("${alliance.name.capitalize} Alliance", style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingInput extends StatelessWidget {
  const RatingInput({
    super.key,
    required this.title,
    required this.onRatingUpdate,
    required this.initialRating,
  });

  final String title;
  final Function(double) onRatingUpdate;
  final double initialRating;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: RatingBar.builder(
        initialRating: initialRating,
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Theme.of(context).colorScheme.primary,
        ),
        onRatingUpdate: onRatingUpdate,
        glow: true,
        allowHalfRating: true,
      ),
    );
  }
}

class ColorInput extends StatefulWidget {
  const ColorInput({
    super.key,
    required this.title,
    required this.onColorChanged,
  });

  final String title;
  final Function(Color) onColorChanged;

  @override
  State<ColorInput> createState() => _ColorInputState();
}

class _ColorInputState extends State<ColorInput> {
  Color currentColor = Colors.red;
  Color beforeColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ColorIndicator(
          onSelectFocus: false,
          onSelect: () async {
            beforeColor = currentColor;
            if (!(await colorPickerDialog())) {
              setState(() {
                currentColor = beforeColor;
                widget.onColorChanged(currentColor);
              });
            }
          },
          color: currentColor,
          width: 36,
          height: 36,
        ),
      ),
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: currentColor,
      onColorChanged: (Color color) {
        setState(() {
          currentColor = color;
          widget.onColorChanged(currentColor);
        });
      },
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showColorName: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(context);
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
      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: title),
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

  final int value;
  final void Function() onValueAdd;
  final void Function() onValueSubtract;

  const NumberInput({
    super.key,
    required this.title,
    required this.value,
    required this.onValueAdd,
    required this.onValueSubtract
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            FilledButton(
              onPressed: onValueAdd,
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size.square(56)),
                  padding: MaterialStateProperty.all(EdgeInsets.zero)
              ),
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 8.0),
            FilledButton(
                onPressed: onValueSubtract,
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size.square(56)),
                  padding: MaterialStateProperty.all(EdgeInsets.zero)
              ),
                child: const Icon(Icons.remove)),
          ],
        ),
      )
    );
  }
}