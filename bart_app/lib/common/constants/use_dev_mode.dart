import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';

class DevModeTools {
  static const bool isDevMode = true;

  static ExpansionTile buildDevMenu() => ExpansionTile(
        leading: const Icon(Icons.developer_mode),
        title: const Text(
          "Developer Settings",
        ),
        maintainState: true,
        children: [
          Material(
            child: InkWell(
              child: ListTile(
                title: const Text(
                  "Update UserLocalProfile Schema",
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () {
                  Toast.show("updating all users schema");
                  BartFirestoreServices.updateUserProfileSchema();
                },
              ),
            ),
          ),
          Material(
            child: InkWell(
              child: ListTile(
                title: const Text(
                  "Update Item Schema",
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () {
                  Toast.show('updating all items schema');
                  BartFirestoreServices.updateItemSchema();
                },
              ),
            ),
          ),
          Material(
            child: InkWell(
              child: ListTile(
                title: const Text(
                  "Update Messages Schema",
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () {
                  Toast.show('updating schema of all messages in all chats');
                  BartFirestoreServices.updateMessagesSchema();
                },
              ),
            ),
          ),
        ],
      );
}