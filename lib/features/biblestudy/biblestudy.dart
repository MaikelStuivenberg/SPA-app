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
                Text('IN THE LIGHT',
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
        Row(
          children: [
            NecessitiesTag(text: 'Kraspapier'),
            NecessitiesTag(text: 'Kraspen / sateprikker'),
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
          'Vorig jaar leerden we over "Look up", toen keken we naar God/ Jezus, leerden we erop te vertrouwen dat Hij de weg weet en er altijd bij zal zijn.\n\nVandaag gaan we nadenken over het thema "In the light". In het licht gaan staan en kinderen van het licht zijn.\n\nHier staat iets over in de bijbel, in Efeze 5:8, maar voordat we daarnaar gaan kijken, doen we eerst even een Icebreaker!',
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
              'Om elkaars namen te leren kennen en te ervaren wat het is om even in het licht te gaan staan, doen we de volgende oefening.',
            ),
            const SizedBox(height: 8),
            const Text('1. Ga in een kring staan.'),
            const SizedBox(height: 8),
            const Text(
                '2. Om de beurt stap je in de kring en zeg je de volgende zin: Ik ben (je naam) en ik houd van (iets te eten of iets te doen). Let op: dat moet beginnen met de eerste letter van jouw naam! (Bv. Ik ben Alex en ik houd van appels/ Ik ben Sander en ik houd van Skiën)'),
            const SizedBox(height: 8),
            const Text(
                '3. De groep reageert met op zijn vriendelijkst: hoi (naam)! En zwaait naar de persoon in het midden.'),
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
          'Lees samen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Paulus is een echte brievenschrijver, misschien wel omdat hij regelmatig in de gevangenis zat. Op deze manier wilde hij nieuwe gemeentes met mensen die net tot geloof gekomen waren aanmoedigen. Hoewel men het niet zeker weet, is het wel waarschijnlijk, dat hij ook de brief voor de gemeente in Efeze heeft geschreven. Dat was in die tijd een grote en belangrijke handels- en havenstad. De christelijke gemeente was daar een mix van joodse en niet joodse gelovigen, oude en nieuwe gelovigen.\n\nVoor die tijd leek het onmogelijk dat deze samen een nieuw volk konden worden. Maar door Jezus was dit mogelijk geworden. God liet door Jezus zien, dat voortaan iedereen zich Kind van God mocht noemen. \n\nDe joden hadden hun eigen wetten over wat wel en niet mocht, de overige leden van de gemeente hadden daar andere ideeën over.\n\nDe brief begint met enthousiasme over wie God is, wat Hij gedaan heeft en wat Hij nog gaat doen.\n\nDe briefschrijver wilde de gemeente erop wijzen, dat ze blij moeten zijn dat ze nu allemaal bij Gods volk hoorden.\n\nOm ze uit te leggen wat het betekent om bij God te horen en hoe je dat kunt laten zien, gebruikte hij de vergelijking met donker en licht: leven zonder en leven met God.',
        ),
        const SizedBox(height: 16),
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Efeziërs 5: 8',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Want vroeger hoorden jullie bij het donker, maar nu horen jullie bij het licht van de Heer. Leef als kinderen van dat licht.',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buidQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bespreek de volgende vragen:',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                  '- Als er gesproken wordt over “de donkere wereld”, dan heeft dat vaak te maken met dingen in het leven waar men zich zorgen om maakt. Over welke dingen in de wereld ben jij bezorgd?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '- In dit verhaal betekent donker leven zonder God.\no Kun jij je iets voorstellen bij wat leven zonder God voor jou zou betekenen?\no Heb jij hier ervaring mee?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '- In dit verhaal is licht een leven samen met God. Wat zou er veranderen in de wereld als we zouden leven in Gods licht?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '- Welke situaties kun jij anders bekijken, omdat je leeft in het licht? (omdat je Jezus kent?)',
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
                  '13+',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '- Het lijkt niet altijd gemakkelijk, om alles wat er in de wereld, en soms ook in ons leven, gebeurt te verdelen in licht en donker. Maar als we toch een poging wagen:\n\nDonker:\no Wat zijn situaties in de wereld die je donker zou noemen?\no Zijn er ook momenten in jouw leven geweest die je donker zou noemen?\n\nLicht:\no Welke situaties in de wereld vind jij getuigen van licht?\no Wanneer ervaar jij in je eigen leven dat je in licht leeft.',
                ),
                const SizedBox(height: 8),
                const Text(
                  '- Ken jij zelf het verschil tussen leven in het donker (zonder God) en leven in het licht (met God)?',
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Iedereen krijgt een vel kraspapier en een kraspen/ sateprikker. Een zwart vel, dat zodra je het gaat bewerken kleur zal geven.',
                ),
                SizedBox(height: 8),
                Text(
                  'Schrijf of teken iets waarin je het afgelopen year Gods Licht hebt gezien.',
                ),
                SizedBox(height: 8),
                Text('of:'),
                SizedBox(height: 8),
                Text(
                  'Schrijf of teken een situatie waar je de komende tijd Gods licht op zou willen zien schijnen.',
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
          'We willen dit moment afsluiten met Gebed. Gebed is niet alleen een manier om om hulp te vragen, maar ook een moment om stil te staan bij wie God is en wat Hij voor ons doet. Het is een kans om je hart voor Hem open te stellen, je zorgen en dankbaarheid met Hem te delen, en te luisteren naar Zijn leiding. Jullie mogen kiezen om het gebed wat hieronder staat te bidden of af te sluiten met open gebed waarbij we jullie willen uitnodigen om een kort gebed uit te spreken voor jezelf of voor een ander. God is altijd bereid om naar je te luisteren, dus voel je vrij om echt open te zijn in dit gesprek met Hem.',
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
                  "Lieve God,\n\nVandaag hebben we mogen lezen, horen en delen over wat leven in uw licht betekent. Dank U wel dat U dit licht in ons leven wilt schijnen en ons op Uw unieke wijze op wat voor manier dan ook wilt helpen. Wilt U de komende maanden, tot dat we weer met SPA bij elkaar mogen komen, met ons mee gaan en ons verbonden houden zodat we niet alleen aan U mogen denken maar ook aan elkaar en zo een licht puntje voor elkaar mogen zijn.\n\nDank U wel In Jezus' naam, Amen",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
