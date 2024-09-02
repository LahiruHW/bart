import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/buttons/bart_page_tab_button.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({
    super.key,
    required this.bodyWidget,
  });

  final StatefulNavigationShell bodyWidget;

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  bool _onTradesPage = true;

  void _toggleHomeTab() {
    setState(() {
      _onTradesPage = !_onTradesPage;
      _onTradesPage ? context.go('/home-trades') : context.go('/home-services');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // tab button row
          SizedBox.fromSize(
            size: Size(double.infinity, 80.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: BartPageTabButton(
                    title: context.tr("home.page.tab.trades"),
                    enabled: _onTradesPage,
                    onTap: _toggleHomeTab,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BartPageTabButton(
                    title: context.tr("home.page.tab.services"),
                    enabled: !_onTradesPage,
                    onTap: _toggleHomeTab,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Expanded(child: widget.bodyWidget),
        ],
      ),
    );
  }
}
