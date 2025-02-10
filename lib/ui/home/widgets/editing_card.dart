import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/notice/model/notice_model.dart';
import '../../../theme/notice_manager_color_theme.dart';
import '../../../theme/typographies.dart';
import '../home_state.dart';
import '../home_view_model.dart';

class EditingCard extends ConsumerStatefulWidget {
  const EditingCard({
    required this.notice,
    super.key,
  });

  final NoticeModel notice;

  @override
  ConsumerState<EditingCard> createState() => _EditingCardState();
}

class _EditingCardState extends ConsumerState<EditingCard> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.notice.title;
    _dateController.text = widget.notice.date ?? '';
    _linkController.text = widget.notice.link;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NoticeManagerColorTheme managerColors =
        Theme.of(context).extension<NoticeManagerColorTheme>()!;
    final HomeState state = ref.watch(homeViewModelProvider);
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider.notifier);

    ref.listen(
        homeViewModelProvider
            .select((HomeState value) => value.editingErrorMessage),
        (String? previous, String next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: managerColors.error,
          ),
        );
      }
    });

    return Container(
      width: 300,
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 300,
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: managerColors.editing,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Text(
                  '공지사항 수정',
                  style: Typo.p16b.copyWith(color: managerColors.white),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    viewModel
                      ..setEditingErrorMessage(
                        editingErrorMessage: '',
                      )
                      ..toggleEditingNotice(
                        id: '',
                      );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: managerColors.white,
                  ),
                  child: const Text(
                    '취소',
                    style: Typo.p16r,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    viewModel.setEditingErrorMessage(
                      editingErrorMessage: '',
                    );
                    if (_titleController.text.isEmpty ||
                        _linkController.text.isEmpty) {
                      viewModel.setEditingErrorMessage(
                        editingErrorMessage: '제목과 링크는 필수로 입력해주세요.',
                      );
                      return;
                    }
                    viewModel
                      ..editNotice(
                        notice: NoticeModel(
                          id: widget.notice.id,
                          title: _titleController.text,
                          date: _dateController.text,
                          link: _linkController.text,
                        ),
                      )
                      ..editSelectedNotice(
                        notice: NoticeModel(
                          id: widget.notice.id,
                          title: _titleController.text,
                          date: _dateController.text,
                          link: _linkController.text,
                        ),
                      );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: managerColors.white,
                  ),
                  child: const Text(
                    '저장',
                    style: Typo.p16r,
                  ),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: state.editingErrorMessage.isNotEmpty
                      ? managerColors.error
                      : managerColors.gray40,
                ),
                right: BorderSide(
                  color: state.editingErrorMessage.isNotEmpty
                      ? managerColors.error
                      : managerColors.gray40,
                ),
                bottom: BorderSide(
                  color: state.editingErrorMessage.isNotEmpty
                      ? managerColors.error
                      : managerColors.gray40,
                ),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 190,
                    child: TextField(
                      controller: _titleController,
                      style: Typo.p16b,
                      maxLines: 7,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '제목을 입력해주세요. \n ex) '
                            '[입학에서 취업까지] 2025학년도 1학기 재학생 등록금 납부 안내',
                        hintStyle: Typo.p16b.copyWith(
                          color: managerColors.gray40,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: managerColors.gray40,
                  ),
                  SizedBox(
                    height: 96,
                    child: TextField(
                      controller: _dateController,
                      style: Typo.p14b,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '일자 정보를 입력해주세요. \n ex) '
                            '신청기간 : 2025. 3. 4.(화) 17:00 ~ 2025. 3. 7(금) 17:00',
                        hintStyle: Typo.p14r.copyWith(
                          color: managerColors.gray40,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: managerColors.gray40,
                  ),
                  SizedBox(
                    height: 96,
                    child: TextField(
                      controller: _linkController,
                      style: Typo.p14r,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '링크를 입력해주세요.',
                        hintStyle: Typo.p14r.copyWith(
                          color: managerColors.gray40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
