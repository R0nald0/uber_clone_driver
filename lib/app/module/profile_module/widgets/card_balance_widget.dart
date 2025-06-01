import 'package:flutter/material.dart';
import 'package:uber_clone_driver/app/helper/extensions.dart';

class CardBalanceWidget extends StatelessWidget {
  final double balance; 
  final ValueNotifier<bool> _isExpandedBalanceCard = ValueNotifier(true);
  final ValueNotifier<bool> _showContentVN = ValueNotifier(true);
   

  CardBalanceWidget({super.key, required this.balance});

  String  money() => balance == 0 ? balance.toStringAsFixed(2) :balance.toFixed();
  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<bool>(
            valueListenable: _isExpandedBalanceCard,
            builder: (_, isExpandedBalanceCardVN, __) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: isExpandedBalanceCardVN ? context.heightPercent(0.19) : 80,
                curve: Curves.decelerate,
                onEnd: () async {
                   if (isExpandedBalanceCardVN) {
                    _showContentVN.value = true;
                  }
                },
                child: Card(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Saldo",
                              style: context.textTheme().bodyLarge?.copyWith(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            IconButton(
                              onPressed: ()async {
                                _showContentVN.value = false;
                                _isExpandedBalanceCard.value =
                                    !isExpandedBalanceCardVN;
                              },
                              icon: Icon(isExpandedBalanceCardVN
                                  ? Icons.keyboard_arrow_down_sharp
                                  : Icons.keyboard_arrow_up_sharp),
                              color: Colors.white,
                            )
                          ],
                        ),
                        ValueListenableBuilder(
                            valueListenable: _showContentVN,
                            builder: (__, value, _) {
                              return AnimatedAlign(
                                alignment: value ? Alignment.centerLeft : Alignment.centerRight,
                                widthFactor: 100,
                                curve: Curves.elasticOut,
                                duration: const Duration(seconds: 2),
                                child:Offstage(
                                  offstage: !value,
                                  child: Text(
                                    "R\$ ${money()}",
                                    style: context
                                        .textTheme()
                                        .displaySmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                  ),
                                  
                                ) ,
                                
                                 
                              );
                            })
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
