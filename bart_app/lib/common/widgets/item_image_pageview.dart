import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/screens/shared/view_image_page.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ItemImagesPageView extends StatefulWidget {
  const ItemImagesPageView({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  State<ItemImagesPageView> createState() => _ItemImagesPageViewState();
}

class _ItemImagesPageViewState extends State<ItemImagesPageView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
//
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: SizedBox.fromSize(
            size: const Size.fromHeight(280),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.item.imgs.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final imgKey = 'item_${widget.item.itemID}_$index';
                final innerChild = GestureDetector(
                  onTap: () {
                    if (kIsWeb) {
                      showDialog(
                        context: context,
                        useRootNavigator: false,
                        barrierDismissible: true,
                        useSafeArea: true,
                        barrierColor: Colors.black,
                        builder: (context) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          child: ViewImagePage(
                            imgUrl: widget.item.imgs[index],
                            imgKey: imgKey,
                          ),
                        ),
                      );
                    } else {
                      context.pushNamed(
                        'viewImage',
                        extra: {
                          'imgUrl': widget.item.imgs[index],
                          'imgKey': imgKey,
                        },
                      );
                    }
                  },

                  // onTap: () {},

                  child: CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl: widget.item.imgs[index],
                    cacheManager: BartImageTools.customCacheManager,
                    cacheKey: imgKey,
                    progressIndicatorBuilder: BartImageTools.progressLoader,
                    fit: BoxFit.contain,
                  ),
                );
                return Hero(tag: imgKey, child: innerChild);
              },
            ),
          ),
        ),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.item.imgs.length,
            effect: WormEffect(
              dotWidth: 8,
              dotHeight: 8,
              activeDotColor:
                  Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
              dotColor:
                  Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
