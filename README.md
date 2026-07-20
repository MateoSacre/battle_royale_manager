# Battle Royale Manager (nom provisoire)

Jeu de gestion mobile (Flutter) où le joueur incarne le manager d'une équipe de
combattants : recrutement, entraînement, cohésion de groupe, puis envoi en
arène pour un battle royale simulé automatiquement.

Le design complet (mécaniques de combat, modèle de combattant, traits,
roadmap...) vit dans [`docs/GDD.md`](docs/GDD.md). Ce README ne fait que
situer le projet dans son état de code ; le GDD reste la source de vérité pour
les règles du jeu.

## Statut actuel

Squelette Flutter par défaut (`flutter create`), aucune logique de jeu n'est
encore implémentée. Le développement démarre par le scope du **prototype**
défini dans le GDD (§2) : uniquement la boucle de combat (pool de combattants
pré-générés → sélection des équipes → simulation → résultat/log), sans
recrutement ni gestion RH ni persistance.

## Stack technique

- **Flutter / Dart** (SDK Dart `^3.9.0`, voir [`pubspec.yaml`](pubspec.yaml))
- Cibles configurées : Android, iOS, plus Web/Windows/macOS/Linux disponibles
  pour un dev loop rapide (`flutter run -d chrome` etc.), même si le jeu vise
  mobile en priorité.
- Aucune dépendance tierce hors du socle Flutter par défaut pour l'instant
  (`cupertino_icons`, `flutter_lints` en dev).

## Structure du dépôt

```
lib/            Code de l'application (actuellement le squelette par défaut)
test/           Tests (actuellement le test par défaut de flutter create)
docs/GDD.md     Game Design Document — référence des règles et de la roadmap
android/ ios/   Projets natifs par plateforme
web/ windows/ macos/ linux/  Cibles secondaires (dev/test, hors priorité produit)
```

## Lancer le projet

```bash
flutter pub get
flutter run
```

Lancer les tests :

```bash
flutter test
```

Analyse statique :

```bash
flutter analyze
```

## Roadmap

Voir [`docs/GDD.md`](docs/GDD.md) §7 pour la roadmap fonctionnelle complète
post-prototype (recrutement, entraînement, cohésion dynamique, affichage 2D
des combats, etc.).
