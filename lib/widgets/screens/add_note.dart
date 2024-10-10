import 'package:flutter/material.dart';
import 'package:note_keeper/models/note_model.dart';
import 'package:note_keeper/utils/db_helper.dart';

class AddNote extends StatefulWidget {
  const AddNote({
    super.key,
    this.note,
  });
  final NoteModel? note;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Add Note',
          style: TextStyle(
            color: Color.fromARGB(255, 69, 102, 134),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(
                  color: Color(0xff4e7397),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xff4e7397),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xff4e7397),
                      width: 2,
                    ),
                  ),
                  labelText: 'Title',
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    color: Color(0xff4e7397),
                  ),
                  hintText: 'Enter Title',
                  hintStyle: const TextStyle(
                    color: Color(0xff4e7397),
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * (1.9 / 3) -
                    MediaQuery.of(context).viewInsets.bottom,
                width: double.infinity,
                child: TextField(
                  controller: _descriptionController,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    color: Color(0xff4e7397),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xff4e7397),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xff4e7397),
                        width: 2,
                      ),
                    ),
                    labelText: 'Description',
                    labelStyle: const TextStyle(
                      fontSize: 22,
                      color: Color(0xff4e7397),
                    ),
                    alignLabelWithHint: true,
                    hintText: 'Enter Description',
                    hintStyle: const TextStyle(
                      color: Color(0xff4e7397),
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        width: 2.0,
                        color: Color(0xff4e7397),
                      ),
                      backgroundColor: const Color(0xffe7edf3),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xff4e7397),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      //if contact has data, then update existing list
                      //according to id
                      //else create a new contact
                      if (widget.note != null) {
                        if (_descriptionController.text.isNotEmpty &&
                            _titleController.text.isNotEmpty) {
                          await DBHelper.updateNote(
                            NoteModel(
                              id: widget.note!.id, //have to add id here
                              title: _titleController.text,
                              description: _descriptionController.text,
                            ),
                          );
                          Navigator.of(context).pop(true);
                        } else {
                          Navigator.of(context).pop(false);
                        }
                      } else {
                        if (_descriptionController.text.isNotEmpty &&
                            _titleController.text.isNotEmpty) {
                          await DBHelper.createNote(
                            NoteModel(
                              title: _titleController.text,
                              description: _descriptionController.text,
                            ),
                          );
                          Navigator.of(context).pop(true);
                        } else {
                          Navigator.of(context).pop(false);
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        width: 2.0,
                        color: Color(0xff4e7397),
                      ),
                      backgroundColor: const Color(0xffe7edf3),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Color(0xff4e7397),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
