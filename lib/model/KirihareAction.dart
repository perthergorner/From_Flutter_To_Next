import '../common/constants.dart';

class KirihareAction {
  var type = "";
  var value = "";
  var imgUrl = "";
  KirihareAction();

  factory KirihareAction.convert(Map<String, dynamic> res){
    KirihareAction model = KirihareAction();
    model.type = res[Constants.type];
    model.value = res[Constants.VALUE];
    model.imgUrl = res[Constants.IMG_URL];
    return model;
  }
  static List<KirihareAction> convertMenu(dynamic val){
    var list = <KirihareAction>[];
    list.add(KirihareAction.convert(val['a']));
    list.add(KirihareAction.convert(val['b']));
    list.add(KirihareAction.convert(val['c']));
    list.add(KirihareAction.convert(val['d']));
    list.add(KirihareAction.convert(val['e']));
    list.add(KirihareAction.convert(val['f']));
    return list;
  }
}