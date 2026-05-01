import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  const WordCard({word, super.key});

  final String? word = "Efflorescence";
  final String title = "word of the day";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      // height: 300,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 132, 127, 127),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.bookmark_outline, color: Colors.white),
              ),
            ],
          ),
          Text(
            "$word",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text("/,efla ' resans/"),
          Text("The state or period of flowering."),

          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(133, 177, 172, 147),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                "\"The efflorescence of her career came in her late thirties.\"",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
