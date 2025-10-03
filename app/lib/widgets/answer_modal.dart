import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'error_modal.dart';
import 'package:archive_hunters/l10n/app_localizations.dart'; 
import 'package:provider/provider.dart';
import '../services/game_state_service.dart';

void showAnswerModal(BuildContext context) {
  final TextEditingController answerController = TextEditingController();
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.answer,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: answerController,
              decoration:  InputDecoration(
                labelText: AppLocalizations.of(context)!.answer,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Just close the modal
                  },
                  child: Text(AppLocalizations.of(context)!.close),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.submit),
                  onPressed: () async {
                    final answer = answerController.text;
                    if (answer.isNotEmpty) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );

                      try {
                        final answerResponse = await apiService.getAnswerId(
                          answer: answer,
                        );

                        Navigator.pop(context); // Dismiss loading indicator

                        if (answerResponse.answerIdResult != 0) {
                          // On correct answer, update the answer ID from the API response
                          Provider.of<GameStateService>(context, listen: false).updateStatus(answerResponse.answerIdResult, context);
                          Navigator.pop(context); // Dismiss the answer modal
                        } else {
                          // If the answer is wrong, show the error message from the API in a modal
                          showErrorModal(
                              context,
                              AppLocalizations.of(context)!.wrongAnswer,
                              AppLocalizations.of(context)!.wrongAnswer);
                        }
                      } catch (e) {
                        Navigator.pop(context); // Dismiss loading indicator
                        showErrorModal(context, AppLocalizations.of(context)!.error,
                            e.toString().replaceFirst("Exception: ", ""));
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
