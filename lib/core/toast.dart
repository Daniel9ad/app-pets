import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showSuccess(context, String title, String description) {
  toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    title: Text(title),
    description: Text(description),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: lowModeShadow,
    showProgressBar: true,
    dragToClose: true,
	);
}

void showError(context, String errorTitle , String errorMessage) {
  toastification.show(
    context: context,
    type: ToastificationType.error,
    style: ToastificationStyle.fillColored,
    title: Text(errorTitle),
    description: Text(errorMessage),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: lowModeShadow,
    showProgressBar: true,
    dragToClose: true,
	);
}

void showInfo(context, String infoTitle , String infoMessage) {
  toastification.show(
    context: context,
    type: ToastificationType.info,
    style: ToastificationStyle.fillColored,
    title: Text(infoTitle),
    description: Text(infoMessage),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: lowModeShadow,
    showProgressBar: true,
    dragToClose: true,
	);
}

void showWarning(context, String warningTitle , String warningMessage) {
  toastification.show(
    context: context,
    type: ToastificationType.warning,
    style: ToastificationStyle.fillColored,
    title: Text(warningTitle),
    description: Text(warningMessage),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: lowModeShadow,
    showProgressBar: true,
    dragToClose: true,
	);
}


