import 'package:flutter/material.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/extensions.dart';
    
class CardTrips extends StatelessWidget {
    final String tripNameLocal; 
    final String date; 
    final String price; 


  const CardTrips({ super.key ,required this.tripNameLocal,required this.date,required this.price});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
      child: Card(
        child: Row(
          spacing: 10,
          children: [
            SizedBox(
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('${UberCloneConstants.ASSEESTS_IMAGE}/uber_car.jpg'),
              ),
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(tripNameLocal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme().bodyLarge?.copyWith(
                     fontWeight: FontWeight.bold 
                  ),
                 ),
                 Text(date,
                  style: context.textTheme().labelLarge?.copyWith(
                     fontWeight: FontWeight.w500 
                 ),
                 ),
                 Text("R\$ $price",
                  style: context.textTheme().labelLarge?.copyWith(
                     fontWeight: FontWeight.w700 
                 ),
                 )
                         ],),
             )
          ],
        ),
      ),
    );
  }
}