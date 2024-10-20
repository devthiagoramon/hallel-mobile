import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/model/ministerio_model.dart';

class MinisterioPanelNotifier extends StateNotifier<Ministerio> {
  MinisterioPanelNotifier() : super(Ministerio.empty());

  selectMinisterio(Ministerio data) {
    state = data;
  }

  cleanMinisterio() {
    state = Ministerio.empty();
  }
}
