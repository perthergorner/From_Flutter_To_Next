class RichMenuModel {
  String richMenuId = "";
  Size size = Size(0,0);
  bool selected = false;
  String name = "";
  String chatBarText = "";
  List<Areas> areas = [];

  RichMenuModel(this.richMenuId,
        this.size,
        this.selected,
        this.name,
        this.chatBarText,
        this.areas);

  RichMenuModel.fromJson(Map<String, dynamic> json) {
    richMenuId = json['richMenuId'];
    size = json['size'] != null ? new Size.fromJson(json['size']) : Size(0,0);
    selected = json['selected'];
    name = json['name'];
    chatBarText = json['chatBarText'];
    if (json['areas'] != null) {
      areas = <Areas>[];
      json['areas'].forEach((v) {
        areas.add(new Areas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['richMenuId'] = this.richMenuId;
    data['size'] = this.size.toJson();
    data['selected'] = this.selected;
    data['name'] = this.name;
    data['chatBarText'] = this.chatBarText;
    data['areas'] = this.areas.map((v) => v.toJson()).toList();
    return data;
  }

  int findIndex(double dWidth,double dHeight, double dx, double dy){
    var x = size.width * dx / dWidth;
    var y = size.height * dy / dHeight;
    for (var i = 0; i < areas.length; i++) {
      var value = areas[i];

      if(value.bounds.x <= x && value.bounds.y <= y
          && (value.bounds.x + value.bounds.width) > x && ( value.bounds.y+ value.bounds.height) > y){
        return i;
      }
    }
    return -1;
  }
}

class Size {
  int width = 0;
  int height = 0;
  Size(this.width, this.height);

  Size.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Areas {
  Bounds bounds = Bounds(0,0,0,0);
  Action action = Action("", "");

  Areas(this.bounds, this.action);

  Areas.fromJson(Map<String, dynamic> json) {
    bounds =
    json['bounds'] != null ? new Bounds.fromJson(json['bounds']) : Bounds(0,0,0,0);
    action =
    json['action'] != null ? new Action.fromJson(json['action']) : Action("", "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bounds'] = this.bounds.toJson();
    data['action'] = this.action.toJson();

    return data;
  }
}

class Bounds {
  int x = 0;
  int y = 0;
  int width = 0;
  int height = 0;

  Bounds(this.x, this.y, this.width, this.height);

  Bounds.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Action {
  String label = "";
  String text = "";
  String type = "message";
  String? uri;

  Action(this.label, this.text);

  Action.fromJson(Map<String, dynamic> json) {
    label = json['label']??"";
    text = json['text']?? "";
    type = json['type']  == null ? (json['uri'] == null ? "message" : 'url'): json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['text'] = this.text;
    data['type'] = this.type;
    return data;
  }
}