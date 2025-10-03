import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:archive_hunters/l10n/app_localizations.dart'; 

void showErrorModal(BuildContext context, String title, String message, { bool end = false } ) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (end) {
              SystemNavigator.pop();
            } else {
              Navigator.of(ctx).pop();
            }
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    ),
  );
}