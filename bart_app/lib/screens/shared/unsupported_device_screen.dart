import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_brand_colour_style.dart';

class UnsupportedDeviceScreen extends StatelessWidget {
  const UnsupportedDeviceScreen({
    super.key,
  });

  Widget getIconRow(BuildContext context, BartBrandColours brandTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              Icon(
                Icons.monitor,
                size: 100,
                color: brandTheme.logoColor,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(
                      color: Colors.white,
                      width: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              Icon(
                Icons.phone_android_rounded,
                size: 100,
                color: brandTheme.logoColor,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.white,
                      width: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Text(
          "We're Sorry :(",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 45.spMin,
                color: brandTheme.logoColor,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandTheme = Theme.of(context).extension<BartBrandColours>()!;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            backgroundColor: brandTheme.logoBackgroundColor,
            extendBody: true,
            persistentFooterAlignment: AlignmentDirectional.center,
            persistentFooterButtons: [
              SizedBox(
                height: 50.spMin,
                child: Text(
                  "bart.",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 30.spMin,
                        color: brandTheme.logoColor,
                      ),
                ),
              ),
            ],
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 10.h,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getIconRow(context, brandTheme),
                    const SizedBox(height: 10),
                    Text(
                      "The Bart Community Trading app is not supported on widescreen devices (yet).",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 28.spMin,
                        color: brandTheme.logoColor,
                      ),
                    ),
                    Text(
                      "Please change your orientation to portrait mode, or reopen the app on a mobile device to continue.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 28.spMin,
                        color: brandTheme.logoColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
