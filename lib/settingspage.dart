import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  final bool initialTransposedExport;
  final bool initialExportHeaders;
  final String initialEventId;
  final ValueChanged<bool> onTransposeChanged;
  final ValueChanged<bool> onExportHeadersChanged;
  final ValueChanged<String> onEventIdChanged;
  final VoidCallback onImportTeamList;
  final VoidCallback onResetAllTeams;
  final VoidCallback onLoadTestTeams;

  const SettingsPage({
    super.key,
    required this.initialTransposedExport,
    required this.initialExportHeaders,
    required this.initialEventId,
    required this.onTransposeChanged,
    required this.onExportHeadersChanged,
    required this.onEventIdChanged,
    required this.onImportTeamList,
    required this.onResetAllTeams,
    required this.onLoadTestTeams,
  });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late bool transposedExport;
  late bool exportHeaders;
  late String eventId;

  @override
  void initState() {
    super.initState();
    transposedExport = widget.initialTransposedExport;
    exportHeaders = widget.initialExportHeaders;
    eventId = widget.initialEventId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Team Lists"),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                      child: const Divider(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              ElevatedButton.icon(
                onPressed: widget.onImportTeamList,
                label: const Text("Import team list"),
                icon: const Icon(Icons.upload),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton.icon(
                onPressed: () => _showConfirmationDialog(
                  context,
                  "Are you ABSOLUTELY SURE you want to remove ALL saved team lists?",
                  widget.onResetAllTeams,
                ),
                label: const Text("RESET ALL TEAMS"),
                icon: const Icon(Icons.delete_forever),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton.icon(
                onPressed: () => _showConfirmationDialog(
                  context,
                  "Are you ABSOLUTELY SURE you want to add 3 nonsense teams to each list?",
                  widget.onLoadTestTeams,
                ),
                label: const Text("Load debug teams"),
                icon: const Icon(Icons.bug_report),
              ),
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
                  setState(() => eventId = value);
                  widget.onEventIdChanged(value);
                },
                controller: TextEditingController(text: eventId),
              ),
            ],
          ),
        ),
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
