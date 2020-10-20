import 'package:flutter/material.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({Key key, this.post}) : super(key: key);
  
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.author)
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              // decoration: BoxDecoration(
              //   color: Colors.lightBlue,
              //   shape: BoxShape.circle
              // ),
              child:
                widget.post.images != null ? 
                new Swiper(
                  itemBuilder: (BuildContext context,int index){
                    String url = widget.post.images[index].url;
                    if(url.startsWith('http')){
                      return new Image.network(url, fit: BoxFit.fitHeight);
                    }else{
                      return new Image.asset(url, fit:BoxFit.fitHeight);
                    }
                    
                    // return new Image.asset('images/others/hs00${index+1}.jpeg', fit:BoxFit.fitHeight);
                    // return new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
                  },
                  itemCount: widget.post.images.length > 0 ? widget.post.images.length : 0,
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(),
                )
                :
                Text('NO IMAGE'),
            ),

            Card(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Text(widget.post.title)),
            Card(child: Text(widget.post.content)),
            Divider(color: Colors.blue,),
            // Text(widget.post.comments[0].content),
            // Text(widget.post.comments[0].author),

            ListView.separated(
              itemBuilder: (BuildContext context, int index){
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('title ${index}'),
                      Divider(),
                      Text('content'),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('author'),
                          Text('date')
                        ],
                      )
                    ],
                  ),
                );
              }, 
              separatorBuilder: (context, index) => Divider(
                height: 50,
              ), 
              itemCount: widget.post.comments.length
            )
          ],
        ),
      ),
    );
  }
}