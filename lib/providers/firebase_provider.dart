import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petleo_test/firebase/firebase_authentication.dart';
import 'package:petleo_test/states/auth_state.dart';

final firebaseProvider = StateNotifierProvider<_FirebaseNotifier, AuthState>(
  (ref) => _FirebaseNotifier(),
);

class _FirebaseNotifier extends StateNotifier<AuthState> {
  _FirebaseNotifier() : super(Checking()) {
    fetch();
  }
  void fetch() async {
    try {
      state = Checking();
      final result = await auth.authCheck();

      state = Checked(result);
    } catch (e) {
      state = CheckError(e);
      rethrow;
    }
  }
}
