import 'package:flutter/material.dart';
import 'bloc_provider.dart';

class MultiBlocProvider extends StatelessWidget {
  /// The [BlocProvider] list which is converted into
  /// a tree of [BlocProvider] widgets.
  ///
  /// The tree of [BlocProvider] widgets is created in order meaning
  /// the first [BlocProvider] will be the top-most [BlocProvider] and
  /// the last [BlocProvider] will be a direct ancestor of the [child] [Widget].
  ///
  /// Each provider's `child` will be discarded, so giving `child` to each
  /// provider makes no sense.
  final List<BlocProvider> blocProviders;

  /// The [Widget] and its descendants which will have access to
  /// every `BloC` provided by [blocProviders].
  ///
  /// This [Widget] will be a direct descendent of
  /// the last [BlocProvider] in [blocProviders].
  final Widget child;

  const MultiBlocProvider({
    Key key,
    @required this.blocProviders,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tree = child;
    for (final blocProvider in blocProviders.reversed) {
      tree = blocProvider.copyWith(tree);
    }
    return tree;
  }
}
