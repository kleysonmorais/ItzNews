import 'package:FlutterNews/support/util/date_util.dart';
// import 'package:FlutterNews/support/util/functions.dart';
import 'package:FlutterNews/pages/datail/detail.dart';
import 'package:flutter/material.dart';

class Notice extends StatelessWidget {
  var img;
  var title;
  var date;
  var content;
  var description;
  var category;
  var link;
  var origin;

  AnimationController animationController;

  Notice(this.img, this.title, this.date, this.content, this.description,
      this.category, this.link, this.origin);

  Notice.fromMap(Map<String, dynamic> map)
      : img = map['url_img'],
        title = map['title']['rendered'],
        date = map['date'],
        content = map['content']['rendered'],
        description = map['excerpt']['rendered'],
        // category = map['category'],
        category = 'Categoria',
        link = map['guid']['rendered'],
        origin = 'Imperatriz Notícias';

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return new GestureDetector(
      onTap: _handleTapUp,
      child: new Container(
        margin: const EdgeInsets.only(
            left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
        child: new Material(
          borderRadius: new BorderRadius.circular(6.0),
          elevation: 2.0,
          child: _getListTile(),
        ),
      ),
    );
  }

  Widget _getListTile() {
    return new Container(
      height: 390.0,
      child: new Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Hero(
            tag: title,
            child: _getImgWidget(img),
            // child: _getImgWidget(Functions.getImgResizeUrl(img, 200, 200)),
          ),
          _getColumText(title, date, description)
        ],
      ),
    );
  }

  _handleTapUp() {
    Navigator.of(_context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new DetailPage(
          img, title, date, content ,description, category, link, origin);
    }));
  }

  Widget _getColumText(tittle, date, description) {
    return new Expanded(
        child: new Container(
      margin: new EdgeInsets.all(10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 100,
            child: _getTitleWidget(title),
          ),
          _getDateWidget(date),
          // _getDescriptionWidget(description)
        ],
      ),
    ));
  }

  Widget _getImgWidget(String url) {
    return new Container(
      // width: 95.0,
      height: 250.0,
      child: new ClipRRect(
        borderRadius: new BorderRadius.only(
            topRight: const Radius.circular(6.0),
            topLeft: const Radius.circular(6.0)),
        child: _getImageNetwork(url),
      ),
    );
  }

  Widget _getImageNetwork(String url) {
    try {
      if (url.isNotEmpty) {
        return new FadeInImage.assetNetwork(
          placeholder: 'assets/place_holder.jpg',
          image: url,
          fit: BoxFit.cover,
        );
      } else {
        return new Image.asset('assets/place_holder.jpg');
      }
    } catch (e) {
      return new Image.asset('assets/place_holder.jpg');
    }
  }

  Widget _getTitleWidget(String curencyName) {
    return new Container(
      padding: EdgeInsets.all(15.0),
      child: new Text(
        curencyName,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: new TextStyle(fontSize: 18.0, color: Colors.grey),
      ),
    );
  }

  Widget _getDescriptionWidget(String description) {
    return new Container(
      margin: new EdgeInsets.only(top: 5.0),
      child: new Text(
        description,
        maxLines: 2,
      ),
    );
  }

  Widget _getDateWidget(String date) {
    // return new Text(
    //   new DateUtil().buildDate(date),
    //   style: new TextStyle(color: Colors.grey, fontSize: 10.0),
    // );
    return new Text(new DateUtil().buildDate(date),
        textAlign: TextAlign.center,
        style: new TextStyle(color: Colors.blue, fontSize: 15.0));
  }
}
