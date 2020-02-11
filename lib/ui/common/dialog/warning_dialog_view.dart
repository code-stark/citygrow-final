import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class WarningDialog extends StatefulWidget {
  const WarningDialog({this.message});
  final String message;
  @override
  _WarningDialogState createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return _NewDialog(widget: widget);
  }
}

class _NewDialog extends StatelessWidget {
  const _NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final WarningDialog widget;

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
                    border: Border.all(color: Colors.lightGreen, width: 5),
                    color: Colors.lightGreen),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: ps_space_4,
                    ),
                    Icon(
                      Icons.warning,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: ps_space_4,
                    ),
                    Text(
                      Utils.getString(context, 'warning_dialog__warning'),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: ps_space_20,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: ps_space_16,
                  right: ps_space_16,
                  top: ps_space_8,
                  bottom: ps_space_8),
              child: Text(
                widget.message,
                style: Theme.of(context).textTheme.button,
              ),
            ),
            const SizedBox(
              height: ps_space_20,
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Theme.of(context).iconTheme.color,
            ),
            MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                Utils.getString(context, 'dialog__ok'),
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }
}
