import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdicionarMembroMinisterioScreen extends StatelessWidget {
  const AdicionarMembroMinisterioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Adicionar membros ao ministerio",
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
      body: SafeArea(child: AdicionarMembroMinisterioContainer()),
    );
  }
}

class AdicionarMembroMinisterioContainer extends ConsumerStatefulWidget {
  const AdicionarMembroMinisterioContainer({
    super.key,
  });

  @override
  ConsumerState<AdicionarMembroMinisterioContainer> createState() =>
      _AdicionarMembroMinisterioContainerState();
}

class _AdicionarMembroMinisterioContainerState
    extends ConsumerState<AdicionarMembroMinisterioContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: ListView());
  }
}
