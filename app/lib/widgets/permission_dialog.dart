// widgets/permission_dialog.dart
import 'package:flutter/material.dart';
import 'package:archive_hunters/l10n/app_localizations.dart';

Future<void> showPermissionExplanationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // L'utente deve interagire con il dialogo
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.permissionsRequiredTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(AppLocalizations.of(context)!.permissionsRequiredBody),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Chiude il dialogo
            },
          ),
        ],
      );
    },
  );
}
