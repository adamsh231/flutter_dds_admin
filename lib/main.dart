import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './listAnak.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    title: 'DDSapp',
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = new Map();
  List dataJson;
  List dataRekomendasi;
  bool ulangAmbilData = true;
  bool ulangRekom = true;
  dynamic noAnak = 0;
  double lebar, tinggi;
  double lebarFixed, tinggiFixed;

  Future ambilData() async {
    http.Response ambil = await http.get(
        Uri.encodeFull("http://ddspkmbareng.id/index.php/Flutter"),
        headers: {"Accept": "application/json"});
    setState(() {
      dataJson = json.decode(ambil.body);
      ulangAmbilData = false;
      //TODO replace MAP data//
      data['nama'] = (dataJson[noAnak]['nama']);
      data['foto'] = (dataJson[noAnak]['foto']);
      data['url'] = "https://ddspkmbareng.id/";
    });
    return dataJson;
  }

  Future rekomendasi(String umur) async {
    http.Response ambil = await http.get(
        Uri.encodeFull(
            "http://ddspkmbareng.id/index.php/Flutter/rekomendasi/" + umur),
        headers: {"Accept": "application/json"});
    setState(() {
      ulangRekom = false;
      dataRekomendasi = json.decode(ambil.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    lebar = MediaQuery.of(context).size.width;
    tinggi = MediaQuery.of(context).size.height;
    lebarFixed = 411.42857142857144;
    tinggiFixed = 774.8571428571429;
    // print("Lebar : $lebar dan Tinggi : $tinggi");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(78, 115, 222, 1),
        centerTitle: true,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    ulangAmbilData = true;
                  });
                },
              )),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: FutureBuilder(
        future: ulangAmbilData ? ambilData() : null,
        builder: (context, snapshot) {
          return ulangAmbilData == false
              ? _body()
              : Center(child: CircularProgressIndicator());
        },
      ),
      drawer: ulangAmbilData == false ? _drawer() : CircularProgressIndicator(),
    );
  }

  //! body !//
  Widget _body() {
    return Column(
      children: <Widget>[
        _stackInfo(),
        _menuBody(),
      ],
    );
  }

  //! body->stackInfo !//
  Widget _stackInfo() {
    return Stack(
      children: <Widget>[
        //! Container Terbawah !//
        Container(
          height: (tinggi * 330 / tinggiFixed),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          child: Container(
            height: (tinggi * 260 / tinggiFixed),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(96, 165, 230, 1),
                  Color.fromRGBO(120, 180, 210, 1),
                  Color.fromRGBO(140, 200, 190, 1)
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    child: Hero(
                      child: Container(
                          margin: EdgeInsets.only(top: 20),
                          height: (tinggi * 140 / tinggiFixed),
                          width: (lebar * 140 / lebarFixed),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: data['foto'] == '?'
                                  ? "https://ddspkmbareng.id/uza/img/bg-img/1x.png"
                                  : data['url'] + data['foto'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.white,
                                child: CircularProgressIndicator(
                                  strokeWidth: 7,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )),
                      tag: 'imgAnak',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _tampilGambar(),
                          ));
                    }),
                SizedBox(
                  height: (tinggi * 10 / tinggiFixed),
                ),
                Text(
                  data['nama'],
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 30,
          right: 20,
          left: 20,
          child: _containerInfo(),
        ),
      ],
    );
  }

  //! body->stackInfo->tampilGambar !//
  Widget _tampilGambar() {
    return Center(
      child: GestureDetector(
        child: Hero(
          child: Container(
            height: (tinggi * 350 / tinggiFixed),
            width: (lebar * 350 / lebarFixed),
            child: CachedNetworkImage(
              imageUrl: data['foto'] == '?'
                  ? "https://ddspkmbareng.id/uza/img/bg-img/1x.png"
                  : data['url'] + data['foto'],
              placeholder: (context, url) => CircularProgressIndicator(
                strokeWidth: 6,
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
          tag: 'imgAnak',
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  //! body->stackInfo->containerInfo !//
  Widget _containerInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _containerInfoContent(
              placeholder: "Umur",
              teks: dataJson[noAnak]['bulan'] +
                  " Bulan " +
                  dataJson[noAnak]['day'] +
                  " Hari",
            )),
        ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _containerInfoContent(
              placeholder: "Berat Badan",
              teks: dataJson[noAnak]['bb_lahir'] + " Kg",
            )),
        ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _containerInfoContent(
              placeholder: "Panjang Badan",
              teks: dataJson[noAnak]['tb_lahir'] + " cm",
            )),
      ],
    );
  }

  //! body->stackInfo->containerInfo->containerInfoContent !//
  Widget _containerInfoContent({String teks, String placeholder}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color.fromRGBO(78, 115, 222, 1), Colors.blue]),
      ),
      height: (tinggi * 80 / tinggiFixed),
      width: (lebar * 120 / lebarFixed),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            teks,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Divider(
            height: (tinggi * 10 / tinggiFixed),
            color: Colors.white,
          ),
          Text(
            placeholder,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  //! body->menuBody !//  (a->c)
  Widget _menuBody() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: (tinggi * 350 / tinggiFixed),
        width: (lebar * 370 / lebarFixed),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(96, 165, 230, 1),
              Color.fromRGBO(120, 180, 210, 1),
              Color.fromRGBO(140, 200, 190, 1)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: (tinggi * 120 / tinggiFixed),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _zScore(
                    hasil: dataJson[noAnak]['stsBB'],
                    placeholder: "Berat Badan",
                    warna: dataJson[noAnak]['stsBBcolor'],
                  ),
                  _zScore(
                    hasil: dataJson[noAnak]['stsTB'],
                    placeholder: "Panjang Badan",
                    warna: dataJson[noAnak]['stsBBcolor'],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                    color: Colors.white,
                    height: (tinggi * 200 / tinggiFixed),
                    child: _listRekom()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //! body->menuBody->zscore !//
  Widget _zScore(
      {@required String hasil, @required String placeholder, String warna}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        color: Colors.white,
        height: (tinggi * 80 / tinggiFixed),
        width: (lebar * 150 / lebarFixed),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              hasil,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: warna == 'd'
                      ? Colors.red
                      : warna == 'w'
                          ? Colors.yellow
                          : warna == 's' ? Colors.green : Colors.black),
            ),
            Divider(
              color: Colors.black,
              height: (tinggi * 4 / tinggiFixed),
            ),
            Text(placeholder),
          ],
        ),
      ),
    );
  }
  
  //! body->menuBody->zscore !//
  Widget _listRekom() {
    return FutureBuilder(
        future: ulangRekom ? rekomendasi(dataJson[noAnak]['bulan']) : null,
        builder: (context, index) {
          return ulangRekom == false
              ? ListView.separated(
                  itemCount: dataRekomendasi.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      dataRekomendasi[index]['deskripsi'],
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Container(
                  width: (lebar * 400 / lebarFixed),
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 5,
                  )),
                );
        });
  }

  //! body->drawer !//
  Widget _drawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              margin: EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Hero(
                      child: Container(
                        height: (tinggi * 70 / tinggiFixed),
                        width: (lebar * 70 / lebarFixed),
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/a2.jpg'),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      tag: 'imgProfil',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _tampil(),
                          ));
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Ny. " + dataJson[noAnak]['nama_ibu'],
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                      Text(
                        "iffa@gmail.com",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(78, 115, 222, 1),
            ),
          ),
          ListTile(
            title: Text('Menu Utama'),
            leading: Icon(
              Icons.home,
              color: Colors.grey,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(
            color: Colors.black,
            height: (tinggi * 0 / tinggiFixed),
          ),
          ListTile(
            title: Text('Daftar Anak'),
            leading: Icon(
              Icons.supervised_user_circle,
              color: Colors.grey,
              size: 30,
            ),
            onTap: () async {
              Navigator.pop(context);
              final nomor = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListAnak(
                            dataAnak: dataJson,
                          )));
              setState(() {
                if (nomor != null) {
                  noAnak = nomor;
                  ulangAmbilData = true;
                  ulangRekom = true;
                }
              });
            },
          ),
          ListTile(
            title: Text('Daftar Riwayat'),
            leading: Icon(
              Icons.list,
              color: Colors.grey,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(
            color: Colors.black,
            height: (tinggi * 0 / tinggiFixed),
          ),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.grey,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //! body->drawer->tampil !//
  Widget _tampil() {
    return Center(
      child: GestureDetector(
        child: Hero(
          child: Container(
            height: (tinggi * 350 / tinggiFixed),
            width: (lebar * 350 / lebarFixed),
            child: Image.asset(
              'img/a2.jpg',
              fit: BoxFit.contain,
            ),
          ),
          tag: 'imgProfil',
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
