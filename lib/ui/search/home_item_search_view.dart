import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/product/search_product_provider.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/ui/common/ps_button_widget.dart';
import 'package:flutteradmotors/ui/common/ps_dropdown_base_widget.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/ps_special_check_text_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/condition_of_item.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/model_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/item_build_type.dart';
import 'package:flutteradmotors/viewobject/item_fuel_type.dart';
import 'package:flutteradmotors/viewobject/item_price_type.dart';
import 'package:flutteradmotors/viewobject/item_seller_type.dart';
import 'package:flutteradmotors/viewobject/item_type.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:flutteradmotors/viewobject/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutteradmotors/viewobject/transmission.dart';
import 'package:provider/provider.dart';
import 'package:flutteradmotors/ui/common/ps_textfield_widget.dart';

class HomeItemSearchView extends StatefulWidget {
  const HomeItemSearchView({
    @required this.productParameterHolder,
    @required this.animation,
    @required this.animationController,
  });

  final ProductParameterHolder productParameterHolder;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ItemSearchViewState createState() => _ItemSearchViewState();
}

class _ItemSearchViewState extends State<HomeItemSearchView> {
  ProductRepository repo1;
  PsValueHolder valueHolder;
  SearchProductProvider _searchProductProvider;

  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputMaximunPriceEditingController =
      TextEditingController();
  final TextEditingController userInputMinimumPriceEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');

    final Widget _searchButtonWidget = PSButtonWidget(
      hasShadow: true,
      width: double.infinity,
      titleText: Utils.getString(context, 'home_search__search'),
      onPressed: () async {
        // _searchProductProvider.productParameterHolder.itemLocationId =
        //     _searchProductProvider.psValueHolder.locationId;

        _searchProductProvider.productParameterHolder.isPaid =
            PsConst.PAID_ITEM_FIRST;
        if (userInputItemNameTextEditingController.text != null &&
            userInputItemNameTextEditingController.text != '') {
          _searchProductProvider.productParameterHolder.searchTerm =
              userInputItemNameTextEditingController.text;
        } else {
          _searchProductProvider.productParameterHolder.searchTerm = '';
        }
        if (userInputMaximunPriceEditingController.text != null) {
          _searchProductProvider.productParameterHolder.maxPrice =
              userInputMaximunPriceEditingController.text;
        } else {
          _searchProductProvider.productParameterHolder.maxPrice = '';
        }
        if (userInputMinimumPriceEditingController.text != null) {
          _searchProductProvider.productParameterHolder.minPrice =
              userInputMinimumPriceEditingController.text;
        } else {
          _searchProductProvider.productParameterHolder.minPrice = '';
        }

        if (_searchProductProvider.manufacturerId != null) {
          _searchProductProvider.productParameterHolder.manufacturerId =
              _searchProductProvider.manufacturerId;
        }
        if (_searchProductProvider.modelId != null) {
          _searchProductProvider.productParameterHolder.modelId =
              _searchProductProvider.modelId;
        }
        if (_searchProductProvider.itemTypeId != null) {
          _searchProductProvider.productParameterHolder.itemTypeId =
              _searchProductProvider.itemTypeId;
        }
        if (_searchProductProvider.itemConditionId != null) {
          _searchProductProvider.productParameterHolder.conditionOfItemId =
              _searchProductProvider.itemConditionId;
        }
        if (_searchProductProvider.itemPriceTypeId != null) {
          _searchProductProvider.productParameterHolder.itemPriceTypeId =
              _searchProductProvider.itemPriceTypeId;
        }
        if (_searchProductProvider.transmissionId != null) {
          _searchProductProvider.productParameterHolder.transmissionId =
              _searchProductProvider.transmissionId;
        }
        if (_searchProductProvider.itemColorId != null) {
          _searchProductProvider.productParameterHolder.colorId =
              _searchProductProvider.itemColorId;
        }
        if (_searchProductProvider.fuelTypeId != null) {
          _searchProductProvider.productParameterHolder.fuelTypeId =
              _searchProductProvider.fuelTypeId;
        }
        if (_searchProductProvider.buildTypeId != null) {
          _searchProductProvider.productParameterHolder.buildTypeId =
              _searchProductProvider.buildTypeId;
        }
        if (_searchProductProvider.sellerTypeId != null) {
          _searchProductProvider.productParameterHolder.sellerTypeId =
              _searchProductProvider.sellerTypeId;
        }
        print('userInputText' + userInputItemNameTextEditingController.text);
        final dynamic result =
            await Navigator.pushNamed(context, RoutePaths.filterProductList,
                arguments: ProductListIntentHolder(
                  appBarTitle:
                      Utils.getString(context, 'home_search__app_bar_title'),
                  productParameterHolder:
                      _searchProductProvider.productParameterHolder,
                ));
        if (result != null && result is ProductParameterHolder) {
          _searchProductProvider.productParameterHolder = result;
        }
      },
    );

