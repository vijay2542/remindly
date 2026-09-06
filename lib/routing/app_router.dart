import 'package:go_router/go_router.dart';
import '../features/about/presentation/pages/about_page.dart';
import '../features/auth/presentation/pages/lock_page.dart';
import '../features/memory/presentation/pages/add_memory_page.dart';
import '../features/memory/presentation/pages/home_page.dart';
import '../features/memory/presentation/pages/memory_detail_page.dart';
import '../features/search/presentation/pages/search_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/lock',
      name: 'lock',
      builder: (context, state) => const LockPage(),
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
  ],
);
