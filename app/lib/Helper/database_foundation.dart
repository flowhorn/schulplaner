import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

typedef T ObjectBuilder<T>(String id, Map<String, dynamic> data);
typedef bool ItemFilter<T>(T item);
typedef String GetKey<T>(T item);
typedef T DataCreator<T, T2>(T item, T2 secondary);
typedef void VoidData<T>(T item);
typedef int Sorter<T>(T item1, T item2);
enum ChangeType { ADDED, MODIFIED, REMOVED }
ChangeType fromDocumentChange(DocumentChangeType type) {
  switch (type) {
    case DocumentChangeType.added:
      return ChangeType.ADDED;
    case DocumentChangeType.modified:
      return ChangeType.MODIFIED;
    case DocumentChangeType.removed:
      return ChangeType.REMOVED;
  }
  return null;
}

class DataDocumentPackage<T> {
  DocumentReference reference;
  final bool directlyLoad, lockedOnStart, loadNullData;
  final ObjectBuilder<T> objectBuilder;
  bool _isinitiated = false;
  bool _islocked = false;
  bool _loadedData = false;
  List<StreamController<T>> _list_streamcontroller;
  List<StreamController<T>> _list_streamcontroller_once;
  StreamSubscription<DocumentSnapshot> _listener;
  DataDocumentPackage(
      {@required this.reference,
      @required this.objectBuilder,
      this.directlyLoad = false,
      this.lockedOnStart = false,
      this.loadNullData = false}) {
    _list_streamcontroller = [];
    _list_streamcontroller_once = [];
    if (lockedOnStart) _islocked = true;
    if (directlyLoad) {
      _initiate();
    }
  }

  T data;

  Stream<T> get stream {
    if (_islocked == false) if (_isinitiated == false) _initiate();
    StreamController<T> newcontroller = StreamController();
    _list_streamcontroller.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _list_streamcontroller.remove(newcontroller);
    };
    return newcontroller.stream;
  }

  Future<T> get once {
    if (_islocked == false) if (_isinitiated == false) _initiate();
    if (_loadedData) {
      return Future.value(data);
    } else {
      StreamController<T> newcontroller = StreamController();
      _list_streamcontroller_once.add(newcontroller);
      return newcontroller.stream.first;
    }
  }

  void _initiate() {
    _isinitiated = true;
    _listener = reference.snapshots().listen((event) {
      if (_loadedData == false) _loadedData = true;
      if (event.exists) {
        data = objectBuilder(event.id, event.data());
        for (StreamController<T> controller in _list_streamcontroller) {
          controller.add(data);
        }
        for (StreamController<T> controller in _list_streamcontroller_once) {
          controller.add(data);
        }
        _list_streamcontroller_once.clear();
      } else {
        if (loadNullData) {
          data = objectBuilder(event.id, event.data());
        } else {
          data = null;
        }
        for (StreamController<T> controller in _list_streamcontroller) {
          controller.add(data);
        }
        for (StreamController<T> controller in _list_streamcontroller_once) {
          controller.add(data);
        }
        _list_streamcontroller_once.clear();
      }
    });
  }

  void close() {
    if (_isinitiated) {
      _listener.cancel();
    }
  }

  void unlock({DocumentReference newreference}) {
    _islocked = false;
    if (newreference != null) reference = newreference;
    if (_list_streamcontroller.isNotEmpty && _isinitiated == false) {
      _initiate();
    }
  }
}

class DataCombinedPackage<T> {
  List<StreamController<Map<String, T>>> _list_streamcontroller;
  List<StreamController<Map<String, T>>> _list_streamcontroller_once;
  final GetKey<T> getKey;
  DataCombinedPackage({@required this.getKey}) {
    _list_streamcontroller = [];
    _list_streamcontroller_once = [];
    data = {};
  }

  Map<String, T> data;

  Stream<T> getItemStream(String id) {
    if (getKey == null) {
      throw Exception('Missing Implementation for getKey');
    } else {
      return getItemFilteredStream((item) => getKey(item) == id);
    }
  }

