import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/module/auth/controller/authentication_controller.dart';
import 'package:uber_clone_driver/app/module/home_module/home_controller.dart';

class HomePage extends StatefulWidget {
  final AuthenticationController _auth;
  final HomeController _homeController;

  const HomePage(
      {super.key,
      required AuthenticationController auth,
      required HomeController homeController})
      : _auth = auth,
        _homeController = homeController;

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> listItens = ["Configurações", "Deslogar"];
deslogarUsuario() {}
_escolhaItem(String escolha) {
  switch (escolha) {
    case "Configurações":
      break;
    case "Deslogar":
      deslogarUsuario();
      break;
  }
}

class _HomePageState extends State<HomePage> {
  late ReactionDisposer reactionDisposerUser;
  late ReactionDisposer reactionDisposerRequisicao;

  var listRequisicao = <Requisicao>[];


  findAllTrisp() async {
     widget._homeController.findTrips();
  }

  initReactions() async {
    /* reactionDisposerUser =
        reaction<Usuario?>((_) => widget._auth.dataStringUser, (user) {
      if (user != null) {
        print(user.nome);
      } else {
        print('Usuarion esta nulo');
      }
    });

    reactionDisposerRequisicao =
        reaction<List<Requisicao>?>((_) => widget._homeController.requisicoes, (requisicoes) {
      if (requisicoes != null && requisicoes.isNotEmpty) {
         listRequisicao = [...requisicoes];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhuma Viagem ") )
        );
      }
    }); */
  }

  @override
  void initState() {
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(title: const Text('Motorista'), actions: [
        PopupMenuButton<String>(
            onSelected: _escolhaItem,
            itemBuilder: (context) => listItens.map((String item) {
                  return PopupMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList())
      ]),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Observer(builder: (context) {
          return ListView.builder(
              itemCount: listRequisicao.length,
              itemBuilder: (context, index) {
                final requisicao = listRequisicao[index];
                return Card(
                  shadowColor: Colors.black,
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        const Text("Passageiro :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(requisicao.passageiro.nome)
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            const Text("Destino :",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                requisicao.destino.nomeDestino,
                                style: const TextStyle(fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Valor :",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                'R\$${requisicao.valorCorrida}',
                                style: const TextStyle(fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      //controller.teste();
                      Navigator.pushNamed(context, '/corrida');
                    },
                  ),
                );
              });
        }),
      ),
    );
  }
}
