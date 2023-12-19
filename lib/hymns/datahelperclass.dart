import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../hymns/hymnClass.dart';

class HymnDatabaseHelper {
  static final HymnDatabaseHelper _singleton = HymnDatabaseHelper._internal();

  factory HymnDatabaseHelper() {
    return _singleton;
  }

  HymnDatabaseHelper._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null && _database!.isOpen) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'hymn_database.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        print("Creating the hymns table");
        return db.execute(
          'CREATE TABLE hymns(id INTEGER PRIMARY KEY, number INTEGER, name TEXT, isFavorite INTEGER, content TEXT)',
        );
      },
    );

    print("Database opened successfully");

    // Check if there are hymn records in the database

    return database;
  }

  Future<List<Hymn>> loadHymnDataFromAssets() async {
    List<Hymn> hymns = [];

    for (var i = 1; i <= totalHymns; i++) {
      final hymnName = getHymnName(i); // Get the hymn name
      final assetPath =
          'assets/hymns/$i.${hymnName ?? 'Unknown'}.txt'; // Provide a default if hymnName is null

      try {
        final content = await rootBundle.loadString(assetPath);

        // Create a Hymn object and add it to the list
        final firstLine = content.split('\n')[0].trim();
        hymns.add(Hymn(
          name: firstLine,
          number: i,
          assetPath: assetPath,
          id: i,
          content: content,
        ));

        // Insert the hymn data into the database
        await insertHymn(i, hymnName!, false, content);
      } catch (e) {
        print('Error loading content for hymn $i: $e'); // Debug log
      }
    }

    // Return the list of loaded hymns
    return hymns;
  }

  Future<void> insertHymn(
      int number, String name, bool isFavorite, String content) async {
    try {
      final db = await database;
      if (db != null) {
        final hymnData = {
          'number': number,
          'name': name,
          'isFavorite': isFavorite ? 1 : 0,
          'content': content,
        };
        // print('Inserting hymn into the database: $number'); // Debug log
        final hymnId = await db.insert(
          'hymns',
          hymnData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('Hymn data inserted successfully with ID: $hymnId'); // Debug log
      } else {
        print('Database is null'); // Debug log
      }
    } catch (e) {
      print('Error inserting hymn data: $e'); // Debug log
    }
  }

  Future<List<Hymn>> getAllHymns(bool onlyFavorites) async {
    final db = await database;
    if (db != null) {
      List<Map<String, dynamic>> maps;
      if (onlyFavorites) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final List<String> favoriteIds =
            prefs.getStringList('favoriteHymns') ?? [];
        maps =
            await db.query('hymns', where: 'id IN (${favoriteIds.join(',')})');
      } else {
        maps = await db.query('hymns');
      }

      return List.generate(maps.length, (i) {
        final int number = maps[i]['number'];
        return Hymn(
          id: maps[i]['id'],
          number: number,
          name: maps[i]['name'],
          isFavorite: maps[i]['isFavorite'] == 1,
          assetPath: 'assets/hymns/$number.${getHymnName(number)}.txt',
          content: maps[i]['content'],
        );
      });
    } else {
      return [];
    }
  }
}

const totalHymns = 610; // Total number of hymns

