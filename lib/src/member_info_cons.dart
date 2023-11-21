// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';

class MemberInfoCons {
  MemberInfoCons({required this.name, required this.email, required this.status_messages, required this.uid, required this.time });

  final String email;
  final String name;
  final String status_messages;
  final String uid;
  final int time;
}
