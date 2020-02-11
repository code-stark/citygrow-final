import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/shop_info/shop_info_provider.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/default_photo.dart';
import 'package:digitalproductstore/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopInfoView extends StatefulWidget {
  const ShopInfoView({Key key, this.animationController, this.animation})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ShopInfoViewState createState() => _ShopInfoViewState();
}

class _ShopInfoViewState extends State<ShopInfoView> {
  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return SliverToBoxAdapter(
      child: Consumer<ShopInfoProvider>(
        builder:
            (BuildContext context, ShopInfoProvider provider, Widget child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: widget.animation,
                    child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 30 * (1.0 - widget.animation.value), 0.0),
                        child: provider.shopInfo != null &&
                                provider.shopInfo.data != null
                            ? _ShopInfoViewWidget(
                                widget: widget, provider: provider)
                            : Container()));
              });
        },
      ),
    );
  }
}

class _ShopInfoViewWidget extends StatelessWidget {
  const _ShopInfoViewWidget({
    Key key,
    @required this.widget,
    @required this.provider,
  }) : super(key: key);

  final ShopInfoView widget;
  final ShopInfoProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _HeaderImageWidget(
          photo: provider.shopInfo.data.defaultPhoto ?? '',
        ),
        Container(
          margin: const EdgeInsets.only(
              left: ps_space_16, right: ps_space_16, top: ps_space_16),
          child: Column(
            children: <Widget>[
              ImageAndTextWidget(
                data: provider.shopInfo.data ?? '',
              ),
              _DescriptionWidget(
                data: provider.shopInfo.data,
              ),
              _PhoneAndContactWidget(
                phone: provider.shopInfo.data,
              ),
              _LinkAndTitle(
                  icon: FontAwesome.wordpress,
                  title:
                      Utils.getString(context, 'shop_info__visit_our_website'),
                  link: provider.shopInfo.data.aboutWebsite),
              _LinkAndTitle(
                  icon: FontAwesome.facebook,
                  title: Utils.getString(context, 'shop_info__facebook'),
                  link: provider.shopInfo.data.facebook),
              _LinkAndTitle(
                  icon: FontAwesome.google_plus_circle,
                  title: Utils.getString(context, 'shop_info__google_plus'),
                  link: provider.shopInfo.data.googlePlus),
              _LinkAndTitle(
                  icon: FontAwesome.twitter_square,
                  title: Utils.getString(context, 'shop_info__twitter'),
                  link: provider.shopInfo.data.twitter),
              _LinkAndTitle(
                  icon: FontAwesome.instagram,
                  title: Utils.getString(context, 'shop_info__instagram'),
                  link: provider.shopInfo.data.instagram),
              _LinkAndTitle(
                  icon: FontAwesome.youtube,
                  title: Utils.getString(context, 'shop_info__youtube'),
                  link: provider.shopInfo.data.youtube),
              _LinkAndTitle(
                  icon: FontAwesome.pinterest,
                  title: Utils.getString(context, 'shop_info__pinterest'),
                  link: provider.shopInfo.data.pinterest),
              _SourceAddressWidget(
                data: provider.shopInfo.data,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _LinkAndTitle extends StatelessWidget {
  const _LinkAndTitle({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.link,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: ps_space_16,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                  width: ps_space_20,
                  height: ps_space_20,
                  child: Icon(
                    icon,
                  )),
              const SizedBox(
                width: ps_space_12,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.body2,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: ps_space_8,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: ps_space_32,
              ),
              InkWell(
                child: Text(
                  link == ''
                      ? Utils.getString(context, 'shop_info__dash')
                      : link,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        color: ps_ctheme__color_about_us,
                      ),
                ),
                onTap: () async {
                  if (await canLaunch(link)) {
                    await launch(link);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _HeaderImageWidget extends StatelessWidget {
  const _HeaderImageWidget({
    Key key,
    @required this.photo,
  }) : super(key: key);

  final DefaultPhoto photo;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PsNetworkImage(
          photoKey: '',
          defaultPhoto: photo ?? '',
          width: double.infinity,
          height: 300,
          boxfit: BoxFit.cover,
          onTap: () {},
        ),
      ],
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final ShopInfo data;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: ps_space_4,
    );

    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: data.defaultPhoto,
      width: 50,
      height: 50,
      boxfit: BoxFit.cover,
      onTap: () {},
    );

    return Row(
      children: <Widget>[
        _imageWidget,
        const SizedBox(
          width: ps_space_12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                data.name,
                style: Theme.of(context).textTheme.subhead.copyWith(
                      color: ps_ctheme__color_speical,
                    ),
              ),
              _spacingWidget,
              InkWell(
                child: Text(
                  data.aboutPhone1,
                  style: Theme.of(context).textTheme.body1.copyWith(),
                ),
                onTap: () async {
                  if (await canLaunch('tel://${data.aboutPhone1}')) {
                    await launch('tel://${data.aboutPhone1}');
                  } else {
                    throw 'Could not Call Phone Number 1';
                  }
                },
              ),
              _spacingWidget,
              Row(
                children: <Widget>[
                  Container(
                      child: Icon(
                    Icons.email,
                  )),
                  const SizedBox(
                    width: ps_space_8,
                  ),
                  InkWell(
                    child: Text(
                      data.codEmail,
                      style: Theme.of(context).textTheme.body1.copyWith(
                            color: ps_ctheme__color_about_us,
                          ),
                    ),
                    onTap: () async {
                      if (await canLaunch('mailto:teamps.is.cool@gmail.com')) {
                        await launch('mailto:teamps.is.cool@gmail.com');
                      } else {
                        throw 'Could not launch teamps.is.cool@gmail.com';
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _PhoneAndContactWidget extends StatelessWidget {
  const _PhoneAndContactWidget({
    Key key,
    @required this.phone,
  }) : super(key: key);

  final ShopInfo phone;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: ps_space_16,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: ps_space_32,
        ),
        Text(Utils.getString(context, 'shop_info__contact'),
            style: Theme.of(context).textTheme.subhead),
        _spacingWidget,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: ps_space_20,
                height: ps_space_20,
                child: Icon(
                  Icons.phone_in_talk,
                )),
            const SizedBox(
              width: ps_space_12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'shop_info__phone'),
                  style: Theme.of(context).textTheme.subtitle,
                ),
                _spacingWidget,
                InkWell(
                  child: Text(
                    phone.aboutPhone1,
                    style: Theme.of(context).textTheme.body1.copyWith(),
                  ),
                  onTap: () async {
                    if (await canLaunch('tel://${phone.aboutPhone1}')) {
                      await launch('tel://${phone.aboutPhone1}');
                    } else {
                      throw 'Could not Call Phone Number 1';
                    }
                  },
                ),
                _spacingWidget,
                InkWell(
                  child: Text(
                    phone.aboutPhone2,
                    style: Theme.of(context).textTheme.body1.copyWith(),
                  ),
                  onTap: () async {
                    if (await canLaunch('tel://${phone.aboutPhone2}')) {
                      await launch('tel://${phone.aboutPhone2}');
                    } else {
                      throw 'Could not Call Phone Number 2';
                    }
                  },
                ),
                _spacingWidget,
                InkWell(
                  child: Text(
                    phone.aboutPhone3,
                    style: Theme.of(context).textTheme.body1.copyWith(),
                  ),
                  onTap: () async {
                    if (await canLaunch('tel://${phone.aboutPhone3}')) {
                      await launch('tel://${phone.aboutPhone3}');
                    } else {
                      throw 'Could not Call Phone Number 3';
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        _spacingWidget,
      ],
    );
  }
}

class _SourceAddressWidget extends StatelessWidget {
  const _SourceAddressWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final ShopInfo data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: ps_space_32,
        ),
        Row(
          children: <Widget>[
            Text(Utils.getString(context, 'shop_info__source_address'),
                style: Theme.of(context).textTheme.subhead),
          ],
        ),
        const SizedBox(
          height: ps_space_16,
        ),
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
            ),
            _AddressWidget(icon: Icons.location_on, title: data.address1),
            _AddressWidget(icon: Icons.location_on, title: data.address2),
            _AddressWidget(icon: Icons.location_on, title: data.address3),
            const SizedBox(
              height: ps_space_12,
            ),
          ],
        )
      ],
    );
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    Key key,
    @required this.icon,
    @required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: ps_space_16,
        ),
        if (title != '')
          Row(
            children: <Widget>[
              Container(
                  width: ps_space_20,
                  height: ps_space_20,
                  child: Icon(
                    icon,
                  )),
              const SizedBox(
                width: ps_space_8,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.body1.copyWith(),
              ),
            ],
          )
        else
          Container()
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key key, this.data}) : super(key: key);

  final ShopInfo data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: ps_space_16,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            data.description,
            style: Theme.of(context).textTheme.body1.copyWith(height: 1.3),
          ),
        )
      ],
    );
  }
}
