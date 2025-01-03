

part of '../home_page.dart';

typedef OnTap = void Function();  
class CardTripItem extends StatelessWidget {
  final Requisicao requisicao;
  final OnTap? onTap;


  const CardTripItem({ super.key , required this.requisicao,required this.onTap });
  
  @override
  Widget build(BuildContext context) {
    return  Card(
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
                        onTap: onTap,
                      ),
                    );
}
}