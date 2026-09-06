import 'package:go_router/go_router.dart';
import '../features/about/presentation/pages/about_page.dart';
import '../features/auth/presentation/pages/lock_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/diary/presentation/pages/diary_calendar_page.dart';
import '../features/diary/presentation/pages/diary_editor_page.dart';
import '../features/diary/presentation/pages/diary_entries_page.dart';
import '../features/diary/presentation/pages/diary_home_page.dart';
import '../features/diary/presentation/pages/diary_settings_page.dart';
import '../features/diary/presentation/pages/diary_unlock_page.dart';
import '../features/memory/presentation/pages/add_memory_page.dart';
import '../features/memory/presentation/pages/home_page.dart';
import '../features/memory/presentation/pages/memory_detail_page.dart';
import '../features/search/presentation/pages/search_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/lock',
      name: 'lock',
      builder: (context, state) => const LockPage(),
    ),
    GoRoute(
      path: '/remindly',
      name: 'remindly-home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add',
      name: 'add-memory',
      builder: (context, state) {
        final startVoice = state.uri.queryParameters['voice'] == 'true';
        return AddMemoryPage(startVoice: startVoice);
      },
    ),
    GoRoute(
      path: '/memory/:id',
      name: 'memory-detail',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MemoryDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) {
        final q = state.uri.queryParameters['q'];
        final startVoice = state.uri.queryParameters['voice'] == 'true';
        return SearchPage(initialQuery: q, startVoice: startVoice);
      },
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: '/diary',
      name: 'diary-home',
      builder: (context, state) => const DiaryHomePage(),
    ),
    GoRoute(
      path: '/diary/unlock',
      name: 'diary-unlock',
      builder: (context, state) => const DiaryUnlockPage(),
    ),
    GoRoute(
      path: '/diary/editor',
      name: 'diary-editor-new',
      builder: (context, state) {
        final initialText = state.extra as String?;
        return DiaryEditorPage(initialText: initialText);
      },
    ),
    GoRoute(
      path: '/diary/entry/:id',
      name: 'diary-editor-edit',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return DiaryEditorPage(entryId: id);
      },
    ),
    GoRoute(
      path: '/diary/entries',
      name: 'diary-entries',
      builder: (context, state) => const DiaryEntriesPage(),
    ),
    GoRoute(
      path: '/diary/calendar',
      name: 'diary-calendar',
      builder: (context, state) => const DiaryCalendarPage(),
    ),
    GoRoute(
      path: '/diary/settings',
      name: 'diary-settings',
      builder: (context, state) => const DiarySettingsPage(),
    ),
  ],
);
