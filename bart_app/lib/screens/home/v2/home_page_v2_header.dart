import 'package:bart_app/common/constants/tutorial_widget_keys.dart';
import 'package:bart_app/common/providers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomePageV2PersistentHeader extends SliverPersistentHeaderDelegate {
  HomePageV2PersistentHeader({
    required this.segmentTitle,
    required this.onSelectionChanged,
  });

  final String segmentTitle;
  final Function(Set<int>)? onSelectionChanged;
  final double _extent = 160.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Consumer<TempStateProvider>(
            builder: (context, tempProvider, child) => SegmentedButton<int>(
              segments: [
                ButtonSegment(
                  icon: Icon(
                    Icons.input_rounded,
                    key: BartTuteWidgetKeys.homePageV2IncomingTrades,
                  ),
                  tooltip: 'Incoming',
                  value: 0,
                ),
                ButtonSegment(
                  icon: Icon(
                    Icons.output_rounded,
                    key: BartTuteWidgetKeys.homePageV2OutgoingTrades,
                  ),
                  tooltip: 'Outgoing',
                  value: 1,
                ),
                ButtonSegment(
                  icon: Icon(
                    Icons.hourglass_top_rounded,
                    key: BartTuteWidgetKeys.homePageV2TBCTrades,
                  ),
                  tooltip: 'To Be Completed',
                  value: 2,
                ),
                ButtonSegment(
                  icon: Icon(
                    Icons.sports_score_outlined,
                    key: BartTuteWidgetKeys.homePageV2STH,
                  ),
                  tooltip: 'Successful History',
                  value: 3,
                ),
              ],
              multiSelectionEnabled: false,
              onSelectionChanged: onSelectionChanged,
              selected: tempProvider.homeV2Index,
              showSelectedIcon: false,
              emptySelectionAllowed: false,
            ),
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
