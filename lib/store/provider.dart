import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hallel/model/user_model.dart';
import 'package:hallel/store/notifiers/user_notifier.dart';

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
