import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/provider/transaction/transaction_header_provider.dart';
import 'package:digitalproductstore/provider/user/user_login_provider.dart';
import 'package:digitalproductstore/repository/transaction_header_repository.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/ui/transaction/item/transaction_list_item.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key key,
    this.animationController,
    @required this.flag,
    this.userId,
    @required this.scaffoldKey,
  }) : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int flag;
  final String userId;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return SingleChildScrollView(
        child: Container(
      height: widget.flag ==
              REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
          ? MediaQuery.of(context).size.height - 100
          : MediaQuery.of(context).size.height - 40,
      child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            _ProfileDetailWidget(
              animationController: widget.animationController,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: widget.animationController,
                  curve: const Interval((1 / 4) * 2, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              ),
              userId: widget.userId,
            ),
            _TransactionListViewWidget(
              scaffoldKey: widget.scaffoldKey,
              animationController: widget.animationController,
              userId: widget.userId,
            )
          ]),
    ));
  }
}

class _TransactionListViewWidget extends StatelessWidget {
  const _TransactionListViewWidget(
      {Key key,
      @required this.animationController,
      @required this.userId,
      @required this.scaffoldKey})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of<Users>(context);
    TransactionHeaderRepository transactionHeaderRepository;
    PsValueHolder psValueHolder;
    transactionHeaderRepository =
        Provider.of<TransactionHeaderRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<TransactionHeaderProvider>(
            create: (BuildContext context) {
      final TransactionHeaderProvider provider =
          TransactionHeaderProvider(
              repo: transactionHeaderRepository,
              psValueHolder: psValueHolder);
      if (provider.psValueHolder.loginUserId == null ||
          provider.psValueHolder.loginUserId == '') {
        provider.loadTransactionList(userId);
      } else {
        provider
            .loadTransactionList(provider.psValueHolder.loginUserId);
      }

      return provider;
    }, child: Consumer<TransactionHeaderProvider>(builder:
                (BuildContext context,
                    TransactionHeaderProvider provider,
                    Widget child) {
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('AppUsers')
              .document(users.uid)
              .collection('order')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data.documents != null &&
                snapshot.data != null) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: ps_space_44),
                child: Stack(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: ps_space_12,
                          right: ps_space_12,
                          top: 0,
                          bottom: ps_space_8),
                      child: RefreshIndicator(
                        child: CustomScrollView(
                            physics:
                                const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (snapshot.data.documents !=
                                            null ||
                                        snapshot.data.documents
                                            .isNotEmpty) {
                                      final int count = snapshot
                                          .data.documents.length;
                                      return TransactionListItem(
                                        transactionList: snapshot
                                            .data.documents[index],
                                        scaffoldKey: scaffoldKey,
                                        animationController:
                                            animationController,
                                        animation: Tween<double>(
                                                begin: 0.0, end: 1.0)
                                            .animate(
                                          CurvedAnimation(
                                            parent:
                                                animationController,
                                            curve: Interval(
                                                (1 / count) * index,
                                                1.0,
                                                curve: Curves
                                                    .fastOutSlowIn),
                                          ),
                                        ),
                                        // transaction: provider
                                        //     .transactionList
                                        //     .data[index],
                                        // onTap: () {
                                        //   Navigator.pushNamed(
                                        //       context,
                                        //       RoutePaths
                                        //           .transactionDetail,
                                        //       arguments: snapshot.data
                                        //           .documents[index]);
                                        // },
                                      );
                                    } else {
                                      return null;
                                    }
                                  },
                                  childCount:
                                      snapshot.data.documents.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          return provider.resetTransactionList();
                        },
                      )),
                ]),
              );
            } else {
              return Container();
            }
          });
    })));
  }
}

class _ProfileDetailWidget extends StatelessWidget {
  const _ProfileDetailWidget({
    Key key,
    this.animationController,
    this.animation,
    @required this.userId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: 1,
      color: ps_ctheme__color_line,
    );
    UserRepository userRepository;
    PsValueHolder psValueHolder;
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    final Users users = Provider.of<Users>(context);
    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserLoginProvider>(
          create: (BuildContext context) {
        final UserLoginProvider provider = UserLoginProvider(
            repo: userRepository, psValueHolder: psValueHolder);
        if (provider.psValueHolder.loginUserId == null ||
            provider.psValueHolder.loginUserId == '') {
          provider.getUserLogin(userId);
        } else {
          provider.getUserLogin(provider.psValueHolder.loginUserId);
        }
        return provider;
      }, child: Consumer<UserLoginProvider>(builder:
              (BuildContext context, UserLoginProvider provider,
                  Widget child) {
        if (users != null && users.uid != null) {
          return StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('AppUsers')
                  .document(users.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final dynamic datas = snapshot.data;
                return AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext context, Widget child) {
                      return FadeTransition(
                          opacity: animation,
                          child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0,
                                  100 * (1.0 - animation.value),
                                  0.0),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    _ImageAndTextWidget(
                                      userProvider: provider,
                                      usersData: datas,
                                    ),
                                    _dividerWidget,
                                    _EditAndHistoryRowWidget(
                                        usersData: datas,
                                        userLoginProvider: provider),
                                    _dividerWidget,
                                    _FavAndSettingWidget(),
                                    _dividerWidget,
                                    _JoinDateWidget(
                                      userProvider: provider,
                                      usersData: datas,
                                    ),
                                    _dividerWidget,
                                    _OrderAndSeeAllWidget(),
                                  ],
                                ),
                              )));
                    });
              });
        } else {
          return Container();
        }
      })),
    );
  }
}

