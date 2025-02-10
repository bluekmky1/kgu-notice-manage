import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/notice/model/notice_model.dart';
import '../../../theme/notice_manager_color_theme.dart';
import '../../../theme/typographies.dart';
import '../home_state.dart';
import '../home_view_model.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    required this.notice,
    super.key,
  });

  final NoticeModel notice;

  @override
  Widget build(BuildContext context) {
    final NoticeManagerColorTheme managerColors =
        Theme.of(context).extension<NoticeManagerColorTheme>()!;
    return Container(
      width: 300,
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(
          color: managerColors.gray40,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          NormalCardHeader(notice: notice),
          DisplayNotice(notice: notice),
        ],
      ),
    );
  }
}

class NormalCardHeader extends ConsumerWidget {
  const NormalCardHeader({
    required this.notice,
    super.key,
  });

  final NoticeModel notice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NoticeManagerColorTheme managerColors =
        Theme.of(context).extension<NoticeManagerColorTheme>()!;
    final HomeState state = ref.watch(homeViewModelProvider);
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider.notifier);
    return Container(
      width: 300,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: managerColors.main,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: state.selectedNotices.contains(notice),
            onChanged: (bool? value) {
              viewModel.toggleSelectedNotice(
                notice: notice,
              );
            },
            side: BorderSide(
              color: managerColors.white,
              width: 2,
            ),
            fillColor: WidgetStateProperty.all(managerColors.white),
            checkColor: managerColors.main,
            activeColor: managerColors.white,
            hoverColor: managerColors.gray40.withAlpha(30),
            focusColor: managerColors.white,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                viewModel.toggleSelectedNotice(
                  notice: notice,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.toggleEditingNotice(
                id: notice.id,
              );
            },
            style: IconButton.styleFrom(
              foregroundColor: managerColors.white,
            ),
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: managerColors.white,
                  title: const Text('공지사항 삭제'),
                  content: const Text('정말 삭제하시겠습니까?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: managerColors.black,
                      ),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        viewModel
                          ..deleteNotice(
                            id: notice.id,
                          )
                          ..excludeSelectedNotice(
                            notice: notice,
                          );
                        context.pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: managerColors.error,
                      ),
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              );
            },
            style: IconButton.styleFrom(
              foregroundColor: managerColors.white,
            ),
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayNotice extends StatelessWidget {
  const DisplayNotice({
    required this.notice,
    super.key,
  });

  final NoticeModel notice;

  @override
  Widget build(BuildContext context) {
    final NoticeManagerColorTheme managerColors =
        Theme.of(context).extension<NoticeManagerColorTheme>()!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(),
          SizedBox(
            height: 190,
            child: Text(
              notice.title,
              style: Typo.p16b,
            ),
          ),
          Divider(
            color: managerColors.gray40,
          ),
          SizedBox(
            height: 96,
            child: Text(
              notice.date == null || notice.date!.isEmpty
                  ? '입력 안함'
                  : notice.date!,
              style: Typo.p14b.copyWith(
                color: notice.date == null || notice.date!.isEmpty
                    ? managerColors.gray40
                    : managerColors.black,
              ),
            ),
          ),
          Divider(
            color: managerColors.gray40,
          ),
          SizedBox(
            height: 96,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      physics: const BouncingScrollPhysics(),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) =>
                            true,
                        child: SingleChildScrollView(
                          child: InkWell(
                            onTap: () async {
                              if (await canLaunchUrl(Uri.parse(notice.link))) {
                                await launchUrl(Uri.parse(notice.link));
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('링크를 찾을 수 없습니다.'),
                                      backgroundColor: managerColors.error,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              notice.link,
                              style: Typo.p14r.copyWith(
                                color: Colors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
