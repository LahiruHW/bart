import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/item.dart';
// import 'package:bart_app/common/utility/bart_router.dart';
import 'package:bart_app/common/widgets/market_page_list_tile.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/buttons/market_tab_button.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_market_list_tile_list.dart';
import 'package:go_router/go_router.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({
    super.key,
  });

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  bool _onListedItemsPage = true;

  void _togglePage() {
    setState(() {
      _onListedItemsPage = !_onListedItemsPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
        children: [
          // the tab button row
          SizedBox.fromSize(
            size: const Size(double.infinity, 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: MarketPageTabButton(
                    title: context.tr("market.page.tab.listedItems"),
                    enabled: _onListedItemsPage,
                    onTap: _togglePage,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MarketPageTabButton(
                    title: context.tr("market.page.tab.requests"),
                    enabled: !_onListedItemsPage,
                    onTap: _togglePage,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          // the search bar
          SizedBox.fromSize(
            size: const Size(double.infinity, 70),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: context.tr("market.search.placeholder"),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: _onListedItemsPage
                ? StreamBuilder(
                    // stream: BartFirestoreServices.getItemListStream(),
                    stream:
                        BartFirestoreServices.getMarketplaceItemListStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active &&
                          snapshot.hasData) {
                        final data = snapshot.data as List<Item>;
                        // debugPrint('------------------------------- MARKET DATA: $data');
                        return ListView.separated(
                          itemCount: data.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 8,
                            color: Colors.transparent,
                          ),
                          itemBuilder: (context, index) {
                            final thisItem = data[index];
                            return MarketListTile(
                              item: thisItem,
                              onTap: () {
                                debugPrint('tapped');
                                // BartRouter.pushPage(
                                //   context,
                                //   'item/${data[index].itemID}',
                                //   thisItem,
                                // );
                                context.push(
                                  '/market/item/${thisItem.itemID}',
                                  extra: thisItem,
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return const MarketListTileListShimmer();
                      }
                    },
                  )
                : const Center(
                    child: Text(
                      'Requests\nstill in progress (...sigh)',
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          // // put a small space at the bottom
          // Container(
          //   height: 5,
          //   color: Colors.transparent,
          // ),
        ],
      ),
    );
  }
}
