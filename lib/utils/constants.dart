class SharedPrefKeys {
  static const String isLoggedIn = "is_logged_in";
  static const String userData = "userData";
}

class AppConfig {
  static const serverBaseUrl =
      "https://qr-earth-bthhbwfcbxcvfrbp.eastus-01.azurewebsites.net";
}

class ApiRoutes {
  static const login = "/users/login";
  static const signup = "/users/signup";
  static const userInfo = "/users/info";
  static const userTransactions = "/users/transactions";

  static const leaderboard = "/public/leaderboard";
  static const totalUsers = "/public/total_users";

  static const codeRedeem = "/codes/redeem";
  static const codeValidate = "/codes/validate";
  static const codeCheckFixed = "/codes/check_fixed";
}
