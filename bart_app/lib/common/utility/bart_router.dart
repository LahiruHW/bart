import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/index.dart';
import 'package:bart_app/common/entity/index.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

class BartRouter {
  static final _rootNavKey = GlobalKey<NavigatorState>();
  static final _homeNavKey = GlobalKey<NavigatorState>();
  static final _chatNavKey = GlobalKey<NavigatorState>();
  static final _marketNavKey = GlobalKey<NavigatorState>();
  static final _profileNavKey = GlobalKey<NavigatorState>();

  // static void pushPage(BuildContext context, String route, Object? thisExtra) {
  //   // final currentPath = GoRouter.of(context).routeInformationProvider.value.uri;
  //   // final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

  //   // // get any path parameters
  //   // final pathParams = GoRouter.of(context).routerDelegate.currentConfiguration.pathParameters;
  //   final currentPath =
  //       GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
  //   // debugPrint("currentPath: $currentPath");
  //   // debugPrint("route: $currentPath/$route");
  //   // debugPrint("||||||||||||||||||||||||||||||||||||||||||");
  //   GoRouter.of(context).push(
  //     "$currentPath/$route",
  //     extra: thisExtra,
  //   );
  // }

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavKey,

    initialLocation: '/login-base',
    // initialLocation: '/home',
    // initialLocation: '/market',

    routes: [
      GoRoute(
        name: "login-base",
        path: '/login-base',
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginTypeSelectPage()),
        redirect: (context, state) {
          debugPrint("**************** CHECKING REDIRECTION ****************");
          final provider =
              Provider.of<BartStateProvider>(context, listen: false);
          if (provider.userProfile.userID.isNotEmpty) {
            return '/home';
          }
          return null;
        },
      ),

      GoRoute(
        name: "settings",
        path: '/settings',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SettingsPage(), maintainState: true),
      ),

      // ShellRoute for the app AFTER the user has logged in
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) => Base(bodyWidget: child),
        branches: [
          // StatefulShellBranch for the HOME tab ----------------------------------------------
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            routes: [
              GoRoute(
                name: 'home',
                path: '/home',
                pageBuilder: (context, state) => const MaterialPage(
                  child: HomePage(),
                  maintainState: true,
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _homeNavKey,
                    path: 'test1',
                    name: 'test1',
                    pageBuilder: (context, state) => const MaterialPage(
                      child: TestPage1(),
                    ),
                  ),
                  GoRoute(
                    name: 'viewTrade',
                    path: 'viewTrade',
                    parentNavigatorKey: _homeNavKey,
                    builder: (context, state) {
                      final data = state.extra as Map<String, dynamic>;
                      final trade = data['trade'] as Trade;
                      final tradeType = data['tradeType'] as TradeCompType;
                      final userID = data['userID'] as String;
                      return ViewTradePage(
                        trade: trade,
                        tradeType: tradeType,
                        userID: userID,
                      );
                    },
                  ),
                  GoRoute(
                    name: 'newItem',
                    path: 'newItem',
                    parentNavigatorKey: _homeNavKey,
                    builder: (context, state) {
                      return const NewItemPage(
                        isReturnOffer: false,
                        returnForItem: null,
                        // currentPath: state.path!,
                      );
                    },
                    routes: [
                      GoRoute(
                        name: 'newItemResult',
                        path: 'newItemResult',
                        builder: (context, state) {
                          final data = state.extra as Map<String, dynamic>;
                          Item item = data['item'] as Item;
                          return NewItemResultPage(
                            messageHeading: data['messageHeading'],
                            message: data['message'],
                            isSuccessful: data['isSuccessful'],
                            item: item,
                            dateCreated: data['dateCreated'],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // StatefulShellBranch for the CHAT tab ----------------------------------------------
          StatefulShellBranch(
            navigatorKey: _chatNavKey,
            routes: [
              GoRoute(
                name: "chat",
                path: '/chat',
                pageBuilder: (context, state) => const MaterialPage(
                  child: ChatListPage(),
                  maintainState: true,
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _chatNavKey,
                    name: 'chatRoom',
                    path: 'chatRoom/:id',
                    pageBuilder: (context, state) {
                      final chatID = state.pathParameters['id']!;
                      final chatData = state.extra as Chat;
                      return MaterialPage(
                        child: ChatPage(chatID: chatID, chatData: chatData),
                        maintainState: true,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // StatefulShellBranch for the MARKET tab ---------------------------------------------
          StatefulShellBranch(
            navigatorKey: _marketNavKey,
            routes: [
              GoRoute(
                name: "market", // /market
                path: '/market',
                pageBuilder: (context, state) => const MaterialPage(
                  child: MarketPage(),
                  maintainState: true,
                ),
                routes: [
                  GoRoute(
                    name: 'item', // /market/item/:id
                    path: 'item/:id',
                    parentNavigatorKey: _marketNavKey,
                    pageBuilder: (context, state) {
                      final itemID = state.pathParameters['id']!;
                      Item item = state.extra as Item;
                      return MaterialPage(
                        child: ItemPage(
                          itemID: itemID,
                          item: item,
                          // currentPath: state.path!,
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        name: 'returnItem', // /market/item/:id/returnItem
                        path: 'returnItem',
                        builder: (context, state) {
                          Item item = state.extra as Item;
                          return ReturnOfferPage(
                            returnForItem: item,
                            // currentPath: state.path!,
                            currentPath: 'item/${item.itemID}/returnItem',
                          );
                        },
                        routes: [
                          GoRoute(
                            name: 'tradeResult',
                            path: 'tradeResult',
                            builder: (context, state) {
                              final data = state.extra as Map<String, dynamic>;
                              Item item1 = data['item1'] as Item;
                              Item item2 = data['item2'] as Item;
                              return TradeResultPage(
                                messageHeading: data['messageHeading'],
                                message: data['message'],
                                isSuccessful: data['isSuccessful'],
                                item1: item1,
                                item2: item2,
                                dateCreated: data['dateCreated'],
                              );
                            },
                            // redirect: (context, state) => Future.delayed(
                            //   const Duration(milliseconds: 2500),
                            //   () => '/market',
                            // ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // StatefulShellBranch for the PROFILE tab ---------------------------------------------
          StatefulShellBranch(
            navigatorKey: _profileNavKey,
            routes: [
              GoRoute(
                name: "profile",
                path: "/profile",
                pageBuilder: (context, state) => const MaterialPage(
                  child: ProfilePage(),
                ),
                routes: [],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
