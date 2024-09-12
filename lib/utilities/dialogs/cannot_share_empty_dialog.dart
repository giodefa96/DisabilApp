import 'package:flutter/widgets.dart';
import 'package:disabilapp/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'Cannot share an empty note',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
