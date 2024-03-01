import 'package:flutter/material.dart';
import 'package:fbroadcast/fbroadcast.dart';
import '../../common/common.dart';
import '../../common/constants.dart';

// 提案リスト用のウィジェット
class SuggestionListView extends StatefulWidget {
  final List<String> suggestions; // 提案される文字列のリスト

  SuggestionListView({Key? key, required this.suggestions}) : super(key: key);

  @override
  _SuggestionListViewState createState() => _SuggestionListViewState();
}

class _SuggestionListViewState extends State<SuggestionListView> {
  final ScrollController _scrollController = ScrollController(); // スクロールコントローラーを追加

  @override
  Widget build(BuildContext context) {
    bool isSmartPhone = Common.device == Constants.SMART_PHONE; // スマートフォンかどうかを判定

    // スマートフォンであればWrapウィジェットを使用し、そうでなければ元のListViewを使用
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: isSmartPhone ? null : 60, // スマートフォンの場合は高さを指定しない
      child: isSmartPhone
          ? Wrap(
        spacing: 8.0, // 横方向のスペース
        runSpacing: 4.0, // 縦方向のスペース
        children: widget.suggestions.map((suggestion) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: OutlinedButton(
            onPressed: () => _onSuggestionTap(suggestion),
            child: Text(suggestion),
          ),
        )).toList(),
      )
          : Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: _scrollLeft,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: OutlinedButton(
                    onPressed: () => _onSuggestionTap(widget.suggestions[index]),
                    child: Text(widget.suggestions[index]),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: _scrollRight,
          ),
        ],
      ),
    );
  }

  void _onSuggestionTap(String suggestion) {
    FBroadcast.instance().broadcast(
      Constants.SEND_MSG,
      value: suggestion,
    );
  }
  void _scrollLeft() {
    final currentPosition = _scrollController.offset;
    const singleItemScrollExtent = 150.0; // 提案アイテムの幅を基に適切な値に調整
    final scrollPosition = currentPosition - singleItemScrollExtent;
    _scrollController.animateTo(
      scrollPosition > _scrollController.position.minScrollExtent ? scrollPosition : _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final currentPosition = _scrollController.offset;
    const singleItemScrollExtent = 150.0; // 提案アイテムの幅を基に適切な値に調整
    final scrollPosition = currentPosition + singleItemScrollExtent;
    _scrollController.animateTo(
      scrollPosition < _scrollController.position.maxScrollExtent ? scrollPosition : _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

}
