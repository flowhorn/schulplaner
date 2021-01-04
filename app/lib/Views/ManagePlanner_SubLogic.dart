import 'package:flutter/material.dart';
import 'package:schulplaner8/Extras/ReordableList.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_loader_bloc.dart';
import 'package:schulplaner8/app_base/src/models/load_all_planner_status.dart';
import 'package:schulplaner8/models/planner.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class OrderableExample extends StatefulWidget {
  final LoadAllPlannerStatus loadAllPlannerStatus;
  final PlannerLoaderBloc plannerLoaderBloc;
  final ValueWidgetBuilder<Planner> builder;
  OrderableExample(
      this.plannerLoaderBloc, this.loadAllPlannerStatus, this.builder,
      {Key key})
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
  final Key key;
}

class _OrderableExampleState extends State<OrderableExample> {
  final LoadAllPlannerStatus loadAllPlannerStatus;
  final PlannerLoaderBloc loadAllPlanner;
  final ValueWidgetBuilder<Planner> builder;
  List<ItemData> _items;
  Map<String, Planner> accountmap;
  Map<String, int> accountorder;

  _OrderableExampleState(
      this.loadAllPlanner, this.loadAllPlannerStatus, this.builder) {
    accountmap = loadAllPlannerStatus.plannermap;
    accountorder = loadAllPlannerStatus.plannerordermap;
    _items = [];
    _items.addAll(accountmap.values.map((account) => ItemData(
          account.id,
          account,
        )));
    _items.sort((ItemData a, ItemData b) {
      return ((accountorder ?? {})[b.id] ?? -1)
          .compareTo((accountorder ?? {})[a.id] ?? -1);
    });
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    for (int i = 0; i < _items.length; ++i) {
      if (_items[i].key == key) return i;
    }
    return -1;
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint(
          'Reordering ' + item.toString() + ' -> ' + newPosition.toString());
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
    return ReorderableList(
      onReorder: _reorderCallback,
      child: UpListView(
        items: _items,
        builder: (BuildContext c, item) {
          int index = _items.indexOf(item);
          return Item(
            data: _items[index],
            // first and last attributes affect border drawn during dragging
            first: index == 0,
            last: index == _items.length - 1,
            child: builder(context, _items[index].planner, null),
          );
        },
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item({this.data, this.first, this.last, this.child});

  final Widget child;
  final ItemData data;
  final bool first;
  final bool last;

  // Builds decoration for list item; During dragging we don't want top border on first item
  // and bottom border on last item
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

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild,
        decorationBuilder: _buildDecoration);
  }
}
