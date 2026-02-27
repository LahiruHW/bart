// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  ListTile _viewItemTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.remove_red_eye_rounded),
      tileColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      title: Text(
        context.tr('item.page.btn.viewItem'),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 18.spMin,
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: () {
        Navigator.pop(context); // close the modal sheet
        context.push('/item', extra: item);
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
    );
  }

  ListTile _editItemTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.edit),
      tileColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      title: Text(
        context.tr('item.page.btn.editItem'),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 18.spMin,
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: () {
        Navigator.pop(context); // close the modal sheet
        context.push(
          '/item/${item.itemID}/editItem',
          extra: {'item': item},
        );
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
    );
  }

  ListTile _deleteItemTile(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      leading: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      title: Text(
        context.tr('item.page.btn.deleteItem'),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.red,
              fontSize: 18.spMin,
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: () async {
        Navigator.pop(context); // close the modal sheet
        await deleteConfirmationDialog(context);
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
    );
  }

  void show() {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: isCurrentUser
                    ? [
                        MarketListTile(
                          item: item,
                          onTap: () {},
                          onLongPress: () {},
                        ),
                        _viewItemTile(context),
                        _editItemTile(context),
                        _deleteItemTile(context),
                      ]
                    : [
                        MarketListTile(
                          item: item,
                          onTap: () {},
                          onLongPress: () {},
                        ),
                        _viewItemTile(context),
                        const SizedBox(height: 10),
                        Text(
                          context.tr('item.page.btn.viewRestricted'),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 12.spMin,
                                  ),
                        ),
                      ],
              ),
            ),
          ],
        );
      },
    );
  }
}
