import 'package:easy_box/core/extensions/extensions.dart';
import 'package:easy_box/core/utils/utils.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_creation_bloc.dart';
import 'package:easy_box/features/inventory/presentation/widgets/add_product_form.dart';
import 'package:easy_box/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider(
          create: (_) => sl<ProductCreationBloc>(),
          child: const AddProductForm(),
        );
      },
    );
  }

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
            key: const ValueKey('logout_button'),
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
          ActionCard(
            key: const ValueKey('home_menu_inventory'),
            icon: Icons.inventory_2_outlined,
            title: context.S.homeMenuInventory,
            onTap: () {
              context.push('/inventory');
            },
          ),
          ActionCard(
            key: const ValueKey('home_menu_add_product'),
            icon: Icons.add_box_outlined,
            title: context.S.homeMenuAddProduct,
            onTap: () => _showAddProductSheet(context),
          ),
          ActionCard(
            key: const ValueKey('home_menu_receiving'),
            icon: Icons.archive_outlined,
            title: context.S.homeMenuReceiving,
            onTap: () {
              context.push('/receiving');
            },
          ),
          ActionCard(
            key: const ValueKey('home_menu_scanning'),
            icon: Icons.qr_code_scanner,
            title: context.S.homeMenuScanning,
            onTap: () {
              context.push('/scanning');
            },
          ),
          ActionCard(
            key: const ValueKey('home_menu_settings'),
            icon: Icons.settings_outlined,
            title: context.S.homeMenuSettings,
            onTap: () {
              context.push('/settings');
            },
          ),
          ActionCard(
            key: const ValueKey('home_menu_picking'),
            icon: Icons.shopping_basket_outlined,
            title: context.S.homeMenuPicking,
            onTap: () {
              context.push('/orders');
            },
          ),
        ],
      ),
    );
  }
}