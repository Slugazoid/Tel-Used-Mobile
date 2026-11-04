class Message {
  final String id;
  final String text;
  final String time;
  final bool isMine;

  const Message({
    required this.id,
    required this.text,
    required this.time,
    required this.isMine,
  });
}

const Map<String, List<Message>> dummyMessages = {
  '1': [
    Message(
      id: 'm1',
      text: 'Permisi kak, sepatu putihnya masih ada?',
      time: '11:58',
      isMine: true,
    ),
    Message(
      id: 'm2',
      text: 'Masih ada kak, kondisi 90% mulus ya',
      time: '11:59',
      isMine: false,
    ),
    Message(
      id: 'm3',
      text:
          'Siang kak, aku suka sepatunya. Kalau aku tawar 175 ribu boleh nggak?',
      time: '12:00',
      isMine: true,
    ),
  ],
  '2': [
    Message(
      id: 'm1',
      text: 'Kak, jaket denimnya masih ada?',
      time: '11:30',
      isMine: true,
    ),
    Message(
      id: 'm2',
      text:
          'Kondisinya masih bagus banget kak, cuma ada sedikit bekas lipatan di bagian lengan. Tidak ada sobek, tidak luntur, dan semua kancingnya masih lengkap. Kalau mau lihat foto detailnya nanti aku kirim ya, soalnya ada beberapa bagian yang belum sempat difoto.',
      time: '11:40',
      isMine: false,
    ),
    Message(
      id: 'm3',
      text: 'Masih ada kak, nego dikit boleh kok',
      time: '11:42',
      isMine: false,
    ),
  ],
  '4': [
    Message(
      id: 'm1',
      text: 'Bukunya sudah dikirim ya kak, resinya menyusul',
      time: '19:45',
      isMine: false,
    ),
    Message(
      id: 'm2',
      text: 'Makasih kak, barangnya udah sampai :)',
      time: '20:10',
      isMine: true,
    ),
  ],
};
