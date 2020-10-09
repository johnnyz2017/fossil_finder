import 'package:flutter/material.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

// class SwiperTestPage extends StatefulWidget {
//   final String title;

//   const SwiperTestPage({Key key, this.title}) : super(key: key);

//   @override
//   _SwiperTestPageState createState() => _SwiperTestPageState();
// }

// class _SwiperTestPageState extends State<SwiperTestPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SwipeStack(
//       children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int index) {
//         return SwiperItem(
//                   builder: (SwiperPosition position, double progress) {
//                       return Material(
//                           elevation: 4,
//                           borderRadius: BorderRadius.all(Radius.circular(6)),
//                           child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.all(Radius.circular(6)),
//                               ),
//                               child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                       Text("Item $index", style: TextStyle(color: Colors.black, fontSize: 20)),
//                                       Text("Progress $progress", style: TextStyle(color: Colors.blue, fontSize: 12)),
//                                   ],
//                               )
//                           )
//                       );
//                   }
//               );
//           }).toList(),
//           visibleCount: 3,
//           stackFrom: StackFrom.Top,
//           translationInterval: 6,
//           scaleInterval: 0.03,
//           onEnd: () => debugPrint("onEnd"),
//           onSwipe: (int index, SwiperPosition position) => debugPrint("onSwipe $index $position"),
//           onRewind: (int index, SwiperPosition position) => debugPrint("onRewind $index $position"),
//       );
//   }
// }



class SwiperTestPage extends StatefulWidget {
  
  final Post post;

  const SwiperTestPage({Key key, this.post}) : super(key: key);

  @override
  _SwiperTestPageState createState() => new _SwiperTestPageState();
}

class _SwiperTestPageState extends State<SwiperTestPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.post.title),
      ),
    body:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 200,
          // decoration: BoxDecoration(
          //   color: Colors.lightBlue,
          //   shape: BoxShape.circle
          // ),
          child: new Swiper(
              itemBuilder: (BuildContext context,int index){
                return new Image.asset('images/others/hs00${index+1}.jpeg', fit:BoxFit.fitHeight);
                // return new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
              },
              itemCount: 3,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
        ),

        Card(
          margin: EdgeInsets.only(left: 10, top: 10),
          child: Text(widget.post.title)),
        Card(child: Text(widget.post.content)),
        Divider(color: Colors.blue,),
        Text(widget.post.comments[0].content),
        Text(widget.post.comments[0].author),
      ],
    ),
    );
  }
}