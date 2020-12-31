import 'package:flutter/material.dart';

Future<T> showSheet<T>(
    {@required BuildContext context,
    @required Widget child,
    String title}) async {
  return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return new Opacity(
          opacity: 1.0,
          child: Material(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 6.0,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 4.0,
                    width: MediaQuery.of(context).size.width / 6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        color: Colors.grey[500]),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                if (title != null) ...[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      title ?? "-",
                      style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500]),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                ],
                child,
                SizedBox(
                  height: 16.0,
                ),
              ],
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        );
      });
}
