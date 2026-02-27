import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/foundation.dart';
import 'package:bart_app/common/utility/bart_auth.dart';
import 'package:bart_app/common/constants/env/bart_env.dart';

class BartEmailHandler {
  static BartEmailHandler? _instance;

  BartEmailHandler._internal();

  /// A singleton class that is used to send emails to users.
  factory BartEmailHandler() => _instance ?? BartEmailHandler._internal();

  String _sendFrom() => BartEnv.mailerUser;

  SmtpServer _server() => kIsWeb
      ? gmailSaslXoauth2(
          BartEnv.mailerUser,
          BartAuthService().currentUser!.refreshToken!,
        )
      : gmail(BartEnv.mailerUser, BartEnv.mailerPassword);

  Future<void> sendMail() async {
    final msg = Message();

    msg.subject = 'Test Email';
    msg.from = Address(_sendFrom(), 'YoMomma');

    msg.recipients.add(const Address('hemakagn@gmail.com'));

    msg.text = 'She fat.';

    await send(msg, _server());
  }
}
