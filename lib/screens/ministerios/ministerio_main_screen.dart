import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hallel/model/ministerio_model.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:hallel/utils/utils.dart';

class MinisterioMainScreen extends StatelessWidget {
  const MinisterioMainScreen({super.key});

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

class CardsMinisterioComunidade extends StatefulWidget {
  const CardsMinisterioComunidade({super.key});

  @override
  State<CardsMinisterioComunidade> createState() =>
      _CardsMinisterioComunidadeState();
}

class _CardsMinisterioComunidadeState extends State<CardsMinisterioComunidade> {
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
        height: 450,
        child: PageView.builder(
            controller: _pageController,
            itemCount: _ministerios.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Card(
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
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FilledButton(
                          onPressed: () {},
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
                )),
              );
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
