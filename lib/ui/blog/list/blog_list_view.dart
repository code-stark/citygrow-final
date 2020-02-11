import 'package:digitalproductstore/provider/blog/blog_provider.dart';
import 'package:digitalproductstore/repository/blog_repository.dart';
import 'package:digitalproductstore/ui/blog/item/blog_list_item.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _BlogListViewState createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  BlogProvider _blogProvider;
  Animation<double> animation;

  @override
  void dispose() {
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _blogProvider.nextBlogList();
      }
    });

    super.initState();
  }

  BlogRepository repo1;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<BlogRepository>(context);

    print(
        '............................Build UI Again ............................');
    return EasyLocalizationProvider(
      data: data,
      child: ChangeNotifierProvider<BlogProvider>(
        create: (BuildContext context) {
          final BlogProvider provider = BlogProvider(repo: repo1);
          provider.loadBlogList();
          _blogProvider = provider;
          return _blogProvider;
        },
        child: Consumer<BlogProvider>(
          builder: (BuildContext context, BlogProvider provider, Widget child) {
            return Stack(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                        left: ps_space_16,
                        right: ps_space_16,
                        top: ps_space_8,
                        bottom: ps_space_8),
                    child: RefreshIndicator(
                      child: CustomScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (provider.blogList.data != null ||
                                      provider.blogList.data.isNotEmpty) {
                                    final int count =
                                        provider.blogList.data.length;
                                    return BlogListItem(
                                      animationController:
                                          widget.animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      blog: provider.blogList.data[index],
                                      onTap: () {
                                        print(provider.blogList.data[index]
                                            .defaultPhoto.imgPath);
                                        Navigator.pushNamed(
                                            context, RoutePaths.blogDetail,
                                            arguments:
                                                provider.blogList.data[index]);
                                      },
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                childCount: provider.blogList.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider.resetBlogList();
                      },
                    )),
                PSProgressIndicator(provider.blogList.status)
              ],
            );
          },
        ),
      ),
    );
  }
}
