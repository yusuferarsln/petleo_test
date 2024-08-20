import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petleo_test/services/api_service.dart';
import 'package:petleo_test/states/fetch_state.dart';

final liveSectionProvider =
    StateNotifierProvider<_LiveSectionNotifier, FetchState>(
  (ref) => _LiveSectionNotifier(ref),
);

class _LiveSectionNotifier extends StateNotifier<FetchState> {
  _LiveSectionNotifier(this.ref) : super(Fetching());
  final Ref ref;
  void fetch() async {
    try {
      state = Fetching();
      final result = await api.getAllPostsWithUsernames();

      state = Fetched(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}
