import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/market_page_list_tile.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/buttons/market_tab_button.dart';
import 'package:bart_app/common/widgets/listed_item_bottom_modal_sheet.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_market_list_tile_list.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({
    super.key,
  });

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  bool _onListedItemsPage = true;
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  String _searchText = '';
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _searchController = TextEditingController(
      text: _searchText,
    );
    _searchController.addListener(updateText);
    _searchFocusNode = FocusNode();
  }

  void updateText() {
    setState(() {
      _searchText = _searchController.text;
      _showClearButton = _searchText.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(updateText);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _togglePage() {
    setState(() {
      _onListedItemsPage = !_onListedItemsPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: () => _searchFocusNode.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: _onListedItemsPage
            ? FloatingActionButton(
                onPressed: () {
                  if (_onListedItemsPage) {
                    context.push('/home/newItem');
                  }
                },
                child: const Icon(Icons.add),
              )
            : null,
        body: Column(
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
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onEditingComplete: () => _searchFocusNode.unfocus(),
                    decoration: InputDecoration(
                      hintText: context.tr("market.search.placeholder"),
                      hintStyle: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle!
                          .copyWith(fontSize: 18),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _showClearButton
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                _searchFocusNode.unfocus();
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: _onListedItemsPage
                  ? StreamBuilder(
                      stream:
                          BartFirestoreServices.getMarketplaceItemListStream()
                              .map(
                        (itemList) => itemList
                            .where((item) =>
                                item.doesItemContainQuery(_searchText))
                            .toList(),
                      ),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                        if (snapshot.hasData) {
                          final data = snapshot.data as List<Item>;

                          // filter the data based on the search text
                          _onListedItemsPage
                              ? data
                                  .where((item) =>
                                      item.doesItemContainQuery(_searchText))
                                  .toList()
                              : null;

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
                                onLongPress: () => ListedItemBottomModalSheet(
                                  item: thisItem,
                                  context: context,
                                  loadingOverlay: LoadingBlockFullScreen(
                                    context: context,
                                    dismissable: false,
                                  ),
                                  scaffoldKey: _scaffoldKey,
                                ).show(),
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
      ),
    );
  }
}
