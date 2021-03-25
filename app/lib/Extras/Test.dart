import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Item {
  late String? id, name, date;
  late bool? enabled;

  Item({
    this.id,
    this.name,
    this.date,
    this.enabled,
  });

  Item.fromData(dynamic data) {
    id = data['id'];
    name = data['name'];
    enabled = data['enabled'];
    date = data['date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'enabled': enabled,
      'date': date,
    };
  }

  Item copyWith({
    String? id,
    String? name,
    String? date,
    bool? enabled,
  }) {
    return Item(
      id: this.id ?? id,
      name: this.name ?? name,
      date: this.date ?? date,
      enabled: this.enabled ?? enabled,
    );
  }
}

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .snapshots()
            .map((snap) {
          return snap.docs.map((snap) => Item.fromData(snap.data)).toList();
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            final items = snapshot.data ?? [];
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.name ?? '-'),
                  );
                });
          }
        });
  }
}

class DetailItemView extends StatelessWidget {
  final String itemid;
  DetailItemView({
    required this.itemid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Item?>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .doc(itemid)
          .snapshots()
          .map((snap) {
        if (snap.exists) {
          return Item.fromData(snap.data);
        } else {
          return null;
        }
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final item = snapshot.data;
          return Text(item?.name ?? '-');
        }
      },
    );
  }
}
