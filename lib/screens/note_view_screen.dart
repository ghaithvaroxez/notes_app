import 'package:flutter/material.dart';
import 'package:flutternotes/helper/note_provider.dart';
import 'package:flutternotes/models/note.dart';
import 'package:flutternotes/utils/constants.dart';
import 'package:flutternotes/widgets/delete_popup.dart';
import 'package:flutternotes/widgets/list_item.dart';
import 'package:flutternotes/screens/note_list_screen.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'note_edit_screen.dart';


class NoteViewScreen extends StatefulWidget {
  static const route = '/note-view';

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  Note selectedNote;
int id;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     id = ModalRoute
        .of(context)
        .settings
        .arguments;
    final provider = Provider.of<NoteProvider>(context);
    if (provider.getNote(id) != null)
      selectedNote = provider.getNote(id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () {

              Provider.of<NoteProvider>(context,listen:false).deleteNote(id);
            Navigator.pop(context);}
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedNote?.title,
                style: viewTitleStyle,
              ),
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.access_time,
                    size: 18,

                  ),
                ),
                Text('${selectedNote?.date}')
              ],
            ),
            if (selectedNote.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.file(File(selectedNote.imagePath)),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                selectedNote.content,
                style: viewContentStyle,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NoteEditScreen.route,
              arguments: selectedNote.id);
        },
        child: Icon(Icons.edit,
        color: Colors.white70,),
      backgroundColor: Colors.lightGreen,
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedNote: selectedNote);
        });
  }
}





//    return Consumer(
//      child: noNotesUI(context),
//      builder: (context, noteprovider, child) =>
//      noteprovider.items.length <= 0
//          ? child
//          : ListView.builder(
//        itemCount: noteprovider.items.length + 1,
//        itemBuilder: (context, index)
//        {
//          if (index == 0)
//          {
//            return header();
//          }
//          else
//          {
//            final i = index - 1;
//            final item = noteprovider.items[i];
//            return ListItem(
//              id: item.id,
//              title: item.title,
//              content: item.content,
//              imagePath: item.imagePath,
//              date: item.date,
//            );
//          }
//        },
//      ),
//    );
//  }
//}



