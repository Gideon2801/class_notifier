import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:class_notifier/models/classroom.dart';

class CreateClassroomPage extends StatefulWidget {
  final Classroom? classroom;
  CreateClassroomPage({required this.classroom});

  @override
  _CreateClassroomPageState createState() => _CreateClassroomPageState();
}

class _CreateClassroomPageState extends State<CreateClassroomPage> {
  final _title = TextEditingController();
  final _url = TextEditingController();
  final _notify = TextEditingController();
  final _description = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  Classroom? classroom = null;

  @override
  void initState() {
    if (widget.classroom == null) {
      classroom = Classroom.fromParams(
          '<No title>', '<No description>', DateTime.now(), 0, '', 2);
    } else {
      classroom = widget.classroom!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 40.0),
            Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                const Text('CREATE NOTIFY'),
              ],
            ),
            const SizedBox(height: 40.0),
            DateTimeField(
              decoration: InputDecoration(
                labelText: classroom!.dateTime!.toIso8601String(),
                isDense: true,
                contentPadding: const EdgeInsets.all(2),
              ),
              format: format,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        currentValue ?? DateTime.now(),
                      ));

                  classroom!.dateTime = DateTimeField.combine(date, time);
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            ),
            Row(
              children: [
                buildDaySelector('Mon', 0),
                buildDaySelector('Tue', 1),
                buildDaySelector('Wed', 2),
                buildDaySelector('Thu', 3),
                buildDaySelector('Fri', 4),
                buildDaySelector('Sat', 5),
                buildDaySelector('Sun', 6),
              ],
            ),
            const SizedBox(height: 10.0),
            TextField(
              autofocus: true,
              controller: _title,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.topic_outlined),
                filled: true,
                labelText: 'Tile',
              ),
            ),
            const SizedBox(height: 15.0),
            TextField(
              autofocus: true,
              controller: _url,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.link_rounded),
                filled: true,
                labelText: 'URL',
              ),
            ),
            const SizedBox(height: 15.0),
            TextField(
              autofocus: true,
              controller: _notify,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.notifications_active_outlined),
                filled: true,
                labelText: 'Notify',
                helperText: 'Set time to notify start classess. Ex: 5 minute',
              ),
            ),
            const SizedBox(height: 15.0),
            TextField(
              autofocus: true,
              maxLines: null,
              controller: _description,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description_outlined),
                filled: true,
                labelText: 'Description',
              ),
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    _url.clear();
                    _notify.clear();
                    _description.clear();
                  },
                ),
                ElevatedButton(
                  child: const Text('COMFIRM'),
                  onPressed: () {
                    Navigator.pop(context);
                    //
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildDaySelector(String name, int value) {
    bool isRepeated = classroom!.isRepeatAt(value);
    return GestureDetector(
      onTap: () {
        setState(() {
          classroom!.setRepeatAt(value, !isRepeated);
        });
      },
      child: SizedBox(
        width: 50,
        height: 40,
        child: Text(
          name,
          style: TextStyle(color: isRepeated ? Colors.red : Colors.grey),
        ),
      ),
    );
  }
}
