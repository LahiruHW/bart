import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/extensions/ext_trade.dart';
import 'package:bart_app/common/widgets/item_description.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:bart_app/common/widgets/result_item_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bart_app/common/widgets/icons/icon_exchange.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/screens/shared/trade_details_page_footer.dart';
import 'package:bart_app/common/extensions/ext_bart_scroll_controller.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

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
  late String lable1;
  late String lable2;
  bool _isMsgSending = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _descriptionTextController = TextEditingController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 300),
          () => _scrollController.scrollDown(offset: 100),
        );
      }
    });
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
          child: CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: imagePath,
            progressIndicatorBuilder: BartImageTools.progressLoader,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // somehow this line fixes the locale issue
    debugPrint('------------- ${context.locale.toString()}');

    if (widget.tradeType != TradeCompType.outgoing) {
      if (!widget.trade.isRead){
        BartFirestoreServices.markTradeAsRead(widget.trade.tradeID);
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: StreamBuilder<Trade>(
          stream: BartFirestoreServices.getTradeStream(
            widget.userID,
            widget.trade.tradeID,
          ),
          initialData: widget.trade,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('NO DATA'),
              );
            }

            final Trade thisTrade = snapshot.data!;
            final labels = thisTrade.getTradeItemLabels();
            lable1 = labels.$1;
            lable2 = labels.$2;

            return SingleChildScrollView(
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
                    item: thisTrade.tradedItem,
                    onTap: () =>
                        viewImage(context, thisTrade.tradedItem.imgs[0]),
                  ),
                  const SizedBox(height: 12),
                  const ExchangeIcon(),
                  const SizedBox(height: 12),
                  ResultItemTile(
                    key: ValueKey(context.locale.toString()),
                    label: lable2,
                    item: thisTrade.offeredItem,
                    onTap: !thisTrade.offeredItem.isPayment
                        ? () =>
                            viewImage(context, thisTrade.offeredItem.imgs[0])
                        : () {},
                  ),
                  const SizedBox(height: 20),
                  ItemDescription(item: thisTrade.offeredItem),
                  const SizedBox(height: 10),
                  TradeDetailsPageFooter(
                    userID: widget.userID,
                    trade: thisTrade,
                    tradeType: thisTrade.tradeCompType,
                    descriptionTextController: _descriptionTextController,
                    focusNode: _focusNode,
                    loadingOverlay: LoadingBlockFullScreen(
                      context: context,
                      dismissable: false,
                    ),
                    isMsgSending: _isMsgSending,
                    whileSending: () {
                      setState(() => _isMsgSending = true);
                    },
                    onSent: () {
                      setState(() => _isMsgSending = false);
                    },
                  ).build(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
