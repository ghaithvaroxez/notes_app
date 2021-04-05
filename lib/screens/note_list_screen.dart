import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/widgets/list_item.dart';
import 'package:provider/provider.dart';
import 'package:flutternotes/helper/note_provider.dart';
import 'package:flutternotes/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

import 'note_edit_screen.dart';

class NoteListScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<NoteProvider>(context,listen:false).getNotes(),
      builder: (context,Snapshot)
        {
          if(Snapshot.connectionState==ConnectionState.waiting)
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );



          else
            {
             if(Snapshot.connectionState==ConnectionState.done)
               {
                 return Scaffold(
                   backgroundColor: Color(0xFFf5f5f5),
                   body: Consumer<NoteProvider>(
                     child: noNotesUI(context),
                     builder: (context,noteprovider,child)=>noteprovider.items.length<=0?child:

                 ListView.builder(
        itemCount: noteprovider.items.length + 1,
        itemBuilder: (context, index)
        {
          if (index == 0)
          {
            return header();
          }
          else
          {
            final i = index - 1;
            final item = noteprovider.items[i];
            return ListItem(
              id: item.id,
              title: item.title,
              content: item.content,
              imagePath: item.imagePath,
              date: item.date,
            );
          }
        },
      ),

                   ),
                   floatingActionButton: FloatingActionButton(
                     onPressed: (){
                       goToNoteEditScreen(context);
                     },
                     child: Icon(Icons.add,
                     color:Colors.white70),
                     backgroundColor: Colors.lightGreen,),
                 );
               }
             return Container(
               color: Colors.blue,
             );
            }



        }



    );
  }


}
_launchUrl() async{
  const url='https://www.facebook.com/profile.php?id=100005986361663';
  if(await canLaunch(url))
  {
    await launch(url);
  }
  else
  {
    throw 'Faild';
  }
}
Widget header()
{
  return Container(
    decoration: BoxDecoration
      (
      color: headerColor,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(75.0),

      ),
    ),
    height: 150,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Notes'
          ,style: headerNotesStyle,

        ),
        SizedBox(height: 5,),
        GestureDetector(
          onTap: _launchUrl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
Image(
  image: AssetImage("assets/fb.png"),
  height: 20,
  width: 20,
),
              Text(
                'Ghaith Malas',
                style: headerRideStyle,
              ),
            ],
          ),
        ),


      ],
    ),
  );
}

Widget noNotesUI(BuildContext context)
{
  return Container(
    color: Colors.white,
    child: ListView(

      children: [
        header(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:50),
              child: Image.asset(
                'assets/cry.png'
                ,fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),

            ),
            RichText(text: TextSpan(
                style: noNotesStyle,
                children: [
                  TextSpan(text: 'There is no note available\nTap on "'),
                  TextSpan(
                      text: '+',
                      style: boldPlus,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          goToNoteEditScreen(context);
                        }),
                  TextSpan(text: '" to add new note'),
                ]
            ),
            ),
          ],
        ),
      ],
    ),
  ) ;
}
void goToNoteEditScreen(BuildContext context) {
  Navigator.of(context).pushNamed(NoteEditScreen.route);
}
