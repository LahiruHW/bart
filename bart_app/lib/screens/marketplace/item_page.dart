import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/widgets/item_description.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/widgets/item_image_pageview.dart';
import 'package:bart_app/common/widgets/item_ask_a_question.dart';
import 'package:bart_app/common/widgets/item_return_preferences.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({
    super.key,
    required this.item,
    required this.itemID,
  });

  final Item item;
  final String itemID;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late Item item;
  late String itemID;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    itemID = widget.itemID;
    item = widget.item;
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<BartStateProvider>(
        builder: (context, provider, child) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr(
                  'item.page.title',
                  namedArgs: {'itemOwner': item.itemOwner.userName},
                ),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: BartAppTheme.red1,
                      fontSize: 18.spMin,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                item.itemName,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 28.spMin,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              ItemImagesPageView(item: item),
              const SizedBox(height: 25),
              ItemDescription(item: item),
              const SizedBox(height: 10),
              ItemReturnPreferences(item: item),
              const SizedBox(height: 10),
              if (provider.userProfile.userID != item.itemOwner.userID)
                ItemQuestionField(
                  item: item,
                  userID: provider.userProfile.userID,
                  focusNode: focusNode,
                ),
              const SizedBox(height: 10),
              if (provider.userProfile.userID != item.itemOwner.userID)
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 80,
                    child: BartMaterialButton(
                      label: context.tr('item.page.btn.returnOffer'),
                      onPressed: () {
                        // a user can't trade with themselves
                        if (provider.userProfile.userID ==
                            item.itemOwner.userID) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            BartSnackBar(
                              message: context.tr('item.page.snackbar.msg1'),
                              backgroundColor: Colors.amber,
                              icon: Icons.warning,
                            ).build(context),
                          );
                          return;
                        }

                        context.push(
                          '/item/returnItem',
                          extra: item,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
