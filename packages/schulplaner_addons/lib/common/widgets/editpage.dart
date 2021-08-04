//
import 'package:schulplaner_addons/common/widgets/pickers.dart';
import 'package:schulplaner_addons/common/widgets/widgets.dart';
import 'package:schulplaner_addons/tools/image/cloud_photo.dart';
import 'package:schulplaner_addons/utils/date_utils.dart' as date_utils;
import 'package:schulplaner_addons/utils/file_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum EditPageType { edit, create }

class EditPage<T> extends StatefulWidget {
  final ValueNotifier<T> data;
  final EditPageType editPageType;
  final ValueWidgetBuilder<T> builder;
  final bool Function(T data) onFinished;
  EditPage({
    required this.data,
    required this.editPageType,
    required this.onFinished,
    required this.builder,
  });
  @override
  State<StatefulWidget> createState() => _EditPageState<T>();
}

class _EditPageState<T> extends State<EditPage<T>> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
        valueListenable: widget.data,
        builder: (context, data, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.editPageType == EditPageType.create
                  ? 'Erstellen'
                  : 'Bearbeiten'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              controller: scrollController,
              child: widget.builder(context, data, null),
            ),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  bool result = widget.onFinished(data);
                  if (result == true) Navigator.pop(context);
                },
                icon: Icon(Icons.done),
                label: Text('Fertig')),
          );
        });
  }
}

class EditTextField extends StatelessWidget {
  final String initialValue;
  final void Function(String newText) onChanged;
  final IconData? iconData;
  final String? label, hint;
  final int? maxLines, maxLength;

  EditTextField(
      {required this.initialValue,
      required this.onChanged,
      this.iconData,
      this.label,
      this.hint,
      this.maxLength,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 6.0,
        right: 6.0,
        top: 6.0,
        bottom: 6.0,
      ),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: iconData != null ? Icon(iconData) : null,
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        maxLength: maxLength,
        maxLines: maxLines,
      ),
    );
  }
}

class EditDateField extends StatelessWidget {
  final String? date;
  final void Function(String newDate) onChanged;
  final String? label;
  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  EditDateField({
    required this.date,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 6.0,
        right: 6.0,
        top: 6.0,
        bottom: 6.0,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: isSelected,
        builder: (context, value, _) {
          return InkWell(
            child: InputDecorator(
              isEmpty: date == null,
              isFocused: value,
              decoration: InputDecoration(
                labelText: label,
                icon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 18.0,
                  child: date == null
                      ? Container()
                      : Text(date_utils.DateUtils.getDateText(date!),
                          style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
            onTap: () {
              isSelected.value = true;
              selectDate(context, initialDate: date).then((newDate) {
                if (newDate != null) onChanged(newDate);
                isSelected.value = false;
              });
            },
          );
        },
      ),
    );
  }
}

class EditTimeField extends StatelessWidget {
  final TimeOfDay? timeOfDay;
  final void Function(TimeOfDay newTimeOfDay) onChanged;
  final String? label;
  final void Function(BuildContext context)? onRemoved;
  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  EditTimeField({
    required this.timeOfDay,
    required this.onChanged,
    this.onRemoved,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 6.0,
        right: 6.0,
        top: 6.0,
        bottom: 6.0,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: isSelected,
        builder: (context, value, _) {
          return InkWell(
            child: InputDecorator(
              isEmpty: timeOfDay == null,
              isFocused: value,
              decoration: InputDecoration(
                  labelText: label,
                  icon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                  suffixIcon: (onRemoved != null && timeOfDay != null)
                      ? IconButton(
                          onPressed: () => onRemoved!(context),
                          icon: Icon(Icons.cancel),
                        )
                      : null),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 18.0,
                  child: timeOfDay == null
                      ? Container()
                      : Text(timeOfDay!.format(context),
                          style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
            onTap: () {
              isSelected.value = true;
              selectTime(context, initialTime: timeOfDay).then((newTime) {
                if (newTime != null) onChanged(newTime);
                isSelected.value = false;
              });
            },
          );
        },
      ),
    );
  }
}

class EditCustomField extends StatelessWidget {
  final String? value;
  final Future<void> Function(BuildContext context) onClicked;
  final IconData? iconData;
  final String? label;
  final void Function(BuildContext context)? onRemoved;
  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  EditCustomField({
    required this.value,
    required this.onClicked,
    this.iconData,
    this.label,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 6.0,
        right: 6.0,
        top: 6.0,
        bottom: 6.0,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: isSelected,
        builder: (context, selected, _) {
          return InkWell(
            onTap: () {
              isSelected.value = true;
              onClicked(context).then((_) {
                isSelected.value = false;
              });
            },
            child: InputDecorator(
              isEmpty: value == null,
              isFocused: selected,
              decoration: InputDecoration(
                  labelText: label,
                  icon: Icon(iconData),
                  border: OutlineInputBorder(),
                  suffixIcon: (onRemoved != null && value != null)
                      ? IconButton(
                          onPressed: () => onRemoved!(context),
                          icon: Icon(Icons.cancel),
                        )
                      : null),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 18.0,
                  child: value == null
                      ? Container()
                      : Text(value!, style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditPhotoField extends StatelessWidget {
  final CloudPhoto cloudPhoto;
  final void Function() onClickedRemove;
  final void Function(LocalFile file) onAddedFile;
  EditPhotoField(
      {required this.cloudPhoto,
      required this.onClickedRemove,
      required this.onAddedFile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 6.0,
        top: 6.0,
        bottom: 6.0,
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            radius: 48.0,
            child: cloudPhoto == null
                ? Icon(
                    Icons.person,
                    size: 48.0,
                  )
                : CachedNetworkImage(
                    imageUrl: cloudPhoto.compUrl!,
                  ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Text(
                    'Profilfoto',
                    style: TextStyle(fontSize: 19.0),
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  RoundButton(
                    label: 'Neues Bild',
                    onTap: () {
                      selectImage(context, resize: true).then((localFile) {
                        if (localFile != null) {
                          onAddedFile(localFile);
                        }
                      });
                    },
                  ),
                  if (cloudPhoto != null)
                    RoundButton(
                      label: 'Entfernen',
                      onTap: () {
                        onClickedRemove();
                      },
                    ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
