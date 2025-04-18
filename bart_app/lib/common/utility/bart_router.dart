import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/index.dart';
import 'package:bart_app/common/entity/index.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/utility/bart_route_handler.dart';
import 'package:bart_app/common/utility/bart_app_update_checker.dart';
// import 'package:bart_app/common/utility/bart_firebase_analytics.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

class BartRouter {
  static final rootNavKey = GlobalKey<NavigatorState>();
  static final _homeNavKey = GlobalKey<NavigatorState>();
  static final _homeTradesNavKey = GlobalKey<NavigatorState>();
  static final _homeServicesNavKey = GlobalKey<NavigatorState>();
  static final _chatNavKey = GlobalKey<NavigatorState>();
  static final _marketNavKey = GlobalKey<NavigatorState>();
  static final _marketListedItemsNavKey = GlobalKey<NavigatorState>();
  static final _marketServicesNavKey = GlobalKey<NavigatorState>();
  static final _profileNavKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavKey,
    initialLocation: '/login',
    // redirect: (context, state) {
    // },
    routes: [
      GoRoute(
        name: "login",
        path: '/login',
        pageBuilder: (context, state) {
          BartAppUpdateChecker.startupConfigCheck(context);
          return const MaterialPage(
            child: LoginTypeSelectPage(),
          );
        },
        onExit: (context, state) {
          BartRouteHandler.preExitCallbacks(context);
          return true;
        },
        redirect: (context, state) {
          debugPrint("**************** CHECKING REDIRECTION ****************");
          final provider = Provider.of<BartStateProvider>(
            context,
            listen: false,
          );
          final userProf = provider.userProfile;
          if (userProf.userID.isNotEmpty) {
            // BartAnalyticsEngine.setCurrentUID(provider.userProfile.userID);
            if (userProf.isFirstLogin) {
              return '/onboard';
            }
            return '/home-trades';
          }
          return null;
        },
      ),

      GoRoute(
        name: "onboard",
        path: '/onboard',
        pageBuilder: (context, state) {
          BartAppUpdateChecker.startupConfigCheck(context);
          // BartAnalyticsEngine.userBeginsOnboarding();
          return const MaterialPage(
            child: OnboardingPage(),
          );
        },
        onExit: (context, state) {
          // BartAnalyticsEngine.userEndsOnboarding();
          // BartAnalyticsEngine.logAppClose();
          BartRouteHandler.preExitCallbacks(context);
          return true;
        },
      ),

      GoRoute(
        name: "settings",
        path: '/settings',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final bool expandAll = data['beginAllExpanded'] as bool;
          return MaterialPage(
            child: SettingsPage(
              beginAllExpanded: expandAll,
            ),
            maintainState: false,
          );
        },
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

      GoRoute(
        name: 'privacyPolicy',
        path: '/privacyPolicy',
        pageBuilder: (context, state) {
          final fileName = state.extra as String;
          return MaterialPage(
            child: PrivacyPolicyPage(
              fileName: fileName,
            ),
          );
        },
      ),

      // GoRoute(
      //   name:'unsupportedDevice',
      //   path: '/unsupportedDevice',
      //   pageBuilder: (context, state) {

      //   },
      // ),

      // ShellRoute for the app AFTER the user has logged in
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavKey,
        restorationScopeId: 'root',
        builder: (context, state, child) => Base(bodyWidget: child),
        branches: [
          // StatefulShellBranch for the HOME tab ----------------------------------------------
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            restorationScopeId: 'home',
            routes: [
              // new Sub StatefulShellBranch for the HOME tab ---------------------------------------------
              StatefulShellRoute.indexedStack(
                restorationScopeId: 'home-base',
                pageBuilder: (context, state, child) {
                  return MaterialPage(
                    child: HomePageBase(bodyWidget: child),
                  );
                },
                parentNavigatorKey: _homeNavKey,
                branches: [
                  StatefulShellBranch(
                    navigatorKey: _homeTradesNavKey,
                    routes: [
                      GoRoute(
                        name: 'home-trades',
                        path: '/home-trades',
                        parentNavigatorKey: _homeTradesNavKey,
                        pageBuilder: (context, state) {
                          BartAppUpdateChecker.startupConfigCheck(context);
                          return const MaterialPage(
                            child: HomeTradesPage(),
                          );
                        },
                        routes: const [],
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    navigatorKey: _homeServicesNavKey,
                    routes: [
                      GoRoute(
                        name: 'home-services',
                        path: '/home-services',
                        parentNavigatorKey: _homeServicesNavKey,
                        pageBuilder: (context, state) => const MaterialPage(
                          maintainState: true,
                          child: HomeServicesPage(),
                        ),
                        routes: const [],
                      ),
                    ],
                  ),
                ],
              ),

              // home page subroutes that use up the whole screen
              GoRoute(
                parentNavigatorKey: _homeNavKey,
                name: 'test1',
                path: '/test1',
                pageBuilder: (context, state) => const MaterialPage(
                  child: TestPage1(),
                ),
              ),

              GoRoute(
                name: 'viewTrade',
                path: '/viewTrade',
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
                      BartRouteHandler.preExitCallbacks(context);
                      return true;
                    },
                  )
                ],
              ),

              GoRoute(
                name: 'newItem',
                path: '/newItem',
                parentNavigatorKey: _homeNavKey,
                builder: (context, state) {
                  return const NewItemPage(
                    isReturnOffer: false,
                    returnForItem: null,
                  );
                },
                onExit: (context, state) {
                  BartRouteHandler.preExitCallbacks(context);
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
                          // BartAnalyticsEngine.userGoToListedItems();
                          return const MaterialPage(
                            maintainState: true,
                            child: MarketListedItemsPage(),
                          );
                        },
                        routes: const [],
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    navigatorKey: _marketServicesNavKey,
                    restorationScopeId: 'market-services',
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _marketServicesNavKey,
                        name: 'market/services',
                        path: '/market/services',
                        pageBuilder: (context, state) {
                          return MaterialPage(
                            child: MarketServicesPage(
                              parentContext: rootNavKey.currentContext!,
                            ),
                            maintainState: true,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // market subsection that used up the whole screen
              GoRoute(
                name: 'item', // /item/:id
                path: '/item/:id',
                parentNavigatorKey: _marketNavKey,
                pageBuilder: (context, state) {
                  final itemID = state.pathParameters['id']!;
                  Item item = state.extra as Item;
                  // BartAnalyticsEngine.userGoToItemPage(itemID);
                  return CustomTransitionPage(
                    child: ItemPage(item: item, itemID: itemID),
                    barrierColor: Theme.of(context).scaffoldBackgroundColor,
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  );
                },
                routes: [
                  GoRoute(
                    name: 'editItem', // /item/:id/editItem
                    path: 'editItem',
                    builder: (context, state) {
                      final data = state.extra as Map<String, dynamic>;
                      final item = data['item'] as Item;
                      return EditItemPage(tradedItem: item);
                    },
                    onExit: (context, state) {
                      BartRouteHandler.preExitCallbacks(context);
                      return true;
                    },
                  ),
                  GoRoute(
                    name: 'returnItem', // /item/:id/returnItem
                    path: 'returnItem',
                    builder: (context, state) {
                      Item item = state.extra as Item;
                      return ReturnOfferPage(returnForItem: item);
                    },
                    onExit: (context, state) {
                      BartRouteHandler.preExitCallbacks(context);
                      return true;
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
