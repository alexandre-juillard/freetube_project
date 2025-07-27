# 🔧 Guide d'accès à Adminer - Interface PostgreSQL

## 📋 Vue d'ensemble

Adminer est une interface web pour gérer la base de données PostgreSQL de Freetube. Ce guide vous explique comment démarrer les services et vous connecter à l'interface d'administration.

---

## 🚀 Étape 1 : Démarrage des services Docker

### Depuis la racine du projet Freetube :

```bash
# Démarrer la base de données et Adminer
docker-compose up database adminer -d
```

**Alternative si les services sont déjà créés :**
```bash
# Démarrer tous les services
docker-compose up -d

# Ou démarrer seulement les services nécessaires
docker-compose start database adminer
```

### Vérifier que les services sont actifs :

```bash
docker-compose ps
```

**Résultat attendu :**
```
NAME                IMAGE                COMMAND                  SERVICE    CREATED          STATUS
freetube_database   postgres:15-alpine   "docker-entrypoint.s…"   database   X minutes ago    Up X minutes (healthy)   0.0.0.0:5432->5432/tcp
freetube_adminer    adminer:latest       "entrypoint.sh php -…"   adminer    X minutes ago    Up X minutes             0.0.0.0:8080->8080/tcp
```

---

## 🌐 Étape 2 : Accès à l'interface web

### Ouvrir Adminer dans le navigateur :

**URL :** http://localhost:8080

---

## 🔐 Étape 3 : Connexion à la base de données

### Paramètres de connexion :

| Champ | Valeur |
|-------|--------|
| **Système** | PostgreSQL |
| **Serveur** | `localhost` |
| **Utilisateur** | `freetube_user` |
| **Mot de passe** | `freetube_password` |
| **Base de données** | `freetube_db` |

### Capture d'écran des paramètres :
```
┌─────────────────────────────────────┐
│ Système: [PostgreSQL ▼]             │
│ Serveur: [localhost            ]    │
│ Utilisateur: [freetube_user    ]    │
│ Mot de passe: [freetube_password]   │
│ Base de données: [freetube_db  ]    │
│                                     │
│ [Se connecter]                      │
└─────────────────────────────────────┘
```

---

## ✅ Étape 4 : Vérification de la connexion

### Une fois connecté, vous devriez voir :

1. **11 tables** dans la base de données :
   - `utilisateurs`
   - `chaines`
   - `videos`
   - `commentaires`
   - `likes`
   - `abonnements`
   - `playlists`
   - `playlist_videos`
   - `historique_visionnage`
   - `sessions`
   - `statistiques_videos`

2. **Données de test** disponibles :
   - 7 utilisateurs (admin, créateurs, viewers)
   - 3 chaînes (Tech, Gaming, Cuisine)
   - 7 vidéos avec métadonnées
   - Commentaires, likes, abonnements

---

## 🔍 Étape 5 : Explorer les données

### Requêtes utiles à tester :

```sql
-- Voir tous les utilisateurs
SELECT nom_utilisateur, email, nom_affichage, statut FROM utilisateurs;

-- Voir les chaînes avec leurs créateurs
SELECT c.nom_affichage as chaine, u.nom_utilisateur as createur, c.nombre_abonnes 
FROM chaines c 
JOIN utilisateurs u ON c.utilisateur_id = u.id;

-- Voir les vidéos les plus populaires
SELECT titre, nombre_vues, nombre_likes, date_publication 
FROM videos 
ORDER BY nombre_vues DESC;

-- Voir les commentaires récents
SELECT u.nom_utilisateur, v.titre, c.contenu, c.date_creation
FROM commentaires c
JOIN utilisateurs u ON c.utilisateur_id = u.id
JOIN videos v ON c.video_id = v.id
ORDER BY c.date_creation DESC;
```

---

## 🛠️ Dépannage

### Problème : "Connexion refusée"

**Solutions :**

1. **Vérifier que les services sont actifs :**
   ```bash
   docker-compose ps
   ```

2. **Vérifier les logs :**
   ```bash
   docker-compose logs database
   docker-compose logs adminer
   ```

3. **Redémarrer les services :**
   ```bash
   docker-compose restart database adminer
   ```

### Problème : "Base de données vide"

**Solution - Exécuter les migrations manuellement :**

```bash
# Créer les tables
docker-compose exec database psql -U freetube_user -d freetube_db -f /docker-entrypoint-initdb.d/migrations/001_create_initial_schema.sql

# Ajouter les données de test
docker-compose exec database psql -U freetube_user -d freetube_db -f /docker-entrypoint-initdb.d/seeds/001_seed_test_data.sql
```

### Problème : Port 8080 déjà utilisé

**Solution - Changer le port :**

Modifier dans `docker-compose.yml` :
```yaml
adminer:
  ports:
    - "8081:8080"  # Utiliser le port 8081 au lieu de 8080
```

Puis accéder via : http://localhost:8081

---

## 📚 Fonctionnalités Adminer utiles

### Navigation :
- **Structure** : Voir le schéma des tables
- **Données** : Parcourir les enregistrements
- **Requête SQL** : Exécuter des requêtes personnalisées
- **Exporter** : Sauvegarder les données
- **Importer** : Charger des données

### Raccourcis clavier :
- `Ctrl + Enter` : Exécuter la requête SQL
- `Ctrl + S` : Sauvegarder la requête

---

## 🔒 Sécurité

⚠️ **Important :** Adminer est configuré pour le développement uniquement. En production :

1. Désactiver Adminer
2. Utiliser des connexions sécurisées (SSL)
3. Restreindre l'accès par IP
4. Utiliser des mots de passe forts

---

## 📞 Commandes de référence rapide

```bash
# Démarrer les services
docker-compose up database adminer -d

# Vérifier l'état
docker-compose ps

# Voir les logs
docker-compose logs adminer

# Arrêter les services
docker-compose down

# Redémarrer un service
docker-compose restart adminer
```

---

## 🎯 Résumé de la procédure complète

1. **Démarrer** : `docker-compose up database adminer -d`
2. **Ouvrir** : http://localhost:8080
3. **Connecter** : PostgreSQL / localhost / freetube_user / freetube_password / freetube_db
4. **Explorer** : 11 tables avec données de test
5. **Utiliser** : Interface graphique pour gérer la BDD

**Votre base de données Freetube est maintenant accessible et prête pour le développement ! 🎉**
