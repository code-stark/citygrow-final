import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/ui/blog/list/blog_list_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:flutter/material.dart';

class CollectionHeaderListContainerView extends StatefulWidget {
  @override
  _CollectionHeaderListContainerViewState createState() =>
      _CollectionHeaderListContainerViewState();
}

class _CollectionHeaderListContainerViewState
    extends State<CollectionHeaderListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context).iconTheme,
          title: Text(
            Utils.getString(context, 'collection_header__app_bar_name'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: BlogListView(
          animationController: animationController,
        ),
      ),
    );
  }
}
