import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/module/home_module/widgets/card_payment_methods.dart';

import 'package:uber_clone_driver/app/module/profile_module/profile_controller.dart';
import 'package:uber_clone_driver/app/module/profile_module/widgets/Info_user_widget.dart';
import 'package:uber_clone_driver/app/module/profile_module/widgets/card_balance_widget.dart';
import 'package:uber_clone_driver/app/module/profile_module/widgets/card_trips.dart';
import 'package:uber_clone_driver/app/module/profile_module/widgets/profile_image_widget.dart';

class ProfilePage extends StatefulWidget {
  final ProfileController profileController;
  const ProfilePage({super.key, required this.profileController});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with DialogLoader {
  final reactionsDisposer = <ReactionDisposer>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       await widget.profileController.findData();
      _initReaction();
      
    });
  }
  @override
  void dispose() {
    for (var rection in reactionsDisposer) {
        rection();
    }
    super.dispose();
  }

  
  Future<void> _initReaction() async {
     final ProfileController(:loading,:usuario,:errorMessage) = widget.profileController;
    final loadingReaction = autorun( (_){
      if (loading) {
          showLoaderDialog();
          return;
      }
      hideLoader();
    });

    final userReaction =
        reaction<Usuario?>((_) => usuario, (user) {

    });

    

    final errorReaction = reaction<String?>(
        (_) => errorMessage, (error) {
      if (error != null) {
        callSnackBar(error);
      }
    });
    
    reactionsDisposer.addAll([userReaction, errorReaction,loadingReaction]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            pinned: true,
            collapsedHeight: 250,
            expandedHeight: 250.0,
            toolbarHeight: 80.0,
            floating: false,
            leading: IconButton.filled(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.black.withAlpha(130))),
              splashRadius: 20,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
            ),
            actions: [
              IconButton.filled(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.black.withAlpha(130))),
                splashRadius: 20,
                onPressed: () {
                  dialogPerfilEdit(context);
                },
                icon: const Icon(Icons.edit),
                color: Colors.white,
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 50),
              title: Observer(builder: (_) {
                return InfoUserWidget(
                  driverName:
                      widget.profileController.usuario?.nome ?? 'UserName',
                  tripFinalized: 3,
                  boxTitle: [
                    {
                      'Corridas ${widget.profileController.requests?.length}':
                          false
                    },
                    const {'1.0': true}
                  ],
                );
              }),
              background: SizedBox(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 50),
                      color: Colors.transparent.withAlpha(0),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1502877338535-766e1452684a?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned(
                        right: 10,
                        bottom: 1,
                        child: SizedBox(
                            height: 80,
                            width: 105,
                            child: ProfileImageWidget(
                              urlImage:
                                  "https://images.unsplash.com/photo-1504593811423-6dd665756598?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            )))
                  ],
                ),
              ),
            ),
          ),
          CardBalanceWidget(
              addMoney: () {
                //widget.profileController.createIntentPayment(100.0);
                Stripe.instance.presentPaymentSheet();
                showPaymentBottomSheet(context, "Adicionar dinheiro");
              },
              balance:
                  widget.profileController.usuario?.balance.toDouble() ?? 0.0),
          const CardPaymentMethods(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Viagems Realizadas",
                style: context.textTheme().labelLarge,
              ),
            ),
          ),
          Observer(builder: (context) {
            return Visibility(
              visible: widget.profileController.requests != null &&
                  widget.profileController.requests!.isNotEmpty,
              replacement: const SliverFillRemaining(
                child: Center(
                  child: Text("Nenhuma Viagem realizadda"),
                ),
              ),
              child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: widget.profileController.requests?.length,
                (context, index) {
                  final Requisicao(:destino, :valorCorrida, :requestDate) =
                      widget.profileController.requests![index];
                  return CardTrips(
                      tripNameLocal: destino.bairro,
                      date: requestDate.uberFormatDate('pt_BR'),
                      price: valorCorrida);
                },
              )),
            );
          })
        ],
      ),
    ));
  }

  Future<dynamic> dialogPerfilEdit(BuildContext context) {
    return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Altere dados do perfil",
                        textAlign: TextAlign.center,
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Altere a imagem de fundo"),
                            SizedBox(
                                height: context.heightPercent(0.17),
                                width: context.widthPercent(0.9),
                                child: Image.asset(
                                  UberCloneConstants.ASSEESTS_IMAGE_LOGO,
                                  fit: BoxFit.cover,
                                )),
                            const Text("Altere a imagem do perfil"),
                            SizedBox(
                              height: context.heightPercent(0.17),
                              width: context.widthPercent(0.9),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    UberCloneConstants.ASSEESTS_IMAGE_LOGO),
                              ),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  label: Text('Nome'), hintText: "Nome.."),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {}, child: const Text("Cancelar")),
                        TextButton(
                            onPressed: () {}, child: const Text("Salvar"))
                      ],
                    );
                  },
                );
  }
   
   
}
