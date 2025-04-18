import 'package:go_router/go_router.dart';
import 'package:bart_app/common/utility/bart_router.dart';


// go syntax 
//  ---> GoRouter.of(context).go('/path');
//  ---> context.go('/path');


/// Helper extension for [GoRouter] that adds custom methods to allow easy navigation.
extension BartGoRouter on BartRouter {

  static String get currentLocation => BartRouter
      .router.routerDelegate.currentConfiguration.matches.last.matchedLocation;

  void bartGo(String path) {
    final currentPath = currentLocation;

    if (currentPath == path) {
      return;
    }

    // if(currentPath == '/'){
    //   go(path);
    //   return;
    // }
    

  }
}
