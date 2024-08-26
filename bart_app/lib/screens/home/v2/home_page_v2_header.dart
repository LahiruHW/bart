import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_segment_slider_style.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';

class HomePageV2PersistentHeader extends SliverPersistentHeaderDelegate {
  HomePageV2PersistentHeader({
    required this.segmentTitle,
    required this.onSelectionChanged,
  });

  final String segmentTitle;
  final Function(int?) onSelectionChanged;
  final double _extent = 160.h;
  final double _width = 270.w;
  final double _height = 60.h;

  Map<int, Widget> buttonFactory(
    List<Icon> iconList,
    BartSegmentSliderStyle style,
    int selectedIndex,
  ) {
    Map<int, Widget> buttonMap = {};
    for (int i = 0; i < iconList.length; i++) {
      buttonMap[i] = IconButton(
        icon: iconList[i],
        disabledColor:
            selectedIndex == i ? style.selectedIconColour : style.iconColour,
        onPressed: null,
      );
    }
    return buttonMap;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final sliderStyle = Theme.of(context).extension<BartSegmentSliderStyle>()!;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Consumer<TempStateProvider>(
            builder: (context, tempProvider, child) {
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
                      groupValue: tempProvider.homeV2Index,
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 5.w,
                      ),
                      children: buttonFactory(
                        [
                          const Icon(Icons.input_rounded),
                          const Icon(Icons.output_rounded),
                          const Icon(Icons.hourglass_top_rounded),
                          const Icon(Icons.sports_score_rounded),
                        ],
                        sliderStyle,
                        tempProvider.homeV2Index,
                      ),
                      onValueChanged: onSelectionChanged,
                    ),
                  ),
                  SizedBox(
                    width: _width,
                    height: _height,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            key: BartTuteWidgetKeys.homePageV2IncomingTrades,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            key: BartTuteWidgetKeys.homePageV2OutgoingTrades,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            key: BartTuteWidgetKeys.homePageV2TBCTrades,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            key: BartTuteWidgetKeys.homePageV2STH,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 30.h),
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
  double get maxExtent => _extent;

  @override
  double get minExtent => _extent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
