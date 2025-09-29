import 'dart:developer';

import 'package:dunno/constants/themes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DunnoImageUploadingTile extends StatelessWidget {
  final Map<String, dynamic>? task;

  const DunnoImageUploadingTile({super.key, required this.task});

  double _progressPercent(TaskSnapshot snapshot) {
    if (snapshot.bytesTransferred == 0 || snapshot.totalBytes == 0) {
      return 0;
    }

    return snapshot.bytesTransferred / snapshot.totalBytes;
  }

  @override
  Widget build(BuildContext context) {
    UploadTask uploadTask = task!['task'];
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask.snapshotEvents,
      builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        Widget subtitle = LinearProgressIndicator(color: AppColors.cerise);
        TaskSnapshot? snapshot = asyncSnapshot.data;
        TaskState? state = snapshot?.state;

        if (asyncSnapshot.hasError) {
          if (asyncSnapshot.error is FirebaseException && (asyncSnapshot.error as FirebaseException).code == 'canceled') {
            subtitle = const Text('Upload canceled.');
          } else {
            log(asyncSnapshot.error.toString());
            subtitle = const Text('Something went wrong.');
          }
        } else if (snapshot != null && !snapshot.bytesTransferred.isInfinite && !snapshot.bytesTransferred.isNaN) {
          subtitle = Column(
            children: [
              LinearProgressIndicator(value: _progressPercent(snapshot), color: AppColors.cerise),
            ],
          );
        }

        return ListTile(
          title: subtitle,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (state == TaskState.paused) IconButton(icon: const Icon(Icons.file_upload), onPressed: uploadTask.resume),
              if (state == TaskState.success) CircularProgressIndicator(color: AppColors.cerise),
            ],
          ),
        );
      },
    );
  }
}
