import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// -----------------------------------------------------------------------
class NewTransaction extends StatefulWidget {
  final Function _addTr;

  NewTransaction(this._addTr);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}
// -----------------------------------------------------------------------
class _NewTransactionState extends State<NewTransaction> {

  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  DateTime _enteredDate;

  void _submitData() {
    final _enteredTitle = titleCtrl.text;
    final _enteredAmount = double.parse(amountCtrl.text);

    if (_enteredTitle.isEmpty || _enteredAmount <= 0 || _enteredDate == null) {
      return;
    }
    
    widget._addTr(titleCtrl.text, double.parse(amountCtrl.text), _enteredDate);
    Navigator.of(context).pop();
  }

  void _openDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime.now()
      ).then((res) {
        if (res == null) { return; }
        setState(() {
          _enteredDate = res;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: titleCtrl,
                    ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _submitData(),
                    ),
                    Container(
                      height: 50,
                      child: Row(children: <Widget>[
                        Expanded(child: Text(_enteredDate == null ? 'enter date' : 'Transaction date: ${DateFormat.yMd().format(_enteredDate)}')),
                        FlatButton(
                          onPressed: _openDatePicker,
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'choose date...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          )
                      ],),
                    ),
                  RaisedButton(
                    onPressed: _submitData,
                    child: Text('Add transaction'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    )
                ],
              ),
            ),
          ),
    );
  }
}