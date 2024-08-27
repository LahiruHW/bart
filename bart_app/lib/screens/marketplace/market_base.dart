import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';
import 'package:bart_app/common/widgets/buttons/bart_page_tab_button.dart';

class MarketBase extends StatefulWidget {
  const MarketBase({
    super.key,
    required this.bodyWidget,
  });

  final StatefulNavigationShell bodyWidget;

  @override
  State<MarketBase> createState() => _MarketBaseState();
}

class _MarketBaseState extends State<MarketBase> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  bool _onListedItemsPage = true;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  bool _showClearButton = false;
  Timer? _debounce;
  late final TempStateProvider tempProvider;
  final Duration _debounceDuration = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _searchController = TextEditingController(text: "");
    _searchController.addListener(updateText);
    _searchFocusNode = FocusNode();
    tempProvider = Provider.of<TempStateProvider>(context, listen: false);
  }

  void updateText() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      tempProvider.setSearchText(_searchController.text);
      _showClearButton = tempProvider.searchText.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(updateText);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleMarketTab() {
    setState(() {
      _onListedItemsPage = !_onListedItemsPage;
      _onListedItemsPage
          ? context.go('/market/listed-items')
          : context.go('/market/requests');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _searchFocusNode.unfocus(),
      onVerticalDragDown: (_) => _searchFocusNode.unfocus(),
      onHorizontalDragDown: (_) => _searchFocusNode.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: _onListedItemsPage
            ? FloatingActionButton(
                onPressed: () {
                  if (_onListedItemsPage) {
                    context.push('/newItem');
                  }
                },
                child: const Icon(Icons.add),
              )
            : null,
        body: Column(
          children: [
            // the tab button row
            SizedBox.fromSize(
              size: Size(double.infinity, 80.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: BartPageTabButton(
                      key: BartTuteWidgetKeys.marketPageTab1,
                      title: context.tr("market.page.tab.listedItems"),
                      enabled: _onListedItemsPage,
                      onTap: _toggleMarketTab,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BartPageTabButton(
                      key: BartTuteWidgetKeys.marketPageTab2,
                      title: context.tr("market.page.tab.requests"),
                      enabled: !_onListedItemsPage,
                      onTap: _toggleMarketTab,
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
              child: widget.bodyWidget,
            ),
          ],
        ),
      ),
    );
  }
}
