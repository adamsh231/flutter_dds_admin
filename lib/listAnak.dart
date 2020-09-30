import 'package:flutter/material.dart';

class ListAnak extends StatelessWidget {
  const ListAnak({Key key, this.dataAnak}) : super(key: key);

  final List dataAnak;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Anak"),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemCount: dataAnak.length,
          itemBuilder: (context, index) => InkWell(
            onTap: (){
              Navigator.pop(context,index);
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "($index) " + dataAnak[index]['nama'],
                style: TextStyle(fontSize: 20),
              )),
            ),
          ),
        ));
  }
}
