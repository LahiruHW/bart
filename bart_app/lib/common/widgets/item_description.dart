import 'package:flutter/material.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';

class ItemDescription extends StatelessWidget {
  const ItemDescription({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          context.tr('item.page.prod.desc'),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: BartAppTheme.red1,
                fontSize: 20,
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
          child: Text(
            item.itemDescription,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      ],
    );
  }
}
