import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

const List<String> urls = [
  'images/1.jpg',
  'images/2.jpg',
  'images/3.jpg',
  'images/4.jpg',
];

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isTagging = false;
  List<PhotoState> photoStates = List.of(urls.map((url) => PhotoState(url)));

  void toggleTagging(String url) {
    setState(() {
      isTagging = !isTagging;
      photoStates.forEach((element) {
        if (isTagging && element.url == url) {
          element.selected == true;
        } else {
          element.selected == false;
        }
      });
    });
  }

  void onPhotoSelect(String url, bool selected) {
    setState(() {
      photoStates.forEach((element) {
        if (element.url == url) {
          element.selected == selected;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Photo Viewer",
      home: GalleryPage(
        title: "Image Gallery",
        photoStates: photoStates,
        tagging: isTagging,
        toggleTagging: toggleTagging,
        onPhotoSelect: onPhotoSelect,
      ),
    );
  }
}

class PhotoState {
  String url;
  bool selected;

  PhotoState(this.url, {this.selected = false});
}

class GalleryPage extends StatelessWidget {
  final String title;
  final List<PhotoState> photoStates;
  final bool tagging;

  final Function toggleTagging;
  final Function onPhotoSelect;

  GalleryPage({
    required this.title,
    required this.photoStates,
    required this.tagging,
    required this.toggleTagging,
    required this.onPhotoSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.count(
        primary: true,
        crossAxisCount: 2,
        children: photoStates
            .map((ps) => Photo(
                  state: ps,
                  selectable: tagging,
                  onLongPress: toggleTagging,
                  onSelect: onPhotoSelect,
                ))
            .toList(),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  final PhotoState state;
  final bool selectable;
  final Function onLongPress;
  final Function onSelect;

  const Photo(
      {required this.state,
      required this.selectable,
      required this.onLongPress,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      GestureDetector(
        child: Image.network(state.url),
        onLongPress: () => onLongPress(state.url),
      ),
    ];
    if (selectable) {
      children.add(Positioned(
          left: 20,
          top: 0,
          child: Theme(
            data: Theme.of(context)
                .copyWith(unselectedWidgetColor: Colors.grey[200]),
            child: Checkbox(
              onChanged: (value) {
                onSelect(state.url, value);
              },
              value: state.selected,
              activeColor: Colors.white,
              checkColor: Colors.red,
            ),
          )));
    }

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Stack(
        alignment: Alignment.center,
        children: children,
      ),
    );
  }
}
