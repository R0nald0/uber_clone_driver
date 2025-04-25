import 'package:flutter/material.dart';

class InfoUserWidget extends StatelessWidget {
  const InfoUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
       padding: const EdgeInsets.all(16),
        width: width * 0.6,
        height: height * 0.156,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Tuth Motorista",
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
             style: theme.textTheme.headlineMedium?.copyWith(
                   color: Colors.white,
             ), 
            ),
             Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric( horizontal: 14,vertical: 6),
                  decoration:  BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(124, 207, 209, 209)
                  ),
                  child: Text('Motorista',
                   style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white
                   ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric( horizontal: 14,vertical: 6),
                  decoration:  BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(124, 207, 209, 209)
                  ),
                  child: Text('Motorista',
                   style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white
                   ),
                  ),
                ),
              ],
            ),
            RichText(
                text: TextSpan(
                    style: theme.textTheme.labelLarge?.copyWith(
                      color:Colors.white
                    ),
                    text: 'Corridas Realizadas ',
                    children: [
                  TextSpan(
                      text: '12',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ))
                ])),
          ],
        ),
      ),
    );
  }
}
