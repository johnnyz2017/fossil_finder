
import 'dart:convert';

import 'comment.dart';

class Specimen{
  final int id;
  final int temporaryId;
  final int permanentId;
  final String address;
  final double latitude;
  final double longtitude;
  final List<Comment> comments;
  final DateTime firstCommitTime;
  final DateTime lastUpdateTime;

  Specimen(this.id, this.temporaryId, this.permanentId, this.address, this.latitude, this.longtitude, this.comments, this.firstCommitTime, this.lastUpdateTime);

  Specimen.fromJson(Map<String, dynamic> json)
  : id = json["id"],
    temporaryId = json["temporaryId"],
    permanentId = json["permanentId"],
    address = json["address"],
    latitude = json["latitute"],
    longtitude = json["longtitude"],
    comments = new List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    firstCommitTime = jsonDecode(json["firstCommitTime"]),
    lastUpdateTime = jsonDecode(json["lastUpdateTime"]);
}