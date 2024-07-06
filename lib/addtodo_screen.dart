import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:todoapp/db_handler.dart';
import 'package:todoapp/model/todo_model.dart';

class AddTodoScreen extends StatefulWidget {
  AddTodoScreen({super.key});
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  @override
  Widget build(BuildContext context) {
    print("Widget is loading!!!!!!!!!!!!!");
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(
            top: mq.height * 0.04,
            left: mq.width * 0.06,
            right: mq.width * 0.06,
            bottom: mq.height * 0.02),
        child: Form(
          key: widget._key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add New \nNote",
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: mq.height * 0.05),
                  textField(
                    placeholder: "Enter Title",
                    controller: widget.titleController,
                    maxLine: 2,
                    textFieldValidator: (value) {
                      if (value!.isEmpty) {
                        return "Enter title";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: mq.height * 0.05),
                  textField(
                    placeholder: "Enter Description",
                    controller: widget.descriptionController,
                    maxLine: 4,
                    textFieldValidator: (value) {
                      if (value!.isEmpty) {
                        return "Enter description";
                      }
                      return null;
                    },
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  if (widget._key.currentState!.validate()) {
                    TodoModel note = TodoModel(
                        title: widget.titleController.text.toString(),
                        description:
                            widget.descriptionController.text.toString());
                    try {
                      await DBHandler().insert(note);
                      List<TodoModel> read = await DBHandler().get();
                      bool isInserted = read.any(
                        (e) =>
                            e.title == note.title &&
                            e.description == note.description,
                      );
                      if (isInserted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Note added successfully')));
                        widget.titleController.clear();
                        widget.descriptionController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to add note')));
                      }
                      print("Data Inserted Successfully");
                    } catch (e) {
                      print("Error inserting data: $e");
                    }
                  }
                },
                child: Container(
                  height: mq.height * 0.07,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Colors.orange,
                      Colors.blue,
                    ]),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(width: mq.height * 0.02),
                        const Text(
                          "Add Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: ,
    );
  }

  // addTodo() {}

  Widget textField({
    required String placeholder,
    required TextEditingController controller,
    required int maxLine,
    required String? Function(String?)?
        textFieldValidator, // textFieldValidator aik string return krega and is k function me aik parameter hoga ye define kia he
  }) {
    return TextFormField(
      validator: textFieldValidator,
      controller: controller,
      maxLines: maxLine,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)),
      ),
    );
  }
}
