import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hallel/model/ministerio_model.dart';
import 'package:hallel/model/status_membro_ministerio.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:hallel/services/user_service/membro_ministerio_service.dart';
import 'package:hallel/services/user_service/ministerio_service.dart';
import 'package:hallel/store/provider.dart';
import 'package:hallel/utils/utils.dart';

class MinisterioMainScreen extends ConsumerStatefulWidget {
  const MinisterioMainScreen({super.key});

  @override
  ConsumerState<MinisterioMainScreen> createState() =>
      _MinisterioMainScreenState();
}

class _MinisterioMainScreenState extends ConsumerState<MinisterioMainScreen> {
  List<Ministerio> _ministerios = [];

  Future<void> ministeriosThatMembroParticipate() async {
    try {
      List<Ministerio> ministeriosResponse = await MembroMinisterioServiceAPI()
          .listMinisterioThatMembroParticipate(ref.read(userProvider).id);
      setState(() {
        _ministerios = ministeriosResponse;
      });
    } catch (e) {
      log(e.toString(), name: "MinisterioMainScreen");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ministeriosThatMembroParticipate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "MINISTERIOS",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          toolbarHeight: 75,
          shape: BorderDirectional(
              bottom: BorderSide(color: Colors.black, width: 1))),
      body: MinisterioMainContainer(),
      floatingActionButton: _ministerios.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return ModalMinisterioMembroContainer(
                        ministerios: _ministerios,
                      );
                    });
              },
              backgroundColor: Colors.blue,
              shape: CircleBorder(),
              child: Icon(
                Icons.group,
                color: Colors.white,
              ),
            )
          : SizedBox(),
    );
  }
}

class ModalMinisterioMembroContainer extends StatelessWidget {
  final List<Ministerio> ministerios;

  const ModalMinisterioMembroContainer({super.key, required this.ministerios});
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.bold);

    return SizedBox(
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ministerios.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Participação nos ministérios",
                    textAlign: TextAlign.left,
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ministerios.length,
                      itemBuilder: (context, index) {
                        return CardMinisterioMembro(
                          ministerio: ministerios[index],
                        );
                      },
                    ),
                  )
                ],
              )
            : SizedBox(
                width: 10,
                height: 10,
              ),
      ),
    );
  }
}

class CardMinisterioMembro extends ConsumerStatefulWidget {
  final Ministerio ministerio;
  const CardMinisterioMembro({super.key, required this.ministerio});

  @override
  ConsumerState<CardMinisterioMembro> createState() =>
      _CardMinisterioMembroState();
}

class _CardMinisterioMembroState extends ConsumerState<CardMinisterioMembro> {
  StatusMembroMinisterio? _statusMembro;
  bool loading = true;

  Future<void> listStatusMembroInMinisterio() async {
    try {
      StatusMembroMinisterio? statusMembro = await MembroMinisterioServiceAPI()
          .listStatusMembroMinisterioInMinisterio(
              widget.ministerio.id ?? "", ref.read(userProvider).id);
      setState(() {
        _statusMembro = statusMembro;
        loading = false;
      });
    } catch (e) {
      log(e.toString(), name: "MinisterioMainScreen");
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listStatusMembroInMinisterio();
  }

  String getStatusMembroText() {
    switch (_statusMembro) {
      case StatusMembroMinisterio.membro:
        return "Membro";
      case StatusMembroMinisterio.coordenador:
        return "Coordenador";
      case StatusMembroMinisterio.viceCoordenador:
        return "Vice-coordenador";
      default:
        return "Error";
    }
  }

  Future<void> tokenCoordenador(String ministerioId) async {
    try {
      String membroId = ref.read(userProvider).id;
      String? token = await MembroMinisterioServiceAPI()
          .getTokenCoordenador(ministerioId, membroId);
      if (token != null) {
        DioClient.setTokenCoordenador(token);
      }
    } catch (e) {
      log(e.toString(), name: "MinisterioMainScreen");
    }
  }

  Future<void> selectMinisterio() async {
    ref
        .read(ministerioPanelProvider.notifier)
        .selectMinisterio(widget.ministerio);
    await tokenCoordenador(widget.ministerio.id ?? "");
    if (!mounted) return;
    context.go(Uri(
        path: "/ministerio/panel",
        queryParameters: {'id': widget.ministerio.id}).toString());
  }

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);