    repo1 = Provider.of<ProductRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<SearchProductProvider>(
            lazy: false,
            create: (BuildContext content) {
              _searchProductProvider = SearchProductProvider(
                  repo: repo1, psValueHolder: valueHolder);
              _searchProductProvider.productParameterHolder =
                  widget.productParameterHolder;
              final String loginUserId =
                       Utils.checkUserLoginId(valueHolder);    
              _searchProductProvider.loadProductListByKey(
                  loginUserId,
                  _searchProductProvider.productParameterHolder);

              return _searchProductProvider;
            },
            child: Consumer<SearchProductProvider>(
              builder: (BuildContext context, SearchProductProvider provider,
                  Widget child) {
                if (_searchProductProvider.productList != null &&
                    _searchProductProvider.productList.data != null) {
                  widget.animationController.forward();
                  return SingleChildScrollView(
                    child: AnimatedBuilder(
                        animation: widget.animationController,
                        child: Container(
                          color: PsColors.baseColor,
                          child: Column(
                            children: <Widget>[
                              const PsAdMobBannerWidget(),
                              _ProductNameWidget(
                                userInputItemNameTextEditingController:
                                    userInputItemNameTextEditingController,
                              ),
                              _PriceWidget(
                                userInputMinimumPriceEditingController:
                                    userInputMinimumPriceEditingController,
                                userInputMaximunPriceEditingController:
                                    userInputMaximunPriceEditingController,
                              ),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'search__manufacturer'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedManufacturerName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic manufacturerResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.manufacturer,
                                            arguments: provider
                                                .selectedManufacturerName);

                                    if (manufacturerResult != null &&
                                        manufacturerResult is Manufacturer) {
                                      provider.manufacturerId =
                                          manufacturerResult.id;
                                      provider.modelId = '';
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedManufacturerName =
                                              manufacturerResult.name;
                                          provider.selectedModelName = '';
                                        });
                                      }
                                    }
                                    if (manufacturerResult) {
                                      provider.selectedManufacturerName = '';
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title:
                                      Utils.getString(context, 'search__model'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedModelName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);
                                    if (provider.manufacturerId != '') {
                                      final dynamic modelResult =
                                          await Navigator.pushNamed(context,
                                              RoutePaths.searchSubCategory,
                                              arguments:
                                                  ModelIntentHolder(
                                                      modelName: provider
                                                          .selectedModelName,
                                                      categoryId: provider
                                                          .manufacturerId));
                                      if (modelResult != null &&
                                          modelResult is Model) {
                                        provider.modelId = modelResult.id;

                                        provider.selectedModelName =
                                            modelResult.name;
                                      }
                                      if (modelResult) {
                                        provider.selectedModelName = '';
                                      }
                                    } else {
                                      showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ErrorDialog(
                                              message: Utils.getString(context,
                                                  'home_search__choose_manufacturer_first'),
                                            );
                                          });
                                      const ErrorDialog(
                                          message: 'Choose Category first');
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__type'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedItemTypeName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic itemTypeResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemType,
                                            arguments:
                                                provider.selectedItemTypeName);

                                    if (itemTypeResult != null &&
                                        itemTypeResult is ItemType) {
                                      provider.itemTypeId = itemTypeResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedItemTypeName =
                                              itemTypeResult.name;
                                        });
                                      }
                                    }
                                    if (itemTypeResult) {
                                      provider.selectedItemTypeName = '';
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__item_condition'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedItemConditionName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic itemConditionResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemCondition,
                                            arguments: provider
                                                .selectedItemConditionName);

                                    if (itemConditionResult != null &&
                                        itemConditionResult
                                            is ConditionOfItem) {
                                      provider.itemConditionId =
                                          itemConditionResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedItemConditionName =
                                              itemConditionResult.name;
                                        });
                                      }
                                    }
                                    if (itemConditionResult) {
                                      provider.selectedItemConditionName = '';
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__price_type'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedItemPriceTypeName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic itemPriceTypeResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemPriceType,
                                            arguments: provider
                                                .selectedItemPriceTypeName);

                                    if (itemPriceTypeResult != null &&
                                        itemPriceTypeResult is ItemPriceType) {
                                      provider.itemPriceTypeId =
                                          itemPriceTypeResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedItemPriceTypeName =
                                              itemPriceTypeResult.name;
                                        });
                                      }
                                    }
                                    if (itemPriceTypeResult) {
                                      provider.selectedItemPriceTypeName = '';
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__transmission'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedTransmissionName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic tramissionResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.transmission,
                                            arguments: provider
                                                .selectedTransmissionName);

                                    if (tramissionResult != null &&
                                        tramissionResult is Transmission) {
                                      provider.transmissionId =
                                          tramissionResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedTransmissionName =
                                              tramissionResult.name;
                                        });
                                      }
                                    }
                                    if (tramissionResult) {
                                      provider.selectedTransmissionName = '';
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__color'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedColorName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic colorResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemColor,
                                            arguments:
                                                provider.selectedColorName);

                                    if (colorResult != null &&
                                        colorResult is ItemColor) {
                                      provider.itemColorId = colorResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedColorName =
                                              colorResult.colorValue;
                                        });
                                      }
                                    }
                                    if (colorResult) {
                                      provider.selectedColorName = '';
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__fuel_type'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedFuelType,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic fuelTypeResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemFuelType,
                                            arguments:
                                                provider.selectedFuelType);

                                    if (fuelTypeResult != null &&
                                        fuelTypeResult is ItemFuelType) {
                                      provider.fuelTypeId = fuelTypeResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedFuelType =
                                              fuelTypeResult.fuelName;
                                        });
                                      }
                                    }
                                    if (fuelTypeResult) {
                                      provider.selectedFuelType = '';
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__build_type'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedBuildType,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic buildTypeResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemBuildType,
                                            arguments:
                                                provider.selectedBuildType);

                                    if (buildTypeResult != null &&
                                        buildTypeResult is ItemBuildType) {
                                      provider.fuelTypeId = buildTypeResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedBuildType =
                                              buildTypeResult.carType;
                                        });
                                      }
                                    }
                                    if (buildTypeResult) {
                                      provider.selectedBuildType = '';
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__seller_type'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedSellerType,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic sellerTypeResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemSellerType,
                                            arguments:
                                                provider.selectedSellerType);

                                    if (sellerTypeResult != null &&
                                        sellerTypeResult is ItemSellerType) {
                                      provider.sellerTypeId =
                                          sellerTypeResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedSellerType =
                                              sellerTypeResult.sellerType;
                                        });
                                      }
                                    }
                                    if (sellerTypeResult) {
                                      provider.selectedSellerType = '';
                                    }
                                  }),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: PsDimens.space16,
                                      top: PsDimens.space16,
                                      right: PsDimens.space16,
                                      bottom: PsDimens.space40),
                                  child: _searchButtonWidget),
                            ],
                          ),
                        ),
                        builder: (BuildContext context, Widget child) {
                          return FadeTransition(
                              opacity: widget.animation,
                              child: Transform(
                                  transform: Matrix4.translationValues(
                                      0.0,
                                      100 * (1.0 - widget.animation.value),
                                      0.0),
                                  child: child));
                        }),
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}

