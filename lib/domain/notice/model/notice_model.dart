import 'package:equatable/equatable.dart';

class NoticeModel extends Equatable {
  final String id;
  final String title;
  final String? date;
  final String link;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.date,
    required this.link,
  });

  // factory ExampleModel.fromEntity({
  //   required ExampleEntity entity,
  // }) =>
  //     ExampleModel(
  //       id: entity.id,
  //       title: entity.title,
  //     );

  // JSON 직렬화를 위한 메서드
  Map<String, String> toJson() => <String, String>{
        'id': id,
        'title': title,
        'date': date ?? '',
        'link': link,
      };

  // JSON 역직렬화를 위한 팩토리 생성자
  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
        id: json['id']!,
        title: json['title']!,
        date: json['date']!,
        link: json['link']!,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        date,
        link,
      ];
}
