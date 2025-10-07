import 'package:flutter/material.dart';

void main() {
  runApp(Bai1());
}

class Bai1 extends StatelessWidget {
  const Bai1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("19_Trần Thái Thiên_1050080202")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            openMyAlertDialog(context);
          },
          child: Text("Show Dialog"),
        ),
      ),
    );
  }
}
void openMyAlertDialog(BuildContext context)  {
  // Create a AlertDialog.
  AlertDialog dialog = AlertDialog(
    title: Text("Confirm"),
    content: Text("Are you sure to remove this item?"),
    shape: RoundedRectangleBorder(
        side:  BorderSide(color: Colors.green,width: 3),
        borderRadius: BorderRadius.all(Radius.circular(15))
    ),
    actions: [
      ElevatedButton(
          child: Text("Yes Delete"),
          onPressed: (){
            Navigator.of(context).pop(true); // Return true
          }
      ),
      ElevatedButton(
          child: Text("Cancel"),
          onPressed: (){
            Navigator.of(context).pop(false); // Return false
          }
      ),
    ],
  );

  // Call showDialog function.
  Future<bool?> futureValue = showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
  futureValue.then( (value) {
    print("Return value: " + value.toString()); // true/false
  });
}
