import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final bool plataformaIos;
  final String label;
  final Function() onPressed;

  AdaptativeButton({required this.plataformaIos,required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return plataformaIos
        ? CupertinoButton(
            child: Text(label),
            onPressed: onPressed,
            color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 20),
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            child: Text(label),
            onPressed: onPressed,
          );
  }
}
