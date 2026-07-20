# Game Design Document — Battle Royale Manager (nom provisoire)

## 1. Concept

**Pitch** : Un jeu de gestion où le joueur incarne un manager d'équipe de combattants, qu'il recrute, entraîne, et envoie s'affronter dans des arènes de type battle royale.

**Genre** : Gestion / Simulation, avec menus principalement, et un affichage 2D léger (prévu en évolution, pas pour le proto).

**Plateforme** : Flutter — mobile en priorité (Android/iOS), extension future possible vers desktop/web.

**Rythme** : Progression longue (dizaines d'heures), façon carrière sur plusieurs saisons.

**Focus gameplay** : 50% gestion RH (recrutement, entraînement, moral, cohésion) / 50% stratégie pré-combat (équipement, tactique, composition d'équipe).

**Combats** : Simulés automatiquement (le joueur voit le résultat/log), avec une évolution future possible vers un affichage 2D "spectateur".

---

## 2. Scope du prototype (MVP)

Le prototype se concentre uniquement sur la **boucle de combat**, sans gestion RH ni recrutement :

- Un pool de combattants pré-générés avec leurs stats
- Sélection des équipes → lancement de la simulation → affichage du résultat/log
- Pas de progression, pas de persistance de carrière

Objectif : valider que regarder/lire le déroulement d'un combat simulé est intéressant, avant d'investir dans la couche gestion.

---

## 3. Modèle de combattant

### 3.1 Axes de personnalité (0-100)

Chaque combattant possède 4 scores indépendants, générés à la création :

| Axe | Pôle bas (0) | Pôle haut (100) |
|---|---|---|
| **Autonomie** | Suit les décisions du groupe | Agit selon son propre jugement |
| **Agressivité** | Évite le conflit, prudent | Cherche l'affrontement |
| **Leadership** | Suiveur | Cherche à diriger le groupe |
| **Intelligence** | Décisions instinctives/impulsives | Décisions calculées/tactiques (QI général, distinct du QI de combat) |

### 3.2 Traits (archétypes)

Le trait est une étiquette **dérivée** des 4 scores (pas une donnée de base). Calcul par **nearest neighbor** : distance euclidienne entre le profil du personnage et chaque ancrage ci-dessous ; le trait affiché est celui de l'ancrage le plus proche.

| Trait | Autonomie | Agressivité | Leadership | Intelligence |
|---|---|---|---|---|
| Stratège | 20 | 25 | 80 | 90 |
| Leader | 25 | 45 | 95 | 70 |
| Tête brûlée | 90 | 95 | 20 | 15 |
| Berserker | 75 | 95 | 45 | 30 |
| Froussard | 85 | 5 | 15 | 35 |
| Loyal | 10 | 45 | 20 | 50 |
| Suiveur | 10 | 20 | 10 | 25 |
| Discret | 50 | 20 | 5 | 75 |
| Protecteur | 25 | 60 | 65 | 65 |
| Opportuniste | 80 | 50 | 25 | 80 |
| Prodige | 100 | 100 | 100 | 100 |
| Échec | 0 | 0 | 0 | 0 |

**Mécanique "Vrai [Trait]"** : après génération du profil et calcul du trait le plus proche, un jet séparé à **0.5% de chance** peut déclencher un "snap" : les 4 scores du personnage sont remplacés par les valeurs exactes de l'ancrage, et le titre devient "Vrai [Trait]" (ex: "Vrai Stratège", "Vrai Échec").

### 3.3 Cohésion d'équipe

Score composé de deux termes à poids :

- **Similarité** : dispersion (écart-type) des membres sur 3 axes (autonomie, agressivité, intelligence — le leadership en est exclu, il est traité séparément par le terme de hiérarchie). Faible dispersion = bonne similarité. `similarité = 100 - écart_type_moyen`.
- **Hiérarchie** : écart entre le leadership du membre au score le plus haut et la moyenne du leadership des autres membres (le leader est exclu de cette moyenne). Un écart net (leader clairement identifié) augmente ce terme.

`cohésion = similarité × poids similarité + hiérarchie × poids hiérarchie`

Cas particuliers :
- Équipe d'un seul combattant : cohésion maximale (100), il n'y a pas de dispersion ni de hiérarchie à mesurer.
- Équipe vide : cas d'erreur (ne devrait pas se produire en pratique).

- **Pour le proto** : score fixe, calculé une fois au début du combat.
- **Évolution prévue** : dynamique en cours de partie (modificateurs temporaires liés aux événements — pertes, victoires, temps passé ensemble).

**Effet en combat** : à chaque décision d'équipe (déplacement, ciblage), un jet basé sur la cohésion détermine si l'équipe agit **groupée** ou se **fragmente** (chaque membre décide/agit seul).

### 3.4 Stats de combat (0-100)

| Stat | Rôle |
|---|---|
| **Carry** | Capacité de charge (accès équipement) + sert de base au calcul des PV |
| **Observation** | Détection anticipée de l'adversaire → initiative |
| **Mobility** | Cadence d'action (ATB), esquive, capacité de fuite/poursuite |
| **Brawl (CQC)** | Efficacité en combat rapproché |
| **Aim** | Efficacité à distance, précision du ciblage (localisation) |
| **Tactic (Battle IQ)** | Qualité des décisions tactiques en combat (engager/fuir/cibler) — distinct de l'Intelligence générale |

**Génération** : chaque trait définit une plage de valeurs de départ + un plafond d'entraînement par stat de combat (potentiel). Le remplissage précis des valeurs par trait est un travail de contenu/équilibrage à faire progressivement (premier jet approximatif acceptable pour le proto).

**Progression** : les stats de combat évoluent via l'entraînement (mécanique RH, hors scope proto), dans la limite du plafond défini par le trait.

### 3.5 Points de vie

```
PV_max = valeur_base + (Carry × multiplicateur)
```

Valeurs exactes à ajuster en test (ex. valeur_base = 50, multiplicateur = 0.5).

---

## 4. Structure de l'arène

- **Format de départ** : 16 participants, équipes de 1/2/4 modulables (solo/duo/squad).
- **Carte** : graphe de zones abstraites (5-8 zones nommées, connectées entre elles), pas de coordonnées x/y pour le proto.
- **Objectif futur** : plusieurs types d'événements/formats d'arène.

---

## 5. Algorithme de simulation — vue d'ensemble

Simulation par tours sur le graphe de zones, jusqu'à ce qu'il ne reste qu'une équipe/qu'un participant.

### 5.1 Déplacement et fragmentation

À chaque tour, par équipe :

1. Jet de cohésion → équipe **groupée** (agit comme un bloc) ou **fragmentée** (chaque membre décide seul)
2. Décision de déplacement (rester / zone adjacente), influencée par le rapport de force perçu

### 5.2 Détection → Initiative

Quand deux équipes/individus se retrouvent dans la même zone :

```
score_détection = moyenne(Observation des membres présents)
Écart significatif (>15-20 pts) → l'équipe avec le score le plus haut a l'initiative
Sinon → détection simultanée
```

**Sous initiative, si l'équipe choisit de fuir** :

```
Jet de risque : Mobility (fuyard) vs Observation (adversaire)
Succès → fuite discrète, pas de combat
Échec → repérée en fuite, l'adversaire gagne l'initiative si combat malgré tout
```

**Sous initiative, si l'équipe choisit d'engager** → bonus d'embuscade au premier échange.

### 5.3 Décision d'engager/fuir (par individu ou équipe groupée)

```
rapport_de_force_perçu = rapport_de_force_réel + erreur (inversement proportionnelle à Tactic)
Perçu favorable → tendance à engager
Perçu défavorable → tendance à fuir (dépend ensuite de Mobility pour réussir)
```

### 5.4 Résolution du duel — Timeline ATB

Chaque combattant a un rythme d'action individuel basé sur sa Mobility :

```
rythme(mobility) = 0.5 × 2^(mobility / 50)
Mobility 0   → 0.5 action/unité de temps
Mobility 50  → 1 action/unité (référence)
Mobility 100 → 2 actions/unité
```

L'équipe avec l'initiative obtient une action gratuite pour tous ses membres avant le démarrage de la timeline. Ensuite, chaque combattant agit selon son propre compteur de temps.

**Actions disponibles** : se rapprocher, fuir, se mettre à couvert, tirer, taper.

**État distance/contact** : suivi **individuellement par paire de combattants** (un combattant peut être à distance de certains adversaires et au contact d'autres simultanément). "Tirer" nécessite l'état distance, "taper" nécessite le contact.

### 5.5 Ciblage (combats en équipe)

```
Équipe groupée (cohésion réussie) → focus fire : cible la plus faible/vulnérable de l'équipe adverse
Équipe fragmentée (cohésion ratée) → ciblage individuel dispersé, pondéré par le Tactic de chacun
  (Tactic élevé → tend quand même vers la cible la plus faible ; Tactic faible → quasi aléatoire)
```

### 5.6 Résolution d'une touche

**Précision mitigée par l'esquive (Mobility de la cible)** :

```
Distance : aim_effectif = Aim_attaquant - (Mobility_cible × 0.3)
CQC      : brawl_effectif = Brawl_attaquant - (Mobility_cible × 0.6)
```

(Facteurs de départ, à ajuster en test — l'esquive compte davantage en CQC qu'à distance.)

**Couvert** (façon XCOM 2, tir à distance uniquement) :

```
Couvert bas  → -25% chance de toucher
Couvert haut → -50% chance de toucher
```

S'active via l'action "se mettre à couvert", se désactive si le combattant bouge.

### 5.7 Localisation de la touche (en cas de succès)

Pondérée par l'Aim de l'attaquant (viser la tête est plus fréquent avec un Aim élevé, et plus caractéristique du tir à distance que du CQC) :

| Zone | Aim faible (0-30) | Aim moyen (30-70) | Aim élevé (70-100) |
|---|---|---|---|
| Tête | ~5% | ~15% | ~40-50% |
| Torse | ~50% | ~45% | ~35% |
| Bras (cumulé x2) | ~25% | ~22% | ~10% |
| Jambes (cumulé x2) | ~20% | ~18% | ~5-10% |

En CQC, le ciblage tête est moins fréquent (le CQC reste orienté dégâts/neutralisation plutôt que précision létale).

### 5.8 Effets de blessure par zone

| Zone touchée | Effet |
|---|---|
| Tête | Élimination instantanée |
| Torse | Dégâts PV normaux |
| Bras (1) | Malus Aim |
| Bras (2) | Incapable d'attaquer (ni tir ni CQC) |
| Jambe (1) | Malus Mobility |
| Jambe (2) | Immobilisé (ne peut plus fuir/se rapprocher) |

PV globaux en parallèle, élimination à 0.

### 5.9 Équipement (v1 simplifiée)

| Arme | Catégorie | Effet |
|---|---|---|
| Rien (mains nues) | CQC | +0 |
| Couteau | CQC | Bonus Brawl effectif |
| Pistolet | Distance | Bonus Aim effectif |

Extensible plus tard (fusils, snipers, armes lourdes) sans changer l'architecture.

---

## 6. Points à trancher / affiner en test

- Facteurs d'esquive exacts (0.3 / 0.6) et seuils de détection (15-20 pts)
- Barème précis des PV (valeur de base, multiplicateur Carry)
- Remplissage complet des plages de stats de combat par trait (12 traits × 6 stats)
- Distribution exacte des probabilités de localisation selon Aim
- Gestion des pertes côté équipe victorieuse (peut-elle aussi perdre des membres ?) — non tranché

## 7. Roadmap fonctionnelle (post-proto)

- Recrutement et système RH complet
- Entraînement et progression des stats
- Cohésion dynamique en cours de partie
- Affichage 2D des combats (spectateur)
- Multiples types d'événements/formats d'arène
- Extension de l'équipement (armes longues, armures, etc.)
