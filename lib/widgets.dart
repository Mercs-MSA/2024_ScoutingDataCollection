import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
        glow: false,
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
    return ListTile(
      title: Text(title),
      trailing: DropdownButton(
        borderRadius: BorderRadius.circular(4),
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        value: choice,
        onChanged: onChoiceUpdate,
      ),
    );
  }
}
