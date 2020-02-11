import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class VersionUpdateDialog extends StatefulWidget {
  const VersionUpdateDialog(
      {Key key,
      this.title,
      this.description,
      this.leftButtonText,
      this.rightButtonText,
      this.onCancelTap,
      this.onUpdateTap})
      : super(key: key);
  @override
  _VersionUpdateDialogState createState() => _VersionUpdateDialogState();
  final String title, description, leftButtonText, rightButtonText;
  final Function onCancelTap;
  final Function onUpdateTap;
}

class _VersionUpdateDialogState extends State<VersionUpdateDialog> {
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

  final VersionUpdateDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  height: ps_space_60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border: Border.all(color: Colors.orange, width: 5),
                      color: Colors.orange),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: ps_space_8),
                      Icon(
                        Icons.alarm,
                        color: Colors.white,
                      ),
                      const SizedBox(width: ps_space_8),
                      Text(
                        Utils.getString(
                            context, 'version_update_dialog__version_update'),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: ps_space_8),
              Container(
                padding: const EdgeInsets.only(
                    left: ps_space_16,
                    right: ps_space_16,
                    top: ps_space_16,
                    bottom: ps_space_8),
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ],
                ),
              ),
              // SizedBox(height: ps_space_8),
              Container(
                padding: const EdgeInsets.only(
                    left: ps_space_16, right: ps_space_16, bottom: ps_space_8),
                child: Text(
                  widget.description,
                  style:
                      TextStyle(color: Colors.green, wordSpacing: ps_space_4),
                ),
              ),
              const SizedBox(height: ps_space_8),
              Divider(
                color: Theme.of(context).iconTheme.color,
                height: 1,
              ),
              Row(children: <Widget>[
                Expanded(
                    child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onCancelTap();
                  },
                  child: Text(
                    widget.leftButtonText,
                    style: Theme.of(context).textTheme.button,
                  ),
                )),
                Container(
                    height: 50,
                    width: 0.4,
                    color: Theme.of(context).iconTheme.color),
                Expanded(
                    child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onUpdateTap();
                  },
                  child: Text(
                    widget.rightButtonText,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: ps_ctheme__color_speical),
                  ),
                )),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
