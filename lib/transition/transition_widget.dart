// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';

// import 'transition_bloc.dart';
// import 'transition_page.dart';

// class TransitionWidget<T extends TransitionBloc> extends StatelessWidget {
//   const TransitionWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Selector<T, TransitionPage>(
//       selector: (_, bloc) => bloc.state.visiblePage,
//       builder: (context, page, _) {
//         var buildScreen = page.buildScreen(context);
//         final providers = page.getPageProviders();
//         if (providers.isEmpty) {
//           return buildScreen;
//         }
//         return MultiProvider(
//           key: ValueKey<int>(page.hashCode),
//           providers: providers,
//           child: buildScreen,
//         );
//       },
//     );
//   }
// }
