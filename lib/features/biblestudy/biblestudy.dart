import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/features/biblestudy/widgets/necessities_tag.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class BibleStudyPage extends StatefulWidget {
  const BibleStudyPage({super.key});

  @override
  BibleStudyPageState createState() => BibleStudyPageState();
}

class BibleStudyPageState extends State<BibleStudyPage> {
  late Future<QuerySnapshot<Map<String, dynamic>>> biblestudyFuture;

  @override
  void initState() {
    super.initState();
    biblestudyFuture =
        FirebaseFirestore.instance.collection('biblestudy').get();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      'Bijbelstudie',
      SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LOOK UP!',
                    style: Theme.of(context).textTheme.headlineLarge,),
                const SizedBox(height: 4),
                _buildBenodigdheden(),
                const SizedBox(height: 16),
                _drawLine(),
                const SizedBox(height: 16),
                _buildIntroduction(),
                const SizedBox(height: 16),
                _buildIcebreaker(),
                const SizedBox(height: 16),
                _drawLine(),
                const SizedBox(height: 16),
                _buildReading(),
                const SizedBox(height: 16),
                _buidQuestions(),
                const SizedBox(height: 16),
                _drawLine(),
                const SizedBox(height: 16),
                _buildActivity(),
                const SizedBox(height: 16),
                _drawLine(),
                const SizedBox(height: 16),
                _buildPrayer(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      back: true,
    );
  }

  Widget _drawLine() {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      color: Theme.of(context).dividerColor.withAlpha(200),
    );
  }

  Widget _buildBenodigdheden() {
    return const Column(
      children: [
        // Text(
        //   'Benodigdheden',
        //   style: Theme.of(context).textTheme.bodyLarge!,//.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        // ),
        // const SizedBox(height: 8),
        Row(
          children: [
            NecessitiesTag(text: 'Belofte kaartjes (13+)'),
            NecessitiesTag(text: 'Potjes (13-)'),
            NecessitiesTag(text: 'Bijbelversen (13-)'),
          ],
        ),
      ],
    );
  }

  Widget _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Introductie',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Vandaag gaan we nadenken over het thema "Look Up" – omhoog kijken naar God, vooral wanneer het moeilijk is. Vorig jaar leerden we over "Grow" – groeien in ons geloof. Hoe meer we groeien, hoe meer we beseffen dat we God altijd nodig hebben. In de Bijbeltekst die we vandaag gaan lezen zegt God: “Wees niet bang, want Ik ben bij je” (Jesaja 43:5). God belooft ons altijd te helpen, zelfs in moeilijke tijden. Hoe mooi dat we altijd mogen weten dat er iemand is die het beste met ons voor heeft en ons tegen het kwade wil beschermen? In Jesaja 43:4 zegt Hij: “Je bent kostbaar in mijn ogen, ik houd van jou”. Dus, als je je onzeker voelt, kijk omhoog naar God en vertrouw op Zijn belofte dat Hij altijd bij je is.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildIcebreaker() {
    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Icebreaker',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Text(
              '· Ga in een cirkel staan. Zometeen zegt één van jullie de woorden "Kijk omhoog", dan moet iedereen omhoog kijken, wanneer de leider de woorden "Kijk omlaag" zegt, kijkt iedereen naar beneden.',
            ),
            const SizedBox(height: 8),
            const Text(
                '· Als de leider "Kijk naar elkaar" zegt, moeten iedereen naar iemand anders in de cirkel kijken. Als twee mensen elkaar in de ogen kijken, vallen jullie beide uit het spel.',),
            const SizedBox(height: 8),
            const Text('· Ga door totdat er een paar winnaars overblijven.'),
            const SizedBox(height: 8),
            Text(
              'Soms zijn we gefocust op anderen of op onszelf, maar vandaag gaan we het hebben hoe waardevol het is om naar God te kijken – "Look Up".',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bijbel & Vragen',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Lees de volgende Bijbelgedeelten samen en beantwoord de vragen die erbij staan.',
        ),
        const SizedBox(height: 16),
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jesaja 43:1-7',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'De Heer zegt tegen zijn volk: ‘Israël, wees niet bang, ik zal je bevrijden. Want ik heb je gemaakt, ik heb je het leven gegeven. Ik heb jou je naam gegeven, jij bent van mij!\nAls je door water heen moet, zal ik bij je zijn. Als je rivieren oversteekt, zul je niet verdrinken. Als je door vuur loopt, zul je niet verbranden. De vlammen zullen je geen pijn doen. Want ik, de Heer, ben jouw God. Ik ben de heilige God van Israël, en ik zal je bevrijden.\nIsraël, jij bent heel belangrijk voor mij, je bent heel veel waard. Ik houd zo veel van je! Voor jou gaf ik Egypte, Nubië en Seba weg. Voor jou geef ik alles weg, alle mensen en alle volken van de wereld. Wees niet bang, want ik zal bij je zijn. Ik haal je nakomelingen terug uit het oosten en uit het westen. Tegen het noorden zeg ik: ‘Geef mijn volk terug.’ Tegen het zuiden zeg ik: ‘Laat mijn volk gaan!’ Tegen alle verre landen zeg ik: ‘Breng mijn volk weer terug. Breng de Israëlieten allemaal terug. Ze zijn naar mij genoemd. Ik heb hen gemaakt ter ere van mijzelf, ik heb hun het leven gegeven.’’',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        // const SizedBox(height: 16),
        //   const Text(
        //     'Jezus vertelde de gelijkenis van het mosterdzaadje om te illustreren hoe het Koninkrijk van God kan groeien. Het kleine verhaal laat ons zien dat iets wat lijkt op een onbenullig beginpunt, kan leiden tot iets heel groots. Net als het mosterdzaadje kunnen ons geloof, onze daden en kleinste bijdragen het potentieel hebben om een ​​aanzienlijke invloed en verandering in deze wereld teweeg te brengen.',
        //   ),
        //   const SizedBox(height: 16),
        //   Card(
        //     child: Container(
        //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             'Kolossenzen 2:7',
        //             style: Theme.of(context)
        //                 .textTheme
        //                 .bodyLarge!
        //                 .copyWith(fontWeight: FontWeight.bold),
        //           ),
        //           const Text(
        //             '7. Net zoals een boom met zijn wortels stevig in de grond staat, zo moeten jullie stevig in Hem geworteld staan. Dan zullen jullie in Hem opgebouwd worden. En jullie zullen stevig blijven staan in het geloof dat we jullie geleerd hebben. Wees ook dankbaar.',
        //           ),
        //           const SizedBox(height: 8),
        //         ],
        //       ),
        //     ),
        //   ),
        //   const SizedBox(height: 16),
        //   const Text(
        //     'Net zoals een boom sterke wortels nodig heeft om hoog te groeien en vruchten te dragen, hebben wij ook behoefte aan verankering. Gods liefde en waarheid zijn onze voeding om te bloeien in elk aspect van ons leven. Door het liefdevolle werk van God in ons te omarmen, door zijn Heilige Geest, zullen we uitgroeien tot een leven van vervulling en met een doel. En het uiteindelijke resultaat? Een leven vol dankbaarheid!',
        //   ),
      ],
    );
  }

  Widget _buidQuestions() {
    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vragen 13-',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. God zegt in Jesaja 43:1 dat Hij je bij je naam roept en dat je van Hem bent. Hoe voelt het om te weten dat je speciaal en belangrijk voor iemand anders bent?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '2. Hoe laat jij aan iemand anders merken dat je hem/haar speciaal en belangrijk vindt?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '3. Hoe zou God dit aan jou laten merken?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '4. In vers 2 belooft God dat Hij je helpt, zelfs als je door water of vuur gaat. Kun je een moment bedenken waarop je je bang voelde? Hoe kun je dan naar God kijken?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '5.Het is belangrijk om omhoog te blijven kijken naar God en op Zijn beloftes te vertrouwen. Welke beloftes zien jullie in de Bijbeltekst terugkomen?',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vragen 13+',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. Jesaja 43:1 zegt: "Wees niet bang, want ik heb je verlost." Wat betekent het voor jou om te weten dat God je kent en altijd bij je wil zijn?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '2. In vers 2 belooft God dat water en vuur je niet zullen overweldigen. Hoe kun je in moeilijke momenten omhoog blijven kijken naar God en op Zijn beloftes vertrouwen?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '3. Waarom denk je dat God zoveel beloftes in de Bijbel heeft gegeven? Wat laat dit zien over wie Hij is?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '4. Wat betekent het voor jou om stevig geworteld te zijn in Hem?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '5. Waarom denk je dat het soms moeilijk is om naar God te blijven kijken en op Zijn beloftes te vertrouwen? Hoe kun je daar beter in worden?',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activiteit',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '13-',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                    'God heeft ons veel beloften gegeven in de Bijbel. Deze beloften helpen ons om te weten dat we nooit alleen zijn, zelfs niet als het moeilijk is. Vandaag gaan jullie een belofte kiezen die jullie aanspreekt. Kijk goed naar de versen die we hebben en kies degene die jou het meeste helpt. Misschien is dat een belofte die je geruststelt als je bang bent, of eentje die je herinnert dat God altijd bij je is.',),
                const SizedBox(height: 8),
                const Text(
                  'Nu gaan jullie je potje versieren! Gebruik de materialen die je hebt (stickers, markers, glitters, etc.) en maak het potje helemaal van jou. Als je bijvoorbeeld kiest voor de belofte "Ik zal je leven beschermen", kun je het potje versieren met een schild of een hartje. Wees creatief!',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Zet je potje op een plek waar je het vaak kunt zien, bijvoorbeeld op je bureau of op je nachtkastje. Zo word je elke dag herinnerd aan Gods belofte voor jou!',
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '13+',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                    'In de Bijbel heeft God ons veel beloften gegeven die ons helpen om te groeien in ons geloof en om ons te herinneren dat Hij altijd bij ons is, zelfs als het moeilijk is. Vandaag ga je een belofte kiezen die jou het meeste aanspreekt. Lees de versen die we hebben voorbereid en kies degene die jou het meeste raakt. Misschien spreekt een belofte je aan omdat je momenteel door een lastige tijd gaat, of omdat je behoefte hebt aan Gods kracht of liefde.',),
                const SizedBox(height: 8),
                const Text(
                  'Hieronder zijn een paar voorbeelden van beloften die je kunt kiezen (maar je mag natuurlijk ook zelf opzoek gaan naar belofte van God die jou aanspreekt!).',
                ),
                const SizedBox(height: 8),
                const Text(
                    'Kies de belofte die jou het meeste aanspreekt en schrijf deze duidelijk op het kaartje. Je kunt de versen letterlijk overnemen of in je eigen woorden opschrijven wat het voor jou betekent. Neem de tijd om er goed over na te denken. Wat doet deze belofte met je? Hoe kan deze belofte je helpen in je dagelijks leven?',),
                const SizedBox(height: 16),
                Text(
                  'Jesaja 41:10',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "Wees niet bang, want Ik ben bij je. Wees niet bang, want Ik ben je God. Ik maak je sterk, Ik help je, Ik steun je met mijn rechterhand die recht is."',
                ),
                const SizedBox(height: 16),
                Text(
                  'Deuteronomium 31:6',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '"Wees sterk en moedig. Wees niet bang, want de Heer, je God, is altijd bij je. Hij zal je nooit in de steek laten."',
                ),
                const SizedBox(height: 16),
                Text(
                  '1 Johannes 1:9',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "Als we onze fouten toegeven, is God trouw en rechtvaardig. Hij zal onze fouten vergeven en ons reinigen van alles wat verkeerd is."',
                ),
                const SizedBox(height: 16),
                Text(
                  'Jeremia 29:11',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "Ik weet wat Ik voor jullie in gedachten heb, zegt de Heer. Ik heb plannen voor jullie die goed zijn, en geen plannen die slecht zijn. Ik wil jullie een toekomst vol hoop geven."',
                ),
                const SizedBox(height: 16),
                Text(
                  'Matteüs 11:28',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "Kom bij Mij, jullie die moe zijn en het zwaar hebben. Ik zal jullie rust geven."',
                ),
                const SizedBox(height: 16),
                Text(
                  'Filippenzen 4:19',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "Mijn God zal alles wat jullie nodig hebben, geven uit Zijn grote rijkdom, door Christus Jezus."',
                ),
                const SizedBox(height: 16),
                Text(
                  'Psalm 121:7',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "De Heer zal je beschermen tegen alles kwaad. Hij zal je leven beschermen."',
                ),
                const SizedBox(height: 16),
                Text(
                  'Johannes 14:27',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "Vrede laat Ik jullie, Mijn vrede geef Ik jullie. Ik geef jullie niet zoals de wereld dat doet."',
                ),
                const SizedBox(height: 16),
                Text(
                  'Jesaja 40:29',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "Hij geeft de vermoeiden kracht, en de zwakken maakt Hij sterk."',
                ),
                const SizedBox(height: 16),
                Text(
                  'Psalm 145:18',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '· "De Heer is dichtbij iedereen die Hem vraagt om te helpen, iedereen die eerlijk naar Hem toe komt."',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gebed',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'We willen dit moment afsluiten met Gebed. Gebed is niet alleen een manier om om hulp te vragen, maar ook een moment om stil te staan bij wie God is en wat Hij voor ons doet. Het is een kans om je hart voor Hem open te stellen, je zorgen en dankbaarheid met Hem te delen, en te luisteren naar Zijn leiding.',
        ),
        const SizedBox(height: 8),
        const Text(
          'Jullie mogen kiezen om het gebed wat hieronder staat te bidden of af te sluiten met open gebed waarbij we jullie willen uitnodigen om een kort gebed uit te spreken voor jezelf of voor een ander. God is altijd bereid om naar je te luisteren, dus voel je vrij om echt open te zijn in dit gesprek met Hem.',
        ),
        const SizedBox(height: 8),
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  "Lieve God,\n\nDank U wel voor Uw geweldige beloften aan ons. Bedankt dat we altijd op U kunnen vertrouwen, zelfs als het moeilijk is. U zegt dat U altijd bij ons bent, ons sterk maakt en ons nooit zult verlaten. We zijn zo blij dat we weten dat we niet bang hoeven te zijn, omdat U bij ons bent, door alles heen. Dank U dat U ons helpt als we fouten maken, en dat U ons altijd vergeeft. Dank U dat we mogen weten dat U een goed plan voor ons hebt en dat U voor ons zorgt, elke dag weer.\nGod, help ons om altijd omhoog te kijken naar U, om te weten dat U ons leidt en helpt. Als we ons verdrietig of bang voelen, herinner ons dan aan Uw beloften. Help ons om te blijven vertrouwen op U, in alles wat we doen.\nDank U voor Uw liefde en voor altijd bij ons zijn. We houden van U!\n\nIn Jezus' naam,\nAmen.",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
