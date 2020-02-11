import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/viewobject/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogListItem extends StatelessWidget {
  const BlogListItem(
      {Key key,
      @required this.blog,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Blog blog;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                          margin: const EdgeInsets.all(ps_space_8),
                          child: BlogListItemWidget(blog: blog)))));
        });
  }
}

class BlogListItemWidget extends StatelessWidget {
  const BlogListItemWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(ps_space_4),
          child: PsNetworkImage(
            height: ps_space_200,
            width: double.infinity,
            photoKey: '',
            defaultPhoto: blog.defaultPhoto,
            boxfit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: ps_space_8, right: ps_space_8, top: ps_space_12),
          child: Text(
            blog.name,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: ps_space_4,
              bottom: ps_space_12,
              left: ps_space_8,
              right: ps_space_8),
          child: Text(
            blog.description,
            maxLines: 4,
            style: Theme.of(context).textTheme.body1.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
