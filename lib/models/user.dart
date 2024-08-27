class User {
  late String username;
  late String? email;
  late String? phoneNumber;
  late String id;
  late int redeemedCodeCount;
  late int points;
  late String createdAt;

  void setFromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    id = json['id'];
    redeemedCodeCount = json['redeemed_code_count'];
    points = json['points'];
    createdAt = json['created_at'];
  }
}

class LeaderboardEntry {
  late String username;
  late int points;

  static fromJson(Map<String, dynamic> json) {
    LeaderboardEntry l = LeaderboardEntry();
    l.username = json['username'];
    l.points = json['points'];
    return l;
  }
}

class UserTransactions {
  late String id;
  late String timestamp;
  late int amount;

  static fromJson(Map<String, dynamic> json) {
    UserTransactions uh = UserTransactions();
    uh.id = json['id'];
    uh.timestamp = json['timestamp'];
    uh.amount = json['amount'];
    return uh;
  }
}