class _JoinDateWidget extends StatelessWidget {
  const _JoinDateWidget(
      {this.userProvider, @required this.usersData});
  final UserLoginProvider userProvider;
  final DocumentSnapshot usersData;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(ps_space_16),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  Utils.getString(context, 'profile__join_on'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  width: ps_space_2,
                ),
                Text(
                  // DateTime.parse(usersData['TimeCreated'].toDate().toString())
                  //
                  DateFormat.yMMMMEEEEd()
                          .format(usersData['TimeCreated'].toDate())
                          .toString() ??
                      '',

                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            )));
  }
}

class _FavAndSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Widget _sizedBoxWidget = SizedBox(
      width: ps_space_4,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.favouriteProductList,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__favourite'),
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Container(
          color: ps_ctheme__color_line,
          width: ps_space_1,
          height: ps_space_48,
        ),
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.setting,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.settings,
                      color: Theme.of(context).iconTheme.color),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__setting'),
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class _EditAndHistoryRowWidget extends StatelessWidget {
  const _EditAndHistoryRowWidget(
      {@required this.userLoginProvider, @required this.usersData});
  final UserLoginProvider userLoginProvider;
  final DocumentSnapshot usersData;
  @override
  Widget build(BuildContext context) {
    final Widget _verticalLineWidget = Container(
      color: ps_ctheme__color_line,
      width: ps_space_1,
      height: ps_space_48,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _EditAndHistoryTextWidget(
          snapshot: usersData,
          userLoginProvider: userLoginProvider,
          checkText: 0,
        ),
        // _verticalLineWidget,
        // _EditAndHistoryTextWidget(
        //   snapshot: usersData,
        //   userLoginProvider: userLoginProvider,
        //   checkText: 1,
        // ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          snapshot: usersData,
          userLoginProvider: userLoginProvider,
          checkText: 2,
        )
      ],
    );
  }
}

class _EditAndHistoryTextWidget extends StatelessWidget {
  const _EditAndHistoryTextWidget({
    Key key,
    @required this.userLoginProvider,
    @required this.checkText,
    @required this.snapshot,
  }) : super(key: key);

  final UserLoginProvider userLoginProvider;
  final int checkText;
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: MaterialButton(
            height: 50,
            minWidth: double.infinity,
            onPressed: () async {
              if (checkText == 0) {
                final dynamic returnData = await Navigator.pushNamed(
                    context, RoutePaths.editProfile,
                    arguments: snapshot);
                if (returnData)
                  userLoginProvider.getUserLogin(
                      userLoginProvider.psValueHolder.loginUserId);
              } else if (checkText == 1) {
                Navigator.pushNamed(
                  context,
                  RoutePaths.historyList,
                );
              } else if (checkText == 2) {
                Navigator.pushNamed(
                  context,
                  RoutePaths.transactionList,
                );
              }
            },
            child: checkText == 0
                ? Text(
                    Utils.getString(context, 'profile__edit'),
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                : checkText == 1
                    ? Text(
                        Utils.getString(context, 'profile__history'),
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        Utils.getString(
                            context, 'profile__transaction'),
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.bold),
                      )));
  }
}

class _OrderAndSeeAllWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutePaths.transactionList,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: ps_space_20,
            left: ps_space_16,
            right: ps_space_16,
            bottom: ps_space_16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(Utils.getString(context, 'profile__order'),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1),
            InkWell(
              child: Text(
                Utils.getString(context, 'profile__view_all'),
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: ps_ctheme__color_speical),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget(
      {this.userProvider, @required this.usersData});
  final UserLoginProvider userProvider;
  final DocumentSnapshot usersData;
  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<Users>(context);

    final Widget _imageWidget = Padding(
      padding: const EdgeInsets.all(ps_space_16),
      child: PsNetworkCircleImage(
        photoKey: '',
        url: usersData['ProfileImage'].toString() ??
            user.imageUrl ??
            'https://www.searchpng.com/wp-content/uploads/2019/02/Profile-PNG-Icon-715x715.png',
        width: ps_space_80,
        height: ps_space_80,
        boxfit: BoxFit.cover,
        onTap: () {},
      ),
    );
    const Widget _spacingWidget = SizedBox(
      height: ps_space_4,
    );

    return Container(
      width: double.infinity,
      height: ps_space_120,
      child: Row(
        children: <Widget>[
          _imageWidget,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: ps_space_24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    usersData['name'] ?? user.name,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  _spacingWidget,
                  //!user Phone number
                  Text(
                    usersData['phonenumber'] != '' &&
                            usersData['phonenumber'] != null
                        ? usersData['phonenumber']
                        : Utils.getString(
                            context, 'profile__phone_no'),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  _spacingWidget,
                  //!about me
                  Text(
                    usersData['aboutme'] != '' &&
                            usersData['aboutme'] != null
                        ? usersData['aboutme']
                        : Utils.getString(
                            context, 'profile__about_me'),
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
