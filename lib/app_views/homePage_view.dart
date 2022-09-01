import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elred_test/app_models/todo_model.dart';
import 'package:elred_test/app_services/todo_provider.dart';
import 'package:elred_test/app_views/sideNavBar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController titlecontroller = TextEditingController();
    TextEditingController desccontroller = TextEditingController();
    return Consumer<StateProvider>(builder: ((context, todoProvider, child) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => sideNavBar()));
              },
              icon: const Icon(Icons.menu),
            ),
          ),
          extendBodyBehindAppBar: true,
          extendBody: true,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("Enter task title and description"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titlecontroller,
                              decoration: const InputDecoration(
                                  hintText: "Enter Title"),
                            ),
                            TextField(
                              controller: desccontroller,
                              decoration: const InputDecoration(
                                  hintText: "Enter description"),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                          ElevatedButton(
                              onPressed: () {
                                todoProvider.addNewTask(Todo(
                                    description: desccontroller.text,
                                    title: titlecontroller.text));
                                Navigator.pop(context);
                                desccontroller.clear();
                                titlecontroller.clear();
                              },
                              child: const Text("Add"))
                        ],
                      ));
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          body: taskViewBody(context));
    }));
  }

  taskViewBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Consumer<StateProvider>(
        builder: (context, todos, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: <Widget>[
                  Image.asset('assets/wallpaper.jpg'),
                  overviewWidget(todos.items.length.toString()),
                ],
              ),
            ),
            const Text("To-Do List :"),
            todoListBuilder(),
          ],
        ),
      ),
    );
  }

  todoListBuilder() {
    return Consumer<StateProvider>(builder: (context, todo, child) {
      if (todo.items.isEmpty) {
        todo.getData();
      }
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todo.items.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => ListTile(
                title: Text(todo.items[index].title.toString()),
                subtitle: Text(todo.items[index].description.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        TextEditingController editingdescController =
                            TextEditingController(
                                text: todo.items[index].description);
                        TextEditingController editingtitleController =
                            TextEditingController(
                                text: todo.items[index].title);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  actions: [
                                    ElevatedButton(
                                        onPressed: (() {
                                          Navigator.pop(context);
                                        }),
                                        child: const Text("Cancel")),
                                    ElevatedButton(
                                      onPressed: (() {
                                        todo.editTask(
                                            todo.items[index],
                                            editingdescController.text,
                                            editingtitleController.text);
                                        editingdescController.clear();
                                        editingtitleController.clear();

                                        Navigator.pop(context);
                                      }),
                                      child: const Text("Update"),
                                    )
                                  ],
                                  title: const Text("Edit"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        decoration: const InputDecoration(
                                            hintText:
                                                "Edit Your Task's Description"),
                                        controller: editingtitleController,
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Edit Your Task's Title"),
                                        controller: editingdescController,
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          todo.chanceCompleteness(todo.items[index]);
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text(
                                        "Are you Sure you want to delete"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            todo.removeItem(
                                              todo.items[index],
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Delete"))
                                    ],
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ],
                ),
              ));
    });
  }

  overviewWidget(String? total) {
    var now = DateTime.now();
    var formatter = DateFormat.yMMMMd('en_US');
    String formattedDate = formatter.format(now);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 230,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Your",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Things",
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        "Total Tasks:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        total.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
