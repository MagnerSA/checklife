import '../models/task.model.dart';
import '../util/comparing.dart';

Comparing compare = Comparing();

var today = DateTime.now();

var tasksMock = {
  "${today.toString()} 00001": Task(
    title: "Fazer compras",
    date: today.toString(),
    id: "${today.toString()} 00001",
  ),
  "${today.toString()} 00002": Task(
    title: "Terminar trabalho",
    date: today.toString(),
    id: "${today.toString()} 00002",
  ),
  "${today.toString()} 00003": Task(
    title: "Limpar a casa",
    date: today.toString(),
    id: "${today.toString()} 00003",
  ),
  "${today.toString()} 00004": Task(
    title: "Assistir um filme",
    date: today.toString(),
    id: "${today.toString()} 00004",
  ),
};

getTasks(DateTime date) {
  var searchedTasks = {};

  for (var value in tasksMock.values) {
    if (compare.isSameDay(date, DateTime.parse(value.date))) {
      searchedTasks[value.id] = tasksMock[value.id];
    }
  }

  return searchedTasks;
}
