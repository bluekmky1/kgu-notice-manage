import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../ui/candidate_management/candidate_manage_view.dart';
import '../ui/home/home_view.dart';
import '../ui/manage_election_notice/manage_election_notice_view.dart';
import '../ui/manage_user/manage_user_view.dart';
import '../ui/manage_vote/manage_vote_view.dart';
import '../ui/manage_vote_result/manage_vote_result_view.dart';
import '../ui/sign_in/sign_in_view.dart';
import '../ui/sign_up/sign_up_view.dart';
import '../ui/vote_analytics/vote_analytics_view.dart';
import 'app_router_interceptor.dart';
import 'redirect_notifier.dart';
import 'routes.dart';

final Provider<AppRouter> appRouterProvider =
    Provider<AppRouter>((ProviderRef<AppRouter> ref) => AppRouter(
          appRouterInterceptor: AppRouterInterceptor(ref: ref),
          refreshListenable: ref.read(redirectNotifierProvider),
        ));

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter({
    required Listenable refreshListenable,
    required AppRouterInterceptor appRouterInterceptor,
  })  : _appRouterInterceptor = appRouterInterceptor,
        _refreshListenable = refreshListenable;

  final AppRouterInterceptor _appRouterInterceptor;
  final Listenable _refreshListenable;

  // 라우트의 이동마다 호출됩니다.
  FutureOr<String?> _redirect(BuildContext context, GoRouterState state) =>
      _appRouterInterceptor.redirect(context, state);

  late final GoRouter _router = GoRouter(
    initialLocation: Routes.home.name,
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    refreshListenable: _refreshListenable,
    errorBuilder: (BuildContext context, GoRouterState state) => const Scaffold(
      body: Center(
        child: Text('Internal Error'),
      ),
    ),
    redirect: _redirect,
    routes: <RouteBase>[
      GoRoute(
        name: Routes.home.name,
        path: Routes.home.path,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: HomeView(),
        ),
      ),
      GoRoute(
        name: Routes.manageUser.name,
        path: Routes.manageUser.path,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: ManageUserView(),
        ),
      ),
      GoRoute(
        name: Routes.manageVote.name,
        path: Routes.manageVote.path,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: ManageVoteView(),
        ),
      ),
      GoRoute(
        name: Routes.manageElectionNotice.name,
        path: Routes.manageElectionNotice.path,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: ManageElectionNoticeView(),
        ),
      ),
      GoRoute(
        name: Routes.voteAnalytics.name,
        path: Routes.voteAnalytics.path,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: VoteAnalyticsView(),
        ),
      ),
      GoRoute(
        name: Routes.candidateManage.name,
        path: Routes.candidateManage.path,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CandidateManageView(),
        ),
      ),
      GoRoute(
        name: Routes.manageVoteResult.name,
        path: Routes.manageVoteResult.path,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: ManageVoteResultView(),
        ),
      ),

      // Auth Routes
      GoRoute(
        path: Routes.auth.path,
        name: Routes.auth.name,
        redirect: _redirect,
        routes: <RouteBase>[
          GoRoute(
            name: Routes.signIn.name,
            path: Routes.signIn.path,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<dynamic>(
              child: SignInView(),
            ),
          ),
          GoRoute(
            name: Routes.signUp.name,
            path: Routes.signUp.path,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<dynamic>(
              child: SignUpView(),
            ),
          ),
        ],
      ),
    ],
  );

  GoRouter get router => _router;
}
