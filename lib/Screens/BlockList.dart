import 'package:crush/Constants/constants.dart';
import 'package:crush/Services/blockServices/blockservices.dart';
import 'package:crush/Services/generatechannelservices.dart';
import 'package:crush/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

class BlockList extends StatefulWidget {
  const BlockList({Key? key}) : super(key: key);

  @override
  _BlockListState createState() => _BlockListState();
}

class _BlockListState extends State<BlockList> {
  List blocklist = [];
  @override
  void initState() {
    // TODO: implement initState
    BlockServices().getBlockList().then((value) {
      setState(() {
        print(value);
        blocklist = value['data'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundContainer(),
          Container(
            color: Colors.white.withOpacity(0.4),
            child: ListView.builder(
                itemCount: blocklist.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: ListTile(
                          tileColor: Colors.white,
                          leading: Icon(
                            Icons.block,
                            color: Colors.red,
                          ),
                          title: Text(blocklist[index]['Name']
                              .toString()
                              .toUpperCase()),
                          trailing: MaterialButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: appThemeColor),
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              BlockServices()
                                  .unblockUser(
                                      blocklist[index]['block_user_id'])
                                  .then((value) {
                                BlockServices().getBlockList().then((value) {
                                  setState(() {
                                    print(value);
                                    blocklist = value['data'];
                                  });
                                });
                              });
                            },
                            child: Text(
                              'Unblock',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
