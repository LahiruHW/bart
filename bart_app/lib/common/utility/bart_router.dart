import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/index.dart';
import 'package:bart_app/common/entity/index.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

class BartRouter {
  static final _rootNavKey = GlobalKey<NavigatorState>();
  static final _homeNavKey = GlobalKey<NavigatorState>();
  static final _chatNavKey = GlobalKey<NavigatorState>();
  static final _marketNavKey = GlobalKey<NavigatorState>();
  static final _marketListedItemsNavKey = GlobalKey<NavigatorState>();
  static final _marketRequestsNavKey = GlobalKey<NavigatorState>();
  static final _profileNavKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/login-base',
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

      GoRoute(
        name: 'viewImage',
        path: '/viewImage',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final String imgUrl = data['imgUrl'] as String;
          final String imgKey = data['imgKey'] as String;
          return MaterialPage(
            child: ViewImagePage(
              imgUrl: imgUrl,
              imgKey: imgKey,
            ),
            maintainState: false,
          );
        },
      ),

      // ShellRoute for the app AFTER the user has logged in
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavKey,
        restorationScopeId: 'root',
        builder: (context, state, child) => Base(bodyWidget: child),
        branches: [
          // StatefulShellBranch for the HOME tab ----------------------------------------------
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            restorationScopeId: 'home',
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
                    routes: [
                      GoRoute(
                        name: 'editTrade',
                        path: 'editTrade',
                        builder: (context, state) {
                          final data = state.extra as Map<String, dynamic>;
                          final trade = data['trade'] as Trade;
                          return trade.offeredItem.isPayment
                              ? EditTradePagePayment(trade: trade)
                              : EditTradePageOffer(trade: trade);
                        },
                        onExit: (context, state) {
                          final tempProvider = Provider.of<TempStateProvider>(
                            context,
                            listen: false,
                          );
                          tempProvider.clearAllTempData();
                          return true;
                        },
                      )
                    ],
                  ),
                  GoRoute(
                    name: 'newItem',
                    path: 'newItem',
                    parentNavigatorKey: _homeNavKey,
                    builder: (context, state) {
                      return const NewItemPage(
                        isReturnOffer: false,
                        returnForItem: null,
                      );
                    },
                    onExit: (context, state) {
                      final tempProvider = Provider.of<TempStateProvider>(
                        context,
                        listen: false,
                      );
                      tempProvider.clearAllTempData();
                      return true;
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
            restorationScopeId: 'chat',
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
            restorationScopeId: 'market',
            routes: [
              // Sub StatefulShellBranch for the MARKET tab ---------------------------------------------
              StatefulShellRoute.indexedStack(
                restorationScopeId: 'market-base',
                builder: (context, state, child) => MarketBase(
                  bodyWidget: child,
                ),
                branches: [
                  StatefulShellBranch(
                    navigatorKey: _marketListedItemsNavKey,
                    restorationScopeId: 'market-listed-items',
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _marketListedItemsNavKey,
                        name: "market/listed-items", // market/listed-items
                        path: '/market/listed-items',
                        pageBuilder: (context, state) {
                          return MaterialPage(
                            child: MarketListedItemsPage(
                              parentContext: _rootNavKey.currentContext!,
                            ),
                            maintainState: true,
                          );
                        },
                        routes: [
                          GoRoute(
                            name: 'item', // market/listed-items/item/:id
                            path: 'item/:id',
                            parentNavigatorKey: _marketNavKey,
                            pageBuilder: (context, state) {
                              final itemID = state.pathParameters['id']!;
                              Item item = state.extra as Item;
                              return MaterialPage(
                                key: ValueKey(itemID),
                                child: ItemPage(
                                  itemID: itemID,
                                  item: item,
                                ),
                              );
                            },
                            routes: [
                              GoRoute(
                                name:
                                    'editItem', // market/listed-items/item/:id/editItem
                                path: 'editItem',
                                builder: (context, state) {
                                  final data =
                                      state.extra as Map<String, dynamic>;
                                  final item = data['item'] as Item;
                                  return EditItemPage(tradedItem: item);
                                },
                                onExit: (context, state) {
                                  final tempProvider =
                                      Provider.of<TempStateProvider>(context,
                                          listen: false);
                                  tempProvider.clearAllTempData();
                                  return true;
                                },
                              ),
                              GoRoute(
                                name:
                                    'returnItem', // market/listed-items/item/:id/returnItem
                                path: 'returnItem',
                                builder: (context, state) {
                                  Item item = state.extra as Item;
                                  return ReturnOfferPage(returnForItem: item);
                                },
                                routes: [
                                  GoRoute(
                                    name: 'tradeResult',
                                    path: 'tradeResult',
                                    builder: (context, state) {
                                      final data =
                                          state.extra as Map<String, dynamic>;
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    navigatorKey: _marketRequestsNavKey,
                    routes: [
                      GoRoute(
                          parentNavigatorKey: _marketRequestsNavKey,
                          name: 'market/requests',
                          path: '/market/requests',
                          pageBuilder: (context, state) {
                            return MaterialPage(
                              child: MarketRequestsPage(
                                parentContext: _rootNavKey.currentContext!,
                              ),
                              maintainState: true,
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // StatefulShellBranch for the PROFILE tab ---------------------------------------------
          StatefulShellBranch(
            navigatorKey: _profileNavKey,
            restorationScopeId: 'profile',
            routes: [
              GoRoute(
                name: "profile",
                path: "/profile",
                pageBuilder: (context, state) => const MaterialPage(
                  child: ProfilePage(),
                ),
                routes: const [],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
