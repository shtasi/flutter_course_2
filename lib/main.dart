import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './model/transaction.dart';
import './widgets/chart.dart';

void main() {
  // // запрещаем работу приложения в альбовном режиме, только портретная ориентация экрана
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Планировщик занятий',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18),
          button: TextStyle(color: Colors.white)
            ),
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(headline6: TextStyle(fontFamily: 'OpenSans', fontSize: 20)))
      ),
      );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _transactions = [
    Transaction(id: '1', title: 'shoes', amount: 69.99, date: DateTime.now()),
    Transaction(id: '2', title: 'pomidors', amount: 4.49, date: DateTime.now()),
    Transaction(id: '3', title: 'cucumbers', amount: 3.99, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(id: DateTime.now().toString(), title: title, amount: amount, date: date);
    setState(() {
      _transactions.add(newTransaction);
    });
  }

void _deleteTransaction(String id) {
  setState(() {
    _transactions.removeWhere((el) =>  el.id == id);
  });
}

  void _addBtnClick(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
        title: Text('Планировщик занятий'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () => _addBtnClick(context))
        ],
      );
    final trList = Container(
            height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
            child: TransactionList(_transactions, _deleteTransaction));
    final chart = Container(
            height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
            child: Chart(_recentTransaction)
          );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          if (_isLandscape) Row(children: <Widget>[
            Text('Show chart'),
            Switch(
              value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            })
          ],),
          if (!_isLandscape) Container(
            height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.3,
            child: Chart(_recentTransaction)
          ),
          if (!_isLandscape) trList,
          if (_isLandscape) _showChart ? chart : trList
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addBtnClick(context),
      ),
    );
  }
}
