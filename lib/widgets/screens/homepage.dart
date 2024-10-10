import 'package:flutter/material.dart';
import 'package:note_keeper/widgets/screens/add_note.dart';
import 'package:note_keeper/models/note_model.dart';
import 'package:note_keeper/utils/db_helper.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Color.fromARGB(255, 69, 102, 134),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NoteModel>>(
        future: DBHelper.readNote(), //read contacts list here
        builder:
            (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
          //if snapshot has no data yet
          if (!snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Loading...'),
                ],
              ),
            );
          }
          //if snapshot return empty [], show text
          //else show contact list
          return snapshot.data!.isEmpty
              ? const Center(
                  child: Text(
                    'No Note yet!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff4e7397),
                    ),
                  ),
                )
              : ListView(
                  children: snapshot.data!.map((note) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 4,
                              ),
                              title: Text(
                                note.title,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Color(0xff4e7397),
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                note.description,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff4e7397),
                                ),
                              ),
                              leading: const Icon(
                                Icons.note_add_outlined,
                                color: Color(0xff4e7397),
                                size: 37,
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xff4e7397),
                                ),
                                onPressed: () async {
                                  await DBHelper.deleteNote(note.id!);
                                  setState(() {
                                    //rebuild widget after delete
                                  });
                                },
                              ),
                              tileColor: const Color(0xffe7edf3),
                              onTap: () async {
                                //tap on ListTile, for update
                                final refresh =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddNote(
                                      note: NoteModel(
                                        id: note.id,
                                        title: note.title,
                                        description: note.description,
                                      ),
                                    ),
                                  ),
                                );

                                if (refresh) {
                                  setState(() {
                                    //if return true, rebuild whole widget
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final refresh = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddNote(),
            ),
          );

          if (refresh) {
            setState(() {
              //if return true, rebuild whole widget
            });
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff4e7397),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
    );
  }
}
