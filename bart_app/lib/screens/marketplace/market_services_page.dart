import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:bart_app/common/providers/index.dart';

class MarketServicesPage extends StatelessWidget {
  const MarketServicesPage({
    super.key,
    required this.parentContext,
  });

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    // return Consumer2<BartStateProvider, TempStateProvider>(
    //   builder: (context, stateProvider, tempProvider, child) {
    //     final searchText = tempProvider.searchText;
    //     return SizedBox.expand(
    //       child: StreamBuilder(
            
    //       ),
    //     );
    //   },
    // );

    return const Center(
      child: Text(
        'Services\nstill in progress (...sigh)',
        textAlign: TextAlign.center,
      ),
    );
  }
}
