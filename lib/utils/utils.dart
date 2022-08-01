//import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Command {
  static final all = [email];
  static const email = "mail gönder";
}

class Utils {
  static void textScan(String currentText) {
    final text = currentText.toLowerCase();
    if (text.contains(Command.email)) {
      final body = _getTextAfterCommand(text: text, command: Command.email);
      openEmail(body: body);
    }
  }

  static _getTextAfterCommand({required String text, required String command}) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;
    if (indexCommand == -1) {
      return null;
    } else {
      return text.substring(indexAfter).trim();
    }
  }

  static Future openEmail({
    required String body,
  }) async {
    final url = "malito: ?body=${Uri.encodeFull(body)}";
    await _emailLaunch(url);
  }

  static _emailLaunch(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    }
  }
}
