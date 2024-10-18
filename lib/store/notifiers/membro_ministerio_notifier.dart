import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/model/membro_ministerio_model.dart';
import 'package:hallel/model/status_membro_ministerio.dart';

class MembroMinisterioNotifier extends StateNotifier<MembroMinisterio> {
  MembroMinisterioNotifier() : super(MembroMinisterio());

  void setObject(MembroMinisterio data) {
    state = data;
  }

  void setStatusMembro(MembroMinisterio data, StatusMembroMinisterio status) {
    data.statusMembroMinisterio = status;
    state = data;
  }
}
