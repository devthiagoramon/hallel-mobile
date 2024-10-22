import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hallel/components/general/popup_menu_h.dart';
import 'package:hallel/model/funcao_ministerio.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:hallel/services/user_service/funcao_ministerio_service.dart';
import 'package:hallel/store/provider.dart';
import 'package:hallel/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class MinisterioPanelScreen extends ConsumerWidget {
  final String id;
  const MinisterioPanelScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "${ref.read(ministerioPanelProvider).nome}",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                DioClient.setTokenCoordenador("");
                GoRouter.of(context).go("/ministerio");
              },
              icon: Icon(
                Icons.chevron_left,
                size: 32,
              )),
          toolbarHeight: 75,
          shape: BorderDirectional(
              bottom: BorderSide(color: Colors.black, width: 1))),
      body: MinisterioPanelContainer(),
    );
  }
}

class MinisterioPanelContainer extends ConsumerStatefulWidget {
  const MinisterioPanelContainer({super.key});

  @override
  ConsumerState<MinisterioPanelContainer> createState() =>
      _MinisterioPanelContainerState();
}

class _MinisterioPanelContainerState
    extends ConsumerState<MinisterioPanelContainer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            EscalasCalendarContainer(),
            Divider(
              height: 24,
            ),
            MembrosMinisterioContainer(),
            Divider(
              height: 24,
            ),
            FuncoesMinisterioContainer()
          ],
        ),
      ),
    );
  }
}

class FuncoesMinisterioContainer extends ConsumerStatefulWidget {
  const FuncoesMinisterioContainer({super.key});

  @override
  ConsumerState<FuncoesMinisterioContainer> createState() =>
      _FuncoesMinisterioContainerState();
}

class _FuncoesMinisterioContainerState
    extends ConsumerState<FuncoesMinisterioContainer> {
  String? filterValue = "Nome";
  List<FuncaoMinisterio> funcoesMinisterio = [];
  bool _isLoading = true;

  Future<void> listFuncoesMinisterio() async {
    try {
      String ministerioId = ref.read(ministerioPanelProvider).id ?? "";
      List<FuncaoMinisterio> funcoesMinisteriosResponse =
          await FuncaoMinisterioServiceAPI()
              .listFuncaoMinisterioAPI(ministerioId);
      setState(() {
        funcoesMinisterio = funcoesMinisteriosResponse;
        _isLoading = false;
      });
    } catch (e) {
      log(e.toString(), name: "MinisterioPanelScreen");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listFuncoesMinisterio();
  }

  @override
  void didUpdateWidget(covariant FuncoesMinisterioContainer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    listFuncoesMinisterio();
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Future<void> deleteFuncao(String funcaoMinisterioId) async {
    try {
      bool response =
          await FuncaoMinisterioServiceAPI().deleteFuncao(funcaoMinisterioId);
      if (response) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Função excluida com sucesso!"),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ));
        List<FuncaoMinisterio> listaUpdated = funcoesMinisterio
            .where((element) => element.id != funcaoMinisterioId)
            .toList();
        setState(() {
          funcoesMinisterio = listaUpdated;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final funcoesMinisterioTextStyle =
        TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Funções",
                style: funcoesMinisterioTextStyle,
              ),
            ),
            PopupMenuH(iconSize: 32, items: [
              PopupMenuHItem(
                  label: "Adicionar função",
                  icon: Icon(
                    Icons.add,
                    color: Colors.green,
                    size: 24,
                  ),
                  onPress: () {
                    GoRouter.of(context).push("/ministerio/funcao/add");
                  })
            ])
          ],
        ),
        _isLoading
            ? LinearProgressIndicator(
                color: Colors.blue,
              )
            : SizedBox(),
        DropdownButton(
            hint: Text("Selecione um valor"),
            borderRadius: BorderRadius.all(Radius.circular(24)),
            elevation: 2,
            value: filterValue,
            items: ["Nome"].map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                filterValue = newValue;
              });
            }),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: funcoesMinisterio.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: hexToColor(funcoesMinisterio[index].cor ?? ""),
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            funcoesMinisterio[index].nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 2),
                          Text(
                            funcoesMinisterio[index].descricao!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuH(icon: Icons.more_horiz, items: [
                      PopupMenuHItem(
                          label: "Editar",
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 24,
                          ),
                          onPress: () {
                            ref
                                .read(adicionarEditarFuncaoProvider.notifier)
                                .selectFuncaoMinisterio(
                                    funcoesMinisterio[index]);
                            GoRouter.of(context)
                                .push("/ministerio/funcao/edit");
                          }),
                      PopupMenuHItem(
                          label: "Excluir",
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPress: () => AppUtils.modalDelete(
                                  context, "Excluir função", () async {
                                deleteFuncao(funcoesMinisterio[index].id);
                              }))
                    ])
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class MembrosMinisterioContainer extends StatefulWidget {
  const MembrosMinisterioContainer({
    super.key,
  });

  @override
  State<MembrosMinisterioContainer> createState() =>
      _MembrosMinisterioContainerState();
}

class _MembrosMinisterioContainerState
    extends State<MembrosMinisterioContainer> {
  String? filterValue = "Nome";

  @override
  Widget build(BuildContext context) {
    final membroMinisterioTextStyle =
        TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Membros do ministério",
          style: membroMinisterioTextStyle,
        ),
        DropdownButton(
            hint: Text("Selecione um valor"),
            borderRadius: BorderRadius.all(Radius.circular(24)),
            elevation: 2,
            value: filterValue,
            items: ["Nome", "Função"].map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                filterValue = newValue;
              });
            })
      ],
    );
  }
}

class EscalasCalendarContainer extends StatelessWidget {
  const EscalasCalendarContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final escalasTextStyle =
        TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Escalas",
          style: escalasTextStyle,
        ),
        SizedBox(
          height: 16,
        ),
        Card(
          color: Colors.grey[100],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2040, 12, 29),
              locale: "pt_BR",
              availableCalendarFormats: Map.from({CalendarFormat.month: ""}),
              calendarFormat: CalendarFormat.month,
            ),
          ),
        )
      ],
    );
  }
}
