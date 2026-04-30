import 'dart:async';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';

import '../models/contact_request_model.dart';

class ContactService {
  Future<bool> sendContactRequest(ContactRequest request) async {
    final Email email = Email(
      body: request.description,
      subject: request.subject,
      recipients: ['yamba.yann@gmail.com'],
      attachmentPaths: request.attachmentPath != null
          ? [request.attachmentPath!]
          : null,
      isHTML: false,
    );

    //Debug logs
    AppLoggerHelper.debug('Contact Email Subject: ${email.subject}');
    AppLoggerHelper.debug('Contact Email Body: ${email.body}');
    AppLoggerHelper.debug('Contact Email Recipients: ${email.recipients}');
    AppLoggerHelper.debug(
      'Contact Email Attachment Paths: ${email.attachmentPaths}',
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      AppLoggerHelper.error('Error sending contact email', e);
      return false;
    }
    return true;
  }

  // Future<void> send() async {
  //   final Email email = Email(
  //     body: _bodyController.text,
  //     subject: _subjectController.text,
  //     recipients: [_recipientController.text],
  //     attachmentPaths: attachments,
  //     isHTML: isHTML,
  //   );

  //   String platformResponse;

  //   try {
  //     await FlutterEmailSender.send(email);
  //     platformResponse = 'success';
  //   } catch (error) {
  //     print(error);
  //     platformResponse = error.toString();
  //   }

  //   if (!mounted) return;

  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text(platformResponse)));
  // }
}
