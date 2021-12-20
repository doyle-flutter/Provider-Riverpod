void main() => runApp(System());

class System extends StatelessWidget {
  const System({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
    => ProviderTodo();
    // => RiverPodTodo();
}
