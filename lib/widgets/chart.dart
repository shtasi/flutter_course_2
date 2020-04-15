import 'package:flutter/material.dart';
import 'package:flutter_course_2/widgets/chart_bar.dart';
import 'package:intl/intl.dart';
import '../model/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (Transaction tr in recentTransactions) {
        if (tr.date.day == weekDay.day && tr.date.month == weekDay.month && tr.date.year == weekDay.year) {
          totalSum += tr.amount;
        }
      }
      return {'day': DateFormat.E().format(weekDay).substring(0, 1), 'amount': totalSum};
    }).reversed.toList();
  }

  double get maxSpent {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + tr['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(data['day'], data['amount'], maxSpent != 0.0 ? ((data['amount'] as double) / maxSpent) : 0.0)
            );
          // return Text(' ${data['day']}: ${data['amount']} |');
        }).toList()),
      ),
    );
  }
}