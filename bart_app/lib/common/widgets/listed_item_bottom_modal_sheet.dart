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
    required this.scaffoldKey,
  });

  final Item item;
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final LoadingBlockFullScreen loadingOverlay;

  Future<void> deleteConfirmationDialog(BuildContext thisContext) async {
    showDialog(
      context: thisContext,
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
                (value) {
                  loadingOverlay.hide();
                  ScaffoldMessenger.of(scaffoldKey.currentContext!)
                      .showSnackBar(
                    BartSnackBar(
                      message: tr('item.page.delete.item.snackbar1'),
                      backgroundColor: Colors.green,
                      icon: Icons.error,
                    ).build(scaffoldKey.currentContext!),
                  );
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
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                    '/market/item/${item.itemID}/editItem',
                    extra: {'item': item},
                  );
                },
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
              ),
            ],
          ),
        );
      },
    );
  }
}
