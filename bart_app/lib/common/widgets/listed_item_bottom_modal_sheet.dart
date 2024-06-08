import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/widgets/market_page_list_tile.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class ListedItemBottomModalSheet {
  ListedItemBottomModalSheet({
    required this.item,
    required this.context,
    required this.loadingOverlay,
    required this.parentContext,
    required this.isCurrentUser,
  });

  final Item item;
  final BuildContext context;
  final BuildContext parentContext;
  final LoadingBlockFullScreen loadingOverlay;
  final bool isCurrentUser;

  Future<void> deleteConfirmationDialog(BuildContext thisContext) async {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          context.tr('item.page.btn.deleteItem'),
        ),
        content: Text(
          context.tr('item.page.delete.item.warning'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // close the dialog
              loadingOverlay.show();
              await BartFirestoreServices.deleteItem(item).then(
                (result) {
                  loadingOverlay.hide();
                  if (result) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      BartSnackBar(
                        message: tr('item.page.delete.item.snackbar1'),
                        backgroundColor: Colors.green,
                        icon: Icons.done,
                      ).build(parentContext),
                    );
                  } else {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      BartSnackBar(
                        message: tr('item.page.delete.item.snackbar2'),
                        backgroundColor: Colors.red,
                        icon: Icons.error,
                      ).build(parentContext),
                    );
                  }
                },
              );
            },
            child: Text(context.tr('yes')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.tr('no')),
          ),
        ],
      ),
    );
  }

  show() {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: isCurrentUser
                ? [
                    MarketListTile(
                      item: item,
                      onTap: () {},
                      onLongPress: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: Text(context.tr('item.page.btn.editItem')),
                      onTap: () {
                        Navigator.pop(context); // close the modal sheet
                        context.push(
                          '/market/listed-items/item/${item.itemID}/editItem',
                          extra: {'item': item},
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: Text(
                        context.tr('item.page.btn.deleteItem'),
                        style: const TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        Navigator.pop(context); // close the modal sheet
                        await deleteConfirmationDialog(context);
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                    ),
                  ]
                : [
                    MarketListTile(
                      item: item,
                      onTap: () {},
                      onLongPress: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.remove_red_eye_rounded),
                      title: Text(context.tr('item.page.btn.viewItem')),
                      onTap: () {
                        Navigator.pop(context); // close the modal sheet
                        context.push(
                          '/market/listed-items/item/${item.itemID}',
                          extra: item,
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.tr('item.page.btn.viewRestricted'),
                      textAlign: TextAlign.center,
                    ),
                  ],
          ),
        );
      },
    );
  }
}
