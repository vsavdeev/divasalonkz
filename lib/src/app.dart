import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main/main_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyAppState(),
      child: MaterialApp(
        title: 'Салон красоты DiVa',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
        home: MainPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final Set<String> favoriteServices = {};
  var current = WordPair.random();
  final List<WordPair> history = [];
  final Set<WordPair> favorites = {};
  GlobalKey<AnimatedListState>? historyListKey;

  void getNext() {
    history.insert(0, current);
    historyListKey?.currentState?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite([WordPair? pair]) {
    pair ??= current;
    favorites.contains(pair) ? favorites.remove(pair) : favorites.add(pair);
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(flex: 3, child: HistoryListView()),
          const SizedBox(height: 10),
          BigCard(pair: appState.current),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(
                onPressed: () => appState.toggleFavorite(),
                icon: appState.favorites.contains(appState.current)
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: 'Like',
              ),
              const SizedBox(width: 10),
              _buildButton(
                onPressed: appState.getNext,
                label: 'Next',
              ),
            ],
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildButton(
      {required VoidCallback onPressed,
      IconData? icon,
      required String label}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox(),
      label: Text(label),
    );
  }
}

class BigCard extends StatelessWidget {
  final WordPair pair;
  const BigCard({super.key, required this.pair});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium?.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            Text(pair.first,
                style: style?.copyWith(fontWeight: FontWeight.w200)),
            Text(pair.second,
                style: style?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  final _key = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    final appState = context.read<MyAppState>();
    appState.historyListKey = _key;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.transparent, Colors.black],
        stops: [0.0, 0.5],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: const EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () => appState.toggleFavorite(pair),
                icon: appState.favorites.contains(pair)
                    ? const Icon(Icons.favorite, size: 12)
                    : const SizedBox(),
                label:
                    Text(pair.asLowerCase, semanticsLabel: pair.asPascalCase),
              ),
            ),
          );
        },
      ),
    );
  }
}
