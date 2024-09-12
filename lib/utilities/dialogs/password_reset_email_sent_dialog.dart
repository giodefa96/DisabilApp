import 'package:flutter/widgets.dart';
import 'package:disabilapp/utilities/dialogs/generic_dialog.dart';

Future<void> showPassowrdResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      title: 'Password reset',
      content:
          'We have now sent you a password reset link. Please check your email for more information.',
      optionsBuilder: () => {"OK": null});
}
