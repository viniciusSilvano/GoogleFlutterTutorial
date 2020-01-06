import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordstate extends State<RandomWords>{

  final _suggetions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {

    void _pushSaved(){
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context){
            final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair){
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              }
            );
            final List<Widget> divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggetions'),
              ),
              body: ListView(children: divided),
            );
          }
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );

  }

  Widget _buildSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context,i){
        if(i.isOdd) return Divider(); /*2*/
        
        final index = i ~/ 2;/*3*/
        if(index >= _suggetions.length){
          _suggetions.addAll(generateWordPairs().take(10));/**4 */
        }
        return _buildRow(_suggetions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair){
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair); 
          }else{
            _saved.add(pair);
          }
        });
      },
    );
  }
}

class RandomWords extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RandomWordstate();
}
