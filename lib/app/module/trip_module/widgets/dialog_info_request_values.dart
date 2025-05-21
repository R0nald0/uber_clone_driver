import 'package:flutter/material.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class DialogInfoRequestValues extends StatelessWidget {
  final Requisicao request;
  final VoidCallback onSuccess;
  final VoidCallback onError;
  const DialogInfoRequestValues({ super.key, required this.request, required this.onSuccess, required this.onError });

   @override
   Widget build(BuildContext context) {
    final theme = Theme.of(context);
       return  Center(
         child: Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.sizeOf(context).height * 0.30,
              width: MediaQuery.sizeOf(context).width *  .80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withAlpha(210)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   Center(
                  child: Text(
                'Viagem Finalizada',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )),
              RichText(
                  text: TextSpan(
                      style: theme.textTheme.labelLarge,
                      text: 'Valor da viagem ',
                      children: [
                    TextSpan(
                        text: ' R\$ ${request.valorCorrida}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ))
                  ])),
                  Row(
                    children: [
                       Expanded(
                         child: TextButton(
                                             onPressed: () {
                         onError();
                                               Navigator.pop(context);
                                             },
                                             child: Text('Tive um problema',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.bold))),
                       ),
                   ElevatedButton(
                    onPressed: onSuccess,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        overlayColor: Colors.white12),
                    child: const Text(
                      'Confirmar pagamento',
                      style: TextStyle(color: Colors.white),
                    ),)
                    ],
                  ),
                  
                ],
              ),
             ),
       );
  }
}