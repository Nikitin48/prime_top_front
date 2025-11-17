class Analyses {
  const Analyses({
    this.bleskPri60Grad,
    this.uslovnayaVyazkost,
    this.deltaE,
    this.deltaL,
    this.deltaA,
    this.deltaB,
    this.colorDiffDeltaeD8,
    this.vremyaSushki,
    this.pikovayaTemperatura,
    this.tolschinaDlyaGrunta,
    this.adgeziya,
    this.stoikostKRastvor,
    this.kolvoVykrSPartii,
    this.unnamed16,
    this.stepenPeretira,
    this.tverdVeschesPoV,
    this.tolschPlenkiZhidk,
    this.tolschDlyEmLakCh,
    this.teoreticheskiiRashod,
    this.prochnostPriIzgibe,
    this.stoikostKObratUdaru,
    this.prochnRastyazhPoEr,
    this.blesk,
    this.plotnost,
    this.massDolyaNeletVesh,
    this.vizKontrolPoverh,
    this.vneshniiVid,
    this.grunt,
    this.tverdostPoKarandashu,
  });

  final double? bleskPri60Grad;
  final double? uslovnayaVyazkost;
  final double? deltaE;
  final double? deltaL;
  final double? deltaA;
  final double? deltaB;
  final double? colorDiffDeltaeD8;
  final double? vremyaSushki;
  final double? pikovayaTemperatura;
  final double? tolschinaDlyaGrunta;
  final double? adgeziya;
  final double? stoikostKRastvor;
  final double? kolvoVykrSPartii;
  final double? unnamed16;
  final double? stepenPeretira;
  final double? tverdVeschesPoV;
  final double? tolschPlenkiZhidk;
  final double? tolschDlyEmLakCh;
  final double? teoreticheskiiRashod;
  final double? prochnostPriIzgibe;
  final double? stoikostKObratUdaru;
  final double? prochnRastyazhPoEr;
  final double? blesk;
  final double? plotnost;
  final double? massDolyaNeletVesh;
  final String? vizKontrolPoverh;
  final String? vneshniiVid;
  final String? grunt;
  final String? tverdostPoKarandashu;

  /// Получить все поля как Map для отображения
  Map<String, dynamic> getFields() {
    final fields = <String, dynamic>{};
    
    if (bleskPri60Grad != null) {
      fields['Блеск при 60°'] = bleskPri60Grad;
    }
    if (uslovnayaVyazkost != null) {
      fields['Условная вязкость'] = uslovnayaVyazkost;
    }
    if (deltaE != null) {
      fields['Дельта E'] = deltaE;
    }
    if (deltaL != null) {
      fields['Дельта L'] = deltaL;
    }
    if (deltaA != null) {
      fields['Дельта A'] = deltaA;
    }
    if (deltaB != null) {
      fields['Дельта B'] = deltaB;
    }
    if (colorDiffDeltaeD8 != null) {
      fields['Цветовое различие Delta E D8'] = colorDiffDeltaeD8;
    }
    if (vremyaSushki != null) {
      fields['Время сушки'] = vremyaSushki;
    }
    if (pikovayaTemperatura != null) {
      fields['Пиковая температура'] = pikovayaTemperatura;
    }
    if (tolschinaDlyaGrunta != null) {
      fields['Толщина для грунта'] = tolschinaDlyaGrunta;
    }
    if (adgeziya != null) {
      fields['Адгезия'] = adgeziya;
    }
    if (stoikostKRastvor != null) {
      fields['Стойкость к раствору'] = stoikostKRastvor;
    }
    if (kolvoVykrSPartii != null) {
      fields['Количество выкрасок с партии'] = kolvoVykrSPartii;
    }
    if (unnamed16 != null) {
      fields['Неименованное поле 16'] = unnamed16;
    }
    if (stepenPeretira != null) {
      fields['Степень перетира'] = stepenPeretira;
    }
    if (tverdVeschesPoV != null) {
      fields['Твердые вещества по весу'] = tverdVeschesPoV;
    }
    if (tolschPlenkiZhidk != null) {
      fields['Толщина пленки жидкой'] = tolschPlenkiZhidk;
    }
    if (tolschDlyEmLakCh != null) {
      fields['Толщина для эмали/лака'] = tolschDlyEmLakCh;
    }
    if (teoreticheskiiRashod != null) {
      fields['Теоретический расход'] = teoreticheskiiRashod;
    }
    if (prochnostPriIzgibe != null) {
      fields['Прочность при изгибе'] = prochnostPriIzgibe;
    }
    if (stoikostKObratUdaru != null) {
      fields['Стойкость к обратному удару'] = stoikostKObratUdaru;
    }
    if (prochnRastyazhPoEr != null) {
      fields['Прочность растяжения'] = prochnRastyazhPoEr;
    }
    if (blesk != null) {
      fields['Блеск'] = blesk;
    }
    if (plotnost != null) {
      fields['Плотность'] = plotnost;
    }
    if (massDolyaNeletVesh != null) {
      fields['Массовая доля нелетучих веществ'] = massDolyaNeletVesh;
    }
    if (vizKontrolPoverh != null) {
      fields['Визуальный контроль поверхности'] = vizKontrolPoverh;
    }
    if (vneshniiVid != null) {
      fields['Внешний вид'] = vneshniiVid;
    }
    if (grunt != null) {
      fields['Грунт'] = grunt;
    }
    if (tverdostPoKarandashu != null) {
      fields['Твердость по карандашу'] = tverdostPoKarandashu;
    }
    
    return fields;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Analyses &&
          runtimeType == other.runtimeType &&
          bleskPri60Grad == other.bleskPri60Grad &&
          uslovnayaVyazkost == other.uslovnayaVyazkost &&
          deltaE == other.deltaE &&
          deltaL == other.deltaL &&
          deltaA == other.deltaA &&
          deltaB == other.deltaB &&
          colorDiffDeltaeD8 == other.colorDiffDeltaeD8 &&
          vremyaSushki == other.vremyaSushki &&
          pikovayaTemperatura == other.pikovayaTemperatura &&
          tolschinaDlyaGrunta == other.tolschinaDlyaGrunta &&
          adgeziya == other.adgeziya &&
          stoikostKRastvor == other.stoikostKRastvor &&
          kolvoVykrSPartii == other.kolvoVykrSPartii &&
          unnamed16 == other.unnamed16 &&
          stepenPeretira == other.stepenPeretira &&
          tverdVeschesPoV == other.tverdVeschesPoV &&
          tolschPlenkiZhidk == other.tolschPlenkiZhidk &&
          tolschDlyEmLakCh == other.tolschDlyEmLakCh &&
          teoreticheskiiRashod == other.teoreticheskiiRashod &&
          prochnostPriIzgibe == other.prochnostPriIzgibe &&
          stoikostKObratUdaru == other.stoikostKObratUdaru &&
          prochnRastyazhPoEr == other.prochnRastyazhPoEr &&
          blesk == other.blesk &&
          plotnost == other.plotnost &&
          massDolyaNeletVesh == other.massDolyaNeletVesh &&
          vizKontrolPoverh == other.vizKontrolPoverh &&
          vneshniiVid == other.vneshniiVid &&
          grunt == other.grunt &&
          tverdostPoKarandashu == other.tverdostPoKarandashu;

  @override
  int get hashCode =>
      bleskPri60Grad.hashCode ^
      uslovnayaVyazkost.hashCode ^
      deltaE.hashCode ^
      deltaL.hashCode ^
      deltaA.hashCode ^
      deltaB.hashCode ^
      colorDiffDeltaeD8.hashCode ^
      vremyaSushki.hashCode ^
      pikovayaTemperatura.hashCode ^
      tolschinaDlyaGrunta.hashCode ^
      adgeziya.hashCode ^
      stoikostKRastvor.hashCode ^
      kolvoVykrSPartii.hashCode ^
      unnamed16.hashCode ^
      stepenPeretira.hashCode ^
      tverdVeschesPoV.hashCode ^
      tolschPlenkiZhidk.hashCode ^
      tolschDlyEmLakCh.hashCode ^
      teoreticheskiiRashod.hashCode ^
      prochnostPriIzgibe.hashCode ^
      stoikostKObratUdaru.hashCode ^
      prochnRastyazhPoEr.hashCode ^
      blesk.hashCode ^
      plotnost.hashCode ^
      massDolyaNeletVesh.hashCode ^
      vizKontrolPoverh.hashCode ^
      vneshniiVid.hashCode ^
      grunt.hashCode ^
      tverdostPoKarandashu.hashCode;
}

