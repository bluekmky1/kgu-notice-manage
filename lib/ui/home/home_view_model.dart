import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/loading_status.dart';
import '../../domain/notice/model/notice_model.dart';
import '../../service/storage/storage_key.dart';
import '../../service/storage/storage_service.dart';
import 'home_state.dart';

final AutoDisposeStateNotifierProvider<HomeViewModel, HomeState>
    homeViewModelProvider = StateNotifierProvider.autoDispose(
  (AutoDisposeRef<HomeState> ref) => HomeViewModel(
    state: HomeState.init(),
    storageService: ref.read(storageServiceProvider),
  ),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final StorageService _storageService;

  HomeViewModel({
    required HomeState state,
    required StorageService storageService,
  })  : _storageService = storageService,
        super(state);

  Future<void> init() async {
    state = state.copyWith(
      noticesLoadingStatus: LoadingStatus.loading,
    );
    try {
      final String? noticesJson =
          await _storageService.getString(key: StorageKey.notices);

      if (noticesJson != null) {
        final List<dynamic> decoded = jsonDecode(noticesJson) as List<dynamic>;
        final List<NoticeModel> notices = decoded
            .map((dynamic item) =>
                NoticeModel.fromJson(item as Map<String, dynamic>))
            .toList();
        state = state.copyWith(
          notices: notices,
          noticesLoadingStatus: LoadingStatus.success,
        );
      } else {
        await _storageService.setString(
          key: StorageKey.notices,
          value: '[]',
        );

        state = state.copyWith(
          noticesLoadingStatus: LoadingStatus.success,
          notices: const <NoticeModel>[],
        );
      }
    } on Exception catch (e) {
      state = state.copyWith(
        noticesLoadingStatus: LoadingStatus.error,
        storageErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addNotice({required NoticeModel notice}) async {
    final List<NoticeModel> newNotices = <NoticeModel>[
      ...state.notices,
      notice,
    ];

    await _storageService.setString(
      key: StorageKey.notices,
      value: jsonEncode(
          newNotices.map((NoticeModel notice) => notice.toJson()).toList()),
    );

    state = state.copyWith(
      isAddingNotice: false,
      notices: newNotices,
    );
  }

  void toggleSelectedNotice({required NoticeModel notice}) {
    state = state.copyWith(
      selectedNotices: state.selectedNotices.contains(notice)
          ? state.selectedNotices
              .where((NoticeModel e) => e.id != notice.id)
              .toList()
          : <NoticeModel>[...state.selectedNotices, notice],
    );
  }

  void excludeSelectedNotice({required NoticeModel notice}) {
    state = state.copyWith(
      selectedNotices: state.selectedNotices
          .where((NoticeModel e) => e.id != notice.id)
          .toList(),
    );
  }

  void toggleAddingNotice({required bool isAddingNotice}) {
    state = state.copyWith(
      isAddingNotice: isAddingNotice,
    );
  }

  void toggleEditingNotice({required String id}) {
    state = state.copyWith(
      editingNoticeId: id,
    );
  }

  void editSelectedNotice({required NoticeModel notice}) {
    state = state.copyWith(
      selectedNotices: state.selectedNotices
          .map((NoticeModel e) => e.id == notice.id ? notice : e)
          .toList(),
    );
  }

  Future<void> editNotice({required NoticeModel notice}) async {
    final List<NoticeModel> newNotices = state.notices
        .map((NoticeModel e) => e.id == notice.id ? notice : e)
        .toList();

    await _storageService.setString(
      key: StorageKey.notices,
      value: jsonEncode(
          newNotices.map((NoticeModel notice) => notice.toJson()).toList()),
    );

    state = state.copyWith(
      notices: newNotices,
      editingNoticeId: '',
    );
  }

  Future<void> deleteNotice({required String id}) async {
    final List<NoticeModel> newNotices =
        state.notices.where((NoticeModel e) => e.id != id).toList();

    await _storageService.setString(
      key: StorageKey.notices,
      value: jsonEncode(
          newNotices.map((NoticeModel notice) => notice.toJson()).toList()),
    );

    state = state.copyWith(
      notices: newNotices,
    );
  }

  void setAddingErrorMessage({required String addingErrorMessage}) {
    state = state.copyWith(
      addingErrorMessage: addingErrorMessage,
    );
  }

  void setEditingErrorMessage({required String editingErrorMessage}) {
    state = state.copyWith(
      editingErrorMessage: editingErrorMessage,
    );
  }
}
