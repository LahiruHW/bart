import 'package:flutter/material.dart';

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
    return const Center(
      child: Text(
        'Services Tab',
        textAlign: TextAlign.center,
      ),
    );
  }
}
