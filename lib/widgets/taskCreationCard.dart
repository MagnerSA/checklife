import 'package:checklife/services/task.service.dart';
import 'package:checklife/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../controllers/application.controller.dart';
import '../../../models/task.model.dart';
import '../../../util/formatting.dart';

class TaskCreationCard extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textController;
  final void Function() createTask;

  const TaskCreationCard({
    Key? key,
    required this.focusNode,
    required this.textController,
    required this.createTask,
  }) : super(key: key);

  @override
  State<TaskCreationCard> createState() => _TaskCreationCardState();
}

class _TaskCreationCardState extends State<TaskCreationCard> {
  ApplicationController app = ApplicationController();
  FirebaseFirestore bd = FirebaseFirestore.instance;
  Formatting formatting = Formatting();
  TaskService service = TaskService();

  bool isLoading = false;
  bool isOpened = false;
  bool isEditing = false;
  bool isModified = false;

  // enableEdit() {
  //   setState(() {
  //     isEditing = true;
  //     textController.text = widget.task.title;
  //   });
  // }

  // finishTask() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   print("ID aqui ${widget.task.id}");
  //   print("TASK: ${widget.task.toString()}");

  //   widget.task.closed = !widget.task.closed;
  //   await bd.collection("tasks").doc(widget.task.id).set(widget.task.toMap());

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // deleteTask() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   await widget.deleteTask();

  //   setState(() {
  //     isEditing = false;
  //     isOpened = false;
  //     isLoading = false;
  //   });
  // }

  // setIsOpened() {
  //   setState(() {
  //     isOpened = !isOpened;
  //   });
  // }

  // saveChanges() async {
  //   setState(() {
  //     isEditing = false;
  //     isModified = false;
  //     isLoading = true;
  //   });

  //   widget.task.title = textController.text;
  //   await bd.collection("tasks").doc(widget.task.id).set(widget.task.toMap());

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // topCard() {
  //   return Container(
  //     color: Colors.white,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           flex: 1,
  //           child: isLoading
  //               ? SpinKitRing(
  //                   color: widget.task.closed
  //                       ? secondaryColor
  //                       : Colors.grey.shade400,
  //                   lineWidth: 2,
  //                   size: 15,
  //                 )
  //               : IconButton(
  //                   onPressed: finishTask,
  //                   icon: Icon(
  //                     widget.task.closed
  //                         ? Icons.check_box
  //                         : Icons.check_box_outline_blank,
  //                     size: 25,
  //                     color: widget.task.closed
  //                         ? secondaryColor
  //                         : Colors.grey.shade400,
  //                   ),
  //                 ),
  //         ),
  //         Expanded(
  //           flex: 5,
  //           child: Padding(
  //             padding: EdgeInsets.all(10),
  //             child: Center(
  //               child: isEditing
  //                   ? TextFormField(
  //                       controller: textController,
  //                       onChanged: (_) {
  //                         if (!isModified) {
  //                           setState(() {
  //                             isModified = true;
  //                           });
  //                         }
  //                       },
  //                     )
  //                   : Text(widget.task.title),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: IconButton(
  //             onPressed: setIsOpened,
  //             icon: Icon(
  //               isOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
  //               size: 25,
  //               color: Colors.grey.shade500,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // bottomCard() {
  //   int age = -1;
  //   if (widget.task.createdAt != "") {
  //     DateTime createdAt = DateTime.parse(widget.task.createdAt);

  //     age = createdAt.compareTo(app.today) < 0
  //         ? app.currentDate.difference(createdAt).inDays
  //         : 0;
  //   }

  //   String text = age == -1 ? "Indisponível" : "Idade: $age dias";

  //   return !isOpened
  //       ? Container()
  //       : Container(
  //           height: 50,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             border: Border(
  //               top: BorderSide(
  //                 color: Colors.grey.shade300,
  //               ),
  //             ),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Expanded(
  //                 flex: 5,
  //                 child: Center(child: Text(age == 0 ? "Criada hoje" : text)),
  //               ),
  //             ],
  //           ),
  //         );
  // }

  // bottomOptions() {
  //   return isOpened
  //       ? Container(
  //           height: 50,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             border: Border(
  //               top: BorderSide(
  //                 color: Colors.grey.shade300,
  //               ),
  //             ),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               isEditing && !isLoading
  //                   ? Material(
  //                       type: MaterialType.transparency,
  //                       child: InkWell(
  //                         onTap: deleteTask,
  //                         child: Ink(
  //                           width: 50,
  //                           child: const Center(
  //                             child: Icon(
  //                               Icons.delete_outline,
  //                               size: 20,
  //                               color: redColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   : const SizedBox(),
  //               Expanded(
  //                 child: Container(),
  //               ),
  //               isEditing && !isLoading
  //                   ? Material(
  //                       type: MaterialType.transparency,
  //                       child: InkWell(
  //                         onTap: () {
  //                           setState(() {
  //                             isEditing = false;
  //                           });
  //                         },
  //                         child: Ink(
  //                             width: 50,
  //                             child: const Center(
  //                               child: Icon(
  //                                 Icons.close,
  //                                 size: 20,
  //                                 color: redColor,
  //                               ),
  //                             )),
  //                       ),
  //                     )
  //                   : const SizedBox(),
  //               !isEditing
  //                   ? Material(
  //                       type: MaterialType.transparency,
  //                       child: InkWell(
  //                         onTap: enableEdit,
  //                         child: Ink(
  //                           width: 50,
  //                           child: const Center(
  //                             child: Icon(
  //                               Icons.edit_outlined,
  //                               size: 20,
  //                               color: primaryColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   : const SizedBox(),
  //               isModified && isEditing
  //                   ? Material(
  //                       type: MaterialType.transparency,
  //                       child: InkWell(
  //                         onTap: saveChanges,
  //                         child: Ink(
  //                           width: 50,
  //                           child: const Center(
  //                             child: Icon(
  //                               Icons.check,
  //                               size: 20,
  //                               color: greenColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   : const SizedBox(),
  //             ],
  //           ),
  //         )
  //       : Container();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          // width: 350,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: null,
                    focusNode: widget.focusNode,
                    controller: widget.textController,
                    decoration: const InputDecoration(
                      hintText: "Criar nova tarefa",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.createTask,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
