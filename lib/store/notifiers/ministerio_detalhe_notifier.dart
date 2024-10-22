import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/model/ministerio_model.dart';

class MinisterioDetalheNotifier extends StateNotifier<Ministerio> {
  MinisterioDetalheNotifier() : super(Ministerio.empty());

  void selectMinisterio(Ministerio ministerio) {
    state = ministerio;
  }

  void resetMinisterio() {
    state = Ministerio.empty();
  }
}
