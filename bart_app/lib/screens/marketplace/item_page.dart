import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    itemID = widget.itemID;
    item = widget.item;
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      builder: (context, provider, child) => SingleChildScrollView(
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
                    fontSize: 24,
                  ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox.fromSize(
                size: const Size.fromHeight(300),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: item.imgs.length,
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: item.itemID,
                      child: CachedNetworkImage(
                        imageUrl: item.imgs[index],
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: item.imgs.length,
                effect: WormEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor:
                      Theme.of(context).colorScheme.surface.computeLuminance() >
                              0.5
                          ? Colors.black
                          : Colors.white,
                  dotColor:
                      Theme.of(context).colorScheme.surface.computeLuminance() >
                              0.5
                          ? Colors.black.withOpacity(0.3)
                          : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              context.tr('item.page.prod.desc'),
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
                color:
                    Theme.of(context).colorScheme.surface.computeLuminance() >
                            0.5
                        ? Colors.white
                        : Colors.black,
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.itemDescription,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              context.tr(
                'item.page.prefInReturn',
                namedArgs: {'itemOwner': item.itemOwner.userName},
              ),
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
                color:
                    Theme.of(context).colorScheme.surface.computeLuminance() >
                            0.5
                        ? Colors.white
                        : Colors.black,
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.preferredInReturn!.isNotEmpty
                    ? item.preferredInReturn!
                        .map(
                          (txt) => Text(
                            '• $txt',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        )
                        .toList()
                    : [
                        Text(
                          context.tr(
                            'item.page.empty.prefInReturn',
                            namedArgs: {'itemOwner': item.itemOwner.userName},
                          ),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 150,
                height: 80,
                child: BartMaterialButton(
                  label: context.tr('item.page.btn.returnOffer'),
                  onPressed: () {
                    // a user can't trade with themselves
                    if (provider.userProfile.userID == item.itemOwner.userID) {
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
                      '/market/item/${item.itemID}/returnItem',
                      extra: item,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
