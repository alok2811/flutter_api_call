import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  /// show Toast
  static showToast({required String? message}) {
    if (message == null) {
      return;
    }
    Get.closeAllSnackbars();
    Get.snackbar(
      "Alok Task",
      message,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      icon: const Icon(
        Icons.notifications,
        color: Colors.black,
        size: 30,
      ),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      backgroundColor: Colors.white,
      borderRadius: 5,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.black,
      titleText: const Text(
        "Alok Task",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 600),
      messageText: Text(
        message,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Hide the soft keyboard.
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Success Dialog
  static void showSuccessDialog(
      {required BuildContext context,
      required String message,
      VoidCallback? onTap}) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: message,
      onConfirmBtnTap: onTap,
    );
  }

  /// Error Dialog
  static void showErrorDialog(
      {required BuildContext context,
      required String message,
      VoidCallback? onTap}) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      text: message,
      onConfirmBtnTap: onTap,
    );
  }
}
