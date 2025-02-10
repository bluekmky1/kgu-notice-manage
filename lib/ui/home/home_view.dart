import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/loading_status.dart';
import '../../domain/notice/model/notice_model.dart';
import '../../theme/notice_manager_color_theme.dart';
import '../../theme/typographies.dart';
import 'home_state.dart';
import 'home_view_model.dart';
import 'widgets/editing_card.dart';
import 'widgets/notice_card.dart';
import 'widgets/writing_card.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final NoticeManagerColorTheme managerColors =
        Theme.of(context).extension<NoticeManagerColorTheme>()!;
    final HomeState state = ref.watch(homeViewModelProvider);
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Container(
          constraints: const BoxConstraints(
            maxWidth: 1260,
          ),
          alignment: Alignment.centerLeft,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isSmallMobile = constraints.maxWidth < 480;

              if (isSmallMobile) {
                return const Text(
                  '경영학전공 공지 요약 생성기',
                  style: Typo.p20b,
                );
              } else {
                return const Text(
                  '경영학전공 공지 요약 생성기',
                  style: Typo.p24b,
                );
              }
            },
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          const NoticeManageHeader(),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: managerColors.white,
              onRefresh: () async {
                await Future<void>.delayed(const Duration(seconds: 1));
                await viewModel.init();
              },
              color: managerColors.main,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    const Row(),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 1300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          32,
                          16,
                          0,
                        ),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: <Widget>[
                            if (state.noticesLoadingStatus ==
                                LoadingStatus.loading)
                              Center(
                                child: CircularProgressIndicator(
                                  color: managerColors.main,
                                ),
                              ),
                            if (state.notices.isEmpty &&
                                !state.isAddingNotice &&
                                state.noticesLoadingStatus ==
                                    LoadingStatus.success)
                              const Padding(
                                padding: EdgeInsets.only(top: 64),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '변환할 공지사항이 없습니다.\n 공지사항을 추가해주세요.',
                                      textAlign: TextAlign.center,
                                      style: Typo.p16r,
                                    ),
                                  ],
                                ),
                              ),
                            if (state.noticesLoadingStatus ==
                                LoadingStatus.success)
                              ...List<Widget>.generate(
                                state.notices.length,
                                (int index) {
                                  if (state.editingNoticeId ==
                                      state.notices[index].id) {
                                    return EditingCard(
                                      notice: state.notices[index],
                                    );
                                  }

                                  return NoticeCard(
                                    notice: state.notices[index],
                                  );
                                },
                              ),
                            if (state.isAddingNotice &&
                                state.noticesLoadingStatus ==
                                    LoadingStatus.success)
                              const WritingCard(),
                            if (state.noticesLoadingStatus ==
                                LoadingStatus.error)
                              Padding(
                                padding: const EdgeInsets.only(top: 64),
                                child: Column(
                                  children: <Widget>[
                                    const Row(),
                                    const Text(
                                      '공지사항을 불러오는데 실패했습니다.\n 다시 시도해주세요.',
                                      textAlign: TextAlign.center,
                                      style: Typo.p16r,
                                    ),
                                    const SizedBox(height: 32),
                                    TextButton(
                                      onPressed: viewModel.init,
                                      style: TextButton.styleFrom(
                                        backgroundColor: managerColors.main,
                                        foregroundColor: managerColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 20,
                                        ),
                                      ),
                                      child: const Text('다시 시도'),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoticeManageHeader extends ConsumerWidget {
  const NoticeManageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NoticeManagerColorTheme managerColors =
        Theme.of(context).extension<NoticeManagerColorTheme>()!;
    final HomeState state = ref.watch(homeViewModelProvider);
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider.notifier);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isSmallMobile = constraints.maxWidth < 480;

        if (isSmallMobile) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: managerColors.background,
              border: Border(
                bottom: BorderSide(
                  color: managerColors.gray40,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    viewModel.toggleAddingNotice(
                      isAddingNotice: true,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: managerColors.main,
                    foregroundColor: managerColors.white,
                  ),
                  child: const Row(
                    children: <Widget>[
                      Text(
                        '공지사항 추가',
                        style: Typo.p16b,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: state.selectedNotices.isNotEmpty &&
                          state.editingNoticeId.isEmpty &&
                          !state.isAddingNotice
                      ? () {
                          _showKakaoFormatDialog(
                            context: context,
                            notices: state.notices,
                            managerColors: managerColors,
                          );
                        }
                      : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: state.selectedNotices.isNotEmpty &&
                                state.editingNoticeId.isEmpty &&
                                !state.isAddingNotice
                            ? managerColors.main
                            : managerColors.gray40,
                        width: 2,
                      ),
                    ),
                    backgroundColor: managerColors.white,
                    foregroundColor: managerColors.main,
                  ),
                  child: const Row(
                    children: <Widget>[
                      Text(
                        '카톡 형식 출력',
                        style: Typo.p16b,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: managerColors.background,
              border: Border(
                bottom: BorderSide(
                  color: managerColors.gray40,
                ),
              ),
            ),
            constraints: const BoxConstraints(
              maxWidth: 1280,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    viewModel.toggleAddingNotice(
                      isAddingNotice: true,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: managerColors.main,
                    foregroundColor: managerColors.white,
                  ),
                  child: const Text(
                    '공지사항 추가',
                    style: Typo.p16b,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: state.selectedNotices.isNotEmpty
                      ? () {
                          _showKakaoFormatDialog(
                            context: context,
                            notices: state.notices,
                            managerColors: managerColors,
                          );
                        }
                      : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: state.selectedNotices.isNotEmpty
                            ? managerColors.main
                            : managerColors.gray40,
                        width: 2,
                      ),
                    ),
                    backgroundColor: managerColors.white,
                    foregroundColor: managerColors.main,
                  ),
                  child: const Text(
                    '카톡 형식 출력',
                    style: Typo.p16b,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

void _showKakaoFormatDialog({
  required BuildContext context,
  required List<NoticeModel> notices,
  required NoticeManagerColorTheme managerColors,
}) {
  String selectedMajor = '경영학전공'; // 기본값
  String formattedText = _generateKakaoFormat(notices, selectedMajor);

  showDialog<void>(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => AlertDialog(
        backgroundColor: managerColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.all(12),
        contentPadding: const EdgeInsets.all(12),
        title: Row(
          children: <Widget>[
            const Text('카카오톡 형식', style: Typo.p20b),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: managerColors.white,
                foregroundColor: managerColors.main,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: formattedText));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('텍스트가 복사되었습니다.')),
                );
              },
              child: const Text('복사하기'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedMajor,
              dropdownColor: managerColors.white,
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: '경영학전공',
                  child: Text('💙경영학전공 공지사항💙'),
                ),
                DropdownMenuItem<String>(
                  value: '통합',
                  child: Text('💙통합 공지사항💙'),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedMajor = newValue;
                    formattedText =
                        _generateKakaoFormat(notices, selectedMajor);
                  });
                }
              },
              isExpanded: true,
              padding: const EdgeInsets.only(bottom: 16),
            ),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 300,
                minWidth: 300,
              ),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: SelectableText(formattedText),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: managerColors.white,
              foregroundColor: managerColors.black,
            ),
            child: const Text('닫기'),
          ),
        ],
      ),
    ),
  );
}

String _generateKakaoFormat(List<NoticeModel> notices, String major) {
  final StringBuffer buffer = StringBuffer();

  // 전공에 따른 이모지 매핑
  final Map<String, String> majorEmojis = <String, String>{
    '경영학전공': '💙',
    '통합': '💙',
  };

  final String emoji = majorEmojis[major] ?? '💙';

  buffer.writeln('$emoji$major 공지사항$emoji\n');

  for (final NoticeModel notice in notices) {
    buffer.writeln('📌 ${notice.title}');
    if (notice.date != null && notice.date!.isNotEmpty) {
      buffer.writeln('[${notice.date}]');
    }
    if (notice.link.isNotEmpty) {
      buffer.writeln('\n${notice.link}');
    }
    buffer.writeln(); // 공지사항 간 빈 줄 추가
  }

  return buffer.toString();
}
