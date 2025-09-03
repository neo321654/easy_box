import 'package:easy_box/core/extensions/extensions.dart';
import 'package:easy_box/core/utils/utils.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return Text(context.S.welcomeMessage(state.user.name));
            }
            return Text(context.S.appTitle);
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(AppDimensions.medium),
        mainAxisSpacing: AppDimensions.medium,
        crossAxisSpacing: AppDimensions.medium,
        children: [
          _HomeMenuItem(
            icon: Icons.inventory_2_outlined,
            title: context.S.homeMenuInventory,
            onTap: () {
              context.push('/inventory');
            },
          ),
          _HomeMenuItem(
            icon: Icons.archive_outlined,
            title: context.S.homeMenuReceiving,
            onTap: () {
              context.push('/receiving');
            },
          ),
          _HomeMenuItem(
            icon: Icons.qr_code_scanner,
            title: context.S.homeMenuScanning,
            onTap: () {
              context.push('/scanning');
            },
          ),
          _HomeMenuItem(
            icon: Icons.settings_outlined,
            title: context.S.homeMenuSettings,
            onTap: () {
              context.push('/settings');
            },
          ),
        ],
      ),
    );
  }
}

class _HomeMenuItem extends StatelessWidget {
  const _HomeMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: AppDimensions.small),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
