import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'datatypes.dart';

enum NumberInputStyle { multi, red, green }

class ScoutSelection extends StatelessWidget {
  const ScoutSelection(
      {super.key,
      required this.team,
      required this.match,
      required this.alliance,
      required this.position,
      required this.onSelected,
      required this.teamNames});

  final int team;
  final int match;
  final Alliances alliance;
  final int position;
  final Function() onSelected;
  final Map teamNames;

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
                  color: alliance == Alliances.red
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
        Text(
          "Team and/or match number not set",
          style: TextStyle(fontSize: 28),
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
        itemBuilder: (context, _) => Icon(
          Icons.star,
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

class NoteCheckbox extends StatelessWidget {
  const NoteCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
  });

  final bool? value;
  final Function(bool?) onChanged;
  final bool tristate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 42.0,
          height: 42.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 5,
                color: Colors.orange,
              )),
        ),
        Checkbox(
            value: value,
            onChanged: onChanged,
            tristate: tristate,
            activeColor: value == true
                ? ColorScheme.fromSeed(
                    seedColor: Colors.green,
                    brightness: Brightness.dark,
                  ).primary
                : ColorScheme.fromSeed(
                    seedColor: Colors.red,
                    brightness: Brightness.dark,
                  ).primary,
            checkColor: value == true
                ? ColorScheme.fromSeed(
                    seedColor: Colors.green,
                    brightness: Brightness.dark,
                  ).onPrimary
                : ColorScheme.fromSeed(
                    seedColor: Colors.red,
                    brightness: Brightness.dark,
                  ).onPrimary),
      ],
    );
  }
}

class RotatedTriangle extends StatelessWidget {
  final double rotationAngle;
  final Color color;
  final Color borderColor;
  final double borderWidth;

  const RotatedTriangle(
      {super.key,
      required this.rotationAngle,
      required this.color,
      required this.borderColor,
      required this.borderWidth});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationAngle,
      alignment: Alignment.center,
      child: CustomPaint(
        size: const Size(100, 100), // Change the size as needed
        painter: RotatedTrianglePainter(
            color: color, borderColor: borderColor, borderWidth: borderWidth),
      ),
    );
  }
}

class RotatedTrianglePainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  RotatedTrianglePainter(
      {required this.color,
      required this.borderColor,
      required this.borderWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Path path = Path();
    path.moveTo(0, size.height); // Start at the bottom-left corner
    path.lineTo(size.width / 2, 0); // Move to the top-center
    path.lineTo(size.width, size.height); // Move to the bottom-right corner
    path.close(); // Close the path to complete the triangle
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
