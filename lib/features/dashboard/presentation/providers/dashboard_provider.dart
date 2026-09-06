import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardModuleInfo {
  final String id;
  final String title;
  final String description;
  final String route;

  const DashboardModuleInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.route,
  });
}

class DashboardState {
  final List<DashboardModuleInfo> modules;

  const DashboardState({
    this.modules = const [
      DashboardModuleInfo(
        id: 'remandly',
        title: 'Remandly',
        description: 'Remember anything. Find it when you need it.',
        route: '/remandly',
      ),
      DashboardModuleInfo(
        id: 'diary',
        title: 'Diary',
        description: 'Your private space for everyday thoughts and memories.',
        route: '/diary',
      ),
    ],
  });
}

final dashboardProvider = Provider<DashboardState>((ref) {
  return const DashboardState();
});