  Stream<T> getItemFilteredStream(ItemFilter<T> filter) {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _list_streamcontroller.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _list_streamcontroller.remove(newcontroller);
    };
    return newcontroller.stream.map((data) {
      Iterable<T> iterable = data?.values?.where(filter);
      if ((iterable?.length ?? 0) > 0) {
        return iterable.first;
      } else {
        return null;
      }
    });
  }

  Stream<Map<String, T>> get stream {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _list_streamcontroller.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _list_streamcontroller.remove(newcontroller);
    };
    return newcontroller.stream;
  }

  Future<Map<String, T>> get once {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _list_streamcontroller_once.add(newcontroller);
    return newcontroller.stream.first;
  }

  T getItem(String key) {
    return data[key];
  }

  void close() {}

  void updateData(T item, ChangeType type) {
    switch (type) {
      case ChangeType.ADDED:
        {
          if (item != null) {
            String key = getKey(item);
            data[key] = item;
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller) {
              controller.add(data);
            }
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller_once) {
              controller.add(data);
            }
            _list_streamcontroller_once.clear();
          }
          break;
        }
      case ChangeType.MODIFIED:
        {
          if (item != null) {
            String key = getKey(item);
            data[key] = item;
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller) {
              controller.add(data);
            }
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller_once) {
              controller.add(data);
            }
            _list_streamcontroller_once.clear();
          }
          break;
        }
      case ChangeType.REMOVED:
        {
          if (item != null) {
            String key = getKey(item);
            data.remove(key);
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller) {
              controller.add(data);
            }
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller_once) {
              controller.add(data);
            }
            _list_streamcontroller_once.clear();
          }
          break;
        }
    }
  }

  void removeWhere(ItemFilter<T> filter) {
    data.removeWhere((key, item) => filter(item));
    for (StreamController<Map<String, T>> controller
        in _list_streamcontroller) {
      controller.add(data);
    }
    for (StreamController<Map<String, T>> controller
        in _list_streamcontroller_once) {
      controller.add(data);
    }
    _list_streamcontroller_once.clear();
  }
}

class DataCombinedPackageSpecial<T, T2> {
  List<StreamController<Map<String, T>>> _list_streamcontroller;
  List<StreamController<Map<String, T>>> _list_streamcontroller_once;
  final GetKey<T> getKey;
  final GetKey<T2> getKeySecondary;
  final DataCreator<T, T2> dataCreator;
  DataCombinedPackageSpecial(
      {@required this.getKey,
      @required this.getKeySecondary,
      @required this.dataCreator}) {
    _list_streamcontroller = [];
    _list_streamcontroller_once = [];
    data = {};
    secondarydata = {};
  }

  Map<String, T> data;
  Map<String, T2> secondarydata;

  Stream<T> getItemStream(String id) {
    if (getKey == null) {
      throw Exception('Missing Implementation for getKey');
    } else {
      return getItemFilteredStream((item) => getKey(item) == id);
    }
  }

  Stream<T> getItemFilteredStream(ItemFilter<T> filter) {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _list_streamcontroller.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _list_streamcontroller.remove(newcontroller);
    };
    return newcontroller.stream.map((data) => data?.values?.firstWhere(filter));
  }

  Stream<Map<String, T>> get stream {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _list_streamcontroller.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _list_streamcontroller.remove(newcontroller);
    };
    return newcontroller.stream;
  }

  Future<Map<String, T>> get once {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _list_streamcontroller_once.add(newcontroller);
    return newcontroller.stream.first;
  }

  void close() {}

  void notifyDataSetChanged() {
    for (StreamController<Map<String, T>> controller
        in _list_streamcontroller) {
      controller.add(data);
    }
  }

  void updateData(T preitem, ChangeType type) {
    if (preitem != null) {
      T item = dataCreator(preitem, secondarydata[getKey(preitem)]);
      switch (type) {
        case ChangeType.ADDED:
          {
            String key = getKey(item);
            data[key] = item;
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller) {
              controller.add(data);
            }
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller_once) {
              controller.add(data);
            }
            _list_streamcontroller_once.clear();
            break;
          }
        case ChangeType.MODIFIED:
          {
            String key = getKey(item);
            data[key] = item;
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller) {
              controller.add(data);
            }
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller_once) {
              controller.add(data);
            }
            _list_streamcontroller_once.clear();
            break;
          }
        case ChangeType.REMOVED:
          {
            String key = getKey(item);
            data.remove(key);
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller) {
              controller.add(data);
            }
            for (StreamController<Map<String, T>> controller
                in _list_streamcontroller_once) {
              controller.add(data);
            }
            _list_streamcontroller_once.clear();
            break;
          }
      }
    }
  }

  void updateDataSecondary(T2 itemsecondary, ChangeType type) {
    switch (type) {
      case ChangeType.ADDED:
        {
          if (itemsecondary != null) {
            String key = getKeySecondary(itemsecondary);
            secondarydata[key] = itemsecondary;
          }
          break;
        }
      case ChangeType.MODIFIED:
        {
          if (itemsecondary != null) {
            String key = getKeySecondary(itemsecondary);
            secondarydata[key] = itemsecondary;
          }
          break;
        }
      case ChangeType.REMOVED:
        {
          if (itemsecondary != null) {
            String key = getKeySecondary(itemsecondary);
            secondarydata.remove(key);
          }
          break;
        }
    }
    if (itemsecondary != null) {
      String key = getKeySecondary(itemsecondary);
      T newdata = dataCreator(data[key], secondarydata[key]);
      if (newdata != null) {
        data[key] = newdata;
      }
      for (StreamController<Map<String, T>> controller
          in _list_streamcontroller) {
        controller.add(data);
      }
      for (StreamController<Map<String, T>> controller
          in _list_streamcontroller_once) {
        controller.add(data);
      }
      _list_streamcontroller_once.clear();
    }
  }

  void removeWhere(ItemFilter<T> filter) {
    data.removeWhere((key, item) => filter(item));
    for (StreamController<Map<String, T>> controller
        in _list_streamcontroller) {
      controller.add(data);
    }
    for (StreamController<Map<String, T>> controller
        in _list_streamcontroller_once) {
      controller.add(data);
    }
    _list_streamcontroller_once.clear();
  }
}

