import 'package:flutter/material.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fossils_finder/pages/list/comment_submit.dart';

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
      body: ListView.builder(
        itemCount: widget.post.comments.length + 2,
        itemBuilder: (BuildContext context, int index){
          if(index == 0){                                            // post content
            return Container(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.post.title, 
                      style: TextStyle(
                        //backgroundColor: Colors.yellow, 
                        color: Colors.blue,
                        fontSize: 30,

                        ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      height: 200,
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
                          },
                          itemCount: widget.post.images.length > 0 ? widget.post.images.length : 0,
                          pagination: new SwiperPagination(),
                          control: new SwiperControl(),
                        )
                        :
                        Text('NO IMAGE'),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      
                      child: Text(
                        widget.post.content,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.lightBlue,

                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
            );


          }else if(index == widget.post.comments.length + 1){     // submit button
            return Container(
              padding: EdgeInsets.all(5),
              child: RaisedButton(
                onPressed: (){
                  print('submit comment button clicked');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CommentSubmitPage();
                    }) 
                  );
                },
                child: Text('Submit Comment'),
                textColor: Colors.green,
              ),
            );


          }else{                                                  // comments
            return Container(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Text('Comment ${index}'),
              ),
            );


          }
        }),
    );
  }
}