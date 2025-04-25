import 'package:flutter/material.dart';
import 'package:uber_clone_driver/app/module/profile_module/widgets/Info_user_widget.dart';
import 'package:uber_clone_driver/app/module/profile_module/widgets/profile_image_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 100,
            stretch: false,
            pinned: true,
            expandedHeight: 380.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(fit: StackFit.loose, children: [
                Image.network(
                  "https://images.unsplash.com/photo-1502877338535-766e1452684a?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  fit: BoxFit.cover,
                ),
                const ProfileImageWidget(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, right: 15),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton.filled(
                          highlightColor: Colors.black12,
                          splashColor: Colors.amber,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            size: 30,
                          ))),
                )
                ,InfoUserWidget()
              ]),
            ),
          ),
          const SliverToBoxAdapter(
              child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1504593811423-6dd665756598?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: 20,
            (context, index) {
              return ListTile(
                title: Text("Teste $index"),
              );
            },
          ))
        ],
      ),
    ));
  }
}
