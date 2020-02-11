import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:flutter/material.dart';

class PsFrameUIForLoading extends StatelessWidget {
  const PsFrameUIForLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.all(ps_space_16),
        decoration: const BoxDecoration(color: Colors.grey));
  }
}
