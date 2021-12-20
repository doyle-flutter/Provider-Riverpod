StateNotifierProvider<TodoController, List<TodoModel>> todoControllerProvider = StateNotifierProvider<TodoController, List<TodoModel>>((ref) => TodoController());

class RiverPodTodo extends StatelessWidget {
  const RiverPodTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ProviderScope(child: MaterialApp(home: Main(),));
}

class Main extends ConsumerWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<TodoModel> _models = ref.watch<List<TodoModel>>(todoControllerProvider);
    TodoController todoController = ref.watch<TodoController>(todoControllerProvider.notifier);
    return MainPage(todoController: todoController);
  }
}

class MainPage extends StatefulWidget {
  final TodoController todoController;
  const MainPage({Key? key, required this.todoController}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
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
      appBar: AppBar(title: Text("Riverpod 👍",)),
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
            // Text(this.widget.todoController.todos.toString())
            Expanded(
              child: this._view(this._textEditingController, this.widget.todoController)
            )
          ],
        ),
      ),
    );
  }
  Widget _view(TextEditingController textEditingController, TodoController todoController){
    return todoController.todos.isEmpty ? Container() : ListView.builder(
      itemCount: todoController.todos.length,
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () => todoController.delete(todoController.todos[index]),
        child: TodoListItem(
          model: todoController.todos[index]
        ),
      ),
    );
  }

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

class TodoController extends StateNotifier<List<TodoModel>> {
  TodoController([List<TodoModel>? list]) : super(list ?? []);
  List<TodoModel> get todos => [...this.state];

  void add(String title) => this._setState([...this.state, TodoModel(title)]);

  void update(int index, String title) {
    this.state[index] = TodoModel(title);
    this._setState(this.state);
  }

  void delete(TodoModel model) {
    final int _findIndex = this.state.indexOf(model);
    this.state.removeAt(_findIndex);
    this._setState(this.state);
  }

  bool get isEmpty => this.state.isEmpty;

  void _setState(List<TodoModel> nextState) => this.state = [...nextState];
}
