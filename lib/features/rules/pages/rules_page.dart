import 'package:flutter/material.dart';
import 'package:spa_app/features/rules/widgets/rule_container.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/styles.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  RulesPageState createState() => RulesPageState();
}

class RulesPageState extends State<RulesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultBodyWidget(
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Regels',
                style: Styles.pageTitle,
              ),
              RuleContainerWidget('RESPECT', '''
Op dit kamp hebben we respect voor elkaar, hoe verschillend we allemaal ook zijn. Praktisch houdt dat in dat jij iedereen als waardevol beschouwt en dat iedereen de moeite waard is om te leren kennen. In repetities, workshops en andere activiteiten heeft iedereen zijn eigen mening (of is die aan het vormen) en we horen liever een eerlijk dan het correcte antwoord. Verder hebben we respect voor de natuur, de medewerkers van Belmont en de leiders van SPA. We houden samen met elkaar de gebouwen en het kampterrein schoon van zwerfvuil en houden geen watergevechten in de gebouwen.
Bezit en gebruik van alcohol, tabak, drugs en energiedrank is de hele week binnen en buiten het kampterrein niet toegestaan.'''),
              RuleContainerWidget('EENHEID', '''
We vormen met elkaar één groep. Niemand valt buiten de boot. De boot is groot genoeg. We pesten elkaar niet. We durven nieuwe mensen te leren kennen. We durven andere mensen ons te laten leren kennen. Iedereen groot of klein, dik of dun, stoer of verlegen; iedereen is even waardevol in Gods ogen en God houdt van iedereen net zoveel. We doen met elkaar ons uiterste best om te zorgen dat niets dit in de weg staat.
We doen niets wat onszelf of de ander in gevaar brengt.
Iedere deelnemer dient bij elk georganiseerd programmaonderdeel aanwezig te zijn. De enige uitzondering is als je van de leiding hiervoor toestemming hebt gekregen.
Mobiele telefoons, game-consoles, laptops, tablets en dergelijke worden tijdens activiteiten niet gebruikt uit respect voor elkaar, voor gasten en de leiders van de verschillende activiteiten.'''),
              RuleContainerWidget('VEILIGHEID', '''
Een veilige omgeving op kamp is belangrijk. We bedoelen twee vormen van veiligheid. Ten eerste het veilig omgaan met jezelf, elkaar, materialen en gebouwen. Daarnaast de veiligheid die er voor zorgt dat je kunt zijn wie je bent en je op je gemak kunt voelen tijdens het kamp.
Het op eigen initiatief verlaten van het kampterrein is niet toegestaan! Verder volg je in geval van brand of een andere calamiteit de instructies van de leiding op.
Medicijnen die je nodig hebt worden aan het begin van de week door de leiding verzameld en tijdens de week aan jou verstrekt.
Het je bevinden in het slaapgebouw of badruimte van de andere sekse is niet toegestaan. Verder ben je overdag niet onnodig in je tent of je slaapzaal en ben je daar ’s nachts juist wèl.
Slaap is belangrijk voor je veiligheid en je gezondheid. Daarom is het tussen 24:00 uur en 7:00 uur stil op het terrein. In de tentenkampen is het vanaf 23:00 uur stil.
'''),
              RuleContainerWidget('VERTROUWEN', '''
Het kamp bestaat uit een hoop lol en plezier. Toch kan het zijn dat je wat op je hart hebt en daar graag met iemand over wilt praten. De leiding op dit kamp is hier speciaal voor jou. Dat kan de leiding van jouw groepje zijn, maar ook elke andere leiding. We willen graag naar je luisteren, met je praten of (als je wilt) met je bidden.
Als je ergens mee zit, bespreek dit dan met je groepsleiding of met de hoofdleiding van het kamp.'''),
              Container(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
