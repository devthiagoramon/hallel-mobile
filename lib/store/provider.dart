import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/model/membro_ministerio_model.dart';
import 'package:hallel/model/user_model.dart';
import 'package:hallel/store/notifiers/membro_ministerio_notifier.dart';
import 'package:hallel/store/notifiers/user_notifier.dart';

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});

final membroMinisterioProvider =
    StateNotifierProvider<MembroMinisterioNotifier, MembroMinisterio>((ref) {
  return MembroMinisterioNotifier();
});
