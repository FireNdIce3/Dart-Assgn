import 'dart:async';
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
  late List<User>users = [];
  late Map<String, int> userStatus = {};
  late List<String> types = ['text', 'voice', 'stage', 'rules', 'announcement'];

  void register(int n, var userData) {
    late List<User> temp = users;
    late List<String> username = [];
    this.users.forEach((element) {
      username.add(element.name);
    });
    for (int i = 0; i < n; i++) {
      String user = userData[i];
      if (user == '') {
        throw new NullException().toString();
      }
      if (username.contains(user)) {
        print("Failure");
        users = temp;
        return;
      }

      User a = new User(user);
      this.users.add(a);
      username.add(user);
      userStatus[user] = 0;
    }

    users.forEach((element) {
      print(element.name);
    });

    print(users.toString());
    print("success");
  }

  void login(int n, var userData) {
    late List<String> username = [];
    users.forEach((element) {
      username.add(element.name);
    });

    for (int i = 0; i < n; i++) {
      String user = userData[i];
      if (user == '') {
        throw new NullException().toString();
      }
      if (!username.contains(user)) {
        print(username.toString());
        print(users.toString());
        throw new MissingUser().toString();
      }
      if (userStatus[user] == 0) {
        userStatus[user] = 1;
      } else {
        throw new LoginException().toString();
      }
      print("login success");
    }
  }

  void logout(int n, var userData) {
    late List<String> username = [];
    users.forEach((element) {
      username.add(element.name);
    });

    for (int i = 0; i < n; i++) {
      String user = userData[i];
      if (user == '') {
        throw new NullException().toString();
      }
      if (!username.contains(user)) {
        throw new MissingUser().toString();
      }
      if (userStatus[user] == 1) {
        userStatus[user] = 0;
      } else {
        throw new LogoutException().toString();
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
      throw new MissingUser().toString();
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
      throw new MissingUser().toString();
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
      throw new MissingServer().toString();
    }
    if (!types.contains(type.toLowerCase()) && type != '') {
      throw new IncompatibleType().toString();
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
      throw new MissingServer().toString();
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
      throw Exception().toString();
    }
    int index = users.indexWhere((element) => element.name == user);
    if (!users[index].isMod) {
      if (type != 'announcement' || type != 'text') {
        throw new ModException().toString();
      } else {
        int index2 = allServers.indexWhere((element) => element.name == server);
        allServers[index2].messages.add(message);
      }
    }
  }
}

void WelcomeInterface(Discord session) {
  String message = stdin.readLineSync() ?? "";
  while (message != '') {
    var arr = message.split(" ");
    String response = arr[0];
    var userData = arr.sublist(2, arr.length);
    if (response == 'register') {
      try {
        int number = int.parse(arr[1]);
        session.register(number, userData);
      } catch (Exception) {
        print("Please try again");
      }
    }
    if (response == 'login') {
      int number = int.parse(arr[1]);
      session.login(number, userData);
    }
    if (response == 'logout') {
      try {
        int number = int.parse(arr[1]);
        session.logout(number, userData);
      } catch (Exception) {
        print("Please try again");
      }
    }
    if (response == 'join') {
      try {
        String user = arr[1];
        String server = arr[2];
        session.join(user, server);
      } catch (Exception) {
        print("Please try again");
      }
    }
    if (response == 'createc') {
      try {
        String server = arr[1];
        String categoryName = arr[2];
        String type = arr[3];
        session.addChannel(server, type, categoryName);
      } catch (Exception) {
        print("Please try again");
      }
    }
    if (response == 'send') {
      try {
        String user = arr[1];
        String server = arr[2];
        String categoryName = arr[3];
        String type = arr[4];
        String message = '';
        for (int i = 5; i < arr.length; i++) {
          message = message + arr[i] + " ";
        }
        session.sendMessage(user, server, type, message, categoryName);
      } catch (Exception) {
        print("Please try again");
      }
    }
    if (response == 'makemod') {
      String user = arr[1];
      session.makeMod(user);
    }
    if (response == 'print') {
      String server = arr[1];
      session.printMod(server);
    }
    if (response == 'category') {
      String server = arr[1];
      session.getCategory(server);
    }
    print("Enter another command");
    message = stdin.readLineSync() ?? '';
  }
}

void main(List<String> args) {
  Discord session = new Discord();
  WelcomeInterface(session);
}
