import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask(String task) {
    setState(() {
      _tasks.add({"task": task, "completed": false, "saved": false});
    });
    _controller.clear();
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]["completed"] = !_tasks[index]["completed"];
    });
  }

  void _toggleSavedTask(int index) {
    setState(() {
      _tasks[index]["saved"] = !_tasks[index]["saved"];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: _selectedIndex == 0
          ? _buildToDoListScreen()
          : _buildSavedTasksScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }

  Widget _buildToDoListScreen() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(child: _buildTaskInput()),
              Expanded(child: _buildTaskList()),
            ],
          );
        } else {
          return Column(
            children: [
              _buildTaskInput(),
              Expanded(child: _buildTaskList()),
            ],
          );
        }
      },
    );
  }

  Widget _buildTaskInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a task',
              ),
              onSubmitted: _addTask,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addTask(_controller.text),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              _tasks[index]["task"],
              style: TextStyle(
                decoration: _tasks[index]["completed"]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            leading: Checkbox(
              value: _tasks[index]["completed"],
              onChanged: (value) => _toggleTask(index),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _tasks[index]["saved"]
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                  onPressed: () => _toggleSavedTask(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedTasksScreen() {
    final savedTasks = _tasks.where((task) => task["saved"]).toList();
    if (savedTasks.isEmpty) {
      return Center(
        child: Text("No saved tasks"),
      );
    }
    return ListView.builder(
      itemCount: savedTasks.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(savedTasks[index]["task"]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteTask(_tasks.indexOf(savedTasks[index])),
            ),
          ),
        );
      },
    );
  }
}