class _ProductNameWidget extends StatefulWidget {
  const _ProductNameWidget({this.userInputItemNameTextEditingController});

  final TextEditingController userInputItemNameTextEditingController;

  @override
  __ProductNameWidgetState createState() => __ProductNameWidgetState();
}

class __ProductNameWidgetState extends State<_ProductNameWidget> {
  @override
  Widget build(BuildContext context) {
    print('*****' + widget.userInputItemNameTextEditingController.text);
    return Column(
      children: <Widget>[
        PsTextFieldWidget(
            titleText: Utils.getString(context, 'home_search__product_name'),
            textAboutMe: false,
            hintText:
                Utils.getString(context, 'home_search__product_name_hint'),
            textEditingController:
                widget.userInputItemNameTextEditingController),
      ],
    );
  }
}

class _ChangeRatingColor extends StatelessWidget {
  const _ChangeRatingColor({
    Key key,
    @required this.title,
    @required this.checkColor,
  }) : super(key: key);

  final String title;
  final bool checkColor;

  @override
  Widget build(BuildContext context) {
    final Color defaultBackgroundColor = PsColors.backgroundColor;
    return Container(
      width: MediaQuery.of(context).size.width / 5.5,
      height: PsDimens.space104,
      decoration: BoxDecoration(
        color: checkColor ? defaultBackgroundColor : PsColors.mainColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.star,
              color: checkColor ? PsColors.iconColor : PsColors.white,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: checkColor ? PsColors.iconColor : PsColors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRangeWidget extends StatefulWidget {
  @override
  __RatingRangeWidgetState createState() => __RatingRangeWidgetState();
}

class __RatingRangeWidgetState extends State<_RatingRangeWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    dynamic _firstRatingRangeSelected() {
      if (!provider.isfirstRatingClicked) {
        // isfirstRatingClicked = true;
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: true,
        );
      } else {
        // isfirstRatingClicked = false;
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _secondRatingRangeSelected() {
      if (!provider.isSecondRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _thirdRatingRangeSelected() {
      if (!provider.isThirdRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fouthRatingRangeSelected() {
      if (!provider.isfouthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fifthRatingRangeSelected() {
      if (!provider.isFifthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: false,
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__rating_range'),
                  style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isfirstRatingClicked) {
                    provider.isfirstRatingClicked = true;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: _firstRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(PsDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isSecondRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = true;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: _secondRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isThirdRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = true;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: _thirdRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(PsDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isfouthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = true;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: _fouthRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  ),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isFifthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = true;
                  } else {
                    setAllRatingFalse(provider);
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: _fifthRatingRangeSelected(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

dynamic setAllRatingFalse(SearchProductProvider provider) {
  provider.isfirstRatingClicked = false;
  provider.isSecondRatingClicked = false;
  provider.isThirdRatingClicked = false;
  provider.isfouthRatingClicked = false;
  provider.isFifthRatingClicked = false;
}

class _PriceWidget extends StatelessWidget {
  const _PriceWidget(
      {this.userInputMinimumPriceEditingController,
      this.userInputMaximunPriceEditingController});
  final TextEditingController userInputMinimumPriceEditingController;
  final TextEditingController userInputMaximunPriceEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__price'),
                  style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
        ),
        _PriceTextWidget(
            title: Utils.getString(context, 'home_search__lowest_price'),
            textField: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: PsDimens.space8, bottom: PsDimens.space12),
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'home_search__not_set'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: PsColors.textPrimaryLightColor),
                ),
                keyboardType: TextInputType.number,
                controller: userInputMinimumPriceEditingController)),
        const Divider(
          height: PsDimens.space1,
        ),
        _PriceTextWidget(
            title: Utils.getString(context, 'home_search__highest_price'),
            textField: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: PsDimens.space8, bottom: PsDimens.space12),
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'home_search__not_set'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: PsColors.textPrimaryLightColor),
                ),
                keyboardType: TextInputType.number,
                controller: userInputMaximunPriceEditingController)),
      ],
    );
  }
}

class _PriceTextWidget extends StatelessWidget {
  const _PriceTextWidget({
    Key key,
    @required this.title,
    @required this.textField,
  }) : super(key: key);

  final String title;
  final TextField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: PsColors.backgroundColor,
      child: Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.bodyText1),
            Container(
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(color: PsColors.mainDividerColor),
                ),
                width: PsDimens.space120,
                height: PsDimens.space36,
                child: textField),
          ],
        ),
      ),
    );
  }
}

