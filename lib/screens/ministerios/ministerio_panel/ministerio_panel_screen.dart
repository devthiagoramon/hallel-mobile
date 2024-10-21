import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:hallel/services/user_service/membro_ministerio_service.dart';
import 'package:hallel/store/provider.dart';
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
  Future<void> tokenCoordenador() async {
    try {
      String ministerioId = ref.read(ministerioPanelProvider).id ?? "";
      String membroId = ref.read(userProvider).id;
      String? token = await MembroMinisterioServiceAPI()
          .getTokenCoordenador(ministerioId, membroId);
      if (token != null) {
        DioClient.setTokenCoordenador(token);
      }
    } catch (e) {
      log(e.toString(), name: "MinisterioPanelScreen");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenCoordenador();
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

class FuncoesMinisterioContainer extends StatefulWidget {
  const FuncoesMinisterioContainer({super.key});

  @override
  State<FuncoesMinisterioContainer> createState() =>
      _FuncoesMinisterioContainerState();
}

class _FuncoesMinisterioContainerState
    extends State<FuncoesMinisterioContainer> {
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
            DropdownButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 32,
                ),
                items: ["Adicionar função"].map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  switch (newValue) {
                    case "Adicionar função":
                      GoRouter.of(context).push("/ministerio/funcao/add");
                      break;
                    default:
                      print("Invalid option!");
                  }
                })
          ],
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
