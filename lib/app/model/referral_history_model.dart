class ReferralHistoryModel {
  Technician? technician;
  Summary? summary;
  List<Referrals>? referrals;
  Pagination? pagination;

  ReferralHistoryModel(
      {this.technician, this.summary, this.referrals, this.pagination});

  ReferralHistoryModel.fromJson(Map<String, dynamic> json) {
    technician = json['technician'] != null
        ? new Technician.fromJson(json['technician'])
        : null;
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['referrals'] != null) {
      referrals = <Referrals>[];
      json['referrals'].forEach((v) {
        referrals!.add(new Referrals.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.technician != null) {
      data['technician'] = this.technician!.toJson();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.referrals != null) {
      data['referrals'] = this.referrals!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Technician {
  int? id;
  String? name;
  String? promoCode;
  double? pcsWallet;

  Technician({this.id, this.name, this.promoCode, this.pcsWallet});

  Technician.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    promoCode = json['promo_code'];
    pcsWallet = json['pcs_wallet'] != null
        ? double.tryParse(json['pcs_wallet'].toString())
        : 0.0;
    // json['pcs_wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['promo_code'] = this.promoCode;
    data['pcs_wallet'] = this.pcsWallet;
    return data;
  }
}

class Summary {
  int? totalReferrals;
  int? verifiedReferrals;

  Summary({this.totalReferrals, this.verifiedReferrals});

  Summary.fromJson(Map<String, dynamic> json) {
    totalReferrals = json['total_referrals'];
    verifiedReferrals = json['verified_referrals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_referrals'] = this.totalReferrals;
    data['verified_referrals'] = this.verifiedReferrals;
    return data;
  }
}

class Referrals {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? promoCode;
  String? usedPromoCode;
  int? amount;
  String? registrationStep;
  String? isVerified;
  String? joinedAt;

  Referrals(
      {this.id,
      this.name,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.promoCode,
      this.usedPromoCode,
      this.amount,
      this.registrationStep,
      this.isVerified,
      this.joinedAt});

  Referrals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    promoCode = json['promo_code'];
    usedPromoCode = json['used_promo_code'];
    amount = json['amount'];
    registrationStep = json['registration_step'];
    isVerified = json['is_verified'];
    joinedAt = json['joined_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['promo_code'] = this.promoCode;
    data['used_promo_code'] = this.usedPromoCode;
    data['amount'] = this.amount;
    data['registration_step'] = this.registrationStep;
    data['is_verified'] = this.isVerified;
    data['joined_at'] = this.joinedAt;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? from;
  int? to;

  Pagination(
      {this.currentPage,
      this.lastPage,
      this.perPage,
      this.total,
      this.from,
      this.to});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}
