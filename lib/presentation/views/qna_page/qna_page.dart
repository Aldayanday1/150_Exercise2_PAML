import 'package:flutter/material.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/floating_button.dart';

class QnAPage extends StatefulWidget {
  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnAPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text('Help'),
                  pinned: true,
                  bottom: TabBar(
                    tabs: [
                      Tab(text: 'Akademik'),
                      Tab(text: 'Non-Akademik'),
                      Tab(text: 'Olahraga & Seni'),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _buildAkademik(),
                _buildNonAkademik(),
                _buildOlahragaSeni(),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingButton(),
    );
  }

  Widget _buildAkademik() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: ListView(
        children: [
          ExpansionTile(
            title: Text('Seminar dan Workshop'),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15),
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.school),
                    title: Text(
                      'Acara yang mengundang pembicara dari industri atau akademisi untuk berbagi pengetahuan dan pengalaman terkini dalam bidang teknik.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: ExpansionTile(
              title: Text('Kegiatan Penelitian Mahasiswa'),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 15),
                  child: Container(
                    child: ListTile(
                      leading: Icon(Icons.science),
                      title: Text(
                        'Terlibat dalam proyek-proyek penelitian yang dipimpin oleh dosen atau sebagai bagian dari program magang, yang bisa berujung pada presentasi hasil penelitian mereka di depan rekan-rekan dan dosen.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: ExpansionTile(
              title: Text('Presentasi Proyek Akhir'),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 15),
                  child: Container(
                    child: ListTile(
                      leading: Icon(Icons.assignment),
                      title: Text(
                        'Mahasiswa dapat mempresentasikan hasil proyek mereka yang telah diselesaikan sebagai syarat kelulusan.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonAkademik() {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('Kegiatan Sosial'),
          children: [
            ListTile(
              title: Text(
                  'Termasuk kegiatan seperti bakti sosial, kampanye sosial, atau kegiatan relawan untuk memberikan dampak positif bagi masyarakat sekitar.'),
            )
          ],
        ),
        ExpansionTile(
          title: Text('Kegiatan Organisasi & Komunitas'),
          children: [
            ListTile(
              title: Text(
                  'Meliputi pertemuan, pelatihan, dan acara kebersamaan yang bertujuan memperkuat hubungan dan keterlibatan dalam organisasi mahasiswa serta pengembangan kepemimpinan.'),
            )
          ],
        ),
        ExpansionTile(
          title: Text('Kompetisi Teknologi'),
          children: [
            ListTile(
              title: Text(
                  'Perlombaan yang menantang mahasiswa untuk memecahkan masalah teknologi tertentu atau menghasilkan inovasi baru dalam bidang teknik.'),
            )
          ],
        ),
        ExpansionTile(
          title: Text('Diskusi Keagamaan'),
          children: [
            ListTile(
              title: Text(
                  'Mencakup forum untuk diskusi kajian agama, kegiatan doa bersama atau meditasi untuk mendalami pemahaman tentang isu-isu keagamaan dan menciptakan suasana refleksi spiritual.'),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildOlahragaSeni() {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('Kompetisi Olahraga'),
          children: [
            ListTile(
              title: Text(
                  'Turnamen atau kompetisi olahraga yang mencakup berbagai cabang olahraga, seperti sepak bola, basket, atau game online E-Sports.'),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Acara Seni'),
          children: [
            ListTile(
              title: Text(
                  'Pertunjukan seni, seperti konser musik, pementasan teater, atau pameran seni rupa, yang melibatkan partisipasi dari mahasiswa dan staf fakultas.'),
            ),
          ],
        ),
      ],
    );
  }
}