    final statusMinisterioTextStyle = TextStyle(
        fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white);
    return Card(
      color: Colors.green[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.ministerio.nome}",
                    style: nameStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      loading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              getStatusMembroText(),
                              style: statusMinisterioTextStyle,
                            )
                    ],
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: selectMinisterio,
                icon: Icon(
                  Icons.chevron_right,
                  size: 32,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}

class MinisterioMainContainer extends StatefulWidget {
  const MinisterioMainContainer({super.key});

  @override
  State<MinisterioMainContainer> createState() =>
      _MinisterioMainContainerState();
}

class _MinisterioMainContainerState extends State<MinisterioMainContainer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BannerMinisterio(),
          SizedBox(height: 24),
          CardsMinisterioComunidade()
        ],
      ),
    );
  }
}

class CardsMinisterioComunidade extends ConsumerStatefulWidget {
  const CardsMinisterioComunidade({super.key});

  @override
  ConsumerState<CardsMinisterioComunidade> createState() =>
      _CardsMinisterioComunidadeState();
}

class _CardsMinisterioComunidadeState
    extends ConsumerState<CardsMinisterioComunidade> {
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;
  int _currentPage = 0;
  bool _loading = true;

  List<Ministerio> _ministerios = [
    Ministerio(
        id: "",
        nome: "",
        coordenadorId: "",
        viceCoordenadorId: "",
        descricao: "",
        imagem: "",
        objetivos: [""]),
    Ministerio(
        id: "",
        nome: "",
        coordenadorId: "",
        viceCoordenadorId: "",
        descricao: "",
        imagem: "",
        objetivos: [""])
  ];

  Future<void> getMinisteriosFromAPI() async {
    try {
      Response<List<dynamic>> response =
          await DioClient().get("/public/ministerio");
      if (mounted) {
        setState(() {
          _ministerios = response.data!
              .map((item) => Ministerio.convertToObjectByJson(item))
              .toList();
          setState(() {
            _loading = false;
          });
        });
      }
    } catch (e) {
      log(e.toString(), name: "MinisterioMainScreen");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMinisteriosFromAPI();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _ministerios.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(_currentPage,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 460,
        child: PageView.builder(
            controller: _pageController,
            itemCount: _ministerios.length,
            itemBuilder: (context, index) {
              return Card(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        _ministerios[index].nome ?? "",
                        style: nameStyle,
                        textAlign: TextAlign.left,
                        textWidthBasis: TextWidthBasis.parent,
                      ),
                    ),
                  ),
                  Divider(),
                  _ministerios[index].imagem != null &&
                          _ministerios[index].imagem!.isNotEmpty
                      ? Image.memory(
                          AppUtils().getImageByBase64(
                              _ministerios[index].imagem ?? ""),
                          height: 240,
                        )
                      : Image.asset(
                          "assets/images/foto_do_ministerio_hallel.png",
                          height: 240,
                        ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FilledButton(
                        onPressed: () async {
                          Ministerio ministerioWithDetails =
                              await MinisterioService()
                                  .listMinisterioWithDetails(
                                      _ministerios[index].id ?? "");
                          ref
                              .read(ministerioDetalheProvider.notifier)
                              .selectMinisterio(ministerioWithDetails);
                          GoRouter.of(context).push("/ministerio/detail");
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 6, 97, 46)),
                        child: Text(
                          "SABER MAIS",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ));
            }),
      ),
    );
  }
}

class BannerMinisterio extends StatelessWidget {
  const BannerMinisterio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/banner_ministerios_hallel_mobile.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
      height: 75,
    );
  }
}
