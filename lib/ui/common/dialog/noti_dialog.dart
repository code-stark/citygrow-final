import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class NotiDialog extends StatefulWidget {
  const NotiDialog({this.message});
  final String message;
  @override
  _NotiDialogState createState() => _NotiDialogState();
}

class _NotiDialogState extends State<NotiDialog> {
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

  final NotiDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: ps_space_20),
          Text(
            Utils.getString(context, 'noti_dialog__notification'),
            style:
                Theme.of(context).textTheme.button.copyWith(color: Colors.red),
          ),
          const SizedBox(height: ps_space_12),
          Text(widget.message, style: Theme.of(context).textTheme.body1),
          Align(
            alignment: Alignment.bottomRight,
            child: MaterialButton(
              height: 50,
              minWidth: ps_space_80,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                Utils.getString(context, 'dialog__ok'),
                style: Theme.of(context).textTheme.button,
              ),
            ),
          )
        ],
      ),
    );
  }
}
