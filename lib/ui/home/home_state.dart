import 'package:equatable/equatable.dart';
import '../../core/loading_status.dart';
import '../../domain/notice/model/notice_model.dart';

class HomeState extends Equatable {
  final LoadingStatus noticesLoadingStatus;

  final List<NoticeModel> notices;
  final List<NoticeModel> selectedNotices;

  final bool isAddingNotice;
  final String editingNoticeId;
  final String addingErrorMessage;
  final String editingErrorMessage;

  const HomeState({
    required this.noticesLoadingStatus,
    required this.notices,
    required this.selectedNotices,
    required this.isAddingNotice,
    required this.editingNoticeId,
    required this.addingErrorMessage,
    required this.editingErrorMessage,
  });

  HomeState.init()
      : noticesLoadingStatus = LoadingStatus.none,
        notices = <NoticeModel>[],
        selectedNotices = <NoticeModel>[],
        isAddingNotice = false,
        editingNoticeId = '',
        addingErrorMessage = '',
        editingErrorMessage = '';

  HomeState copyWith({
    LoadingStatus? noticesLoadingStatus,
    List<NoticeModel>? notices,
    List<NoticeModel>? selectedNotices,
    bool? isAddingNotice,
    String? editingNoticeId,
    String? addingErrorMessage,
    String? editingErrorMessage,
  }) =>
      HomeState(
        noticesLoadingStatus: noticesLoadingStatus ?? this.noticesLoadingStatus,
        notices: notices ?? this.notices,
        selectedNotices: selectedNotices ?? this.selectedNotices,
        isAddingNotice: isAddingNotice ?? this.isAddingNotice,
        editingNoticeId: editingNoticeId ?? this.editingNoticeId,
        addingErrorMessage: addingErrorMessage ?? this.addingErrorMessage,
        editingErrorMessage: editingErrorMessage ?? this.editingErrorMessage,
      );

  @override
  List<Object> get props => <Object>[
        noticesLoadingStatus,
        notices,
        selectedNotices,
        isAddingNotice,
        editingNoticeId,
        addingErrorMessage,
        editingErrorMessage,
      ];
}
