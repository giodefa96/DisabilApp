import 'package:flutter/widgets.dart';
import 'package:disabilapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog({required BuildContext context}) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () => {
      'Yes': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}
