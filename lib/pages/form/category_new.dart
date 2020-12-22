import 'package:flutter/material.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/pages/list/category_select.dart';

class CategoryNewPage extends StatefulWidget {
  @override
  _CategoryNewPageState createState() => _CategoryNewPageState();
}

class _CategoryNewPageState extends State<CategoryNewPage> {
  final _formKey = GlobalKey<FormState>();

  int _pid;
  int _categoryId;

  TextEditingController _categoryTextController = new TextEditingController();
  TextEditingController _titleTextController = new TextEditingController();
  TextEditingController _contentTextController = new TextEditingController();

  CategoryNode category;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发表评论"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                    //_submitComment(context);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _titleTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: '分类标题：',
                ),
                validator: (String value){
                  if(value.isEmpty)
                    return '标题不能为空';
                  return null;

                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _categoryTextController,
                      decoration: InputDecoration(
                        labelText: "父类别："
                      ),
                      readOnly: true,
                      onTap: ()async{
                        category = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return CategorySelector(treeJson: "", editable: false,);
                          }) 
                        );

                        if(category != null){
                          print('result: ${category.key} - ${category.label}');
                          _categoryTextController.text = category.label;
                          
                          String _key = category.key;
                          String _type = _key.split('_')[0];
                          if(_type.isNotEmpty || _type == "c"){
                            _categoryId = int.parse(_key.split('_')[1]);
                            print('got category id ${_categoryId}');
                          }
                        }      
                      },
                    ),
                  ),
                ],
              ),

              Expanded(
                child: TextFormField(
                  controller: _contentTextController,
                  decoration: InputDecoration(
                    labelText: '分类描述：',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}