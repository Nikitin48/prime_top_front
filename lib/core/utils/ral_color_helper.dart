import 'package:flutter/material.dart';

class RalColorHelper {
  static Map<int, Color>? _ralColorMapCache;

  static Map<int, Color> get _ralColorMap {
    _ralColorMapCache ??= _buildRalColorMap();
    return _ralColorMapCache!;
  }

  static Color getRalColor(int ralCode) {
    final colorMap = _ralColorMap[ralCode];
    if (colorMap != null) {
      return colorMap;
    }
    return _generateApproximateColor(ralCode);
  }

  static Color _generateApproximateColor(int ralCode) {
    final code = ralCode.toString().padLeft(4, '0');
    if (code.length < 4) {
      return Colors.grey;
    }

    final firstDigit = int.tryParse(code[0]) ?? 0;
    final remaining = int.tryParse(code.substring(1)) ?? 0;

    int r, g, b;

    switch (firstDigit) {
      case 1:
        r = 200 + (remaining % 55);
        g = 180 + (remaining % 40);
        b = 100 + (remaining % 60);
        break;
      case 2:
        r = 255 - (remaining % 100);
        g = 200 + (remaining % 55);
        b = 0 + (remaining % 100);
        break;
      case 3:
        r = 0 + (remaining % 100);
        g = 200 + (remaining % 55);
        b = 0 + (remaining % 100);
        break;
      case 4:
        r = 0 + (remaining % 100);
        g = 150 + (remaining % 105);
        b = 200 + (remaining % 55);
        break;
      case 5:
        r = 100 + (remaining % 100);
        g = 100 + (remaining % 100);
        b = 200 + (remaining % 55);
        break;
      case 6:
        r = 200 + (remaining % 55);
        g = 100 + (remaining % 100);
        b = 200 + (remaining % 55);
        break;
      case 7:
        r = 100 + (remaining % 100);
        g = 100 + (remaining % 100);
        b = 100 + (remaining % 100);
        break;
      case 8:
        r = 150 + (remaining % 105);
        g = 150 + (remaining % 105);
        b = 150 + (remaining % 105);
        break;
      case 9:
        r = 50 + (remaining % 100);
        g = 50 + (remaining % 100);
        b = 50 + (remaining % 100);
        break;
      default:
        r = 128;
        g = 128;
        b = 128;
    }

    return Color.fromRGBO(
      r.clamp(0, 255),
      g.clamp(0, 255),
      b.clamp(0, 255),
      1.0,
    );
  }

