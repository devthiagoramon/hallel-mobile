import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hallel/components/general/shimmer_container.dart';
import 'package:hallel/model/eventos_model.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Seja bem-vindo à nossa Comunidade Católica Hallel!",
              style: titleStyle,
            ),
            GapHomePage(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/images/home_page_photo.svg',
                  width: 270,
                  height: 169,
                )
              ],
            ),
            GapHomePage(
              height: 48,
            ),
            ButtonsRedirectHomePage(),
            GapHomePage(height: 24),
            EventosHomepageContainer(),
          ],
        ),
      ),
    );
  }
}

class ButtonsRedirectHomePage extends StatelessWidget {
  const ButtonsRedirectHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonRedirectHomePage(
                text: "Horarios",
                icon: Icon(
                  Icons.schedule,
                  size: 32,
                ),
                route: "/home/horarios",
                bgColor: Colors.blue),
          ],
        ),
        GapHomePage(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonRedirectHomePage(
                text: "Fundadora",
                icon: Icon(
                  Icons.portrait,
                  size: 32,
                ),
                route: "/home/fundadora",
                bgColor: Color.fromRGBO(6, 97, 46, 1))
          ],
        )
      ],
    );
  }
}

class GapHomePage extends StatelessWidget {
  final double height;
  const GapHomePage({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class ButtonRedirectHomePage extends StatelessWidget {
  final String text;
  final Icon icon;
  final String route;
  final Color bgColor;
  const ButtonRedirectHomePage(
      {super.key,
      required this.text,
      required this.icon,
      required this.route,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);

    return FilledButton.icon(
      label: Text(
        text.toUpperCase(),
        style: textStyle,
      ),
      onPressed: () => context.go(route),
      icon: icon,
      style: FilledButton.styleFrom(
          backgroundColor: bgColor,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              side: BorderSide.none)),
    );
  }
}

class EventosHomepageContainer extends StatelessWidget {
  const EventosHomepageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Eventos",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        GapHomePage(height: 16),
        EventosCardHomePage()
      ],
    );
  }
}

class EventosCardHomePage extends StatefulWidget {
  const EventosCardHomePage({super.key});

  @override
  State<EventosCardHomePage> createState() => _EventosCardHomePageState();
}

class _EventosCardHomePageState extends State<EventosCardHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  List<EventosListHomePageDTO> _eventos = [];
  bool isLoading = true;

  Future<void> getEventosFromAPI() async {
    try {
      Response<List<dynamic>> response =
          await DioClient().get("/public/home/eventos/listar");
      if (mounted) {
        setState(() {
          _eventos = response.data!
              .map((item) => EventosListHomePageDTO.fromJson(item))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      log(e.toString(), name: "HomeScreen");
      isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      getEventosFromAPI();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
    final dateStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

    return SizedBox(
      height: 375,
      child: isLoading
          ? LoadingComponent(
              child: SizedBox(
              height: 375,
              width: MediaQuery.of(context).size.width,
            ))
          : PageView.builder(
              controller: _pageController,
              itemCount: _eventos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      _eventos[index].image != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                              child: Image.memory(
                                base64Decode(
                                    _eventos[index].image.split(',').last),
                                fit: BoxFit.cover,
                                height: 230,
                              ),
                            )
                          : SizedBox(
                              height: 230,
                            ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(_eventos[index].titulo,
                                      style: nameStyle,
                                      softWrap: true,
                                      maxLines: 2,
                                      textWidthBasis: TextWidthBasis.parent,
                                      overflow: TextOverflow.ellipsis),
                                  GapHomePage(height: 16),
                                  Text(
                                    "Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_eventos[index].date))}",
                                    style: dateStyle,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.chevron_right,
                                        size: 32,
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
    );
  }
}
