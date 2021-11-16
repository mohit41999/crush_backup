import 'package:crush/Constants/constants.dart';
import 'package:crush/Model/getFavourites_usersModel.dart';
import 'package:crush/Screens/userPg.dart';
import 'package:crush/Services/getFavourites_usersService.dart';
import 'package:crush/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

class FavouritesPg extends StatefulWidget {
  final String? user_id;
  const FavouritesPg({Key? key, required this.user_id}) : super(key: key);

  @override
  _FavouritesPgState createState() => _FavouritesPgState();
}

class _FavouritesPgState extends State<FavouritesPg> {
  late Future<GetFavUsers> favourites;
  bool loading = true;
  late GetFavUsers favourite_users;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favourites =
        getFavUsersService().getFav_users(widget.user_id).then((value) {
      setState(() {
        print(value);
        favourite_users = value;
        loading = false;
      });
      return favourite_users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          )
        : Scaffold(
            body: Stack(
              children: [
                backgroundContainer(),
                Container(
                  color: Colors.white.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(
                            'Favourites',
                            style: TextStyle(
                              color: appThemeColor,
                              fontSize: 20,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: favourite_users.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => UserPg(
                                                  homeuser: false,
                                                  user_id: widget.user_id,
                                                  selected_user_id:
                                                      favourite_users
                                                          .data[index].userId,
                                                )));
                                  },
                                  child: ListTile(
                                    isThreeLine: true,
                                    contentPadding: EdgeInsets.all(0),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          favourite_users
                                              .data[index].profilePicture),
                                    ),
                                    title: Text(
                                      favourite_users.data[index].fullName,
                                      style: TextStyle(
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8.0, 0, 8),
                                          child: Text(
                                            '10 Jan',
                                            style: TextStyle(
                                              fontFamily: 'SegoeUI',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
