import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatefulWidget {
  const InfoDialog({this.message});
  final String message;
  @override
  _InfoDialogState createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final InfoDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  border: Border.all(color: Colors.grey, width: 5),
                  color: Colors.grey),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: ps_space_4),
                  Icon(
                    Icons.alarm,
                    color: Colors.white,
                  ),
                  const SizedBox(width: ps_space_4),
                  Text(
                    Utils.getString(context, 'info_dialog__info'),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
          const SizedBox(height: ps_space_20),
          Container(
            padding: const EdgeInsets.only(
                left: ps_space_16,
                right: ps_space_16,
                top: ps_space_8,
                bottom: ps_space_8),
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: ps_space_20),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          MaterialButton(
            height: 50,
            minWidth: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              Utils.getString(context, 'dialog__ok'),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
