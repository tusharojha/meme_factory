import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'models/memes.dart';

void main() => runApp(MemeFactory());

class MemeFactory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Meme Factory',
      theme: CupertinoThemeData(),
      home: HomePage(title: 'Meme Factory'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;
  int item = 0;
  Memes memesData;

  TextEditingController topTextController, bottomTextController;

  void loadMemeImages() async {
    http.Response response =
        await http.get('http://alpha-meme-maker.herokuapp.com/$page/');
    if (response.statusCode == 200) {
      setState(() {
        memesData = Memes.fromJSON(jsonDecode(response.body));
      });
    } else {
      throw Exception("Failed to load memes");
    }
  }

  void nextImage() {
    if (memesData.memes.length - item != 1) {
      setState(() {
        item++;
      });
    } else {
      setState(() {
        item = 0;
        page++;
      });
    }

    print(page);
    print(item);
  }

  @override
  void initState() {
    super.initState();
    loadMemeImages();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
              'http://www.pngall.com/wp-content/uploads/2016/05/Trollface.png'),
        ),
        middle: Text(widget.title),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: memesData == null
                        ? Image.network('https:\/\/i.imgflip.com\/1otk96.jpg')
                        : Image.network(
                      memesData.memes[item].imageUrl,
                      height: 300,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 300,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () {
                    nextImage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(CupertinoIcons.shuffle_thick),
                      ),
                      Text('Change Image'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CupertinoTextField(
                  controller: topTextController,
                  padding: EdgeInsets.all(10),
                  placeholder: 'Enter Top Text',
                  suffix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: CupertinoColors.activeGreen,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CupertinoTextField(
                  controller: bottomTextController,
                  padding: EdgeInsets.all(10),
                  placeholder: 'Enter Bottom Text',
                  suffix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: CupertinoColors.activeGreen,
                    ),
                  ),
                ),
              ),
              CupertinoButton.filled(
                child: Text('Save Image'),
                onPressed: () {
                  print('Save image btn pressed');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
