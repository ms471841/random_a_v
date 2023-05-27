import 'package:random_a_v/data/models/user.dart';
import 'package:random_a_v/services/database.dart';
import 'package:random_a_v/utils/generate_unique_id.dart';

class AuthService {
  final Database _database = Database();

  Future<MyUser> signin(
      String name, DateTime dob, String gender, String photoUrl) async {
    final id = generateUniqueUserId();

    final myuser = MyUser(
        id: id,
        name: name,
        dob: dob.toString(),
        photoUrl: photoUrl,
        gender: gender);
    await _database.saveMyUserToDatabase(myuser);
    return myuser;
  }
}
