import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class PsDropdownBaseWidget extends StatelessWidget {
  const PsDropdownBaseWidget(
      {Key key, @required this.title, @required this.onTap, this.selectedText})
      : super(key: key);

  final String title;
  final String selectedText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: ps_space_12, top: ps_space_4, right: ps_space_12),
          child: Row(
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.body2,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: ps_space_44,
            margin: const EdgeInsets.all(ps_space_12),
            decoration: BoxDecoration(
              color:
                  Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
              borderRadius: BorderRadius.circular(ps_space_4),
              border: Border.all(
                  color: Utils.isLightMode(context)
                      ? Colors.grey[200]
                      : Colors.black87),
            ),
            child: Container(
              margin: const EdgeInsets.all(ps_space_12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      selectedText == ''
                          ? Utils.getString(context, 'home_search__not_set')
                          : selectedText,
                      style: selectedText == ''
                          ? Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(color: Colors.grey[600])
                          : Theme.of(context).textTheme.body1,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
