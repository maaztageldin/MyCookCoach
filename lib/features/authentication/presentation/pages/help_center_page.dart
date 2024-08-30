import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centre d\'aide'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                hintText: 'Recherche',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16),

            // TabBar pour basculer entre FAQ et Contactez-nous
            DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    labelColor: Colors.brown,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.brown,
                    tabs: [
                      Tab(text: 'FAQ'),
                      Tab(text: 'Contactez-nous'),
                    ],
                  ),
                  SizedBox(
                    height: 500, // Hauteur de la zone de contenu
                    child: TabBarView(
                      children: [
                        // Contenu pour l'onglet FAQ
                        FAQSection(),
                        // Contenu pour l'onglet Contactez-nous
                        ListView(
                          children: [
                            HelpCenterItem(
                              icon: Icons.headset_mic_outlined,
                              title: 'Service client',
                            ),
                            HelpCenterItem(
                              icon: FontAwesomeIcons.whatsapp,
                              title: 'WhatsApp',
                              subtitle: '(480) 555-0103',
                            ),
                            HelpCenterItem(
                              icon: Icons.public,
                              title: 'Site web',
                            ),
                            HelpCenterItem(
                              icon: Icons.facebook,
                              title: 'Facebook',
                            ),
                            HelpCenterItem(
                              icon: FontAwesomeIcons.twitter,
                              title: 'Twitter',
                            ),
                            HelpCenterItem(
                              icon: FontAwesomeIcons.instagram,
                              title: 'Instagram',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section FAQ avec filtres et éléments expansibles
class FAQSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Boutons de filtre
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FAQFilterButton(text: 'All', isSelected: true),
              FAQFilterButton(text: 'Services'),
              FAQFilterButton(text: 'General'),
              FAQFilterButton(text: 'Account'),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Liste des FAQ
        Expanded(
          child: ListView(
            children: [
              FAQItem(
                question: "Puis-je suivre la livraison de ma commande ?",
                answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                isExpanded: true,
              ),
              FAQItem(
                question: "Y a-t-il une politique de retour ?",
              ),
              FAQItem(
                question: "Puis-je enregistrer mes articles préférés pour plus tard ?",
              ),
              FAQItem(
                question: "Puis-je partager des produits avec mes amis ?",
              ),
              FAQItem(
                question: "Comment contacter le support client ?",
              ),
              FAQItem(
                question: "Quels modes de paiement sont acceptés ?",
              ),
              FAQItem(
                question: "Comment ajouter un avis ?",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Boutons de filtre pour les catégories FAQ
class FAQFilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;

  FAQFilterButton({required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black, backgroundColor: isSelected ? Colors.brown : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          // Ajouter une logique pour filtrer les FAQ ici
        },
        child: Text(text),
      ),
    );
  }
}

// Widget pour un élément FAQ expansible
class FAQItem extends StatefulWidget {
  final String question;
  final String? answer;
  final bool isExpanded;

  FAQItem({
    required this.question,
    this.answer,
    this.isExpanded = false,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        title: Text(widget.question),
        initiallyExpanded: _isExpanded,
        children: [
          if (widget.answer != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.answer!),
            ),
        ],
      ),
    );
  }
}

// Widget pour un élément de la section Contactez-nous
class HelpCenterItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  HelpCenterItem({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Icon(icon, color: Colors.brown),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: Icon(Icons.expand_more, color: Colors.brown),
          onTap: () {
            // Action à définir lors de l'appui sur l'élément
          },
        ),
      ),
    );
  }
}
