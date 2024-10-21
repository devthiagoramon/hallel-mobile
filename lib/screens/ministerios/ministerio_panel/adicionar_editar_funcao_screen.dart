import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hallel/components/general/form_field_h.dart';
import 'package:hallel/components/general/text_form_field_h.dart';
import 'package:hallel/model/dtos/funcao_ministerio_dto.dart';
import 'package:hallel/model/funcao_ministerio.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:hallel/services/user_service/funcao_ministerio_service.dart';
import 'package:hallel/store/provider.dart';

class AdicionarEditarFuncaoScreen extends ConsumerStatefulWidget {
  const AdicionarEditarFuncaoScreen({super.key});

  @override
  ConsumerState<AdicionarEditarFuncaoScreen> createState() =>
      _AdicionarEditarFuncaoScreenState();
}

class _AdicionarEditarFuncaoScreenState
    extends ConsumerState<AdicionarEditarFuncaoScreen> {
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            ref.read(adicionarEditarFuncaoProvider).id.isEmpty
                ? "Adicionar função"
                : "Editar função",
            style: titleStyle,
          ),
          leading: IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: Icon(
                Icons.chevron_left,
                size: 32,
              )),
          toolbarHeight: 75,
          shape: BorderDirectional(
              bottom: BorderSide(color: Colors.black, width: 1))),
      body: SafeArea(child: AdicionarEditarFuncaoContainer()),
    );
  }
}

class AdicionarEditarFuncaoContainer extends ConsumerStatefulWidget {
  const AdicionarEditarFuncaoContainer({super.key});

  @override
  ConsumerState<AdicionarEditarFuncaoContainer> createState() =>
      _AdicionarEditarFuncaoContainerState();
}

class _AdicionarEditarFuncaoContainerState
    extends ConsumerState<AdicionarEditarFuncaoContainer> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  Color _colorFunction = Colors.grey;
  TextEditingController _iconController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FuncaoMinisterio funcaoMinisterio = ref.read(adicionarEditarFuncaoProvider);

    if (funcaoMinisterio.id.isNotEmpty) {
      setState(() {
        _nameController = TextEditingController(text: funcaoMinisterio.nome);
        _descricaoController =
            TextEditingController(text: funcaoMinisterio.descricao);
        _iconController = TextEditingController(text: funcaoMinisterio.icone);
        _colorFunction = hexToColor(funcaoMinisterio.cor ?? "");
      });
    }
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  String colorToHex(Color color) {
    // Converte o valor ARGB para hexadecimal
    String hex = color.value
        .toRadixString(16)
        .toUpperCase(); // Converte para string hexadecimal
    if (hex.length == 8) {
      return '#$hex'; // Retorna no formato #AARRGGBB
    } else {
      return '#FF$hex'; // Adiciona FF como alpha se o comprimento for 6
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _descricaoController.dispose();
    _iconController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onButtonPressed() async {
    FuncaoMinisterio funcaoSelected = ref.read(adicionarEditarFuncaoProvider);
    if (funcaoSelected.id.isEmpty) {
      setState(() {
        _isLoading = true;
      });
      FuncaoMinisterioDto dto = FuncaoMinisterioDto(
        ministerioId: ref.read(ministerioPanelProvider).id ?? "",
        nome: _nameController.text,
        descricao: _descricaoController.text,
        cor: colorToHex(_colorFunction),
        icone: _iconController.text,
      );
      bool funcaoMinisterioCreated =
          await FuncaoMinisterioServiceAPI().createFuncao(dto);
      if (funcaoMinisterioCreated) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Função criada com sucesso!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
        if (!mounted) return;
        GoRouter.of(context).pop();
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    var styleButton = FilledButton.styleFrom(
        backgroundColor: Colors.green[300], minimumSize: Size(300, 46));
    return Column(
      children: [
        _isLoading || DioClient.isLoading()
            ? LinearProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.white,
              )
            : SizedBox(),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormFieldH(
                        label: "Nome",
                        child: TextFormFieldH(
                            controller: _nameController,
                            hint: "Digite um nome...",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite o nome da função!";
                              }
                              return null;
                            })),
                    SizedBox(
                      height: 16,
                    ),
                    FormFieldH(
                        label: "Descrição",
                        child: TextFormFieldH(
                            controller: _descricaoController,
                            hint: "Digite uma descrição...",
                            minLines: 2,
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite uma descrição para a função!";
                              }
                              return null;
                            })),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FormFieldH(
                            label: "Cor da função",
                            child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Selecione uma cor!"),
                                          content: BlockPicker(
                                              pickerColor: _colorFunction,
                                              onColorChanged: (Color color) {
                                                setState(() {
                                                  _colorFunction = color;
                                                });
                                              }),
                                        );
                                      });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: _colorFunction,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ))),
                        SizedBox(
                          width: 24,
                        ),
                        FormFieldH(
                            label: "Icone da função",
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showEmojiPicker = true;
                                  });
                                },
                                child: Text(
                                  _iconController.text.isNotEmpty
                                      ? _iconController.text
                                      : "Aperte para selecionar!",
                                  style: TextStyle(
                                      fontSize: _iconController.text.isNotEmpty
                                          ? 32
                                          : 16),
                                ))),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: FilledButton(
                          style: styleButton,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              onButtonPressed();
                            }
                          },
                          child: Text(
                            "Adicionar",
                            style: TextStyle(fontSize: 18),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Offstage(
          offstage: !_showEmojiPicker,
          child: EmojiPicker(
            textEditingController: _iconController,
            scrollController: _scrollController,
            config: Config(
              height: 256,
              checkPlatformCompatibility: true,
              viewOrderConfig: ViewOrderConfig(),
              emojiViewConfig: EmojiViewConfig(
                  emojiSizeMax: 28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.2
                          : 1.0)),
              skinToneConfig: const SkinToneConfig(),
              categoryViewConfig: const CategoryViewConfig(),
              bottomActionBarConfig: const BottomActionBarConfig(),
            ),
            onEmojiSelected: (category, emoji) {
              setState(() {
                _iconController.text = emoji.emoji;
                _showEmojiPicker = false;
              });
            },
            onBackspacePressed: () {
              setState(() {
                _showEmojiPicker = false;
              });
            },
          ),
        )
      ],
    );
  }
}
