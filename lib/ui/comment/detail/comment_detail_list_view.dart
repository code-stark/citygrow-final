import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/api/common/ps_status.dart';

import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/comment/comment_detail_provider.dart';
import 'package:digitalproductstore/repository/comment_detail_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:digitalproductstore/ui/common/ps_textfield_widget.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/comment_detail.dart';
import 'package:digitalproductstore/viewobject/comment_header.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/comment_detail_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'comment_detail_list_item_view.dart';

class CommentDetailListView extends StatefulWidget {
  const CommentDetailListView({
    Key key,
    @required this.commentHeader,
  }) : super(key: key);

  final CommentHeader commentHeader;
  @override
  _CommentDetailListViewState createState() => _CommentDetailListViewState();
}

class _CommentDetailListViewState extends State<CommentDetailListView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  CommentDetailProvider _commentDetailProvider;
  CommentDetailRepository commentDetailRepo;
  PsValueHolder psValueHolder;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _commentDetailProvider.nextCommentDetailList(widget.commentHeader.id);
      }
    });
    animationController =
        AnimationController(duration: animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  bool controlProgressBar = false;
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

    commentDetailRepo = Provider.of<CommentDetailRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<CommentDetailProvider>(
        appBarTitle:
            Utils.getString(context, 'comment_detail__app_bar_name') ?? '',
        initProvider: () {
          return CommentDetailProvider(
              repo: commentDetailRepo, psValueHolder: psValueHolder);
        },
        onProviderReady: (CommentDetailProvider provider) {
          provider.loadCommentDetailList(widget.commentHeader.id);
          _commentDetailProvider = provider;
        },
        builder: (BuildContext context, CommentDetailProvider provider,
            Widget child) {
          return Container(
            color: Utils.isLightMode(context)
                ? Colors.grey[100]
                : Colors.grey[900],
            child: Stack(
              children: <Widget>[
                // RefreshIndicator(
                //   child:
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: ps_space_8),
                        child: CustomScrollView(
                            controller: _scrollController,
                            reverse: true,
                            slivers: <Widget>[
                              CommentListWidget(
                                  animationController: animationController,
                                  provider: provider),
                            ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          width: double.infinity,
                          child: EditTextAndButtonWidget(
                              provider: provider,
                              commentHeader: widget.commentHeader)),
                    )
                  ],
                ),
                // onRefresh: () {
                //   return provider
                //       .resetCommentDetailList(widget.commentHeader.id);
                // },
                // ),
                if (provider.commentDetailList.data != null &&
                    provider.commentDetailList != null)
                  // PSProgressIndicator(provider.commentDetailList.status)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Opacity(
                      opacity: provider.commentDetailList.status ==
                              PsStatus.PROGRESS_LOADING
                          ? 1.0
                          : 0.0,
                      child: const LinearProgressIndicator(),
                    ),
                  )
                else
                  const PSProgressIndicator(PsStatus.SUCCESS)
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditTextAndButtonWidget extends StatefulWidget {
  const EditTextAndButtonWidget({
    Key key,
    @required this.provider,
    @required this.commentHeader,
  }) : super(key: key);

  final CommentDetailProvider provider;
  final CommentHeader commentHeader;

  @override
  _EditTextAndButtonWidgetState createState() =>
      _EditTextAndButtonWidgetState();
}

class _EditTextAndButtonWidgetState extends State<EditTextAndButtonWidget> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ps_space_72,
      child: Container(
        decoration: BoxDecoration(
          color: Utils.isLightMode(context) ? Colors.white : Colors.grey[850],
          border: Border.all(
              color: Utils.isLightMode(context)
                  ? Colors.grey[200]
                  : Colors.grey[900]),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(ps_space_12),
              topRight: Radius.circular(ps_space_12)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Utils.isLightMode(context)
                  ? Colors.grey[300]
                  : Colors.grey[900],
              blurRadius: 1.0, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
              offset: const Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(ps_space_1),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: ps_space_4,
              ),
              Expanded(
                  flex: 6,
                  child: PsTextFieldWidget(
                    hintText: Utils.getString(
                        context, 'comment_detail__comment_hint'),
                    textEditingController: commentController,
                    showTitle: false,
                  )),
              // Expanded(
              //   flex: 6,
              //   child: Container(
              //     alignment: Alignment.center,
              //     height: ps_space_44,
              //     margin:
              //         const EdgeInsets.only(right: ps_space_4, left: ps_space_4),
              //     decoration: BoxDecoration(
              //       border: Border.all(width: 2.0, color: Colors.grey),
              //       borderRadius: BorderRadius.circular(ps_space_8),
              //     ),
              //     child: TextField(
              //       maxLines: null,
              //       controller: commentController,
              //       style: Theme.of(context).textTheme.body1,
              //       decoration: InputDecoration(
              //           contentPadding: const EdgeInsets.only(
              //               left: ps_space_12,
              //               bottom: ps_space_8,
              //               right: ps_space_12),
              //           border: InputBorder.none,
              //           hintText: Utils.getString(
              //               context, 'comment_detail__comment_hint')),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Container(
                  height: ps_space_44,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                      left: ps_space_4, right: ps_space_4),
                  decoration: BoxDecoration(
                    color: ps_ctheme__color_speical,
                    borderRadius: BorderRadius.circular(ps_space_4),
                    border: Border.all(
                        color: Utils.isLightMode(context)
                            ? Colors.grey[200]
                            : Colors.black87),
                  ),
                  child: InkWell(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: ps_space_20,
                      ),
                    ),
                    onTap: () async {
                      if (commentController.text.isEmpty) {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return WarningDialog(
                                message: Utils.getString(context,
                                    Utils.getString(context, 'comment__empty')),
                              );
                            });
                      } else {
                        if (await utilsCheckInternetConnectivity()) {
                          utilsNavigateOnUserVerificationView(
                              widget.provider, context, () async {
                            final CommentDetailParameterHolder
                                commentHeaderParameterHolder =
                                CommentDetailParameterHolder(
                              userId: widget.commentHeader.userId,
                              headerId: widget.commentHeader.id,
                              detailComment: commentController.text,
                            );

                            final PsResource<List<CommentDetail>> _apiStatus =
                                await widget.provider.postCommentDetail(
                                    commentHeaderParameterHolder.toMap());
                            if (_apiStatus.data != null) {
                              widget.provider.resetCommentDetailList(
                                  widget.commentHeader.id);
                              commentController.clear();
                            } else {
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(
                                      message: Utils.getString(
                                          context,
                                          Utils.getString(
                                              context, _apiStatus.message)),
                                    );
                                  });
                            }
                          });
                        } else {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message: Utils.getString(
                                      context, 'error_dialog__no_internet'),
                                );
                              });
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: ps_space_4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentListWidget extends StatefulWidget {
  const CommentListWidget({
    Key key,
    this.animationController,
    this.provider,
  }) : super(key: key);

  final AnimationController animationController;
  final CommentDetailProvider provider;
  @override
  _CommentListWidgetState createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          widget.animationController.forward();
          final int count = widget.provider.commentDetailList.data.length;
          return CommetDetailListItemView(
            animationController: widget.animationController,
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn),
              ),
            ),
            comment: widget.provider.commentDetailList.data[index],
            onTap: () {
              // Navigator.pushNamed(context, RoutePaths.commentDetail);
            },
          );
        },
        childCount: widget.provider.commentDetailList.data.length,
      ),
    );
  }
}
