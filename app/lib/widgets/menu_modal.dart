// widgets/menu_modal.dart
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/webview_screen.dart';
import '../services/storage_service.dart';
import '../services/download_service.dart';
import 'error_modal.dart';
import '../main.dart';
import 'package:archive_hunters/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/game_state_service.dart';


void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.changeLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.english),
            onTap: () {
              // Use the global key to call the changeLanguage method
              appKey.currentState?.changeLanguage(const Locale('en'));
              Provider.of<GameStateService>(context, listen: false).updateLanguage("en", context);
              Navigator.of(ctx).pop();
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.italian),
            onTap: () {
              Provider.of<GameStateService>(context, listen: false).updateLanguage("it", context);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    ),
  );
}

void _showDownloadDialog(BuildContext context) {
  final DownloadService downloadService = DownloadService();
  final StorageService storageService = StorageService();
  final ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

  // Get the model URL from storage
  final modelUrl = storageService.getModelUrl();
  final labelsUrl = storageService.getLabelsUrl();

  downloadService
      .downloadModel(
    modelUrl,
    labelsUrl,
    (p) => progressNotifier.value = p,
  )
      .then((_) async {
    progressNotifier.value = 1.0;
    await Future.delayed(const Duration(milliseconds: 300));
    Navigator.pop(context); // Close the dialog on completion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.modelLoaded)),
    );
  }).catchError((e) {
    Navigator.pop(context); // Close the dialog on error
    showErrorModal(
        context, AppLocalizations.of(context)!.failedDownload, e.toString());
  });

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return ValueListenableBuilder<double>(
        valueListenable: progressNotifier,
        builder: (context, progress, child) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.downloadingModel),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 16),
                Text("${(progress * 100).toStringAsFixed(0)}%"),
              ],
            ),
          );
        },
      );
    },
  );
}

void showMenuModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    // FIX: Renamed the builder's context to 'modalContext' to avoid conflict.
    builder: (BuildContext modalContext) {
      return Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context)!.information),
            onTap: () {
              final StorageService _storageService = StorageService();
              final langCode = _storageService.getLanguageCode();
              final url = 'https://sc.provincia.lucca.it/archivehunters/istruzioni-$langCode.html';
              Navigator.pop(modalContext);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WebviewScreen(url: url),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.changeLanguage),
            onTap: () {
              Navigator.pop(modalContext);
              _showLanguageDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: Text(AppLocalizations.of(context)!.updateModel),
            onTap: () {
              // Use the modal's context to close it.
              Navigator.pop(modalContext);
              // Use the main screen's context to show the new dialog.
              _showDownloadDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(AppLocalizations.of(context)!.about),
            onTap: () {
              Navigator.pop(modalContext);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.about),
                  content: Text(AppLocalizations.of(context)!.aboutInfo),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: Text(AppLocalizations.of(context)!.restart),
            onTap: () async {
              await StorageService().clearAll();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}
