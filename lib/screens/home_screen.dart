// import 'package:flutter/material.dart';
// import 'package:klontong_kodeaqua/providers/base_provider.dart';
// import 'package:klontong_kodeaqua/providers/home_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// import '../models/product_model.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(context.read<BaseProvider>().init).whenComplete(context.read<HomeProvider>().init);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Klontong App'),
//         centerTitle: true,
//       ),
//       body: Consumer<BaseProvider>(
//         builder: (_, BaseProvider bp, __) {
//           final bool isBusy = bp.isBusy;

//           return Consumer<HomeProvider>(
//             builder: (_, HomeProvider pp, __) {
//               final int selectedIndex = pp.selectedIndex;
//               final List<ProductModel>? products = pp.products;

//               return <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: products == null
//                       ? GridView.count(
//                           crossAxisCount: 2,
//                           children: List.generate(10, (index) {
//                             return Skeletonizer(
//                               child: Card(
//                                 child: Column(
//                                   children: <Widget>[
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(12),
//                                           color: Theme.of(context).colorScheme.surfaceContainerHighest,
//                                         ),
//                                         child: const Center(
//                                           child: Icon(Icons.shop_outlined),
//                                         ),
//                                       ),
//                                     ),
//                                     const ListTile(
//                                       title: Text('Product name'),
//                                       subtitle: Text('Product price'),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }),
//                         )
//                       : GridView.count(
//                           crossAxisCount: 2,
//                           children: products.map((ProductModel p) {
//                             return Card.filled(
//                               child: InkWell(
//                                 onTap: () {},
//                                 child: Column(
//                                   children: <Widget>[
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(12),
//                                           color: Theme.of(context).colorScheme.primary,
//                                         ),
//                                         child: Center(
//                                           child: Image.network('${p.image}', width: double.infinity, fit: BoxFit.cover),
//                                         ),
//                                       ),
//                                     ),
//                                     ListTile(
//                                       title: Text('${p.name}'),
//                                       subtitle: Text('${p.price}'),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                 ),
//                 ListView(
//                   children: <Widget>[
//                     ListTile(
//                       leading: const CircleAvatar(
//                         child: Icon(Icons.computer_outlined),
//                       ),
//                       title: const Text('CRUD Server'),
//                       subtitle: const Text('Select CRUD Server'),
//                       onTap: context.read<HomeProvider>().onSelectCrudServer,
//                     ),
//                     ListTile(
//                       leading: const CircleAvatar(
//                         child: Icon(Icons.category_outlined),
//                       ),
//                       title: const Text('Categories'),
//                       subtitle: const Text('Manage product categories'),
//                       onTap: context.read<HomeProvider>().toManageCategories,
//                     ),
//                     ListTile(
//                       leading: const CircleAvatar(
//                         child: Icon(Icons.warehouse_outlined),
//                       ),
//                       title: const Text('Product'),
//                       subtitle: const Text('Manage products'),
//                       onTap: context.read<HomeProvider>().toManageProducts,
//                     ),
//                   ],
//                 ),
//                 ListView(),
//               ].elementAt(selectedIndex);
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: const HomeNavigationBar(),
//     );
//   }
// }

// class HomeBody extends StatelessWidget {
//   const HomeBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return <Widget>[
//       GridView.count(
//         crossAxisCount: 2,
//         children: const <Widget>[
//           Card(
//             child: ListTile(
//               title: Text('Test Product 1'),
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Test Product 1'),
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Test Product 1'),
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Test Product 1'),
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Test Product 1'),
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Test Product 1'),
//             ),
//           ),
//         ],
//       ),
//       ListView(
//         children: <Widget>[
//           ListTile(
//             leading: const CircleAvatar(
//               child: Icon(Icons.computer_outlined),
//             ),
//             title: const Text('CRUD Server'),
//             subtitle: const Text('Select CRUD Server'),
//             onTap: context.read<HomeProvider>().onSelectCrudServer,
//           ),
//           ListTile(
//             leading: const CircleAvatar(
//               child: Icon(Icons.category_outlined),
//             ),
//             title: const Text('Categories'),
//             subtitle: const Text('Manage product categories'),
//             onTap: context.read<HomeProvider>().toManageCategories,
//           ),
//           ListTile(
//             leading: const CircleAvatar(
//               child: Icon(Icons.warehouse_outlined),
//             ),
//             title: const Text('Product'),
//             subtitle: const Text('Manage products'),
//             onTap: context.read<HomeProvider>().toManageProducts,
//           ),
//         ],
//       ),
//       ListView(),
//     ].elementAt(context.watch<HomeProvider>().selectedIndex);
//   }
// }

