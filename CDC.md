# Cahier des charges de l'application Freetube

## Contexte

L'entreprise Framinfo souhaite développer une application nommée Freetube, une alternative à l'application Youtube. Un MVP doit être produit afin de valider le projet.

## Objectifs

- Créer une application web permettant de diffuser des vidéos
- Lire du contenu multimédia depuis l'application, sans avoir besoin d'un compte
- Avoir un profil utilisateur permettant de gérer le contenu posté, voir les statistiques sur ses propres contenus, voir le nombre de vues, etc.

## Description du projet

### Généralités

Freetube est une application d'hébergement et de partage de vidéos destinées à deux profils utilisateurs :
- les créateurs de contenus, qui mettent en ligne leurs productions afin de s'adresser à leur audience (divertissement, professionnel, publicités...)
- les consommateurs de contenus, qui regardent le contenu posté par les créateurs de contenu.

### Fonctionnalités demandées

1. Connexion

Un utilisateur pourra  se connecter à l'application via un compte créé spécifiquement sur l'application ou en utilisant au moins un service OAuth2 (Google et Microsoft).

2. Gestion utilisateur

Chaque utilisateur doit pouvoir administrer son compte, à savoir :
- modifier son adresse mail et nom d'utilisateur (doit être unique)
- modifier son mot de passe (doit être sécurisé)
- supprimer son compte
- modifier sa photo de profil
- créer/modifier un nom d'affichage pour sa chaine Freetube
- créer/modifier une description pour sa chaine Freetube

3. Administration d'une chaine Freetube

Les créateurs de contenus doivent pouvoir administrer leur chaine Freetube, publier des vidéos mais aussi suivre toutes leurs statistiques sur un panneau d'administration leur étant dédié.
Un utilisateur peut :
- mettre en ligne une viédo qui générera un lien partageable et qui comprend :
    - un média vidéo, tout type de fichier vidéo sera accepté (mp4, avi, webm...)
    - une miniature de vidéo, tout type de format image sera accepté (png, jpg, jpeg, webp...)
    - un titre
    - une description
    - la date de mise en ligne, définie automatiquement lorsque la vidéo est rendue disponible
    - la possibilité de mettre la vidéo en public (accessible à tous les utilisateurs de Freetube via les fonctionnalités de recherche et de mise en avant) ou en privé (accessible uniquement pour les utilisateurs possédant le lien pour accéder à cette dernière)
