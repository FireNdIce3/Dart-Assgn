import 'dart:io';

class NullException implements Exception {
  String errMsg() => 'Username can\'t be null';
}

class MissingUser implements Exception {
  String errMsg() => "Username doesn't exist";
}

class LoginException implements Exception {
  String errMsg() => "User is already logged in";
}

class LogoutException implements Exception {
  String errMsg() => "User is not logged in";
}

class MissingServer implements Exception {
  String errMsg() => "Server doesn't exist";
}

class IncompatibleType implements Exception {
  String errMsg() => "Type is not compatible";
}

class ModException implements Exception {
  String errMsg() => "User is not allowed to send a message";
}

class User {
  late List<Server> servers = [];
  late String name;
  late bool isMod = false;

  User(String name) {
    this.name = name;
  }
}

class Server {
  late String name;
  late List<String> channels = [];
  late Map<String, String> type;
  late List<String> messages = [];
  Server(String name) {
    this.name = name;
  }
}

class Discord {
  late List<Server> allServers = [];
  late List<User> users = [];
  late Map<String, int> userStatus = {};
  late List<String> types = ['text', 'voice', 'stage', 'rules', 'announcement'];

  void register(int n) {
    late List<User> temp = users;
    late List<String> username = [];
    users.forEach((element) {
      username.add(element.name);
    });
    for (int i = 0; i < n; i++) {
      String? user = stdin.readLineSync() ?? '';
      if (user == '') {
        throw new NullException();
      }
      if (username.contains(user)) {
        print("Failure");
        users = temp;
        return;
      }
      User a = new User(user);
      users.add(a);
      username.add(user);
      userStatus[user] = 0;
    }

    users.forEach((element) {
      print(element.name);
    });
    print("success");
  }

  void login(int n) {
    late List<String> username = [];
    users.forEach((element) {
      username.add(element.name);
    });

    for (int i = 0; i < n; i++) {
      String? user = stdin.readLineSync() ?? '';
      if (user == '') {
        throw new NullException();
      }
      if (!username.contains(user)) {
        throw new MissingUser();
      }
      if (userStatus[user] == 0) {
        userStatus[user] = 1;
      } else {
        throw new LoginException();
      }
      print("login success");
    }
  }

  void logout(int n) {
    late List<String> username = [];
    users.forEach((element) {
      username.add(element.name);
    });

    for (int i = 0; i < n; i++) {
      String? user = stdin.readLineSync() ?? '';
      if (user == '') {
        throw new NullException();
      }
      if (!username.contains(user)) {
        throw new MissingUser();
      }
      if (userStatus[user] == 1) {
        userStatus[user] = 0;
      } else {
        throw new LogoutException();
      }
      print("logout success");
    }
  }

  void join(String user, String server) {
    late List<String> username = [];
    users.forEach((element) {
      username.add(element.name);
    });
    late List<String> servername = [];
    allServers.forEach((element) {
      servername.add(element.name);
    });
    if (!username.contains(user)) {
      throw new MissingUser();
    }
    int index = users.indexWhere((element) => element.name == user);
    if (servername.contains(server)) {
      print("${user} has already joined this server");
      return;
    }
    Server tempServer = new Server(server);
    users[index].servers.add(tempServer);
    allServers.add(tempServer);
  }

  void printMod(String server) {
    late List<String> servername = [];
    users.forEach((element1) {
      element1.servers.forEach((element2) {
        servername.add(element2.name);
      });
    });
    users.forEach((element) {
      if (servername.contains(server) && element.isMod) {
        Future.delayed(const Duration(seconds: 1), () {
          print(element.name);
        });
      }
    });
  }

  void makeMod(String user) {
    late List<String> username = [];
    users.forEach((element) {
      username.add(element.name);
    });
    if (!username.contains(user)) {
      throw new MissingUser();
    }
    int index = users.indexWhere((element) => element.name == user);
    users[index].isMod = true;
  }

  void addChannel(String server, String type, [String category = ""]) {
    late List<String> servername = [];
    allServers.forEach((element) {
      servername.add(element.name);
    });
    if (!servername.contains(server)) {
      throw new MissingServer();
    }
    if (!types.contains(type.toLowerCase()) && type != '') {
      throw new IncompatibleType();
    }
    allServers.forEach((element) {
      if (element.name == server) element.channels.add(category);
      element.type[category] = type;
    });
  }

  void getCategory(String server) {
    late List<String> servername = [];
    users.forEach((element1) {
      element1.servers.forEach((element2) {
        servername.add(element2.name);
      });
    });
    if (!servername.contains(server)) {
      throw new MissingServer();
    }
    print("printing categories in ${server}");
    int index = allServers.indexWhere((element) => element.name == server);
    allServers[index].channels.forEach((element) {
      Future.delayed(const Duration(seconds: 1), () {
        print(element);
      });
    });
  }

  void sendMessage(String user, String server, String type, String message,
      [String category = '']) {
    late List<String> username = [];
    users.forEach((element) {
      username.add(element.name);
    });
    late List<String> servername = [];
    allServers.forEach((element) {
      servername.add(element.name);
    });
    if (!username.contains(user) || !servername.contains(server)) {
      throw Exception();
    }
    int index = users.indexWhere((element) => element.name == user);
    if (!users[index].isMod) {
      if (type != 'announcement' || type != 'text') {
        throw new ModException();
      } else {
        int index2 = allServers.indexWhere((element) => element.name == server);
        allServers[index2].messages.add(message);
      }
    }
  }
}

void WelcomeInterface() {
  print("Welcome to Discord, What you want to do?");
  Discord session = new Discord();
  String? response = stdin.readLineSync();
  if (response == 'register') {
    print("Enter number of users");
    int number = int.parse(stdin.readLineSync() ?? "");
    session.register(number);
  }
  if (response == 'login') {
    print("Enter number of users");
    int number = int.parse(stdin.readLineSync() ?? "");
    session.login(number);
  }
  if (response == 'logout') {
    print("Enter number of users");
    int number = int.parse(stdin.readLineSync() ?? "");
    session.logout(number);
  }
  if (response == 'join') {
    print("Enter the user name ");
    String user = stdin.readLineSync() ?? "";
    String server = stdin.readLineSync() ?? "";
    session.join(user, server);
  }
  if (response == 'createc') {
    print("Enter the server name");
    String server = stdin.readLineSync() ?? "";
    print("Enter the category(optional)");
    String categoryName = stdin.readLineSync() ?? "";
    print("Enter the type");
    String type = stdin.readLineSync() ?? "";
    session.addChannel(server, type, categoryName);
  }
  if (response == 'send') {
    print("Enter the user name");
    String user = stdin.readLineSync() ?? "";
    print("Enter the server name");
    String server = stdin.readLineSync() ?? "";
    print("Enter the category(optional)");
    String categoryName = stdin.readLineSync() ?? "";
    print("Enter the type");
    String type = stdin.readLineSync() ?? "";
    print("Enter the message ");
    String message = stdin.readLineSync() ?? "";
    session.sendMessage(user, server, type, message, categoryName);
  }
  if (response == 'makemod') {
    print("Enter the user name");
    String user = stdin.readLineSync() ?? "";
    session.makeMod(user);
  }
  if (response == 'print') {
    print("Enter the server name");
    String server = stdin.readLineSync() ?? "";
    session.printMod(server);
  }
  if (response == 'category') {
    print("Enter the server name");
    String server = stdin.readLineSync() ?? "";
    session.getCategory(server);
  }
}

void main(List<String> args) {
  WelcomeInterface();
}
