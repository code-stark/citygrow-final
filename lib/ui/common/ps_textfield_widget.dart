import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PsTextFieldWidget extends StatelessWidget {
  const PsTextFieldWidget(
      {this.textEditingController,
      this.titleText = '',
      this.hintText,
      this.textAboutMe = false,
      this.height = ps_space_44,
      this.showTitle = true,
      this.keyboardType = TextInputType.text,
      this.phoneInputType = false});

  final TextEditingController textEditingController;
  final String titleText;
  final String hintText;
  final double height;
  final bool textAboutMe;
  final TextInputType keyboardType;
  final bool showTitle;
  final bool phoneInputType;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(titleText, style: Theme.of(context).textTheme.bodyText2);

    final Widget _productTextFieldWidget = TextField(
        keyboardType:
            phoneInputType ? TextInputType.number : TextInputType.text,
        maxLines: null,
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: textAboutMe
            ? InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: ps_space_12,
                  bottom: ps_space_8,
                  top: ps_space_10,
                ),
                border: InputBorder.none,
                hintText: hintText,
              )
            : InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: ps_space_12,
                  bottom: ps_space_8,
                ),
                border: InputBorder.none,
                hintText: hintText,
              ));

    return Column(
      children: <Widget>[
        if (showTitle)
          Container(
            margin: const EdgeInsets.only(
                left: ps_space_12, top: ps_space_12, right: ps_space_12),
            child: Row(
              children: <Widget>[
                _productTextWidget,
              ],
            ),
          )
        else
          Container(
            height: 0,
          ),
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.all(ps_space_12),
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
            borderRadius: BorderRadius.circular(ps_space_4),
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? Colors.grey[200]
                    : Colors.black87),
          ),
          child: _productTextFieldWidget,
        ),
      ],
    );
  }
}
