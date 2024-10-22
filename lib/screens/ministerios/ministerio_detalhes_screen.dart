import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hallel/model/ministerio_model.dart';
import 'package:hallel/store/provider.dart';
import 'package:hallel/utils/utils.dart';

class MinisterioDetalhesScreen extends ConsumerStatefulWidget {
  const MinisterioDetalhesScreen({super.key});

  @override
  ConsumerState<MinisterioDetalhesScreen> createState() =>
      _MinisterioDetalhesScreenState();
}

class _MinisterioDetalhesScreenState
    extends ConsumerState<MinisterioDetalhesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            ref.read(ministerioDetalheProvider).nome ?? "",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                ref.read(ministerioDetalheProvider.notifier).resetMinisterio();
                GoRouter.of(context).pop();
              },
              icon: Icon(
                Icons.chevron_left,
                size: 32,
              )),
          toolbarHeight: 75,
          shape: BorderDirectional(
              bottom: BorderSide(color: Colors.black, width: 1))),
      body: SafeArea(child: MinisterioDetalheContainer()),
    );
  }
}

class MinisterioDetalheContainer extends ConsumerWidget {
  const MinisterioDetalheContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Ministerio ministerio = ref.read(ministerioDetalheProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageMinisterioComponent(ministerio: ministerio),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  ministerio.descricao ?? "Nenhuma descrição...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                Divider(
                  height: 32,
                ),
                Text(
                  "Objetivos",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                ministerio.objetivos != null
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: ministerio.objetivos!.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Text(
                                  "• ",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  ministerio.objetivos![index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : SizedBox(),
                Divider(
                  height: 32,
                ),
                Text(
                  "Coordenador",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: ministerio.coordenador!.image.isNotEmpty
                          ? MemoryImage(AppUtils()
                              .getImageByBase64(ministerio.coordenador!.image))
                          : null,
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          ministerio.coordenador!.nome,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          ministerio.coordenador!.email,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Vice-Coordenador",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          ministerio.viceCoordenador!.image.isNotEmpty
                              ? MemoryImage(AppUtils().getImageByBase64(
                                  ministerio.viceCoordenador!.image))
                              : null,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          ministerio.viceCoordenador!.nome,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          ministerio.viceCoordenador!.email,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ImageMinisterioComponent extends StatelessWidget {
  const ImageMinisterioComponent({
    super.key,
    required this.ministerio,
  });

  final Ministerio ministerio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ministerio.imagem != null && ministerio.imagem!.isNotEmpty
          ? Center(
              child: Image.memory(
                AppUtils().getImageByBase64(ministerio.imagem ?? ""),
                height: 280,
                fit: BoxFit.cover,
              ),
            )
          : Image.asset(
              "assets/images/foto_do_ministerio_hallel.png",
              height: 280,
            ),
    );
  }
}
