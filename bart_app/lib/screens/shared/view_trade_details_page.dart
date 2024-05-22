import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/result_item_tile.dart';
// import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/widgets/icons/icon_exchange.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';
import 'package:bart_app/common/widgets/input/trade_details_page_footer.dart';

class ViewTradePage extends StatefulWidget {
  const ViewTradePage({
    super.key,
    required this.tradeType,
    required this.trade,
    required this.userID,
  });

  final TradeCompType tradeType;
  final Trade trade;
  final String userID;

  @override
  State<ViewTradePage> createState() => _ViewTradePageState();
}

class _ViewTradePageState extends State<ViewTradePage> {
  late final TextEditingController _descriptionTextController;
  late final ScrollController _scrollController;
  late final FocusNode _focusNode;
  // late final LoadingBlockFullScreen _loadingOverlay;
  late String lable1;
  late String lable2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _descriptionTextController = TextEditingController();
    _focusNode.addListener(() {
      // if (_focusNode.hasFocus || _focusNode.hasPrimaryFocus) {
      if (_focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 300),
          () => scrollDown(offset: 100),
        );
      }
    });
  }

  void scrollDown({double offset = 0.0}) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _descriptionTextController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  static void viewImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(80.0),
          child: CachedNetworkImage(imageUrl: imagePath),
        );
      },
    );
  }

  (String, String) getTradeItemLabels() {
    final trader = widget.trade.tradedItem.itemOwner.userName;
    final tradee = widget.trade.offeredItem.itemOwner.userName;
    switch (widget.tradeType) {
      case TradeCompType.incoming:
        // return (
        //   "Your listed item",
        //   "$tradee is offering you",
        // );
        return (
          tr('view.trade.page.incoming.label1'),
          tr(
            'view.trade.page.incoming.label2',
            namedArgs: {'itemOwner': tradee},
          ),
        );
      case TradeCompType.outgoing:
        // return (
        //   "$trader's listed item",
        //   "You offered",
        // );
        return (
          tr(
            'view.trade.page.outgoing.label1',
            namedArgs: {'itemOwner': trader},
          ),
          tr('view.trade.page.outgoing.label2'),
        );
      case TradeCompType.successful:
        // return (
        //   "Offered by $trader",
        //   "Offered by $tradee, accepted by $trader",
        // );
        return (
          tr(
            'view.trade.page.successful.label1',
            namedArgs: {'itemOwner': trader},
          ),
          tr(
            'view.trade.page.successful.label2',
            namedArgs: {'tradee': tradee, 'trader': trader},
          ),
        );
      case TradeCompType.completeFailed:
        // return (
        //   "Offered by $trader",
        //   "Offered by $tradee, rejected by $trader",
        // );
        return (
          tr(
            'view.trade.page.completeFailed.label1',
            namedArgs: {'itemOwner': trader},
          ),
          tr(
            'view.trade.page.completeFailed.label2',
            namedArgs: {'tradee': tradee, 'trader': trader},
          ),
        );
      default:
        // return (
        //   "Offered by $trader",
        //   "Offered by $tradee",
        // );
        return (
          tr(
            'view.trade.page.default.label1',
            namedArgs: {'itemOwner': trader},
          ),
          tr(
            'view.trade.page.default.label2',
            namedArgs: {'itemOwner': tradee},
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // somehow this line fixes the locale issue
    debugPrint('------------- ${context.locale.toString()}');

    setState(() {
      final val = getTradeItemLabels();
      lable1 = val.$1;
      lable2 = val.$2;
    });

    if (widget.tradeType != TradeCompType.outgoing) {
      if (!widget.trade.isRead) {
        widget.trade.isRead = true;
        BartFirestoreServices.updateTrade(widget.trade);
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultItemTile(
                key: ValueKey(context.locale),
                label: lable1,
                item: widget.trade.tradedItem,
                onTap: () =>
                    viewImage(context, widget.trade.tradedItem.imgs[0]),
              ),
              const SizedBox(height: 12),
              const ExchangeIcon(),
              const SizedBox(height: 12),
              ResultItemTile(
                key: ValueKey(context.locale.toString()),
                label: lable2,
                item: widget.trade.offeredItem,
                labelColor: widget.tradeType == TradeCompType.completeFailed
                    ? Colors.red
                    : null,
                onTap: !widget.trade.offeredItem.isPayment
                    ? () => viewImage(context, widget.trade.offeredItem.imgs[0])
                    : () {},
              ),
              const SizedBox(height: 20),
              Text(
                // 'Product Description: ',
                context.tr('view.trade.page.prodDesc'),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: BartAppTheme.red1,
                      fontSize: 20,
                    ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                              .colorScheme
                              .surface
                              .computeLuminance() >
                          0.5
                      ? Colors.white
                      : Colors.black,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.trade.offeredItem.itemDescription,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              const SizedBox(height: 10),
              ...TradeDetailsPageFooter(
                userID: widget.userID,
                trade: widget.trade,
                tradeType: widget.tradeType,
                descriptionTextController: _descriptionTextController,
                focusNode: _focusNode,
                loadingOverlay: LoadingBlockFullScreen(
                  // context: scaffoldKey.currentContext!,
                  context: context,
                  dismissable: false,
                ),
              ).build(context),
            ],
          ),
        ),
      ),
    );
  }
}
