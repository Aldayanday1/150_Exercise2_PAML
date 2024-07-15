import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistem_pengaduan/data/services/pengaduan_service.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/views/detail_page/detail_screen.dart';

class SearchPage extends StatefulWidget {
  final PengaduanService pengaduanService;

  SearchPage({required this.pengaduanService});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Pengaduan> _searchResult = [];
  List<Pengaduan> _searchHistory = [];

  // keyboard akan muncul secara otomatis saat halaman dimuat
  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchFocusNode.requestFocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSearchHistory();
  }

//  memuat riwayat pencarian dari penyimpanan lokal (SharedPreferences) saat aplikasi dimulai.
  void _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('search_history');
    if (historyJson != null) {
      setState(() {
        _searchHistory = (jsonDecode(historyJson) as List)
            .map((item) => Pengaduan.fromJson(item))
            .toList();
      });
    }
  }

  void _saveSearchHistory(List<Pengaduan> searchHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final historyJson =
        jsonEncode(searchHistory.map((item) => item.toJson()).toList());
    prefs.setString('search_history', historyJson);
  }

  Future<void> _clearSearchHistory() async {
    bool confirm =
        await _showConfirmationDialog('Ingin menghapus semua riwayat?');
    if (confirm) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('search_history');
      setState(() {
        _searchHistory.clear();
      });
    }
  }

  Future<bool> _showConfirmationDialog(String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Konfirmasi'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                  child: Text('Tidak'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                  child: Text('Ya'),
                ),
              ],
            );
          },
        ) ??
        false; // If null, return false
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pencarian'),
      ),
      body: Column(
        children: [
          Container(
            height: 90,
            padding: EdgeInsets.all(20),
            child: TextField(
              focusNode: _searchFocusNode,
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _performSearch(query);
                });
              },
              onSubmitted: (query) {
                _performSearch(query);
              },
              decoration: InputDecoration(
                prefixIconColor: Colors.amber,
                suffixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                hintText: 'Cari...',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 136, 136, 136),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 136, 136, 136))),
              ),
            ),
          ),
          Flexible(
            child: _searchResult.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (context, index) {
                      Pengaduan pengaduan = _searchResult[index];
                      return InkWell(
                        onTap: () {
                          _addToSearchHistory(pengaduan);
                          _navigateToDetailPage(pengaduan);
                        },
                        child: ListTile(
                          title: Text(
                            pengaduan.judul,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            pengaduan.alamat,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              pengaduan.gambar,
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildSearchHistory(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return [];
    }
    return [
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Riwayat Pencarian',
                style: GoogleFonts.roboto(
                  fontSize: 25.0,
                  color: Color.fromARGB(255, 66, 66, 66),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_searchHistory.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: _clearSearchHistory,
              ),
          ],
        ),
      ),
      ..._searchHistory
          .map(
            (pengaduan) => Dismissible(
              key: Key(pengaduan.id.toString()),
              background: Container(
                color: const Color.fromARGB(255, 196, 196, 196),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await _showConfirmationDialog(
                    'Ingin menghapus item ini?');
              },
              onDismissed: (direction) {
                setState(() {
                  _searchHistory.removeWhere((item) => item.id == pengaduan.id);
                  _saveSearchHistory(_searchHistory);
                });
              },
              child: InkWell(
                onTap: () {
                  _navigateToDetailPage(pengaduan);
                },
                child: ListTile(
                  title: Text(
                    pengaduan.judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    pengaduan.alamat,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      pengaduan.gambar,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ];
  }

  void _performSearch(String query) async {
    if (query.isNotEmpty) {
      _searchPengaduan(query);
    } else {
      setState(() {
        _searchResult.clear();
      });
    }
  }

  Future<void> _searchPengaduan(String query) async {
    try {
      List<Pengaduan> pengaduanData =
          await widget.pengaduanService.searchPengaduan(query);
      setState(() {
        _searchResult = pengaduanData;
      });
    } catch (e) {
      print('Failed to search pengaduan');
    }
  }

  void _addToSearchHistory(Pengaduan pengaduan) {
    setState(() {
      _searchHistory.removeWhere((item) => item.id == pengaduan.id);
      _searchHistory.insert(0, pengaduan);
      _saveSearchHistory(_searchHistory);
    });
  }

  void _navigateToDetailPage(Pengaduan pengaduan) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailView(
                pengaduan: pengaduan,
              )),
    );
  }
}