// class HomeNavigationBar extends StatelessWidget {
//   const HomeNavigationBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return NavigationBar(
//       selectedIndex: context.watch<HomeProvider>().selectedIndex,
//       onDestinationSelected: context.read<HomeProvider>().onNavDestinationSelected,
//       destinations: const <Widget>[
//         NavigationDestination(
//           icon: Icon(Icons.home_outlined),
//           selectedIcon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         NavigationDestination(
//           icon: Icon(Icons.assignment_outlined),
//           selectedIcon: Icon(Icons.assignment),
//           label: 'Manager',
//         ),
//         NavigationDestination(
//           icon: Icon(Icons.person_outlined),
//           selectedIcon: Icon(Icons.person),
//           label: 'Account',
//         ),
//       ],
//     );
//   }
// }

import 'package:cancellation_token/cancellation_token.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_kodeaqua/cubits/busy_cubit.dart';
import 'package:klontong_kodeaqua/cubits/categories_cubit.dart';
import 'package:klontong_kodeaqua/cubits/color_theme_cubit.dart';
import 'package:klontong_kodeaqua/cubits/products_cubit.dart';
import 'package:klontong_kodeaqua/cubits/roles_cubit.dart';
import 'package:klontong_kodeaqua/cubits/user_cubit.dart';
import 'package:klontong_kodeaqua/models/category_model.dart';
import 'package:klontong_kodeaqua/models/product_model.dart';
import 'package:klontong_kodeaqua/models/role_model.dart';
import 'package:klontong_kodeaqua/screens/login_screen.dart';
import 'package:klontong_kodeaqua/screens/manage_categories_screen.dart';
import 'package:klontong_kodeaqua/screens/manage_products_screen.dart';
import 'package:klontong_kodeaqua/screens/product_detail_screen.dart';
import 'package:klontong_kodeaqua/widgets/app_bar_loading_widget.dart';
import 'package:klontong_kodeaqua/widgets/custom_crudcrud_dialog_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CancellationToken _token;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _token = CancellationToken();
    _selectedIndex = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // context.read<RolesCubit>().initialize(token: _token);
      context.read<RolesCubit>().init(token: _token);
      await context.read<CategoriesCubit>().init(token: _token);

      // context.read<ProductsCubit>().initialize(token: _token);
      context.read<ProductsCubit>().init(token: _token);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _selectedIndex = 0;
    _token.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Klontong App'),
      ),
      drawer: const NavigationDrawer(
        children: [],
      ),
      body: BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
        return BlocBuilder<UserCubit, UserModel?>(builder: (context, user) {
          return BlocBuilder<RolesCubit, List<RoleModel>?>(builder: (context, roles) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: <Widget>[
                BlocBuilder<ProductsCubit, List<ProductModel>?>(
                  builder: (context, products) {
                    if (products == null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(100, (index) {
                            return Skeletonizer(
                              enabled: isBusy || products == null,
                              child: Card.outlined(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: const Center(),
                                      ),
                                    ),
                                    const ListTile(
                                      title: Text('Loading name'),
                                      subtitle: Text('Loading price'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }

                    if (products.isEmpty) {
                      return const Center(
                        child: Text('No data'),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: products.map((ProductModel product) {
                          return Card.outlined(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Center(
                                        child: Hero(
                                          tag: 'product-image-${product.id}',
                                          child: Image.network('${product.image}', width: double.infinity, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('${product.name}'),
                                    subtitle: Text('Rp.${product.price}'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                if (user?.roleId == roles?[0].id)
                  ListView(
                    children: <Widget>[
                      const AppBarLoadingWidget(),
                      InkWell(
                        onTap: _navigateToCategoriesScreen,
                        borderRadius: BorderRadius.circular(12),
                        child: const ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.category_outlined),
                          ),
                          title: Text('Categories'),
                          subtitle: Text('Manage product categories'),
                        ),
                      ),
                      BlocBuilder<CategoriesCubit, List<CategoryModel>?>(
                        builder: (context, categories) {
                          final bool hasNoCategories = (categories == null ? 0 : categories.length) == 0;

                          return InkWell(
                            onTap: hasNoCategories
                                ? () => ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..clearSnackBars()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text('Please add categories!'),
                                    ),
                                  )
                                : _navigateToProductsScreen,
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.warehouse_outlined),
                              ),
                              title: const Text('Product'),
                              subtitle: const Text('Manage products'),
                              trailing: hasNoCategories
                                  ? const Card.outlined(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Text('Missing Categories!'),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ListView(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircleAvatar(
                          radius: 48,
                          child: Icon(Icons.person_outlined, size: 48),
                        ),
                      ),
                    ),
                    Center(
                      child: BlocBuilder<UserCubit, UserModel?>(builder: (_, user) {
                        return Text('${user?.name}', style: Theme.of(context).textTheme.headlineMedium);
                      }),
                    ),
                    Center(
                      child: Card.outlined(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Text(user?.roleId == roles?[0].id ? "Klontong's Owner" : "User"),
                        ),
                      ),
                    ),
                    const ListTile(
                      title: Text('App'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Card.filled(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (_) => const CustomCrudCrudDialogWidget(),
                              ),
                              borderRadius: BorderRadius.circular(12),
                              child: const ListTile(
                                leading: Icon(Icons.network_check_outlined),
                                title: Text('Change server'),
                                subtitle: Text('Temporary fix for CRUDCRUD limit'),
                              ),
                            ),
                            Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
                            InkWell(
                              onTap: () {
                                showDialog<int?>(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text('Change theme'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () => Navigator.pop(context, 0),
                                            child: const ListTile(
                                              tileColor: Colors.green,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.pop(context, 1),
                                            child: const ListTile(
                                              tileColor: Colors.indigo,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.pop(context, 2),
                                            child: const ListTile(
                                              tileColor: Colors.red,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.pop(context, 3),
                                            child: const ListTile(
                                              tileColor: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).then((int? value) {
                                  if (value == null) return;
                                  context.read<ColorThemeCubit>().set(value: value);
                                  context.read<ColorThemeCubit>().save();
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: const ListTile(
                                leading: Icon(Icons.edit_outlined),
                                title: Text('App theme'),
                                subtitle: Text('Customize based your preferences'),
                              ),
                            ),
                            Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
                            InkWell(
                              onTap: _sendBugReport,
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              child: const ListTile(
                                leading: Icon(Icons.bug_report_outlined),
                                title: Text('Bug report'),
                                subtitle: Text('Report for any issue'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const ListTile(
                      title: Text('Account'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Card.filled(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            InkWell(
                              onTap: _onLogout,
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              child: const ListTile(
                                leading: Icon(Icons.logout_outlined),
                                title: Text('Logout'),
                                subtitle: Text('You may need to sign in again'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ].elementAt(_selectedIndex),
            );
          });
        });
      }),
      bottomNavigationBar: BlocBuilder<UserCubit, UserModel?>(
        builder: (_, user) {
          return BlocBuilder<RolesCubit, List<RoleModel>?>(
            builder: (_, roles) {
              return NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                destinations: <Widget>[
                  const NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  if (user?.roleId == roles?[0].id)
                    const NavigationDestination(
                      icon: Icon(Icons.assignment_outlined),
                      selectedIcon: Icon(Icons.assignment),
                      label: 'Manager',
                    ),
                  const NavigationDestination(
                    icon: Icon(Icons.person_outlined),
                    selectedIcon: Icon(Icons.person),
                    label: 'Account',
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _onDestinationSelected(int index) => setState(() => _selectedIndex = index);

  void _navigateToCategoriesScreen() => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageCategoriesScreen()));

  void _navigateToProductsScreen() => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageProductsScreen()));

  void _onLogout() => showDialog<bool?>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Are you sure want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, logout'),
            )
          ],
        ),
      ).then(_onLogoutCallback);

  void _onLogoutCallback(bool? value) => value != null && value ? context.read<UserCubit>().onLogout().then(_onLogoutConfirmedCallback) : null;

  void _onLogoutConfirmedCallback(bool? value) => value != null && value ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (__) => false) : null;

  Future<void> _sendBugReport() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    final Uri url = Uri.parse('mailto:anajmizdn@gmail.com?subject=Bug%20Report%20-%20Klontong%20App&body=Hi!%20I%20want%20to%20report%20this%20issue\n\nDevice:%20${androidDeviceInfo.model}');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
