


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_words/random_words.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class Painter extends CustomPainter{
  List<Pointclass> points;
  
  @override
  Painter({this.points});
  void paint(Canvas canvas, Size size) {

for (var i = 0; i < points.length-1; i++) {
  if(points[i]!=null && points[i+1]!=null){
    Paint paint=Paint()
..color=points[i+1].colors
..strokeJoin=StrokeJoin.round
..strokeCap=StrokeCap.round
..strokeWidth=points[i+1].strokewidth;
    canvas.drawLine(points[i].points, points[i+1].points, paint);
  }

}
  }




  @override
  bool shouldRepaint(Painter oldDelegate) {
  
    return oldDelegate.points!=points;
  
  }
}

class Pointclass{
  Offset points;
  Color colors;
  double strokewidth;
  Pointclass({this.points,this.colors,this.strokewidth});
}


class _HomeState extends State<Home> {
   Size size; 
   Color colors=Colors.black;
   Color backgroundcolor=Colors.white;
   double strokewidth=5;
 List<List<Pointclass>> list=[];
 List<Pointclass> points=<Pointclass>[];
 GlobalKey globalKey=GlobalKey();
DocumentReference instance;
int incrementer;
List  loselist=[];
List<bool> isselected=[true,false];
bool selected=true;
WordNoun randomword;
TextEditingController textEditingController;
GlobalKey<FormState> formkey=GlobalKey();
bool startgame;
 @override
  void initState() {
   
    super.initState();
 instance=Firestore.instance.collection('users').document('points');
    // instance.delete();
 incrementer=0;
 startgame=false;
  }



