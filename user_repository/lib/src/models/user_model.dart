import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}
