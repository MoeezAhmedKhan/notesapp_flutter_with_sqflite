import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoapp/addtodo_screen.dart';
import 'package:todoapp/db_handler.dart';
import 'package:todoapp/model/todo_model.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({super.key});
  TextEditingController searchController = TextEditingController();
  TextEditingController updateTitleController = TextEditingController();
  TextEditingController updateDescriptionController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.orange,
                Colors.blue,
              ]),
            ),
          ),
          title: const Text(
            "Notes",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
          )),
      body: Padding(
        padding: EdgeInsets.only(
            top: mq.height * 0.02,
            left: mq.width * 0.02,
            right: mq.width * 0.02,
            bottom: mq.height * 0.02),
        child: Column(
          children: [
            TextFormField(
              controller: widget.searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search Title",
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
            ),
            SizedBox(height: mq.height * 0.02),
            Expanded(
              child: FutureBuilder(
                future: DBHandler().get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No Note Found"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String title = snapshot.data![index].title.toString();
                        if (widget.searchController.text.isEmpty) {
                          return ListTile(
                            onTap: () {
                              widget.updateTitleController.text =
                                  snapshot.data![index].title.toString();
                              widget.updateDescriptionController.text =
                                  snapshot.data![index].description.toString();
                              showAlertBox(
                                  context: context,
                                  todoModel: TodoModel(
                                      id: snapshot.data![index].id,
                                      title: widget.updateTitleController.text,
                                      description: widget
                                          .updateDescriptionController.text));
                            },
                            title: Text(
                              snapshot.data![index].title.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  snapshot.data![index].description.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 1,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.blue],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () {
                                DBHandler().delete(snapshot.data![index].id!);
                                setState(() {
                                  print(
                                      "Deleting!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! widget buiding");
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(
                                    Icons.delete_sweep,
                                    color: Colors.white,
                                    size: 18,
                                  )),
                            ),
                          );
                        } else if (title.toLowerCase().contains(
                            widget.searchController.text.toLowerCase())) {
                          return ListTile(
                            onTap: () {
                              widget.updateTitleController.text =
                                  snapshot.data![index].title.toString();
                              widget.updateDescriptionController.text =
                                  snapshot.data![index].description.toString();
                              showAlertBox(
                                  context: context,
                                  todoModel: TodoModel(
                                      id: snapshot.data![index].id,
                                      title: widget.updateTitleController.text,
                                      description: widget
                                          .updateDescriptionController.text));
                            },
                            title: Text(
                              snapshot.data![index].title.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  snapshot.data![index].description.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 1,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.blue],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () {
                                DBHandler().delete(snapshot.data![index].id!);
                                setState(() {
                                  print(
                                      "Deleting!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! widget buiding");
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(
                                    Icons.delete_sweep,
                                    color: Colors.white,
                                    size: 18,
                                  )),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                    ;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void showAlertBox(
      {required BuildContext context, required TodoModel todoModel}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withAlpha(200),
          title:
              const Text("Update Note", style: TextStyle(color: Colors.orange)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: widget.updateTitleController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter title",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: widget.updateDescriptionController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter desciption",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.orange),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'SUBMIT',
                style: TextStyle(color: Colors.orange),
              ),
              onPressed: () async {
                todoModel.title = widget.updateTitleController.text;
                todoModel.description = widget.updateDescriptionController.text;
                await DBHandler().update(todoModel.toMap());
                setState(() {
                  print("Updating!!!!!!!!!!!!!!!!!!!!!!! widget building");
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}

// I have just make seperate widget for floating button
class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Colors.orange,
          Colors.blue,
        ]),
        borderRadius: BorderRadius.circular(100),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodoScreen(),
              ));
        },
        child: const Center(
            child: Icon(
          Icons.add,
          color: Colors.white,
        )),
      ),
    );
  }
}
