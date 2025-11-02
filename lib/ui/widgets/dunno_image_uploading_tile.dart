import 'dart:developer';

import 'package:dunno/constants/themes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DunnoImageUploadingTile extends StatelessWidget {
  final Map<String, dynamic>? task;
  final double size;
  final bool isCircular;

  const DunnoImageUploadingTile({
    super.key, 
    required this.task,
    this.size = 200.0,
    this.isCircular = true,
  });

  double _progressPercent(TaskSnapshot snapshot) {
    if (snapshot.bytesTransferred == 0 || snapshot.totalBytes == 0) {
      return 0;
    }

    return snapshot.bytesTransferred / snapshot.totalBytes;
  }

  @override
  Widget build(BuildContext context) {
    // Safety check for null task
    if (task == null || task!['task'] == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          color: Colors.grey.shade400,
        ),
        child: const Center(
          child: Icon(Icons.error, color: Colors.red, size: 50),
        ),
      );
    }

    UploadTask uploadTask = task!['task'];
    
    if (isCircular) {
      return _buildCircularUploadProgress(uploadTask);
    } else {
      return _buildLinearUploadProgress(uploadTask);
    }
  }

  Widget _buildCircularUploadProgress(UploadTask uploadTask) {
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask.snapshotEvents,
      builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        TaskSnapshot? snapshot = asyncSnapshot.data;
        double progress = 0.0;
        bool hasError = false;
        String errorMessage = '';

        if (asyncSnapshot.hasError) {
          hasError = true;
          if (asyncSnapshot.error is FirebaseException && 
              (asyncSnapshot.error as FirebaseException).code == 'canceled') {
            errorMessage = 'Upload canceled';
          } else {
            log(asyncSnapshot.error.toString());
            errorMessage = 'Upload failed';
          }
        } else if (snapshot != null && 
                   !snapshot.bytesTransferred.isInfinite && 
                   !snapshot.bytesTransferred.isNaN) {
          progress = _progressPercent(snapshot);
        }

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade400,
            border: Border.all(color: AppColors.offWhite, width: 4),
          ),
          child: Center(
            child: hasError
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.cerise),
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLinearUploadProgress(UploadTask uploadTask) {
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask.snapshotEvents,
      builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        Widget subtitle = LinearProgressIndicator(color: AppColors.cerise);
        TaskSnapshot? snapshot = asyncSnapshot.data;
        TaskState? state = snapshot?.state;

        if (asyncSnapshot.hasError) {
          if (asyncSnapshot.error is FirebaseException && 
              (asyncSnapshot.error as FirebaseException).code == 'canceled') {
            subtitle = const Text('Upload canceled.');
          } else {
            log(asyncSnapshot.error.toString());
            subtitle = const Text('Something went wrong.');
          }
        } else if (snapshot != null && 
                   !snapshot.bytesTransferred.isInfinite && 
                   !snapshot.bytesTransferred.isNaN) {
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
              if (state == TaskState.paused) 
                IconButton(
                  icon: const Icon(Icons.file_upload), 
                  onPressed: uploadTask.resume,
                ),
              if (state == TaskState.success) 
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        );
      },
    );
  }
}
