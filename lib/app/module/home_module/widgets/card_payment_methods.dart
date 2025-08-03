import 'package:flutter/material.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

import 'package:uber_clone_driver/app/module/profile_module/widgets/payment_type_widget.dart';

class CardPaymentMethods extends StatefulWidget {
  const CardPaymentMethods({super.key});

  @override
  State<CardPaymentMethods> createState() => _CardPaymentMethodsState();
}

class _CardPaymentMethodsState extends State<CardPaymentMethods> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Material(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        elevation: 4,
        child: GridView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          children: [
            PaymentTypeIconWidget(
                icon: Icons.pix,
                title: 'Pix',
                onTap: (paymentTitle) {
                  showPaymentBottomSheet(context, paymentTitle);
                }),
            PaymentTypeIconWidget(
                icon: Icons.credit_card,
                title: 'Cartão de Crédito',
                onTap: (paymentTitle) {
                  showPaymentBottomSheet(context, paymentTitle);
                }),
            PaymentTypeIconWidget(
                icon: Icons.currency_bitcoin,
                title: 'Bitcoin',
                onTap: (paymentTitle) {
                  showPaymentBottomSheet(context, paymentTitle);
                }),
            PaymentTypeIconWidget(
                icon: Icons.text_snippet_outlined,
                title: 'Boleto',
                onTap: (paymentTitle) {
                  showPaymentBottomSheet(context, paymentTitle);
                }),
          ],
        ),
      ),
    );
  }
}

void showPaymentBottomSheet(
  BuildContext context,
  String paymentType,
) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isDismissible: true,
    elevation: 10,
    isScrollControlled: true,
    scrollControlDisabledMaxHeightRatio: 2700,
    showDragHandle: true,
    enableDrag: true,
    builder: (context) {
      return  PaymentPage(
        paymentType: paymentType,
      );
    },
  );
}