- éditer n'importe quel élément sur une vidéo précédemment créée (tous les points mentionnés précédemment)
- changer la visibilité d'une vidéo
- supprimer une vidéo
- consulter les statistiques de chaque vidéo individuellement (nombre de likes et commentaires)
- consulter les statistiques globales de sa chaine Freetube dans une page dédiée (cumul de stats de l'ensemble des vidéos)

4. Utilisation de Freetube

N'importe quel utilisateur de Freetube, qu'il soit authentifié ou non, peut accéder à la plateforme gratuitement et librement.

Page d'accueil

Bien que la disposition de la page d'accueil soit identique à chaque utilisateur, certaines sections diffèrent :

- pour un utilisateur authentifié :
    - une section "Recommandations" mettant en avant du contenu que l'utilisateur n'a encore jamais vu et similaire au contenu qu'il regarde et avec lequel il a pu interagir (like, commentaire, ajout à une playlist)
    - une section "A consulter plus tard", comprenant les vidéos que l'utilisateur a ajoutées à la playlist du même nom
    - une section "Tendances" avec le contenu de la plateforme ayant généré le plus d'interaction récemment

- pour un utilisateur non authentifié :
    - une section "Recommandations" mettant en avant les 3 mots clés les plus utilisés de la plateforme dans la recherche (par exemple "Informations", "Jeux Vidéos", "Musique"...)
    - une section "Tendances" avec le contenu de la plateforme ayant généré le plus d'interaction récemment
    - une section "Top Créateurs" affichant sous forme de cartes, la photo de profile, le nom et la description de la chaine, des créateurs ayant le plus d'abonnés de la plateforme

Page "Abonnements"

Pour les utilisateurs non-authentifiés, la page redirige automatiquement vers la page de connexion/inscription.
Cette page affiche le fil d'actualités et les dernières vidéos publiées par les créateurs de contenu auquel l'utilisateur est abonné.

Page "Utilisateur"

Pour les utilisateurs non-authentifiés, la page redirige automatiquement vers la page de connexion/inscription.
Cette page met en avant 2 sections :
- historique des vidéos regardées par l'utilisateur
- playlist de l'utilisateur :
    - liste des playlist de l'utilisateur (dont celle "A consulter plus tard" créée par défaut)
    - création/suppression de playslists

Page "Playlist"

Un utilisateur accède à cette page depuis la liste de ses playlists dans la page "Utilisateur".
Cette page comprend uniquement le nom de la playlist et les vidéos (avec miniature, titre et chaine Freetube) contenus dans cette playlist, trié par date d'ajout dans la playlist.

Page pour les vidéos

Lorsqu'un utilisateur clique sur la miniature d'une vidéo ou utilise le lien de partage d'une video, il arrive sur cette page qui affiche :
- un lecteur video avec :
    - la vidéo publiée
    - les fonctionnalités de base d'un lecteur vidéo tel que :
        - bouton play
        - pause
        - avance de XX secondes
        - retrait de XX secondes
        - barre de progression
        - volume
- les informations du créateur de contenu :
    - image de profil
    - nom de la chaine
    - nombre de likes de la vidéo
    - nombres d'abonnés à la chaine du créateur
- un bouton pour s'abonner à la chaine du créateur
- un bouton like
- un bouton pour ajouter la vidéo à une playlist ("a consulter plus tard" par défaut ou playlist personnalisée)
- la description d ela vidéo
- un espace commentaire avec :
    - possibilité de laisser un commentaire
    - feed des commentaires, affichés par date de publication avec les plus récents en premier
- une section "Recommandations" pour un utilisateur authentifié ou une section "Tendance" pour un utilisateur non authentifié

### Architecture et déploiement

1. Architecture

L'application est divisée en 3 parties distinctes :
- une API REST qui implémente toutes les fonctionnalités précédemment énoncées,
- un client web devant uniquement interagir avec le serveur
- une base de données

Absolument aucune logique ne doit avoir lieu sur le client web qui sert que d'interface et redirige les différentes requêtes vers le serveur.

2. Containerisation

Le projet doit avoir un fichier docker-compose.yml à la racine du projet permettant de déployer au moins 3 services Docker séparés, pour le client, le serveur et la base de données.
L'application doit être lancée intégralement via docker-compose.

### Choix tehcnologiques

1. Frontend

Le frontend doit être développé en Angular. Justifié par :

Framework robuste pour applications complexes
TypeScript natif - typage fort, maintenance facilitée
Architecture modulaire - parfait pour une app avec multiples fonctionnalités
Lazy loading - chargement optimisé des vidéos
Reactive Forms - gestion avancée des formulaires (inscription, connexion)
RxJS intégré - gestion élégante des flux de données (streaming vidéo)
PWA ready - possibilité d'application mobile

2. Backend

Le backend doit être développé en Node.js. avec le framework NestJS. Justifié par :

JavaScript/TypeScript - cohérence avec Angular
NPM ecosystem - nombreuses librairies vidéo
Streaming efficace - parfait pour la diffusion vidéo
Microservices ready - scalabilité future
WebSockets - commentaires en temps réel
Multer/GridFS - upload de fichiers volumineux

NestJS spécifiquement :

Architecture similaire à Angular - courbe d'apprentissage réduite
Décorateurs et modules - code plus maintenable
Guards et interceptors - sécurité avancée

3. Base de données 

La base de données doit être développée en PostgresSQL. Justifié par : 

Relations complexes - utilisateurs, vidéos, commentaires, likes
ACID compliance - intégrité des données critiques
Performances - indexation avancée pour les recherches
JSON support - flexibilité pour métadonnées vidéo
Full-text search - recherche de contenu