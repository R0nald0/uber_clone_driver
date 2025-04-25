
  import 'package:flutter/material.dart';


class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
     bottom: 0.0,
     left: 25,
     child: Stack(
       children: [
         const Padding(
           padding: EdgeInsets.only(bottom: 15,right: 15),
           child: CircleAvatar(
             radius: 50,
             backgroundImage: NetworkImage(
               "https://images.unsplash.com/photo-1504593811423-6dd665756598?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
             ),
             
           ),
         ),
         Positioned(
           right: 0.0,
           bottom: 0.0,
           child: IconButton(
           onPressed: () {},
           icon:  const Icon(
             Icons.add,
             size: 40,
             color: Color.fromARGB(255, 61, 17, 17),
           ),),
         )
       ],
     ),
                    );
  }
}
