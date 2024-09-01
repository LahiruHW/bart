import 'package:flutter/material.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemReturnPreferences extends StatelessWidget {
  const ItemReturnPreferences({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Text(
          context.tr(
            'item.page.prefInReturn',
            namedArgs: {'itemOwner': item.itemOwner.userName},
          ),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: BartAppTheme.red1,
                fontSize: 20.spMin,
              ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 18.spMin,
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
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 18.spMin,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}
