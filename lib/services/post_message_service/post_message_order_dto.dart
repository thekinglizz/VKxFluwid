class PostMessageOrderDto {
  String? id;
  String? token;
  List<PostMessageTicketDto>? tickets;
  int? sum;
  PostMessagePdfDto? pdf;

  PostMessageOrderDto({this.id, this.token, this.tickets, this.sum, this.pdf});

  PostMessageOrderDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    if (json['tickets'] != null) {
      tickets = <PostMessageTicketDto>[];
      json['tickets'].forEach((v) {
        tickets!.add(PostMessageTicketDto.fromJson(v));
      });
    }
    sum = json['sum'];
    pdf = json['pdf'] != null ? PostMessagePdfDto.fromJson(json['pdf']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['token'] = token;
    if (tickets != null) {
      data['tickets'] = tickets!.map((v) => v.toJson()).toList();
    }
    data['sum'] = sum;
    if (pdf != null) {
      data['pdf'] = pdf!.toJson();
    }
    return data;
  }
}

class PostMessageTicketDto {
  int? sum;

  PostMessageTicketDto({this.sum});

  PostMessageTicketDto.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sum'] = sum;
    return data;
  }
}

class PostMessagePdfDto {
  String? link;
  String? expire;

  PostMessagePdfDto({this.link, this.expire});

  PostMessagePdfDto.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    expire = json['expire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['link'] = link;
    data['expire'] = expire;
    return data;
  }
}