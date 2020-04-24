import 'package:flutter/material.dart';

import '../placeholder/placeholder_card_short.dart';

class AccountContent extends StatefulWidget {
  @override
  _AccountContentState createState() => _AccountContentState();
}

class _AccountContentState extends State<AccountContent>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ListView.builder(
          itemCount: 9,
          itemBuilder: (content, index) {
            return PlaceholderCardShort(
                color: Color(0xFF99D3F7), backgroundColor: Color(0xFFC7EAFF));
          }),
    );
  }
}
