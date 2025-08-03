import 'package:flutter/material.dart';

class PaymentTypeIconWidget extends StatelessWidget {
  final String title;
  final IconData icon; 
  final ValueChanged<String> onTap;

  const PaymentTypeIconWidget({super.key,required this.title,required this.icon,required this.onTap});

  @override
  Widget build(BuildContext context) {
    
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTap(title),
        child: Material(
          animationDuration: const Duration(seconds: 1),
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              Icon(icon),
              FittedBox(
                fit: BoxFit.cover,
                child: Text(title,style: const TextStyle(
                  fontWeight: FontWeight.w500
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}