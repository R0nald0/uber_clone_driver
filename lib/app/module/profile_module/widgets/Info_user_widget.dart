import 'package:flutter/material.dart';


class InfoUserWidget extends StatelessWidget {
  final String driverName;
  final int tripFinalized;
  final List< Map<String,bool>> boxTitle;
  const InfoUserWidget({super.key,required this.driverName,required this.tripFinalized,required this.boxTitle});


  @override
  Widget build(BuildContext context) {
  
    final height = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
         return  Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding:const EdgeInsets.only(left: 20),
          height: height * 0.13,
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(80), borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft:Radius.circular(8),
              )),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(driverName,
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
               style: theme.textTheme.bodyLarge?.copyWith(
                     color: Colors.white,
                     fontSize: 20
               ), 
              ),
               Row(
                spacing: 10,
                children: boxTitle.map((e) => ContainerText(
                  boxTitle:e.keys.first , theme: theme,
                  showIcon:e.values.first ,
                  )
                  ).toList(),
              ),
             /*   RichText(
                  text: TextSpan(
                      style: theme.textTheme.labelLarge?.copyWith(
                        color:Colors.white
                      ),
                      text: 'Corridas Realizadas $tripFinalized',
                      children: [
                    TextSpan(
                        text: '12',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white
                        ))
                  ])),  */
            ],
          ),
        ),
      );
      },
   
    );
  }
}

class ContainerText extends StatelessWidget {
  final String boxTitle;
  final bool showIcon ;

  const ContainerText(
    {
    super.key,
    required this.boxTitle,
    required this.theme,
    required this.showIcon
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context,) {
    return Container(
      height:40,
      width: 130,
      padding: const EdgeInsets.symmetric( horizontal: 10,vertical: 6),
      decoration:  BoxDecoration(
         borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(124, 207, 209, 209)
      ),
      child: Row(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(boxTitle,
             overflow: TextOverflow.ellipsis,
             style: theme.textTheme.labelLarge?.copyWith(
             color: Colors.white,
             fontSize: 16
           ),
          ),
           Offstage(
            offstage: !showIcon,
            child: const Icon(Icons.star,size: 18,))
        ],
      ),
    );
  }
}