String? getHymnName(int hymnNumber) {
  final hymnNames = {
    1: 'Andu Othe A Guku Thi',
    2: 'He Nyumba Njega Thiini Wa Andu',
    3: 'Jehova Niwe Utheri Wakwa',
    4: 'Nitwendaga Haria',
    5: 'Nitucemanitie',
    6: 'Mugoocei Jesu Niwe Muhonokia',
    7: 'Mugoocei Ngai Mwathani',
    8: 'Ngai Ithe Arogoocwo',
    9: 'Ngai Ithe Witu Wi Mwihokeku',
    10: 'Nituinire Mwathani',
    11: 'Guku Thi Riu Kwi Na Utheri',
    12: 'Hingo Njega Ya Kuhoya',
    13: 'Jesu Mwega Mutheru',
    14: 'Mwathani Ngai Wakwa',
    15: 'O Rucini Twarahuka',
    16: 'Awa Nitwongana Haha Riu',
    17: 'Jesu Ni Muriithi Wakwa',
    18: 'Riria Arwaru Maakomete',
    19: 'Riu Gugitukatuka Nitwongana Haha',
    20: 'Gera Hari Nii Mwathani',
    21: 'Guku Ni Kuri Waganu Muingi',
    22: 'Jehova Wa Kuu Betheli',
    23: 'Muthenya Wa Gikeno',
    24: 'Ngoro Yakwa Ni Hekaru',
    25: 'Ngoro Yakwa Thengerera',
    26: 'Andu Othe Kenai',
    27: 'Gutiri Undu Ungigiria',
    28: 'Gwatiai Matawa Manyu',
    29: 'He Maguta Tawaini Njakanage',
    30: 'Ihiga Ria Tene Ma',
    31: 'Jesu Atuhe Mai Ma Muoyo',
    32: 'Jesu Ningegaga Ni Wendo',
    33: 'Jesu Nitwoka Tukuinire',
    34: 'Jesu Turathime',
    35: 'Jesu We Unyendete',
    36: 'Kuuma Ndaciaruo No Njihagia',
    37: 'Muhonokia Tondu Ni Unyendete',
    38: 'Muhonokia Wakwa Ningwihokete',
    39: 'Mwathani Aranjiirite',
    40: 'Mwathani Na Utheri Waku Mwega',
    41: 'Mwathani Ninjiguaga',
    42: 'Mwathani We Uhonokanagia',
    43: 'Mwathani Witu Ninjukite Riu',
    44: 'Ndi Mwihia O Na Wanyona',
    45: 'Ndirica Cia Uguru',
    46: 'Nduiria Ngoro Yakwa Thiini',
    47: 'Ngai E Haha Na Niekwenda',
    48: 'Ngai Mwega Na Muigua Tha',
    49: 'Ngwenda Kuhaana Ta Jesu',
    50: 'Nii Ndi Munyotu Muno',
    51: 'Ningakinya Ti Itheru',
    52: 'Ninguigua Mugambo',
    53: 'Ninguuka Mwathani Witu',
    54: 'Ningukira Thii Hari Jesu',
    55: 'Ninjangite O Kuraya',
    56: 'Niucangite O Ma Kuraya Muno',
    57: 'O Uguo Ndarii Mwathani',
    58: 'Riria Mwihia Erira',
    59: 'Riu Mwathani Ndaguthaitha',
    60: 'Thakame Ndathime Niyo',
    61: 'Tumuinire Tumukumie',
    62: 'Uka Mwathani Utonye Thiini',
    63: 'Jesu Riua Ria Wega',
    64: 'Ngai Baba Thikiriria',
    65: 'Rwimbo Rwa Hwaiini',
    66: 'Kiugo Giaku Ngai',
    67: 'Mbuku Ya Ngai Ni Theru',
    68: 'Uhoro Uyu Mwega Muno',
    69: 'Uhoro Wa Muoyo',
    70: 'Goocai Jehova',
    71: 'Amukira Ngatho Ciakwa Ngai Wakwa',
    72: 'Ngai Wakwa Ningegaga Muno Ma',
    73: 'Nii Ningwenda Ngai Umenyage',
    74: 'Nii Ninjui Wega Mwathani',
    75: 'Ningutiira Maitho Ndorererie',
    76: 'Nituthathaiye Mwathani Jesu',
    77: 'Riitwa Riaku We Mwathani',
    78: 'Uria Mutheru Niakumagio',
    79: 'Akristiano Kenai',
    80: 'Gwi Gikeno Kinene Ma',
    81: 'Gwi Gikeno Kinene Ma Jesu',
    82: 'Hindi Iria Ngumo Njega Yarehiruo',
    83: 'Iguai Rwimbo Ruu Rwa Araika Iguru',
    84: 'Ithui Athamaki Atatu',
    85: 'Kuria Daudi Aciariiruo',
    86: 'Maikarite Thi Utuku',
    87: 'Mwathani Ni Muciare',
    88: 'Ngai Niwatongoririe',
    89: 'Nigwaciariruo Mwana O Tene',
    90: 'Ni Kuri Mwana Wokire Thi O Tene',
    91: 'Ni Utuku',
    92: 'Ni Wokire Tondu Wa Kunyenda',
    93: 'O Ta Uria O Tene Ma',
    94: 'Onei Muharatiini',
    95: 'Riria Jesu Kristu Aciarirwo',
    96: 'Ta Uria Andu A Tene Ma',
    97: 'Tene Tene Muno Jesu Aari Mwana',
    98: 'Ukani Tukene Andu A Mwathani',
    99: 'Weruini Utuku Tene Ma',
    100: 'Arahuka Arahuka',
    101: 'Guoko Gwaku We Mwathani',
    102: 'Jesu Mwene Niwe Njira',
    103: 'Jesu Ni Muriithi Wa Mburi Ciake',
    104: 'Jesu O Tene Bethilehemu',
    105: 'Jesu Okiire Andu Ake',
    106: 'Mariamu Niaaikaire Hamwe Na Jesu',
    107: 'Muigue Mugambo Wa Jesu',
    108: 'Muraika Wa Mwathani',
    109: 'Ndiui Gitumi Gia Utugi Ucio',
    110: 'Ngondu Mirongo Kenda Na Kenda',
    111: 'Ni Jesu Kristu Wahonokirie',
    112: 'Nu Woimire Iguru',
    113: 'Nyendaga Ngithoma Uhoro Wa Tene',
    114: 'Thikiriria Uhoro Mwega',
    115: 'Ukai Inyui Anogu',
    116: 'O Tene Muno Jesu Munyendi',
    117: 'Thii Na Mbere Muthamaki',
    118: 'Ugooci O Na Riri',
    119: 'Ciugo Mugwanja Cia Mutharabaini',
    120: 'Gwi Karima Ga Kuraya',
    121: 'Jesu Aakuire Ni Undu Wakwa',
    122: 'Jesu Niarihite Thiiri',
    123: 'Jesu Nioirire Thakame',
    124: 'Jesu Njikaria Mutiini',
    125: 'Kuraya Karimaini',
    126: 'Kuria Ukwenda Ninguthii',
    127: 'Kwi Na Ruui Rwa Thakame',
    128: 'Maamuthurire Tuhu Mwathani Jesu',
    129: 'Mburi Cianathinjwo',
    130: 'Muhuro Wa Mutharaba',
    131: 'Muru Wa Ngai Niokire',
    132: 'Mutharabaini Wa Mukuuri',
    133: 'Ndihota Guconoka Riu',
    134: 'Ni Uhoro Wa Kugegania',
    135: 'Nu Utangiigua Kieha',
    136: 'Riria Nguona Mutharaba',
    137: 'Ukai Haha Murire',
    138: 'Wari Ho Makiambithia Mwathani',
    139: 'Gukwiruo Atia Umuthi',
    140: 'Jesu Kristu E Muoyo',
    141: 'Jesu Niaariukire Haleluya',
    142: 'Mukuuri Ni Muriuku',
    143: 'Muthenya Wa Bathaka',
    144: 'Muthenya Wa Kuriuka',
    145: 'Niaakuire Mutiini',
    146: 'Niakuire Undu Wakwa',
    147: 'Ugooci Wothe Ni Waku',
    148: 'Utuku Macemanitie',
    149: 'Gathai Riitwa Ria Jesu',
    150: 'Jesu Ni Anenehio',
    151: 'Mutwe Waigiriiruo Thumbi',
    152: 'Rorai Inyui Atheru',
    153: 'Jesu Niagathamakaga',
    154: 'Kai Jesu Ni Mwega Atwendete Uu',
    155: 'Mwathani Jesu Niagoka Kiririria',
    156: 'Ndungata Cia Mwathani',
    157: 'Niagoka Ringi Jesu Kristu',
    158: 'Riria Agacoka Jesu',
    159: 'Riria Mwathani Witu Agacoka',
    160: 'Tukirii Kwambata Iguru',
    161: 'Uyu Nu Uguikuruka',
    162: 'Hindi Iria Muru Wa Mundu',
    163: 'Hingo Ikirii Guthira',
    164: 'Ithiriro Riri Hakuhi',
    165: 'Jesu Niagacoka Guku Thi',
    166: 'Karumbeta Gakahuhwo Muthenya Ucio',
    167: 'Muhonokia Niagoka',
    168: 'Muthenya Umwe Jesu Niagacoka',
    169: 'Muthenya Uria Munene',
    170: 'Mwathani Ngai Ithe Witu',
    171: 'Uka Uka Imanueli',
    172: 'Heeherera Roho Na Mihumu Yaku',
    173: 'I Roho Mutheru Thikiriria',
    174: 'Mukuuri Witu Mwega Ma',
    175: 'Thakame Ya Mwathani Niyo Ya Goro',
    176: 'We Roho Mutheru',
    177: 'We Roho Mutheru Wa Ngai',
    178: 'Atatu Thiini Wa Umwe',
    179: 'Ngai Mumbi Wa Thi',
    180: 'Ni Ki Wi Nakio Utaheiruo',
    181: 'Nitugooce Ngai',
    182: 'Riua Rirokire Kwara',
    183: 'Wee Nowe Mutheru',
    184: 'Ciana Ici Inai Haleluya',
    185: 'Gooca Jehova Ngai Wa Iguru',
    186: 'Goocai Mwathani Wa Atheru',
    187: 'I Jesu We Mugegania',
    188: 'I Ngai Baba Riu Nimenyete',
    189: 'Jesu Ndakuririkana',
    190: 'Migambo Ngiri Na Ngiri',
    191: 'Muhonokia Arogoocwo',
    192: 'Ngai Nitugukugatha',
    193: 'Ngainaga Uhoro Mwega',
    194: 'Ngoro Yakwa Ndumukumie',
    195: 'Nitukigathe Ngai O Wega',
    196: 'Nitumutue Munene',
    197: 'Riitwa Ria Jesu Ni Riega',
    198: 'Twakugatha Ngai',
    199: 'Ukani Tuinire Ngai',
    200: 'Arata A Ngai Ciugo Ciake Nocio',
    201: 'Gutiri Na Murata Ta Jesu',
    202: 'Gwitu Kwa Ngai Kwi Muhonokia',
    203: 'Hekaruini Ya Iguru',
    204: 'Ithui Nituonete Utheri',
    205: 'Jehova Ngai Niwe Muriithi Wakwa',
    206: 'Jehova Niandiithagia',
    207: 'Jesu Mwene Nioigire Ihinda',
    208: 'Kuraya Kurikiru Ngoroini Yakwa',
    209: 'Kuri Umwe Utwendaga Jesu Witu',
    210: 'Kwahoteka Atia Nii Ngunike',
    211: 'Mundu Muhoro No Uria',
    212: 'Mundu Wa Gwitikia Mwathani Witu',
    213: 'Muoyo Uyu Wa Guku Thi',
    214: 'Muriithi Uria Mwega',
    215: 'Muthamaki Wa Wendani',
    216: 'Ndi Na Rwimbo Nyenda Kuina',
    217: 'Ndi Na Thayu Ndi Thi Ino Ya Mehia',
    218: 'Ndi Na Thayu Wa Ngai Rugendoini',
    219: 'Ndingienyenyeka',
    220: 'Ndingihenio Ni Utonga',
    221: 'Ngai Ni Wendo',
    222: 'Ngai Ni Wendo Na Tha Ciake',
    223: 'Ngai ni Wendo Ngai Ni Wendo',
    224: 'Ngutherio Ngoro Ni Ki',
    225: 'Ngutuura Ngoocaga Mwathani Wakwa',
    226: 'Ngwenda Kumumenya Jesu',
    227: 'Nindakwirutiire Thakame Na Muoyo',
    228: 'Ningwihoka O Thakame',
    229: 'Njikaraga Njuthiriirie Thumbi',
    230: 'Riitwa Ria Jesu Ni Riega Ninyendaga',
    231: 'Ti Itheru Twi Murata',
    232: 'Tiga Gwitigira Ndi Hamwe Nawe',
    233: 'Tondu Ngai Niendire Thi Yothe',
    234: 'Twi Na Jesu Guothe Kuri Na Thayu',
    235: 'Twi Na Utonga Munene',
    236: 'Uhoreri Wa Ngai Utarii Ta Ri',
    237: 'Umwe Kuri Andu Othe',
    238: 'Utugi Wa Magegania',
    239: 'Wenda Woheruo Mehia Maku Riu',
    240: 'Wihoke Riitwa Ria Jesu',
    241: 'Witikio Wakwa Uikaire',
    242: 'Ariu A Ithe Witu Inyui Muhonoketio',
    243: 'Hari Jesu Ngwiheana',
    244: 'I Roho Mutheru Tuigue Tukiina',
    245: 'Jesu Kristu Niegutwita',
    246: 'Jesu Muhonokia Wakwa',
    247: 'Jesu Mukuuri Witu We Utuire',
    248: 'Jesu Riu Ni Aretana',
    249: 'Muoyo Wakwa Ndakuhe Utuike',
    250: 'Mwathani Jesu Niaretana',
    251: 'Nguuka Ndige Nduma Na Kieha',
    252: 'Niwe Uhititie Njira',
    253: 'Rurumukia Wira Waku',
    254: 'Utuiguire Tha Ngai',
    255: 'Andu Aitu Mutibare',
    256: 'Andu Aria Mwendete Jesu',
    257: 'Andu Rutai Wira',
    258: 'Indo Ciaku Nocio',
    259: 'Itikia Ngai Utigane Na Thina',
    260: 'Kundu Kuingi Andu Me Ndumaini',
    261: 'Moko Matheri Thii O Uguo',
    262: 'Mwathani Aathanire Thiii Thi Yothe',
    263: 'Mwathani Ngai Niekwenda',
    264: 'Njiira Uhoro Mwega',
    265: 'Njiira Uhoro Wa Jesu',
    266: 'Njiiraga O Kaingi Ma',
    267: 'O Muthenya Mwathi Wakwa',
    268: 'Riria Coro Wa Ngai Ukahuhwo',
    269: 'Rucini Kiroko Tene',
    270: 'Thiii Mucarie Andu Othe',
    271: 'Unene Na Hinya Ni Ciaku We Jehova',
    272: 'Aanake Ukirai',
    273: 'Andu A Muthamaki',
    274: 'Andu A Mwathani',
    275: 'Arahuranai Mbaara Ni Njihu',
    276: 'Arutwo Meranire Merute Uhoro',
    277: 'Aria Mari Na Hinya',
    278: 'Guku Thi Gutiri Handu',
    279: 'Inirai Wendo Wake Jesu',
    280: 'Jesu Mwene Nianguiriire',
    281: 'Kiigitio Gia Kwihokwo',
    282: 'Kuhoya Kuhaana Ngathi',
    283: 'Magerio Ni Maingi Muturireini Uyu',
    284: 'Magerio Ni Ma Ki',
    285: 'Mbaara Ni Nene Ndi Rugendoini',
    286: 'Mbutu Iitu Ya Agendi',
    287: 'Mundu Wa Kristu Igua',
    288: 'Mundu Witu Nduumiririe',
    289: 'Mwathii Ku Agendi Aya',
    290: 'Mwona Mathina Kaingi',
    291: 'Nanga Yaku Ni Ikaruma Wega',
    292: 'Ndi Rugendoini Ndirithiaga',
    293: 'Ndi Thigari Ya Muthamaki',
    294: 'Ngukinyukia O Kahora',
    295: 'Ngumwira Na Ma Itari Na Nganja',
    296: 'Niekundongoria Mwathani',
    297: 'Nituthiini Ita',
    298: 'Nitwihokage Jesu',
    299: 'Njerekeire O Matuini',
    300: 'Njira Ino Ya Guthii Iguru',
    301: 'Nyendaga Guthoma Rugano',
    302: 'Riria Twatwarana Na Mwathani Jesu',
    303: 'Rua Wega Na Ucamba',
    304: 'Rugendoini Ruru Rwa Guthii Iguru',
    305: 'Thiii Athigari A Jehova Ngai',
    306: 'Ukirai Narua Thigari Cia Kristu',
    307: 'Undongorie Mwathani Jesu',
    308: 'Wihoke Mwathani Rugendoini',
    309: 'Kuuma Hindi Iria Ndathiire',
    310: 'Ndatuuraga Thi Ino Ndarii Ta Mugendi',
    311: 'Ndi Mugeni Guku Ndi Wa Kwa Ngai',
    312: 'Ngai Niendire Andu Othe',
    313: 'Ngoroini Yakwa He Gikeno',
    314: 'Ngwihoka Na Ngoro Yakwa',
    315: 'Ni Jesu Ungenagia Ngoro',
    316: 'Nindakenirio Ni Mwathani',
    317: 'Ninjiguaga Gikeno Kinene',
    318: 'Ninyonete Uhuruko Itari Ndona',
    319: 'Riitwa Ria Jesu Ni Riega Muno',
    320: 'Riria Ndakuite Ni Undu Wa Mehia',
    321: 'Ukani Endi Ngai Muuke Mukenete',
    322: 'Ungimenyana Na Jesu',
    323: 'Utheri Wa Karimaini',
    324: 'Wi Munogu Na Muthini',
    325: 'Aanake Mwetikira Mwathani',
    326: 'Andu A Guku Thi',
    327: 'Andu Othe Nimoriire Ndumaini',
    328: 'Arata Aitu Nituonane',
    329: 'Gwaku Kurugamite Mugeni',
    330: 'Igua Kanua Ka Jesu Mukuuri',
    331: 'Jesu Mwene Nioigire Uria Unyotii',
    332: 'Kiunganoini Giki Atheru',
    333: 'Murigiti E Haha Riu',
    334: 'Ndaiguire Jesu Akinjita',
    335: 'Ndumiriri Ya Mwathi Haleluya',
    336: 'Nimukinyite Hari Jesu Witu',
    337: 'Niugwitwo Ni Jesu Utuike Wake',
    338: 'Thakame Ya Jesu Ya Goro Muno',
    339: 'Uhoro Wa Gukena',
    340: 'Uhoro Wa Kungenia',
    341: 'Uka Kwi Jesu Ndukarege',
    342: 'Uka Riu Kwi Mwathani',
    343: 'Uka Uka Hari Jesu',
    344: 'Ukani Inyui Ehia',
    345: 'Uthamaki Wa Iguru',
    346: 'Uthamaki Waku',
    347: 'Wendo Wa Jesu Ni Mwega Muno',
    348: 'Wi Munogu Na Niuthinikite',
    349: 'Acio Mahaana Ta Njata',
    350: 'Atheru Aria Mahurukite',
    351: 'Guku Kuri Na Kieha Ma',
    352: 'Gwi Thi Njega Muno Kuraya Ma',
    353: 'Hamwe Na Mwathani Mindi O Na Mindi',
    354: 'Hihi No Tukagomana',
    355: 'Ithui Tutigakua Jesu Acoka',
    356: 'Kuraya Kuraya',
    357: 'Kuri Mucii Mutheru',
    358: 'Kwa Baba Matuini Gutiri Na Thina',
    359: 'Kwi Mucii Muthaka',
    360: 'kwi Na Bururi Mwega Ma',
    361: 'Ndi Na Mukuuri Wakwa Uri Matuini',
    362: 'Ndi Na Murata Munene',
    363: 'Ngai Amuikarie Nginya Tene',
    364: 'Ni Kuri Bururi Mwega Ma',
    365: 'Ni Kuri Na Bururi Mwega',
    366: 'Ninjui Wega Nii Ndi Mugendi',
    367: 'Onei Ni Wendo Utarii Atia',
    368: 'Riria Atheru Makaingira',
    369: 'Tuthomaga Ndeto Cia Iguru',
    370: 'Twaragia Uhoro Mwega',
    371: 'Jesu Nienda Twana Tuothe',
    372: 'Riria Jesu Agacoka Agere Managi',
    373: 'Twana O Twa Tene',
    374: 'Guthambio Kunene',
    375: 'Jesu Mutharaba Wakwa',
    376: 'Jesu Nindiihitite Nduike Waku',
    377: 'Mwathani Riu Ndigite Maundu',
    378: 'Ndi Waku Ngai Mugambo Waku',
    379: 'Ngai Niwe Mumbi Thi',
    380: 'Nimbatairio Niwe Mwathani Mutugi',
    381: 'Ni Muthenya Wa Munyaka',
    382: 'Riu Ndi Wa Jesu',
    383: 'Tondu Ndukanetigira',
    384: 'Wee Mundu Wa Mwathani',
    385: 'Hakuhi Na We Mwathani Jesu',
    386: 'Hakuhi Nawe Ngai',
    387: 'He Ngoro Ta Yaku',
    388: 'Ikurukia Roho Waku',
    389: 'Kindu Kiega No Thakame',
    390: 'Mauuru Makwa Mothe',
    391: 'Muhonokia Jesu Utuigue Riu',
    392: 'Ndirakuona Mwathi Wakwa Haha',
    393: 'Ngai Niatumire Muriu',
    394: 'Ngucagia Jesu Ngucia Muno',
    395: 'Thengererai Muuke Methaini',
    396: 'Utuku Uria Anyitagwo',
    397: 'Ikurukiria Wendo Kuuma Iguru',
    398: 'Ithe Witu Wa Wendo',
    399: 'Mucii Wi Na Wendani',
    400: 'Mutumia Uria Ngatha',
    401: 'Tene Tene Kiambiriria',
    402: 'Uhiki Wa Mbere Hau Kiambiriria',
    403: 'Wendo Waku Ngai Murungu',
    404: 'Njiguithagia Mugambo Waku',
    405: 'Kwi Na Ngondu Nyingi Muno',
    406: 'Mutihonokie Aria Mekuura',
    407: 'Ndeithia Ndwaranage Nawe',
    408: 'Ingiona Thina Wa Ungi',
    409: 'Kwi Na Murata Wa Twana',
    410: 'Magatuura O Na Jesu Kuo',
    411: 'Ndi Muohore Ndi Muohore',
    412: 'Niutigite Njira Njega Ya Mwathani',
    413: 'Thi Ino Ti Yakwa',
    414: 'Tukenagio Ni Guikarania Na Arata',
    415: 'Unyite Na Guoko',
    416: 'Gitina Gia Kanitha',
    417: 'Ihingo Ici Hingukai',
    418: 'Muthenya Umwe Ni Mwega Atia',
    419: 'Awa Riu Nindeheana Mwaka Uyu',
    420: 'Jesu Mukuuri Witu',
    421: 'Jesu Muthabibu',
    422: 'Jesu Muthabibu Na Ithui Twi Honge',
    423: 'Maithe Maitu Ma Tene',
    424: 'Nitucokerie Mwathani Ngatho',
    425: 'Irio Ni Nyumu',
    426: 'Mwathani Arogoocwo',
    427: 'Rucini Tuhande Mbeu Cia Wendani',
    428: 'Tucimbaga Migunda',
    429: 'Ukani Na Muhera',
    430: 'Muthenya Ni Wa U Utuku Ni Wa U',
    431: 'Mwathani Witu Turathime',
    432: 'Ngai Uria Wariukirie',
    433: 'Muhonokia Mwendwa Wakwa',
    434: 'Muthenya Waku Mwathani Niwathira',
    435: 'Mwathani Wakwa Unjikarie',
    436: 'Mwathani Witu Nitwakugooca',
    437: 'Riua Ni Rithuu',
    438: 'Riua Nirithuire',
    439: 'Turathime Riu Jesu',
    440: 'Ugooci Waku Ngai Wakwa',
    441: 'Gweterera Ndetereire Jehova',
    442: 'Ihoya Riakwa No Rimwe',
    443: 'Jehova Ndukanandekererie',
    444: 'Jesu Ningwendete Ninjui Wi Wakwa',
    445: 'Mahoya Hoyaga Hari Mwathani',
    446: 'Mokoini Ma Jesu Hakuhi Nake We',
    447: 'Mwathani Ndi Kiiga Giaku',
    448: 'Mwathani Wakwa Nii Ninjui',
    449: 'Ndukahituke Mwathani',
    450: 'Ngai Nowe Mutheru Mwathani Witu',
    451: 'Ningwenda Thayu Ngoroini Yakwa',
    452: 'Ni Uhoro Mwega Na Wa Gikeno',
    453: 'Thiiri Wakwa Wa Mehia',
    454: 'Uthiu Wa Jesu Ningawona',
    455: 'Ariu Na Ari A Ithe Witu',
    456: 'Ciana Cia Isiraeli Riria Ciari Misiri',
    457: 'Gitumi Kia Jesu Onithanio',
    458: 'Ihinda Ni Ikinyu Caitani Na Andu Ake',
    459: 'Isiraeli Nimaanemire',
    460: 'Jehova Mwathani Kuuma',
    461: 'Jehova Ngai Ni Akenagio',
    462: 'Jehova Ngai Nietire Musa',
    463: 'Jehova Nierire Nuhu',
    464: 'Jona Ni Atumirwo',
    465: 'Kuu Suriata Kwari Na Njamba',
    466: 'Kuuma O Kiambiriria',
    467: 'Matuini Iguru',
    468: 'Matuku Ma Kurigiriria',
    469: 'Matuku Maya Turi Ni Mooru',
    470: 'Menyaga Wega Ndi Guku Thi',
    471: 'Mundu Mwagani Na Muura Huhu',
    472: 'Muthamaki Belishazaru',
    473: 'Mwathani Niaaririe Na Iburahimu',
    474: 'Mwathani Wakwa Ni Ebeneza',
    475: 'Ndambararia Moko Makwa',
    476: 'Niaahutirie Icuri Cia Nguo',
    477: 'Ni Kwari Ngaragu Nene',
    478: 'Ninjakiiruo Mucii Uri Kirima Iguru',
    479: 'Nitwarahukei Ngoro Twihuge',
    480: 'Petero Na Johana Magithii Kuhoya',
    481: 'Riria Andu A Tene Maaremire',
    482: 'Riria Ngakinya Iguru',
    483: 'Unjarahure Mwathani Unjarahure',
    484: 'Anginjita Ningwitika',
    485: 'Araika Maraina Atia',
    486: 'Haleluya Ndi Waku',
    487: 'Jesu Mwene Kuhorera',
    488: 'Kahii Gaka Unjire',
    489: 'Kumia Jesu Twana Tutu Tuothe',
    490: 'Mariamu E Na Mwana Iini',
    491: 'Ndi Na Muteithia Uria Undeithagia',
    492: 'Ndwara Kwi Jesu Ndwara Kwi Jesu',
    493: 'Niekite Magegania',
    494: 'Ni Kiroko Tene',
    495: 'Ningagutua Mutegi Andu',
    496: 'Ningutengera Thii Hari Jesu',
    497: 'Rorai Tawa Uyu Wakwa',
    498: 'Thiini Wa Thakame Ya Gaturume',
    499: 'Ukai Tukene Kwi Mwathani',
    500: 'Aca Ndangindiga Thii Nyoike',
    501: 'Aka Iguru Ria Ihiga',
    502: 'Baba Ni Muthamaki',
    503: 'Cuthiriria Jesu',
    504: 'E Muoyo E Muoyo Kristu Jesu',
    505: 'E Muoyo Jesu E Muoyo',
    506: 'Gikeno Thiini Wa Ngoro Yakwa',
    507: 'Gucera Na Jesu',
    508: 'Gutereta Na Jesu Ni Kwega Muno',
    509: 'Gutiri Riitwa Ringi',
    510: 'Gwi Gikeno Giitikaga',
    511: 'Haleluya Tuthii Mbere',
    512: 'Hingo Ciothe Twakaga',
    513: 'Hoyaga Rucini',
    514: 'Hutia Icuri Cia Nguo Yake',
    515: 'Hutia Ringi',
    516: 'I Kai Jesu Anyendete Atia',
    517: 'Ihoru Ndiri O Na Hanini',
    518: 'Indo Ciothe Njega',
    519: 'Ingithii Kwi Jesu',
    520: 'Ira Umuthi O Na Ruciu',
    521: 'Jesu Ari Na Mai',
    522: 'Jesu Eraniire Tuuke Hari We',
    523: 'Jesu Jesu Jesu',
    524: 'Jesu Jesu Ningwendete',
    525: 'Jesu Ndokire Gucirithania',
    526: 'Jesu Ni Mwathani',
    527: 'Jesu Nianyitaga',
    528: 'Jesu Niendaga Nduike',
    529: 'Jesu Niendaga Tuthere Kuria',
    530: 'Jesu Niwe Munyendi',
    531: 'Kuuma Hindi Iria Jesu',
    532: 'Kwarama Ta Weru',
    533: 'Kwihoka Jesu Mbaaraini',
    534: 'Maitho Ni Ma Kuona Ngai',
    535: 'Mathai Na Nimukuona',
    536: 'Menyaga Uria Njitikitie',
    537: 'Murata Mwega Ni Jesu',
    538: 'Muthamaki Niagoka',
    539: 'Mutikaneke Uuru',
    540: 'Mwihoke Jesu',
    541: 'Ndekera Mwathani',
    542: 'Ndi Na Muteithia Uria Undeithagia 2',
    543: 'Ndi Njiraini Ya Kuinuka',
    544: 'Ndi O Kamugendi',
    545: 'Ndiaga Mugate Wa Muoyo',
    546: 'Ndingithengio Hari Ihiga',
    547: 'Nduraga Kundu Kwega',
    548: 'Ngai Ni Mwega',
    549: 'Ngoro Yakwa Heete Jesu',
    550: 'Ngoro Yakwa Ni Njanjamuku',
    551: 'Ngoroini Yakwa He Nyumba',
    552: 'Nguhikira Nguhikira Jesu',
    553: 'Nguigua Uhoro Wa Jesu',
    554: 'Ni Aca Aca',
    555: 'Ni Ka Na Ku Gakenge',
    556: 'Ni Muruthi Wa Juda Utuhotithagia',
    557: 'Ni Wakwa Wakwa Ki',
    558: 'Nianyendaga Nikio Anguiriire',
    559: 'Nii Ndi Njata Nini',
    560: 'Nimbatairio Niwe',
    561: 'Ningugutongoria Ningugutongoria',
    562: 'Ningukena Na Ngoro Yakwa',
    563: 'Ningwitikia Ningwitikia',
    564: 'Ninjui Ruui Rwa Kunina Wihia',
    565: 'Nitugathe Ngai Witu',
    566: 'Ninyendaga Mwathani Muno',
    567: 'No Jesu Ungihota',
    568: 'No Uciaruo Ringi',
    569: 'Nyonaga Thi Ta Iri Thaka',
    570: 'Riria Ngathii Iguru',
    571: 'Riu Riu Njoya',
    572: 'Roho Mutheru Umuhe Handu',
    573: 'Roho Wa Ngai Wa Muoyo',
    574: 'Tara Irathimo Kimwe Gwa Kimwe',
    575: 'Thayu Jesu Aheete',
    576: 'Thayu Mwega Muno',
    577: 'Tonya Jesu Thiini Ngoro Yakwa',
    578: 'Tuhii Twa Jesu Twina Gikeno',
    579: 'Tukinyukie Turumaniriire',
    580: 'Twakugooca Mwathani Jesu',
    581: 'Twana Ni Ta Tugondu',
    582: 'Twarehe Manja Twarehe Manja',
    583: 'Twoka Tukente Na Iheo Ciitu',
    584: 'Uka Jesu Ngoroini',
    585: 'Uka Tuthii Nawe Kwi Jesu',
    586: 'Ukani Muone Jesu Ni Mwega',
    587: 'Utwaranage Na Mwathi Jesu',
    588: 'Wendani Wa Jesu Uria Wanguiriire',
    589: 'Wihugurire Jesu',
    590: 'Wira Wa Jesu Ni Muhuthu Ma',
    591: 'Gathai Ngai Andu Aya',
    592: 'Ithe Muriu Na Roho',
    593: 'Ithe Witu Wa Iguru',
    594: 'Ithe Witu Wi Iguru',
    595: 'Jesu Jesu Mwendwa Wakwa',
    596: 'Kugoocwo Kurogia Kwi Ngai',
    597: 'Mutheru Mutheru Mutheru',
    598: 'Mwathani Ngai Wa Thayu',
    599: 'Ngai Arokurathima',
    600: 'Ngai Ni Wa Kugoocwo',
    601: 'Thayu Thayu Wa Mwene Thayu',
    602: 'Tuohanie We Jesu',
    603: 'Urorathimagwo Ni Ngai',
    604: 'Anirirai Jehova Na Gikeno',
    605: 'Inyui Mawira Mothe Ma Ngai',
    606: 'Mwathani Ngai Wa Isiraeli',
    607: 'Ngoro Yakwa Niirakumia Mwathani',
    608: 'Nitugukugooca Ngai',
    609: 'Riu Mwathani Ni Hindi Ukunjugira',
    610: 'Ukani Tukunguiye Jehova Tukenete'
  };
  if (hymnNames.containsKey(hymnNumber)) {
    return hymnNames[hymnNumber];
  } else {
    return 'Unknown Hymn Name';
  }
}
