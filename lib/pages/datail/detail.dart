import 'dart:async';
import 'dart:io';
import 'package:FlutterNews/support/util/StringsLocation.dart';
import 'package:FlutterNews/support/util/date_util.dart';
// import 'package:FlutterNews/support/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class DetailPage extends StatelessWidget {
  final _img;
  final _title;
  final _date;
  final _content;
  final _description;
  final _link;
  final _category;
  final _origin;

  DetailPage(this._img, this._title, this._date, this._content,
      this._description, this._category, this._link, this._origin);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_origin),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              shareNotice();
            },
            color: Colors.white,
          )
        ],
      ),
      body: new Container(
        // margin: new EdgeInsets.all(2.0),
        child: new Container(
          // elevation: 4.0,
          // borderRadius: new BorderRadius.circular(6.0),
          child: new ListView(
            children: <Widget>[
              new Hero(tag: _title, child: _getImageNetwork(_img)),
              // child: _getImageNetwork(
              //     Functions.getImgResizeUrl(_img, 250, ''))),
              _getBody(_title, _date, _content, _origin, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getImageNetwork(url) {
    try {
      if (url != '') {
        return ClipRRect(
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(6.0), topRight: Radius.circular(6.0)),
          child: new Container(
            height: 250.0,
            child: new FadeInImage.assetNetwork(
              placeholder: 'assets/place_holder.jpg',
              image: url,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return new Container(
          height: 200.0,
          child: new Image.asset('assets/place_holder_3.jpg'),
        );
      }
    } catch (e) {
      return new Container(
        height: 200.0,
        child: new Image.asset('assets/place_holder_3.jpg'),
      );
    }
  }

  Widget _getBody(tittle, date, content, origin, context) {
    return new Container(
      margin: new EdgeInsets.all(5.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTittle(tittle),
          _getDate(date, origin),
          _getContent(content, context),
          // _getAntLink(),
          // _getLink(_link, context)
        ],
      ),
    );
  }

  Widget _getAntLink() {
    return new Container(
      margin: new EdgeInsets.only(top: 30.0),
      child: new Text(
        "Mais detalhes acesse:",
        style:
            new TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
      ),
    );
  }

  Widget _getLink(link, context) {
    return new GestureDetector(
      child: new Text(
        link,
        style: new TextStyle(color: Colors.blue),
      ),
      onTap: () {
        _launchURL(link, context);
      },
    );
  }

  _getTittle(tittle) {
    return new Text(
      tittle,
      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, fontFamily: 'Lora'),
    );
  }

  _getDate(date, origin) {
    return new Container(
      margin: new EdgeInsets.only(top: 4.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            new DateUtil().buildDate(date),
            style: new TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'Lora'),
          ),
          new Text(
            origin,
            style: new TextStyle(fontSize: 12.0, color: Colors.grey, fontFamily: 'Lora'),
          )
        ],
      ),
    );
  }

  _getContent(content, context) {
    return new Container(
      margin: new EdgeInsets.only(top: 20.0),
      child: new HtmlWidget(
        content,
        // builderCallback: (meta, e) => lazySet(null, buildOp: styleTextOp),
        hyperlinkColor: Colors.black,
        textStyle: new TextStyle(fontSize: 16.0, color: Colors.grey[700], fontFamily: 'Lora'),
        onTapUrl: (link) => _launchURL(link, context),
      ),
    );
  }

  _launchURL(url, context) async {
    if (Platform.isAndroid) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    } else {
      Clipboard.setData(new ClipboardData(text: url));
      _showDialog(context);
    }
  }

  Future shareNotice() async {
    await Share.share("$_title:\n$_link");
  }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(getString("text_copy")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(getString("text_fechar")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final styleTextOp = BuildOp(
    onPieces: (meta, pieces) {
      // print('---------------------------------');
      // print('Pieces: ' + pieces.toString());
      // print('Meta To String: ' + meta.toString());
      // print(meta);
      final alt = meta.domElement.attributes['style'];
      // print('Alt: ' + alt);
      final styleText = "style:'font-size: 30px;'";
      // pieces.toString();
      // print(pieces..first?.toString());
      // print(pieces..first?.block?.toString());
      if (alt == 'text-align: right;') {
        print('tex');
        return pieces
          ..first.block.style.apply(fontSizeDelta: 2, fontSizeFactor: 2);
      } else {
        print('else');
        return pieces..first?.block?.addText('oiii');
      }
    },
  );
}
