import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/providers/index.dart';
import 'package:bart_app/common/utility/bart_router.dart';
import 'package:bart_app/common/widgets/market_page_list_tile.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/listed_item_bottom_modal_sheet.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_market_list_tile_list.dart';

class MarketListedItemsPage extends StatelessWidget {
  const MarketListedItemsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<BartStateProvider, TempStateProvider>(
      builder: (context, stateProvider, tempProvider, child) {
        final searchText = tempProvider.searchText;
        return SizedBox.expand(
          child: StreamBuilder(
            stream: BartFirestoreServices.getMarketplaceItemListStream().map(
              (itemList) => itemList
                  .where((item) => item.doesItemContainQuery(searchText))
                  .toList(),
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<Item>;
                // filter the data based on the search text
                searchText.isNotEmpty
                    ? data
                        .where((item) => item.doesItemContainQuery(searchText))
                        .toList()
                    : null;
                return ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 8,
                    color: Colors.transparent,
                  ),
                  itemBuilder: (context, index) {
                    final thisItem = data[index];

                    return MarketListTile(
                      key: index == 0
                          ? BartTuteWidgetKeys.marketPageListedItem
                          : null,
                      item: thisItem,
                      onTap: () {
                        context.push(
                          '/item/${thisItem.itemID}',
                          extra: thisItem,
                        );
                      },
                      onLongPress: () => ListedItemBottomModalSheet(
                        item: thisItem,
                        context: context,
                        loadingOverlay: LoadingBlockFullScreen(
                          context: context,
                          dismissable: false,
                        ),
                        parentContext: BartRouter.rootNavKey.currentContext!,
                        isCurrentUser: (stateProvider.userProfile.userID ==
                            thisItem.itemOwner.userID),
                      ).show(),
                    );
                  },
                );
              } else {
                return const MarketListTileListShimmer();
              }
            },
          ),
        );
      },
    );
  }
}
