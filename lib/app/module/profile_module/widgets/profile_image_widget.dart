
  import 'package:flutter/material.dart';


class ProfileImageWidget extends StatelessWidget {
  final String urlImage ;

  const ProfileImageWidget({
    super.key,required this.urlImage
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        return Material(
          elevation: 10,
          color: Colors.transparent,
          type: MaterialType.circle,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width:70,
            height: constraints.maxHeight *.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                width: 3
              ),
              image:  DecorationImage(
                image: NetworkImage(urlImage,
                scale: 2,
                ),)
            ),
            
          ),
        );
      }
    );
  }
}
