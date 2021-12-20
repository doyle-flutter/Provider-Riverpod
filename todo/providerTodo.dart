class ProviderTodo extends StatelessWidget {
  const ProviderTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<TodoController>(create: (_) => TodoController())
    ],
    child: MaterialApp(home: Main(),),
  );
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoController _todoController = Provider.of<TodoController>(context);
    return MainPage(todoController: _todoController);
  }
}

class MainPage extends StatefulWidget {
  final TodoController todoController;
  const MainPage({Key? key, required this.todoController}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _textEditingController = TextEditingController(text: "");

  @override
  void dispose() {
    this._textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Provider 👋"),),
      body: Container(
        width: _size.width,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: this._textEditingController,)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => this._add(this._textEditingController, this.widget.todoController),
                )
              ],
            ),
            Expanded(
                child: this._view(this._textEditingController, this.widget.todoController)
            )
          ],
        ),
      ),
    );
  }

  Widget _view(TextEditingController textEditingController, TodoController todoController) => todoController.isEmpty
    ? Container()
    : ListView.builder(
      itemCount: todoController.todos.length,
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () => todoController.delete(todoController.todos[index]),
        child: TodoListItem(model: todoController.todos[index]),
      ),
    );

  void _add(TextEditingController textEditingController, TodoController todoController) {
    if(textEditingController.text.isEmpty) return;
    todoController.add(textEditingController.text);
    textEditingController.clear();
  }
}

class TodoListItem extends StatelessWidget {
  final TodoModel model;
  const TodoListItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.all(20.0),
    child: Text(model.title),
  );
}

class TodoModel{
  final String title;
  const TodoModel(this.title);
}

class TodoController with ChangeNotifier {
  final List<TodoModel> _todos = [];
  List<TodoModel> get todos => [..._todos];
  void set todos(List<TodoModel> todos) => throw "ERR";

  void add(String title) {
    this._todos.add(TodoModel(title));
    this.notifyListeners();
  }

  void update(int index, String title) {
    this._todos[index] = TodoModel(title);
    this.notifyListeners();
  }

  void delete(TodoModel model) {
    final int _findIndex = this._todos.indexOf(model);
    this._todos.removeAt(_findIndex);
    this.notifyListeners();
  }

  bool get isEmpty => this._todos.isEmpty;
}
