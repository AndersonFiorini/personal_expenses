import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.e,
    required this.onRemove,
  }) : super(key: key);

  final Transaction e;
  final void Function(String p1) onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text('R\$${e.value}'),
            ),
          ),
        ),
        title: Text(
          e.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat('d MMM y').format(e.date),
        ),
        trailing: MediaQuery.of(context).size.width > 480
            ? TextButton(
          onPressed: () => onRemove(e.id),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              Text(
                'Excluir',
                style: TextStyle(
                    color: Theme.of(context).errorColor),
              ),
            ],
          ),
        )
            : IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => onRemove(e.id),
        ),
      ),
    );
  }
}
