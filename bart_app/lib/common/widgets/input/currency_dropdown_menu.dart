import 'package:bart_app/styles/bart_payment_page_style.dart';
import 'package:flutter/material.dart';

class CurrencyDropDownMenu extends StatelessWidget {
  const CurrencyDropDownMenu({
    super.key,
    required this.selectedCurrency,
    required this.currencyList,
    required this.onChanged,
  });

  final String selectedCurrency;
  final List<String> currencyList;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final paymentPageStyle =
        Theme.of(context).extension<BartPaymentPageStyle>()!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 1,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color:
            paymentPageStyle.currencyDropdownBackgroundColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCurrency,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 20,
          iconDisabledColor: Colors.grey.shade400,
          iconEnabledColor: paymentPageStyle.currencyDropdownIconColor,
          dropdownColor: paymentPageStyle.currencyDropdownBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          style: TextStyle(
            color: paymentPageStyle.currencyDropdownTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          underline: null,
          onChanged: onChanged,
          items: currencyList
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