         body(AsyncSnapshot snapshot){
           if(selected!=true)
           {points.clear();
           loselist.clear();
           
if(snapshot.hasData){
  
   randomword=WordNoun(snapshot.data.documents[2]['randomword']); 
 

for (var i = 0; i <= snapshot.data.documents[0]['incrementer']; i++) {
  

loselist=List.from(snapshot.data.documents[1]['Pointclass$i']);
for (var im = 0; im< loselist.length; im++) {
  if(im==loselist.length-1){
points.add(null);
}else{
points=new List.from(points)..add(Pointclass(
  points:Offset(loselist[im]['pointsdx'],loselist[im]['pointsdy']) ,
  colors: Color(loselist[im]['colors']),
  strokewidth: double.parse('${loselist[im]['strokewidth']}')     
));

}
}
}
print(loselist.length);
}
         }else{print('off');}
  return    Center(
        child:
       ClipRect(child:Container(
         decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2),color: backgroundcolor),
 height: size.height*0.7,width:size.width*0.8,key: globalKey,child:

selected!=true? CustomPaint(
  painter: Painter(points:points),
  
         ):

        GestureDetector(onPanUpdate: (details)async{
           setState(() {
      
     points =  List.from(points)..add(Pointclass(points: details.localPosition,colors:colors,strokewidth: strokewidth));

       print(points.length);
       startgame==true?
     Firestore.instance.collection('users').document('points').setData({
  
       'Pointclass$incrementer':FieldValue.arrayUnion([{'pointsdx':details.localPosition.dx,'pointsdy':details.localPosition.dy,'colors':colors.value,'strokewidth':strokewidth}])
     },merge:true):
     print('start game off');
list.clear();
          });
       
         
        },onPanEnd: (details)async{
setState(() {
  points.add(null);
if(startgame==true)
{  Firestore.instance.collection('users').document('points').updateData({
  'Pointclass$incrementer':FieldValue.arrayUnion([{'pointsdx':points.last,'pointsdy':points.last,'colors':points.last,'strokewidth':points.last}])
     });
     Firestore.instance.collection('users').document('incrementer').updateData({
       'incrementer':incrementer
     });
}else print('startgame off');
   incrementer++;  
});


 
        },child:
         CustomPaint(
  painter: Painter(points:points),
  
         )
)

)
 ,
      )  );
        
      }  
      








  @override
  Widget build(BuildContext context) {
   
    size=MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context,
        builder:(context){
        return
        selected!=true? 
         AlertDialog(content:Form(
        key: formkey,
        child:
         TextFormField(
           controller: textEditingController,
          validator: (word){
            RegExp regExp=RegExp(randomword.asString,caseSensitive: false);
            if(regExp.hasMatch(word)){
              startgame=false;
              return 'win';
            }else return'try again';
          },
        ),),
        actions: <Widget>[
          FlatButton(onPressed: (){
            
            formkey.currentState.validate();
          }, child:Text('OK'))
        ],
        )
        :AlertDialog(content: Text('option not available'),);
        }
        );
      },
      
      child:Icon(Icons.border_color)),
      
      bottomNavigationBar:
     
       BottomNavigationBar(type: BottomNavigationBarType.fixed,unselectedItemColor:Colors.blue,
      items: 
     [ BottomNavigationBarItem(icon: Icon(Icons.undo),title: Text('undo')),
     BottomNavigationBarItem(icon: Icon(Icons.redo),title: Text('redo')),
     BottomNavigationBarItem(icon: Icon(Icons.close),title: Text('erase'))
     ],
    onTap: (index){
    if(  selected!=true){
       print('index =$index');}else
   { switch (index) {
      case 0:
           
      if(points.length!=0){
int  listindex=  points.lastIndexWhere((pointclass){
  return pointclass==null;
        },points.length-2);
       print(listindex);
      
      if(listindex ==-1){
        list.clear();
        points.clear();
         Firestore.instance.collection('users').document('points').delete();
         incrementer=0;
         Firestore.instance.collection('users').document('incrementer').updateData(
           {
             'incrementer':incrementer
           }
         );
      }else{
         list.add(points.sublist(listindex+1));
       print('list lenght ${list.length}');
       incrementer--;
         Firestore.instance.collection('users').document('incrementer').updateData(
           {
             'incrementer':incrementer-1
           }
         );
       Firestore.instance.collection('users').document('points').updateData({
         'Pointclass$incrementer':FieldValue.delete()
       });
   
      points.removeRange(listindex, points.length-1);
      }
      }
       
       break;

      case 1:
          
      if(points.length!=0 && list.length!=0){
   
        points.addAll(list.last);
        for (var i = 0; i < list.last.length; i++) {
          if(i==list.last.length-1){
            instance.updateData({
       
             'Pointclass$incrementer':FieldValue.arrayUnion([{
               'pointsdx':list.last[i],'pointsdy':list.last[i],'colors':list.last[i],'strokewidth':list.last[i]
             }])
                 

         });
          }else{
           instance.updateData({
       
             'Pointclass$incrementer':FieldValue.arrayUnion([{
               'pointsdx':list.last[i].points.dx,'pointsdy':list.last[i].points.dy,'colors':list.last[i].colors.value,'strokewidth':list.last[i].strokewidth
             }])
           });
    } 
        }
       
         incrementer++;
         Firestore.instance.collection('users').document('incrementer').updateData(
           {
             'incrementer':incrementer
           }
         );
       list.removeLast();
        print('executed');
      }
     
      break;

      case  2:
  if(selected!=true){
    print('cannot delete');
  }else
      {
        points.clear();
        list.clear();
         Firestore.instance.collection('users').document('points').delete();
         incrementer=0;
         Firestore.instance.collection('users').document('incrementer').updateData(
           {
             'incrementer':incrementer
           }
         );
    }
        break;
        
      
      default:
      points.clear();
       Firestore.instance.collection('users').document('points').delete();
       incrementer=0;
       Firestore.instance.collection('users').document('incrementer').updateData(
           {
             'incrementer':incrementer
           }
         );
       
    }}
    },
     ),
      
      appBar: AppBar(title: Text('Scribble'),
      actions: <Widget>[
        
        Padding(padding: EdgeInsets.all(10),child: 
        Container(child:selected==true?
        Text('word:$randomword',):Text('guess'),color: Colors.deepPurpleAccent,padding: EdgeInsets.all(10),)
        )
      ],
      
      ),
      
      drawer: Drawer(
        child:ListView(children: <Widget>[
          DrawerHeader(child:Padding(padding: EdgeInsets.only(top: size.height*0.1),
          child: Text('Settings',
          style: TextStyle(fontSize: 30,color: Colors.white),
            )  ),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: Colors.blue)),
         ListTile(leading:Icon(Icons.color_lens,color: Colors.blue,
                     ),
         title: Text('Color',style: TextStyle(fontSize: 20),),
         onTap: (){
           showDialog(context: context,builder:(BuildContext context){

           return AlertDialog(
             title: Text('Pick color'),
         content:
          MaterialPicker(pickerColor:colors, onColorChanged: (updatecolor){
        
             colors=updatecolor;
         }),
         actions: <Widget>[
          
           FlatButton(onPressed: (){
             Navigator.pop(context);
           }, child: Text('OK',))
         ],
              );} );
         },

         ),
         ListTile(
           leading:Icon(Icons.brush,color: Colors.blue,),
           title: Text('brush thickness',style: TextStyle(fontSize: 20),),
           onTap: (){
             showDialog(context: context,
             builder: (BuildContext context){
              return AlertDialog(
               title: Text('Enter size'),
               content:
             TextField(keyboardType: TextInputType.numberWithOptions(decimal: true),
                 onChanged: (string){
                  strokewidth=double.parse(string);
               },),
               actions: <Widget>[
                 FlatButton(onPressed: (){
                   Navigator.pop(context);
                 }, child: Text('OK'))
               ],
                );
             });
           },
         ),
         ListTile(
           leading: Icon(Icons.crop_portrait,color: Colors.blue,),
           title: Text('background color',style: TextStyle(fontSize: 20),),
           onTap: (){
  
 showDialog(context: context,builder:(BuildContext context){

           return AlertDialog(
             title: Text('Pick color'),
         content:
          MaterialPicker(pickerColor:backgroundcolor, onColorChanged: (updatecolor){
        setState(() {
           backgroundcolor=updatecolor;
        });
           
         }),
         actions: <Widget>[
          
           FlatButton(onPressed: (){
             Navigator.pop(context);
           }, child: Text('OK',))
         ],
              );} );



         },),


      //    ListTile(title: 
      //    ToggleButtons(children:[
      //    Text('draw'),Text('download')], isSelected: 
      //   isselected,
      // onPressed: (index){
      //   switch (index) {
      //     case 0:
      //     setState(() {
      //        isselected=[true,false];
      //        selected=true;
      //     });
           
      //       break;
      //       case 1:
      //       setState(() {
      //         isselected=[false,true];
      //         selected=false;
      //       });
      //       break;

      //     default:print('error');
      //   }
      // },),
      //    ),

      //    ListTile(title: 
      //    Text('randomword'),onTap: (){
      //      selected==true?
      //    setState(() {
      //      isselected=[true,false];
      //        randomword=WordNoun.random();
      //        Firestore.instance.collection('users').document('randomword').updateData({
      //          'randomword':'$randomword'
      //        });
      //      print(randomword);  
      //    })  
      //      :showDialog(context: context,child: AlertDialog(
      //        content: Text('option is not available'),
      //      ));
           
      //    },),


        ListTile(
          leading: Icon(Icons.games,color: Colors.blue,),
          title: Text('Start a game',style: TextStyle(fontSize: 20),),
          onTap: (){
            showDialog(context: context,
          child:AlertDialog(
            title: Text('Pick a mode'),
            content: Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
              ListTile(onTap: (){
                setState(() {
                  startgame=true;
                  selected=true; 
                  isselected=[true,false];
             randomword=WordNoun.random();
             Firestore.instance.collection('users').document('randomword').updateData({
               'randomword':'$randomword'
             });
             Firestore.instance.collection('users').document('points').delete();
             incrementer=0;
              points.clear();
                 list.clear();
                 loselist.clear();
           print(randomword);  
         }) ;

              }, title: Text('Draw')),
              ListTile(onTap: (){
                setState(() {
                  startgame=true;
                 isselected=[false,true];
                 selected=false; 
                 points.clear();
                 list.clear();
                 loselist.clear();
                 
                });

              }, title: Text('Guess')),
              
              
            ],),
          )
            );
          },
        ),
ListTile(title: Text('Exit game',style: TextStyle(fontSize: 20)),onTap: (){
                startgame=false;
                selected=true;
              },)


        ],)
      ),
      body:StreamBuilder(stream: Firestore.instance.collection('users').snapshots(),
      
      builder: (BuildContext context,AsyncSnapshot snapshot){
return body(snapshot);
      }));
      
 
     
} 
}     