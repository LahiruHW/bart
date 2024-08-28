import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as bgs;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/trade_widget_badge_style.dart';
import 'package:bart_app/styles/bart_segment_slider_style.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';

class HomePageV2PersistentHeader extends SliverPersistentHeaderDelegate {
  HomePageV2PersistentHeader({
    required this.segmentTitle,
    required this.onSelectionChanged,
    required this.unreadCountArray,
  });

  final String segmentTitle;
  final Function(int?) onSelectionChanged;
  final List<int> unreadCountArray;

  final double _headerHeight = 166.h;
  final double _width = 270.w;
  final double _height = 60.h;

  bool showBadge(badgeIndex) => !(badgeIndex == 0);

  List<Widget> badgeFactory(
    BuildContext context,
    int currentPos,
    List<GlobalKey> keyList,
    TradeWidgetBadgeStyle badgeStyle,
  ) {
    int index = 0;
    return keyList
        .map<Widget>(
          (key) => Expanded(
            flex: 1,
            child: _buildBadge(
              pos: index++,
              context: context,
              segmentIndex: currentPos,
              badgeStyle: badgeStyle,
              child: Container(key: key),
            ),
          ),
        )
        .toList();
  }

  Widget _buildBadge({
    required BuildContext context,
    required int pos,
    required int segmentIndex,
    required Widget child,
    required TradeWidgetBadgeStyle badgeStyle,
  }) {
    final unreadCount = unreadCountArray[pos];
    return bgs.Badge(
      badgeContent: Text(
        unreadCount.toString(),
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: (pos == segmentIndex)
                  ? badgeStyle.selectedLabelColor
                  : badgeStyle.labelColor,
              fontSize: 12.spMin,
            ),
      ),
      showBadge: showBadge(unreadCount),
      position: bgs.BadgePosition.topEnd(end: 3, top: -7),
      badgeStyle: bgs.BadgeStyle(
        shape: bgs.BadgeShape.circle,
        padding: EdgeInsets.all(6.w),
        badgeColor: (pos == segmentIndex)
            ? badgeStyle.selectedBadgeColor
            : badgeStyle.badgeColor,
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.25),
          width: 0.3,
        ),
      ),
      ignorePointer: true,
      badgeAnimation: bgs.BadgeAnimation.scale(
        curve: Curves.easeInOut,
        animationDuration: 400.ms,
        appearanceDisappearanceFadeAnimationEnabled: false,
      ),
      onTap: null,
      child: child,
    );
  }

  Map<int, Widget> buttonFactory(
    List<Icon> iconList,
    BartSegmentSliderStyle style,
    int selectedIndex,
  ) {
    return iconList.asMap().map(
          (key, thisIcon) => MapEntry(
            key,
            IconButton(
              icon: thisIcon,
              disabledColor: selectedIndex == key
                  ? style.selectedIconColour
                  : style.iconColour,
              onPressed: null,
            ),
          ),
        );
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final sliderStyle = Theme.of(context).extension<BartSegmentSliderStyle>()!;
    final badgeStyle = Theme.of(context).extension<TradeWidgetBadgeStyle>()!;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: 25.h),
          Consumer<TempStateProvider>(
            builder: (context, tempProvider, child) {
              final currentPos = tempProvider.homeV2Index;
              return Stack(
                alignment: Alignment.center,
                fit: StackFit.passthrough,
                children: [
                  SizedBox(
                    width: _width,
                    height: _height,
                    child: CupertinoSlidingSegmentedControl(
                      backgroundColor: sliderStyle.backgroundColor,
                      thumbColor: sliderStyle.thumbColor,
                      groupValue: currentPos,
                      children: buttonFactory(
                        [
                          const Icon(Icons.input_rounded),
                          const Icon(Icons.output_rounded),
                          const Icon(Icons.hourglass_top_rounded),
                          const Icon(Icons.sports_score_rounded),
                        ],
                        sliderStyle,
                        currentPos,
                      ),
                      onValueChanged: onSelectionChanged,
                    ),
                  ),
                  SizedBox(
                    width: _width,
                    height: _height,
                    child: Row(
                      children: badgeFactory(
                        context,
                        currentPos,
                        [
                          BartTuteWidgetKeys.homePageV2IncomingTrades,
                          BartTuteWidgetKeys.homePageV2OutgoingTrades,
                          BartTuteWidgetKeys.homePageV2TBCTrades,
                          BartTuteWidgetKeys.homePageV2STH,
                        ],
                        badgeStyle,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 35.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 0.90.sw,
              child: Text(
                segmentTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .computeLuminance() >
                              0.5
                          ? Colors.black
                          : Colors.white,
                      fontSize: 18.spMin,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ]
            .animate(
              delay: 300.ms,
              interval: 50.ms,
            )
            .fadeIn(
              duration: 400.ms,
              curve: Curves.easeInOutCubic,
            ),
      ),
    );
  }

  @override
  double get maxExtent => _headerHeight;

  @override
  double get minExtent => _headerHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