class _SpecialCheckWidget extends StatefulWidget {
  @override
  __SpecialCheckWidgetState createState() => __SpecialCheckWidgetState();
}

class __SpecialCheckWidgetState extends State<_SpecialCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__special_check'),
                  style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
        ),
        SpecialCheckTextWidget(
            title: Utils.getString(context, 'home_search__featured_product'),
            icon: FontAwesome5.gem,
            checkTitle: 1,
            size: PsDimens.space18),
        const Divider(
          height: PsDimens.space1,
        ),
        SpecialCheckTextWidget(
            title: Utils.getString(context, 'home_search__discount_price'),
            icon: Feather.percent,
            checkTitle: 2,
            size: PsDimens.space18),
        const Divider(
          height: PsDimens.space1,
        ),
      ],
    );
  }
}

class _SpecialCheckTextWidget extends StatefulWidget {
  const _SpecialCheckTextWidget({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.checkTitle,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool checkTitle;

  @override
  __SpecialCheckTextWidgetState createState() =>
      __SpecialCheckTextWidgetState();
}

class __SpecialCheckTextWidgetState extends State<_SpecialCheckTextWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    return Container(
        width: double.infinity,
        height: PsDimens.space52,
        child: Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    widget.icon,
                    size: PsDimens.space20,
                    // color: ps_wtheme_icon_color,
                  ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              if (widget.checkTitle)
                Switch(
                  value: provider.isSwitchedFeaturedProduct,
                  onChanged: (bool value) {
                    if (mounted) {
                      setState(() {
                        provider.isSwitchedFeaturedProduct = value;
                      });
                    }
                  },
                  activeTrackColor: PsColors.mainColor,
                  activeColor: PsColors.mainColor,
                )
              else
                Switch(
                  value: provider.isSwitchedDiscountPrice,
                  onChanged: (bool value) {
                    if (mounted) {
                      setState(() {
                        provider.isSwitchedDiscountPrice = value;
                      });
                    }
                  },
                  activeTrackColor: PsColors.mainColor,
                  activeColor: PsColors.mainColor,
                ),
            ],
          ),
        ));
  }
}
