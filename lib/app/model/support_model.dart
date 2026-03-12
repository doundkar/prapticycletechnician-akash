class SupportModel {
  CallSupport? callSupport;
  EmailSupport? emailSupport;
  List<FaqSections>? faqSections;

  SupportModel({this.callSupport, this.emailSupport, this.faqSections});

  SupportModel.fromJson(Map<String, dynamic> json) {
    callSupport = json['call_support'] != null
        ? new CallSupport.fromJson(json['call_support'])
        : null;
    emailSupport = json['email_support'] != null
        ? new EmailSupport.fromJson(json['email_support'])
        : null;
    if (json['faq_sections'] != null) {
      faqSections = <FaqSections>[];
      json['faq_sections'].forEach((v) {
        faqSections!.add(new FaqSections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.callSupport != null) {
      data['call_support'] = this.callSupport!.toJson();
    }
    if (this.emailSupport != null) {
      data['email_support'] = this.emailSupport!.toJson();
    }
    if (this.faqSections != null) {
      data['faq_sections'] = this.faqSections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CallSupport {
  String? title;
  String? subtitle;
  String? availability;
  String? phone;

  CallSupport({this.title, this.subtitle, this.availability, this.phone});

  CallSupport.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    availability = json['availability'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['availability'] = this.availability;
    data['phone'] = this.phone;
    return data;
  }
}

class EmailSupport {
  String? title;
  String? email;
  String? responseTime;

  EmailSupport({this.title, this.email, this.responseTime});

  EmailSupport.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    email = json['email'];
    responseTime = json['response_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['email'] = this.email;
    data['response_time'] = this.responseTime;
    return data;
  }
}

class FaqSections {
  String? title;
  List<Items>? items;

  FaqSections({this.title, this.items});

  FaqSections.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? question;
  String? answer;

  Items({this.question, this.answer});

  Items.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}
