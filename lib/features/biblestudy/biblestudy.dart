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
                Text('GROW!', style: Theme.of(context).textTheme.headlineLarge),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NecessitiesTag(text: 'Papier (2 per persoon)'),
            NecessitiesTag(text: 'Pennen'),
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
          'Het thema vorig jaar was Footprint! We hebben ons gericht op de footprint die we achterlaten door onze acties en keuzes, en hoe dit bepaalt hoe anderen ons zien en hoe onze omgeving wordt beïnvloed. Nu, met het thema GROW, wordt deze impact gericht op persoonlijke groei. Door te groeien in wijsheid, kracht en liefde, veranderen we niet alleen onszelf, maar dragen we ook bij aan de opbouw van Gods Koninkrijk en positieve verandering in de wereld om ons heen. We verleggen de focus dus van de zichtbare footprint naar de innerlijke groei en de impact die het kan hebben op ons leven en de bredere gemeenschap. Laten we samen verkennen en ontdekken van alle geweldige dingen over dit thema. Het kan ongelooflijke dingen doen in ons leven en ons helpen om het speciale plan dat God voor ons heeft te vervullen.',
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
              'Teken een emoji die jouw gevoel, hobby of persoonlijkheid weergeeft. Ga vervolgens in de kring staan en leg aan de rest uit waarom je deze hebt gekozen.',
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
                  'Mattheus 13:31-32',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '31. Jezus vertelde hun nog meer in de vorm van een verhaal. Hij zei: "Je kan het Koninkrijk van God vergelijken met een mosterdzaadje. Iemand plant dat zaadje in zijn akker. 32. Het is maar een heel klein zaadje. Maar uiteindelijk wordt het een plant die groter is dan alle andere tuinkruiden: het wordt een boom. In die boom kunnen de vogels hun nesten bouwen.',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Jezus vertelde de gelijkenis van het mosterdzaadje om te illustreren hoe het Koninkrijk van God kan groeien. Het kleine verhaal laat ons zien dat iets wat lijkt op een onbenullig beginpunt, kan leiden tot iets heel groots. Net als het mosterdzaadje kunnen ons geloof, onze daden en kleinste bijdragen het potentieel hebben om een ​​aanzienlijke invloed en verandering in deze wereld teweeg te brengen.',
        ),
        const SizedBox(height: 16),
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kolossenzen 2:7',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '7. Net zoals een boom met zijn wortels stevig in de grond staat, zo moeten jullie stevig in Hem geworteld staan. Dan zullen jullie in Hem opgebouwd worden. En jullie zullen stevig blijven staan in het geloof dat we jullie geleerd hebben. Wees ook dankbaar.',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Net zoals een boom sterke wortels nodig heeft om hoog te groeien en vruchten te dragen, hebben wij ook behoefte aan verankering. Gods liefde en waarheid zijn onze voeding om te bloeien in elk aspect van ons leven. Door het liefdevolle werk van God in ons te omarmen, door zijn Heilige Geest, zullen we uitgroeien tot een leven van vervulling en met een doel. En het uiteindelijke resultaat? Een leven vol dankbaarheid!',
        ),
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
                  '1. Waarom denk je dat Jezus een mosterdzaadje als voorbeeld koos?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '2. Kun je iets bedenken dat klein is, zoals het mosterdzaadje, maar uiteindelijk groot kan worden? Misschien iets in de natuur of zelfs in jouw eigen leven?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '3. Stel je voor dat je een klein zaadje hebt. Wat voor soort dingen zou je willen laten groeien?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '4. Kun je een voorbeeld bedenken van wanneer je je blij of sterk hebt gevoeld omdat je wist dat God bij je was? Wat denk je dat het betekent om in God opgebouwd te worden?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '5. Wat maakt jou dankbaar, en hoe kan dankbaarheid je helpen om sterk te blijven, net als de stevige wortels van een boom??',
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
                  '1. Wat denk jij dat Jezus wil zeggen met het verhaal van het mosterdzaadje in relatie tot het Koninkrijk van God?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '2. Hoe zie jij de vergelijking tussen het kleine mosterdzaadje en onze kleine bijdragen aan de wereld om ons heen? Heb je voorbeelden waarin iets kleins een groot verschil heeft gemaakt??',
                ),
                const SizedBox(height: 8),
                const Text(
                  '3. Op welke manier zou je zelf klein kunnen beginnen in je geloofsleven?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '4. Wat betekent het voor jou om stevig geworteld te zijn in Hem?',
                ),
                const SizedBox(height: 8),
                const Text(
                  '5. Hoe denk je dat Gods kracht en begeleiding een rol speelt in jouw persoonlijke groei?',
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
        const Text(
            'Iedereen krijgt een vel papier. Verdeel het papier in twee delen.'),
        const SizedBox(height: 8),
        Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bovenin',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Schrijf of teken wat je het afgelopen jaar hebt gedaan dat een positieve impact heeft gehad op anderen.',
                ),
                const SizedBox(height: 8),
              ],
            ),
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
                  'Onderin',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Schrijf of teken een persoonlijk doel of een gebied waarin je zou willen groeien komende maanden.',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Deel met elkaar wat je hebt opgeschreven of heb getekend.',
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
        Text(
          'Neem even 2 minuten de tijd om een kort gebed op te schrijven voor de persoon die rechts van je zit. Spreek daarna om de beurt je gebed voor deze persoon uit.',
        ),
      ],
    );
  }
}
