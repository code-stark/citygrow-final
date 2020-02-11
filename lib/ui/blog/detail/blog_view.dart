import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogView extends StatelessWidget {
  const BlogView({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    final Widget _sliverAppBar = SliverAppBar(
      brightness: Utils.getBrightnessForAppBar(context),
      expandedHeight: ps_space_300,
      floating: true,
      pinned: true,
      snap: false,
      elevation: 0,
      leading: const PsBackButtonWithCircleBgWidget(),
      backgroundColor: Utils.isLightMode(context) ? Colors.white : Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: PsNetworkImage(
          height: ps_space_300,
          width: double.infinity,
          photoKey: '',
          defaultPhoto: blog.defaultPhoto,
          boxfit: BoxFit.cover,
        ),
      ),
    );

    return Scaffold(
        body: CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        _sliverAppBar,
        SliverToBoxAdapter(
          child: TextWidget(
            blog: blog,
          ),
        )
      ],
    ));
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          Utils.isLightMode(context) ? Colors.white10 : const Color(0xFF303030),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(ps_space_12),
            child: Text(
              blog.name,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: ps_space_12, right: ps_space_12, bottom: ps_space_12),
            child: Text(
              blog.description,
              style: Theme.of(context).textTheme.body1.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
