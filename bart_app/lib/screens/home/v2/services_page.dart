import 'package:flutter/material.dart';
// import 'package:bart_app/common/widgets/service_page_list_tile.dart';

class HomeServicesPage extends StatefulWidget {
  const HomeServicesPage({
    super.key,
  });

  @override
  State<HomeServicesPage> createState() => _HomeServicesPageState();
}

class _HomeServicesPageState extends State<HomeServicesPage> {
  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     ServicePageListTile(),
    //   ],
    // );

    return const Center(
      child: Text(
        "We're still working on this part, we'll let you know when it's ready🫡",
        textAlign: TextAlign.center,
      ),
    );
  }
}
