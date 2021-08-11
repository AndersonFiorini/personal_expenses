import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/components/chart.dart';
import 'package:personal_expenses/components/transaction_form.dart';

import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() {
  runApp(ExpansesApp());
}

class ExpansesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple, accentColor: Colors.amber),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transaction = [
    Transaction(
      id: 't0',
      title: 'Conta antiga',
      value: 400.61,
      date: DateTime.now().subtract(Duration(days: 33)),
    ),
    Transaction(
      id: 't1',
      title: 'Novo Tênis de corrida',
      value: 310.76,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't2',
      title: 'Conta de luz',
      value: 211.3,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: 't3',
      title: 'Cartão',
      value: 1211.3,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't4',
      title: 'Seguro',
      value: 21.3,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't5',
      title: 'Casa',
      value: 1111.3,
      date: DateTime.now(),
    ),
  ];

  bool _showChart = false;

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return TransactionForm(_addTransaction, plataformaIos);
        });
  }

  List<Transaction> get _recentTransaction {
    return _transaction.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transaction.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transaction.removeWhere((element) => element.id == id);
    });
  }

  var plataformaIos = Platform.isIOS;

  Widget _getIconButton(IconData icon, Function() fn) {
    return plataformaIos
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : Container(child: IconButton(onPressed: fn, icon: Icon(icon)));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = plataformaIos ? CupertinoIcons.list_bullet : Icons.list;
    final chartList = plataformaIos
        ? CupertinoIcons.chart_bar_alt_fill
        : Icons.bar_chart_outlined;

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : chartList,
          () => setState(() {
            _showChart = !_showChart;
          }),
        ),
      _getIconButton(
        plataformaIos ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
      plataformaIos
          ? Center(
            child: CupertinoSwitch(
                activeColor: Theme.of(context).accentColor,
                value: plataformaIos,
                onChanged: (v) {
                  setState(() {
                    plataformaIos = v;
                  });
                }),
          )
          : Switch(
              activeColor: Theme.of(context).accentColor,
              value: plataformaIos,
              onChanged: (v) {
                setState(() {
                  plataformaIos = v;
                });
              })
    ];
    final appBar =  AppBar(
      title: Text(
        'Personal expenses',
        style: TextStyle(
          fontSize: 20 * mediaQuery.textScaleFactor,
        ),
      ),
      actions: actions,
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    var bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /*if (isLandscape)
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Exibir Gráfico'
                  ),
                  Switch.adaptive(
                      value: _showChart,
                      onChanged: (value){

                        setState(() {
                          _showChart=value;
                        });
                  }),
                ],
              ),*/
            if (_showChart || !isLandscape)
              Container(
                  height: availableHeight * (isLandscape ? 0.8 : 0.3),
                  child: Chart(_recentTransaction)),
            if (!_showChart || !isLandscape)
              Container(
                  height: availableHeight * (isLandscape ? 1 : 0.7),
                  child: TransactionList(_transaction, _removeTransaction)),
          ],
        ),
      ),
    );

    return plataformaIos
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Despesas Pessoais'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: actions),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: plataformaIos
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterFloat,
          );
  }
}