class DataCollectionPackage<T> {
  Query reference;
  final bool directlyLoad, lockedOnStart;
  final ObjectBuilder<T> objectBuilder;
  final GetKey<T> getKey;
  final Sorter<T> sorter;
  bool _isinitiated = false;
  bool _islocked = false;
  bool _loadedData = false;

  List<StreamController<List<T>>> _list_streamcontroller;
  List<StreamController<List<T>>> _list_streamcontroller_once;
  StreamSubscription<QuerySnapshot> _listener;
  DataCollectionPackage(
      {@required this.reference,
      @required this.objectBuilder,
      this.getKey,
      this.directlyLoad = false,
      this.lockedOnStart = false,
      this.sorter}) {
    _list_streamcontroller = [];
    _list_streamcontroller_once = [];
    if (lockedOnStart) _islocked = true;
    if (directlyLoad) {
      _initiate();
    }
  }

  List<T> data = [];

  T getItem(String id) {
    if (id == null) return null;
    if (getKey == null) {
      throw Exception('Missing Implementation for getKey');
    } else {
      return getItemByFilter((item) => getKey(item) == id);
    }
  }

  T getItemByFilter(ItemFilter<T> filter) {
    Iterable<T> iterable = data?.where(filter);
    if (iterable != null && iterable.isNotEmpty) {
      return iterable.first;
    } else {
      return null;
    }
  }

  Stream<T> getItemStream(String id) {
    if (getKey == null) {
      throw Exception('Missing Implementation for getKey');
    } else {
      return getItemFilteredStream((item) => getKey(item) == id);
    }
  }

  Stream<T> getItemFilteredStream(ItemFilter<T> filter) {
    if (_islocked == false) if (_isinitiated == false) _initiate();
    StreamController<List<T>> newcontroller = StreamController();
    _list_streamcontroller.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _list_streamcontroller.remove(newcontroller);
    };
    return newcontroller.stream.map((data) => data.firstWhere(filter));
  }

  Stream<List<T>> getFilteredStream(ItemFilter<T> filter) {
    if (_islocked == false) if (_isinitiated == false) _initiate();
    StreamController<List<T>> newcontroller = StreamController();
    _list_streamcontroller.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _list_streamcontroller.remove(newcontroller);
    };
    return newcontroller.stream.map((data) => data.where(filter).toList());
  }

  Stream<List<T>> get stream {
    if (_islocked == false) if (_isinitiated == false) _initiate();
    StreamController<List<T>> newcontroller = StreamController();
    _list_streamcontroller.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _list_streamcontroller.remove(newcontroller);
    };
    return newcontroller.stream;
  }

  Future<List<T>> get once {
    if (_islocked == false) if (_isinitiated == false) _initiate();
    if (_loadedData) {
      return Future.value(data);
    } else {
      StreamController<List<T>> newcontroller = StreamController();
      _list_streamcontroller_once.add(newcontroller);
      return newcontroller.stream.first;
    }
  }

  void _initiate() {
    _isinitiated = true;
    _listener = reference.snapshots().listen((querySnapshot) {
      if (_loadedData == false) _loadedData = true;
      final documents =
          querySnapshot.docs.where((docSnapshot) => docSnapshot.exists);
      final dataObjects = documents
          .map((docSnapshot) =>
              objectBuilder(docSnapshot.id, docSnapshot.data()))
          .toList();
      dataObjects.removeWhere((it) => it == null);
      if (sorter != null) dataObjects.sort(sorter);
      data = dataObjects;
      for (StreamController<List<T>> controller in _list_streamcontroller) {
        controller.add(data);
      }
      for (StreamController<List<T>> controller
          in _list_streamcontroller_once) {
        controller.add(data);
      }
      _list_streamcontroller_once.clear();
    });
  }

  void close() {
    if (_isinitiated) {
      _listener.cancel();
    }
  }

  void unlock({Query newreference}) {
    _islocked = false;
    if (newreference != null) reference = newreference;
    if (_list_streamcontroller.isNotEmpty && _isinitiated == false) {
      _initiate();
    }
  }
}
