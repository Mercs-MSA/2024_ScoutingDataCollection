import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  final bool initialTransposedExport;
  final bool initialExportHeaders;
  final String initialEventId;
  final bool initialDevMode;
  final ValueChanged<bool> onTransposeChanged;
  final ValueChanged<bool> onExportHeadersChanged;
  final ValueChanged<bool> onDevModeChanged;
  final ValueChanged<String> onEventIdChanged;
  final Function onResetPrefs;

  const SettingsPage({
    super.key,
    required this.initialTransposedExport,
    required this.initialExportHeaders,
    required this.initialEventId,
    required this.initialDevMode,
    required this.onTransposeChanged,
    required this.onExportHeadersChanged,
    required this.onDevModeChanged,
    required this.onEventIdChanged,
    required this.onResetPrefs,
  });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late bool transposedExport;
  late bool exportHeaders;
  late String eventId;
  late bool devMode;

  @override
  void initState() {
    super.initState();
    transposedExport = widget.initialTransposedExport;
    exportHeaders = widget.initialExportHeaders;
    eventId = widget.initialEventId;
    devMode = widget.initialDevMode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text("Export Options"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: const Divider(),
                ),
              ),
            ],
          ),
          SwitchListTile(
            value: transposedExport,
            title: const Text("Transpose Exported Data"),
            subtitle: const Text(
              "Transpose rows and columns in exported data (recommended)",
            ),
            onChanged: (value) {
              setState(() => transposedExport = value);
              widget.onTransposeChanged(value);
            },
          ),
          SwitchListTile(
            value: exportHeaders,
            title: const Text("Export data headers"),
            subtitle: const Text("Add header to CSV data exports"),
            onChanged: (value) {
              setState(() => exportHeaders = value);
              widget.onExportHeadersChanged(value);
            },
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text("Cheering Strings"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: const Divider(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text("Game Options"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: const Divider(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Event ID',
            ),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(15),
            ],
            onChanged: (value) {
              widget.onEventIdChanged(value);
            },
            controller: TextEditingController(text: eventId),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text("Debug"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: const Divider(),
                ),
              ),
            ],
          ),
          FilledButton.icon(
            onPressed: () {
              _showConfirmationDialog(
                  context, "Are you sure you want to wipe ALL configs?", () {
                widget.onResetPrefs();
              });
            },
            icon: Icon(
              Icons.delete_forever,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
            label: Text(
              "Wipe Preferences",
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.tertiary),
            ),
          ),
          SwitchListTile(
            value: devMode,
            title: const Text("Developer Mode"),
            subtitle: const Text("Auto-fill all start data"),
            onChanged: (value) {
              setState(() => devMode = value);
              widget.onDevModeChanged(value);
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        icon: const Icon(Icons.error_rounded, size: 72),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}

class CheeringStringPage extends StatefulWidget {
  final List<String> cheeringStrings;
  final ValueChanged<List<String>> onCheeringStringsChanged;

  const CheeringStringPage({
    super.key,
    required this.cheeringStrings,
    required this.onCheeringStringsChanged,
  });

  @override
  State<CheeringStringPage> createState() => _CheeringStringPageState();
}

class _CheeringStringPageState extends State<CheeringStringPage> {
  late List<String> cheeringStrings;

  @override
  void initState() {
    super.initState();
    cheeringStrings = widget.cheeringStrings;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "String Format",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  ", == delimeter\n* == newline",
                  style: TextStyle(fontFamily: "RobotoMono"),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        ListView.builder(
          itemCount: cheeringStrings.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cheering String',
                ),
                onChanged: (value) {
                  cheeringStrings[index] = value;
                  widget.onCheeringStringsChanged(cheeringStrings);
                },
                controller: TextEditingController(text: cheeringStrings[index]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    cheeringStrings.removeAt(index);
                    widget.onCheeringStringsChanged(cheeringStrings);
                  });
                },
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              cheeringStrings.add('');
              widget.onCheeringStringsChanged(cheeringStrings);
            });
          },
          child: const Text("Add Cheering String"),
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}
