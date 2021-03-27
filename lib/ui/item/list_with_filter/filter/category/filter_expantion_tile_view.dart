import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/provider/model/model_provider.dart';
import 'package:flutteradmotors/repository/model_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:provider/provider.dart';
import 'package:flutteradmotors/ui/common/expansion_tile.dart' as custom;

class FilterExpantionTileView extends StatefulWidget {
  const FilterExpantionTileView(
      {Key key, this.selectedData, this.category, this.onModelClick})
      : super(key: key);
  final dynamic selectedData;
  final Manufacturer category;
  final Function onModelClick;
  @override
  State<StatefulWidget> createState() => _FilterExpantionTileView();
}

class _FilterExpantionTileView extends State<FilterExpantionTileView> {
  ModelRepository subCategoryRepository;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    subCategoryRepository = Provider.of<ModelRepository>(context);

    return ChangeNotifierProvider<ModelProvider>(
        lazy: false,
        create: (BuildContext context) {
          final ModelProvider provider =
              ModelProvider(repo: subCategoryRepository);
          provider.loadAllModelList(widget.category.id);
          return provider;
        },
        child: Consumer<ModelProvider>(builder:
            (BuildContext context, ModelProvider provider, Widget child) {
          return Container(
              child: custom.ExpansionTile(
            initiallyExpanded: false,
            headerBackgroundColor: PsColors.backgroundColor,
            title: Container(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.category.name,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Container(
                        child: widget.category.id ==
                                widget.selectedData[PsConst.MANUFACTURER_ID]
                            ? IconButton(
                                icon: Icon(Icons.playlist_add_check,
                                    color: Theme.of(context)
                                        .iconTheme
                                        .copyWith(color: PsColors.mainColor)
                                        .color),
                                onPressed: () {})
                            : Container())
                  ]),
            ),
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.modelList.data.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space16),
                              child: index == 0
                                  ? Text(
                                      Utils.getString(context,
                                              'product_list__category_all') ??
                                          '',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  : Text(
                                      provider.modelList.data[index - 1].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                            ),
                          ),
                          Container(
                              child: index == 0 &&
                                      widget.category.id ==
                                          widget.selectedData[
                                              PsConst.MANUFACTURER_ID] &&
                                      widget.selectedData[PsConst.MODEL_ID] ==
                                          ''
                                  ? IconButton(
                                      icon: Icon(Icons.check_circle,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .copyWith(
                                                  color: PsColors.mainColor)
                                              .color),
                                      onPressed: () {})
                                  : index != 0 &&
                                          widget.selectedData[PsConst.MODEL_ID] ==
                                              provider
                                                  .modelList.data[index - 1].id
                                      ? IconButton(
                                          icon: Icon(Icons.check_circle,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color),
                                          onPressed: () {})
                                      : Container())
                        ],
                      ),
                      onTap: () {
                        final Map<String, String> dataHolder =
                            <String, String>{};
                        if (index == 0) {
                          // widget.onModelClick(dataHolder);
                          dataHolder[PsConst.MANUFACTURER_ID] =
                              widget.category.id;
                          dataHolder[PsConst.MODEL_ID] = '';
                          dataHolder[PsConst.MANUFACTURER_NAME] =
                              widget.category.name;
                          widget.onModelClick(dataHolder);
                        } else {
                          // widget.onModelClick(
                          //     provider.subCategoryList.data[index - 1]);
                          dataHolder[PsConst.MANUFACTURER_ID] =
                              widget.category.id;
                          dataHolder[PsConst.MODEL_ID] =
                              provider.modelList.data[index - 1].id;
                          dataHolder[PsConst.MANUFACTURER_NAME] =
                              provider.modelList.data[index - 1].name;
                          widget.onModelClick(dataHolder);
                        }
                      },
                    );
                  }),
            ],
            onExpansionChanged: (bool expanding) {
              if (mounted) {
                setState(() => isExpanded = expanding);
              }
            },
          ));
        }));
  }
}
