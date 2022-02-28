import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lgp/bookmark/bookmark.dart';
import 'package:lgp/login/login_page.dart';
import 'package:lgp/login/my_session.dart';
import 'package:lgp/produk/produk_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  void myState() async {
    MySession.instance.getStringValue("username").then((value) => setState(() {
          username = value;
        }));

    MySession.instance.getBooleanValue("loggedin").then((value) => setState(() {
          isLoggedIn = value;
        }));
    print('Username : ' + username);
    print('Is Login : ' + isLoggedIn.toString());
  }

  final int _selectedNavbar = 0;
  void _changeSelectedNavBar(int index) {
    setState(() {
      // print(index);
      if (index == 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const MainPage();
          },
        ));
      } else if (index == 1) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const Bookmark();
          },
        ));
      } else if (index == 2) {
        MySession.instance.removeAll();
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ));
      }
    });
  }

  late TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    const Tab(
      text: 'Gudang',
    ),
    const Tab(
      text: 'Cabang',
    ),
  ];

  @override
  void initState() {
    myState();
    super.initState();
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 13, 9, 243),
                Color.fromARGB(255, 11, 55, 90)
              ])),
        ),
        bottom: TabBar(
          onTap: (index) {
            // Should not used it as it only called when tab options are clicked,
            // not when user swapped
          },
          controller: _controller,
          tabs: list,
        ),
        title: Row(
          children: <Widget>[
            Image.asset(
              'images/icon.png',
              fit: BoxFit.cover,
              width: 60,
            ),
            Text(
              "Gemilang",
              style: GoogleFonts.oswald(fontSize: 18),
            ),
          ],
        ),
      ),

      body: Center(
        child: TabBarView(controller: _controller, children: [
          const ProdukPage(jenis: 'gudang'),
          const ProdukPage(jenis: 'cabang'),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmark",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Logout",
          ),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: const Color.fromARGB(255, 47, 60, 240),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _changeSelectedNavBar,
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              "Gemilang",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            // decoration: BoxDecoration(
            //     color: Colors.green,
            //     image: DecorationImage(
            //         fit: BoxFit.fitHeight,
            //         image: AssetImage('assets/logo.png'))),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const MainPage();
                },
              ))
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_tree),
            title: const Text('Cabang'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const ProdukPage(
                    jenis: 'cabang',
                  );
                },
              ))
            },
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text('Gudang'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const ProdukPage(
                    jenis: 'gudang',
                  );
                },
              ))
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.money),
          //   title: Text('Produk'),
          //   onTap: () => {
          //     Navigator.push(context, MaterialPageRoute(
          //       builder: (context) {
          //         return ProdukPage();
          //       },
          //     ))
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              MySession.instance.removeAll();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
