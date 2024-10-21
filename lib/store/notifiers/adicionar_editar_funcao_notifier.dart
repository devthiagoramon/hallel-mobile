import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/model/funcao_ministerio.dart';

class AdicionarEditarFuncaoNotifier extends StateNotifier<FuncaoMinisterio> {
  AdicionarEditarFuncaoNotifier() : super(FuncaoMinisterio.empty());

  void selectFuncaoMinisterio(FuncaoMinisterio funcaoMinisterio) {
    state = funcaoMinisterio;
  }

  void removeFuncaoMinisterio() {
    state = FuncaoMinisterio.empty();
  }
}
