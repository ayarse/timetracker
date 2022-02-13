import 'package:flutter/material.dart';
import 'package:timetracker/app/home/models/job.dart';

class JobListTile extends StatelessWidget {

  final Job job;
  final VoidCallback onTap;

  JobListTile({Key key, @required this.job, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}