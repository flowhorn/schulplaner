import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Jessica_on_the_CLEO_Thailand_magazine_%28cropped%29.png/255px-Jessica_on_the_CLEO_Thailand_magazine_%28cropped%29.png",
                width: 42.0,
                height: 42.0,
              ),
            ),
            title: Text("Jessica"),
            subtitle: Text("Hey wie gehts?"),
          )
        ],
      ),
      bottomNavigationBar: FlatButton.icon(
          onPressed: () {}, icon: Icon(Icons.add), label: Text("Neuer Chat")),
    );
  }
}
