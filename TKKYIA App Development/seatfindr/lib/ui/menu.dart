import 'package:flutter/material.dart';
import 'package:seatfindr/ui/connection_page.dart';

class menu extends StatefulWidget {
  @override
  menupage createState() => menupage();
}

class menupage extends State<menu> {
  final List<String> _names = <String>[
    'Demo Hawker Centre',
    'Adam Road Food Centre',
    'Amoy Street Food Centre',
    'Bedok Food Centre',
    'Beo Crescent Market',
    'Berseh Food Centre',
    'Bukit Timah Market',
    'Chomp Chomp Food Centre',
    'Commonwealth Crescent Market',
    'Dunman Food Centre',
    'East Coast Lagoon Food Village',
    'Geylang Serai Market',
    'Golden Mile Food Centre',
    'Holland Village Market & Food Centre',
    'Kallang Estate Market',
    'Market Street Food Centre',
    'Maxwell Food Centre',
    'Newton Food Centre',
    'North Bridge Road Market & Food Centre',
    'Pasir Panjang Food Centre',
    'Serangoon Garden Market',
    'Sembawang Hill Food Centre',
    'Taman Jurong Market & Food Centre',
    'Tanglin Halt Market',
    'Tiong Bahru Market',
    'Zion Riverside Food Centre',
    'ABC Brickworks Market & Food Centre',
    'Albert Centre Market & Food Centre',
    'Alexandra Village Food Centre',
    'Blk 1 Jalan Kukoh',
    'Blk 105 Hougang Ave 1',
    'Blk 11 Telok Blangah Crescent',
    'Blk 112 Jalan Bukit Merah',
    'Blk 115 Bukit Merah View',
    'Blk 117 Aljunied Ave 2',
    'Blk 127 Toa Payoh Lorong 1',
    'Blk 137 Tampines Street 11',
    'Blk 159 Mei Chin Road',
    'Blk 16 Bedok South Road',
    'Blk 163 Bukit Merah Central',
    'Blk 17 Upper Boon Keng Road',
    'Blk 20 Ghim Moh Road',
    'Blk 208B New Upper Changi Road',
    'Blk 210 Toa Payoh Lorong 8',
    'Blk 216 Bedok North Street 1',
    'Blk 22 Toa Payoh Lorong 7',
    'Blk 226D Ang Mo Kio Ave 1',
    'Blk 226H Ang Mo Kio Street 22',
    'Blk 254 Jurong East Street 24',
    'Blk 29 Bendemeer Road',
    'Blk 320 Shunfu Road',
    'Blk 341 Ang Mo Kio Ave 1',
    'Blk 347 Jurong East Ave 1',
    'Blk 353 Clementi Ave 2',
    'Blk 36 Telok Blangah Rise',
    'Blk 37A Teban Gardens Road',
    'Blk 409 Ang Mo Kio Ave 10',
    'Blk 44 Holland Drive',
    'Blk 448 Clementi Ave 3',
    'Blk 453A Ang Mo Kio Ave 10',
    'Blk 49 Sims Place',
    'Blk 4A Eunos Crescent',
    'Blk 4A Jalan Batu',
    'Blk 4A Woodlands Centre Road',
    'Blk 502 West  Coast Drive',
    'Blk 503 West Coast Drive',
    'Blk 505 Jurong West Street 52',
    'Blk 50A Marine Terrace',
    'Blk 51 Old Airport Road',
    'Blk 511 Bedok North Street 3',
    'Blk 527 Ang Mo Kio Ave 10',
    'Blk 538 Bedok North Street 3',
    'Blk 58 New Upper Changi Road',
    'Blk 6 Tanjong Pagar Plaza',
    'Blk 628 Ang Mo Kio Ave 4',
    'Blk 630 Bedok Reservoir Road',
    'Blk 69 Geylang Bahru',
    'Blk 7 Empress Road',
    'Blk 724 Ang Mo Kio Ave 6',
    'Blk 726 Clementi West Street 2',
    'Blk 74 Toa Payoh Lorong 4',
    'Blk 75 Toa Payoh Lorong 5',
    'Blk 79 Redhill Lane',
    'Blk 79 Telok Blangah Drive',
    'Blk 80 Circuit Road',
    'Blk 82 Telok Blangah Drive',
    'Blk 84 Marine Parade Central',
    'Blk 85 Bedok North Street 4',
    'Blk 85 Redhill Lane',
    'Blk 89 Circuit Road',
    'Blk 90 Whampoa Drive',
    'Blk 93 Toa Payoh Lorong 4',
    'Blks 13/14 Haig Road',
    'Blks 160/162 Ang Mo Kio Ave 4',
    'Blks 1A/ 2A/ 3A Commonwealth Drive',
    'Blks 2 & 3 Changi Village Road',
    'Blks 20/21 Marsiling Lane',
    'Blks 221 A/B Boon Lay Place',
    'Blks 22A/B Havelock Road',
    'Blks 79/79A Circuit Road',
    'Blks 91/92 Whampoa Drive',
    'Chinatown Market',
    'Chong Pang Market & Food Centre',
    'Hong Lim Market & Food Centre',
    'Kovan Market & Food Centre',
    'Pek Kio Market & Food Centre',
    "People's Park Food Centre",
    'Tekka Market'
  ];
  final _savedNames = <String>[];

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _names.length,
      itemBuilder: (context, index) {
        return _buildRow(_names[index]);
      },
    );
  }

  Widget _buildRow(String name) {
    final alreadySaved = _savedNames.contains(name);

    return Card(
        elevation: 10,
        margin: EdgeInsets.all(7),
        child: GestureDetector(
          child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
              title: Text(name, style: TextStyle(fontSize: 18.0)),
              tileColor: Colors.white,
              trailing: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null),
              onLongPress: () {
                setState(() {
                  if (alreadySaved) {
                    _savedNames.remove(name);
                  } else {
                    _savedNames.add(name);
                  }
                });
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => demo_tables()),
                );
              }),
        ));
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
          appBar: AppBar(title: Text('Saved Hawker Centres')),
          body: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: _savedNames.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    elevation: 10,
                    margin: EdgeInsets.zero,
                    child: GestureDetector(
                        child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(500),
                            ),
                            title: Text(_savedNames[index],
                                style: TextStyle(fontSize: 18.0)),
                            tileColor: Colors.white,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => demo_tables()),
                              );
                            })));
              }));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hawker Centres'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.favorite, color: Colors.red, size: 30),
                onPressed: _pushSaved)
          ],
        ),
        body: _buildList());
  }
}
