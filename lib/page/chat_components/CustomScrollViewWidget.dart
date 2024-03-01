import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fbroadcast/fbroadcast.dart';
import '../../common/common.dart';
import '../../common/constants.dart';
import '../../model/carousel_model.dart';
import '../../model/msg_model.dart';

class CustomCarouselView extends StatefulWidget {
  final MsgModel model;

  CustomCarouselView({Key? key, required this.model}) : super(key: key);

  @override
  _CustomCarouselViewState createState() => _CustomCarouselViewState();
}

class _CustomCarouselViewState extends State<CustomCarouselView> {
  late final List<CarouselModel> carouselModels;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeModels();
  }

  void _initializeModels() {
    var items = jsonDecode(widget.model.msg!);
    carouselModels = items.map<CarouselModel>(
          (v) => CarouselModel.fromJson(v),
    ).toList();
  }

  void _scrollLeft() {
    final currentPosition = _scrollController.offset;
    const singleItemScrollExtent = 200.0 + 8.0 * 2; // アイテムの幅 + 両側のマージン
    final scrollPosition = currentPosition - singleItemScrollExtent * 3;
    _scrollController.animateTo(
      scrollPosition > _scrollController.position.minScrollExtent ? scrollPosition : _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }


  void _scrollRight() {
    final currentPosition = _scrollController.offset;
    const singleItemScrollExtent = 200.0 + 8.0 * 2; // アイテムの幅 + 両側のマージン
    final scrollPosition = currentPosition + singleItemScrollExtent * 3;
    _scrollController.animateTo(
      scrollPosition < _scrollController.position.maxScrollExtent ? scrollPosition : _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSmartPhone = Common.device == Constants.SMART_PHONE; // スマートフォンかどうかを判定

    return carouselModels.isNotEmpty
        ? Row(
      children: [
        if(!isSmartPhone)
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: _scrollLeft,
        ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 4.0,
            controller: _scrollController,
            child: Container(
              height: 260,
              child: ListView.builder(
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: carouselModels.length,
                itemBuilder: (BuildContext context, int index) {
                  return _carouselItem(context, carouselModels[index]);
                },
              ),
            ),
          ),
        ),
        if(!isSmartPhone)
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: _scrollRight,
        ),
      ],
    )
        : Container();
  }

  Widget _carouselItem(BuildContext context, CarouselModel itemModel) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      margin: EdgeInsets.all(4),
      child: InkWell(
        onTap: () => FBroadcast.instance().broadcast(
          Constants.SEND_MSG,
          value: itemModel.title,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(itemModel.imageUrl),
            SizedBox(height: 8),
            Text(itemModel.title, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
