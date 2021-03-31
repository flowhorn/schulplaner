import 'package:flutter/material.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'package:schulplaner8/models/planner.dart';

class OrderableExample extends StatefulWidget {
  final LoadAllPlannerStatus loadAllPlannerStatus;
  final PlannerLoaderBloc plannerLoaderBloc;
  final ValueWidgetBuilder<Planner> builder;
  OrderableExample(
      this.plannerLoaderBloc, this.loadAllPlannerStatus, this.builder,
      {Key? key})
      : super(key: key);
  @override
  _OrderableExampleState createState() =>
      _OrderableExampleState(plannerLoaderBloc, loadAllPlannerStatus, builder);
}

class ItemData {
  ItemData(this.id, this.planner) : key = ValueKey(id);

  final String id;
  final Planner planner;

  // Each item in reorderable list needs stable and unique key
  final Key? key;
}

class _OrderableExampleState extends State<OrderableExample> {
  final LoadAllPlannerStatus loadAllPlannerStatus;
  final PlannerLoaderBloc loadAllPlanner;
  final ValueWidgetBuilder<Planner> builder;
  late List<ItemData> _items;
  late Map<String, Planner> accountmap;
  late Map<String, int> accountorder;

  _OrderableExampleState(
      this.loadAllPlanner, this.loadAllPlannerStatus, this.builder) {
    accountmap = loadAllPlannerStatus.plannermap;
    accountorder = loadAllPlannerStatus.plannerordermap!;
    _items = [];
    _items.addAll(accountmap.values.map((account) => ItemData(
          account.id,
          account,
        )));
    _items.sort((ItemData a, ItemData b) {
      return ((accountorder)[b.id] ?? -1).compareTo((accountorder)[a.id] ?? -1);
    });
  }

  bool _reorderCallback(int draggingIndex, int newPositionIndex) {
    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;
    print('Reordering');
    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint('Reordering ' +
          draggingIndex.toString() +
          ' -> ' +
          newPositionIndex.toString());
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);

      List reverseditems = _items.reversed.toList();
      Map<String, int> neworder = {};
      for (ItemData i in reverseditems) {
        int index = reverseditems.indexOf(i);
        neworder[i.id] = index;
      }
      loadAllPlanner.setNewPlannerOrder(neworder);
    });
    return true;
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: _reorderCallback,
      children: [
        for (final item in _items)
          Item(
            key: ValueKey(item.id),
            data: item,
            // first and last attributes affect border drawn during dragging
            child: builder(context, item.planner, null),
          )
      ],
    
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final ItemData data;

  // Builds decoration for list item; During dragging we don't want top border on first item
  // and bottom border on last item
/*
  BoxDecoration _buildDecoration(BuildContext context, bool dragging) {
    return BoxDecoration(
        border: Border(
            top: first && !dragging
                ? Divider.createBorderSide(context) //
                : BorderSide.none,
            bottom: last && dragging
                ? BorderSide.none //
                : Divider.createBorderSide(context)));
  }

  Widget _buildChild(BuildContext context, bool dragging) {
    return child;
  }
*/

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