  static Map<int, Color> _buildRalColorMap() {
    return {
    1000: const Color(0xFFCDBA88),
    1001: const Color(0xFFD0B084),
    1002: const Color(0xFFD2AA6D),
    1003: const Color(0xFFF7BA0B),
    1004: const Color(0xFFE2B007),
    1005: const Color(0xFFC89F04),
    1006: const Color(0xFFE1A100),
    1007: const Color(0xFFDD9900),
    1011: const Color(0xFFE08E00),
    1012: const Color(0xFFE27C00),
    1013: const Color(0xFFF3E2A9),
    1014: const Color(0xFFDDD48F),
    1015: const Color(0xFFE6D2B5),
    1016: const Color(0xFFE1CC4F),
    1017: const Color(0xFFDDD48F),
    1018: const Color(0xFFE3D9A6),
    1019: const Color(0xFFE6D2B5),
    1020: const Color(0xFFD1BC8A),
    1021: const Color(0xFFD2B773),
    1023: const Color(0xFFF7BA0B),
    1024: const Color(0xFFE2B007),
    1026: const Color(0xFFFFF700),
    1027: const Color(0xFFFFD700),
    1028: const Color(0xFFFFB400),
    1032: const Color(0xFFF7BA0B),
    1033: const Color(0xFFFAD201),
    1034: const Color(0xFFFFA420),
    1035: const Color(0xFF9D9101),
    1036: const Color(0xFF9C8020),
    1037: const Color(0xFF8C7000),
    2000: const Color(0xFFDD7907),
    2001: const Color(0xFFBE4E20),
    2002: const Color(0xFFC63927),
    2003: const Color(0xFFFA842B),
    2004: const Color(0xFFE75B12),
    2005: const Color(0xFFFF6B00),
    2007: const Color(0xFFFFA500),
    2008: const Color(0xFFF44600),
    2009: const Color(0xFFFFB200),
    2010: const Color(0xFFEC7C26),
    2011: const Color(0xFFE55137),
    2012: const Color(0xFFD2691E),
    2013: const Color(0xFFE55137),
    3000: const Color(0xFFA72920),
    3001: const Color(0xFF9B2423),
    3002: const Color(0xFF9B2423),
    3003: const Color(0xFF8D1D2C),
    3004: const Color(0xFF701F28),
    3005: const Color(0xFF5E2028),
    3007: const Color(0xFF402225),
    3009: const Color(0xFF703731),
    3011: const Color(0xFF7E292C),
    3012: const Color(0xFFCB8D73),
    3013: const Color(0xFF9C3226),
    3014: const Color(0xFFD47479),
    3015: const Color(0xFFE1A6AD),
    3016: const Color(0xFFAC4034),
    3017: const Color(0xFFD3545F),
    3018: const Color(0xFFD3545F),
    3019: const Color(0xFFD3545F),
    3020: const Color(0xFFC51F3D),
    3022: const Color(0xFFD2386C),
    3024: const Color(0xFFD2386C),
    3026: const Color(0xFFD2386C),
    3027: const Color(0xFFB42041),
    3028: const Color(0xFFB42041),
    3031: const Color(0xFF721422),
    3032: const Color(0xFFB42041),
    3033: const Color(0xFFB42041),
    4001: const Color(0xFF816183),
    4002: const Color(0xFF8D3C4B),
    4003: const Color(0xFFC4618C),
    4004: const Color(0xFF651E38),
    4005: const Color(0xFF76689A),
    4006: const Color(0xFF9063A2),
    4007: const Color(0xFF533D5B),
    4008: const Color(0xFF8D3C4B),
    4009: const Color(0xFFB3446C),
    4010: const Color(0xFF6C4675),
    4011: const Color(0xFF6C4675),
    4012: const Color(0xFF6C4675),
    5000: const Color(0xFF354D73),
    5001: const Color(0xFF1F3438),
    5002: const Color(0xFF00387B),
    5003: const Color(0xFF1F3855),
    5004: const Color(0xFF191E28),
    5005: const Color(0xFF005387),
    5007: const Color(0xFF376B8C),
    5008: const Color(0xFF2B3A44),
    5009: const Color(0xFF1D252D),
    5010: const Color(0xFF004F7C),
    5011: const Color(0xFF1A252D),
    5012: const Color(0xFF003D82),
    5013: const Color(0xFF1F3855),
    5014: const Color(0xFF4C6B88),
    5015: const Color(0xFF2563AA),
    5017: const Color(0xFF005387),
    5018: const Color(0xFF007CB0),
    5019: const Color(0xFF005E83),
    5020: const Color(0xFF00414F),
    5021: const Color(0xFF007577),
    5022: const Color(0xFF1D252D),
    5023: const Color(0xFF005E83),
    5024: const Color(0xFF004F7C),
    5025: const Color(0xFF2563AA),
    5026: const Color(0xFF003D82),
    6000: const Color(0xFF316650),
    6001: const Color(0xFF287233),
    6002: const Color(0xFF2D572C),
    6003: const Color(0xFF424632),
    6004: const Color(0xFF1F3A3D),
    6005: const Color(0xFF2F4538),
    6006: const Color(0xFF3E3B32),
    6007: const Color(0xFF343B29),
    6008: const Color(0xFF39352A),
    6009: const Color(0xFF31372B),
    6010: const Color(0xFF35682D),
    6011: const Color(0xFF587246),
    6012: const Color(0xFF343E40),
    6013: const Color(0xFF6C7156),
    6014: const Color(0xFF47402E),
    6015: const Color(0xFF3B3C36),
    6016: const Color(0xFF1E5945),
    6017: const Color(0xFF4C9141),
    6018: const Color(0xFF57A639),
    6019: const Color(0xFFBDECB6),
    6020: const Color(0xFF2E3A23),
    6021: const Color(0xFF89AC76),
    6022: const Color(0xFF25221B),
    6024: const Color(0xFF308446),
    6025: const Color(0xFF3D642D),
    6026: const Color(0xFF015D52),
    6027: const Color(0xFF84C3BE),
    6028: const Color(0xFF2C5545),
    6029: const Color(0xFF20603D),
    6032: const Color(0xFF1F4C3A),
    6033: const Color(0xFF7FB5B1),
    6034: const Color(0xFF1B5583),
    6035: const Color(0xFF193737),
    6036: const Color(0xFF0F5132),
    6037: const Color(0xFF00FF00),
    6038: const Color(0xFF278142),
    7000: const Color(0xFF78858B),
    7001: const Color(0xFF8A9597),
    7002: const Color(0xFF7E7B52),
    7003: const Color(0xFF6C7059),
    7004: const Color(0xFF969992),
    7005: const Color(0xFF646B63),
    7006: const Color(0xFF6D6552),
    7008: const Color(0xFF6A5F31),
    7009: const Color(0xFF6C7059),
    7010: const Color(0xFF5B6259),
    7011: const Color(0xFF52595D),
    7012: const Color(0xFF575D57),
    7013: const Color(0xFF575D57),
    7015: const Color(0xFF4F5358),
    7016: const Color(0xFF383E42),
    7021: const Color(0xFF2F353B),
    7022: const Color(0xFF2F3439),
    7023: const Color(0xFF474B4E),
    7024: const Color(0xFF5B6970),
    7026: const Color(0xFF2F3439),
    7030: const Color(0xFF939388),
    7031: const Color(0xFF5D6970),
    7032: const Color(0xFFB8B799),
    7033: const Color(0xFF818479),
    7034: const Color(0xFF939176),
    7035: const Color(0xFFCBD0CC),
    7036: const Color(0xFF9A9697),
    7037: const Color(0xFF7C7F7E),
    7038: const Color(0xFFB4B8B0),
    7039: const Color(0xFF6B695F),
    7040: const Color(0xFF9DA3A6),
    7042: const Color(0xFF8F8F8C),
    7043: const Color(0xFF4E5451),
    7044: const Color(0xFFBDBDBD),
    7045: const Color(0xFF91969A),
    7046: const Color(0xFF82898E),
    7047: const Color(0xFFCFD0CF),
    7048: const Color(0xFF888175),
    8000: const Color(0xFF826C34),
    8001: const Color(0xFF955F20),
    8002: const Color(0xFF6C3B2A),
    8003: const Color(0xFF734222),
    8004: const Color(0xFF8E402A),
    8007: const Color(0xFF59351F),
    8008: const Color(0xFF6F4F28),
    8011: const Color(0xFF5B3A29),
    8012: const Color(0xFF592321),
    8014: const Color(0xFF382C1E),
    8015: const Color(0xFF633A34),
    8016: const Color(0xFF4C2F27),
    8017: const Color(0xFF5F2F23),
    8019: const Color(0xFF4C2F27),
    8022: const Color(0xFF1C1C1C),
    8023: const Color(0xFFA65E2E),
    8024: const Color(0xFF79553D),
    8025: const Color(0xFF755C48),
    8028: const Color(0xFF4E3B31),
    8029: const Color(0xFF763C28),
    9001: const Color(0xFFFDF4E3),
    9002: const Color(0xFFE7EBDA),
    9003: const Color(0xFFF4F4F4),
    9004: const Color(0xFF282828),
    9005: const Color(0xFF0A0A0A),
    9006: const Color(0xFFA5A5A5),
    9007: const Color(0xFF8F8F8C),
    9010: const Color(0xFFFFFFFF),
    9011: const Color(0xFF1C1C1C),
    9012: const Color(0xFFFDF4E3),
    9016: const Color(0xFFF4F4F4),
    9017: const Color(0xFF282828),
    9018: const Color(0xFFCFD0CF),
    9022: const Color(0xFF9C9C9C),
    9023: const Color(0xFF7C7F7E),
    };
  }
}
