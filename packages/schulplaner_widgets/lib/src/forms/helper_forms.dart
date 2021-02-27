//@dart=2.11
import 'package:flutter/material.dart';
import 'form_header.dart';
import '../theme/app_theme.dart';

class FormHideable extends StatefulWidget {
  final String title;
  final WidgetBuilder builder;
  final ValueNotifier<bool> notifier;

  const FormHideable(
      {@required this.title, @required this.notifier, @required this.builder});

  @override
  State<StatefulWidget> createState() => _FormHideableState();
}

class _FormHideableState extends State<FormHideable>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.notifier,
        builder: (context, value, _) {
          return Column(
            children: <Widget>[
              FormHeaderAdvanced(
                widget.title,
                trailing: IconButton(
                    icon: Icon(value ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      widget.notifier.value = !(widget.notifier.value);
                    }),
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 250),
                vsync: this,
                child: value ? widget.builder(context) : Container(),
              ),
            ],
          );
        });
  }
}

class FormStreamHideable extends StatefulWidget {
  final Stream<bool> shouldShow;
  final String title;
  final WidgetBuilder builder;
  final Function(bool) switchState;

  const FormStreamHideable({
    Key key,
    @required this.shouldShow,
    @required this.title,
    @required this.builder,
    @required this.switchState,
  }) : super(key: key);
  @override
  _FormStreamHideableState createState() => _FormStreamHideableState();
}

class _FormStreamHideableState extends State<FormStreamHideable>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: widget.shouldShow,
        builder: (context, snapshot) {
          final shouldShowValue = snapshot.data;
          return Column(
            children: <Widget>[
              FormHeaderAdvanced(
                widget.title,
                trailing: IconButton(
                    icon: Icon(shouldShowValue
                        ? Icons.expand_less
                        : Icons.expand_more),
                    onPressed: () {
                      widget.switchState(!shouldShowValue);
                    }),
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 250),
                vsync: this,
                child: shouldShowValue ? widget.builder(context) : Container(),
              ),
            ],
          );
        });
  }
}

class FormSection extends StatelessWidget {
  final String title;
  final Widget child;
  const FormSection({this.title, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (title != null) FormHeader2(title.toUpperCase()),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: getDividerColor(context)),
          ),
          child: child,
          margin: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 2.0,
            bottom: 4.0,
          ),
          clipBehavior: Clip.antiAlias,
        ),
      ],
    );
  }
}

class FormSectionText extends StatelessWidget {
  final TextSpan text;

  const FormSectionText({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
      child: RichText(
        text: text,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class DefaultTextSpan extends TextSpan {
  DefaultTextSpan(BuildContext context, String text)
      : super(
          text: text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: getClearTextColor(context),
          ),
        );
}
