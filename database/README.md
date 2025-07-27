# 🗄️ Base de données Freetube

## 📋 Vue d'ensemble

Ce dossier contient tous les éléments liés à la base de données PostgreSQL de Freetube :
- Schéma et conception
- Migrations SQL
- Données de test (seeds)
- Scripts d'initialisation
- Documentation

## 🏗️ Structure

```
database/
├── README.md                    # Ce fichier
├── schema-design.md            # Documentation du schéma
├── migrations/                 # Scripts de migration
│   └── 001_create_initial_schema.sql
├── seeds/                      # Données de test
│   └── 001_seed_test_data.sql
└── init-scripts/              # Scripts d'initialisation Docker
    └── 01-init-database.sh
```

## 🚀 Démarrage rapide

### Lancer la base de données avec Docker

```bash
# Depuis la racine du projet
docker-compose up database -d

# Vérifier que la base est prête
docker-compose logs database
```

### Accéder à la base de données

```bash
# Via Docker
docker-compose exec database psql -U freetube_user -d freetube_db

# Via client local (si PostgreSQL installé)
psql -h localhost -p 5432 -U freetube_user -d freetube_db
```

### Interface web (Adminer)

```bash
# Lancer Adminer pour le développement
docker-compose --profile development up adminer -d

# Accéder à http://localhost:8080
# Serveur: database
# Utilisateur: freetube_user
# Mot de passe: freetube_password
# Base: freetube_db
```

## 📊 Schéma de base de données

### Tables principales

| Table | Description | Relations |
|-------|-------------|-----------|
| `utilisateurs` | Comptes utilisateurs | → `chaines`, `sessions` |
| `chaines` | Chaînes des créateurs | ← `utilisateurs`, → `videos` |
| `videos` | Contenu vidéo | ← `chaines`, → `commentaires` |
| `commentaires` | Commentaires sur vidéos | ← `videos`, ← `utilisateurs` |
| `likes` | Likes/dislikes | ← `videos`, ← `commentaires` |
| `abonnements` | Relations utilisateur ↔ chaîne | ← `utilisateurs`, ← `chaines` |
| `playlists` | Collections de vidéos | ← `utilisateurs` |
| `playlist_videos` | Liaison playlist ↔ vidéo | ← `playlists`, ← `videos` |
| `historique_visionnage` | Historique utilisateur | ← `utilisateurs`, ← `videos` |
| `sessions` | Sessions actives | ← `utilisateurs` |
| `statistiques_videos` | Métriques quotidiennes | ← `videos` |

### Vues utiles

- `vue_videos_avec_chaine` : Vidéos avec infos chaîne
- `vue_statistiques_chaines` : Stats agrégées par chaîne

## 🔧 Migrations

### Exécuter une migration

```bash
# Les migrations sont automatiquement exécutées au démarrage Docker
# Pour exécuter manuellement :
docker-compose exec database psql -U freetube_user -d freetube_db -f /docker-entrypoint-initdb.d/migrations/001_create_initial_schema.sql
```

### Créer une nouvelle migration

1. Créer un fichier `002_nom_migration.sql` dans `migrations/`
2. Suivre le format :
   ```sql
   -- Migration 002: Description
   -- Date: YYYY-MM-DD
   
   -- Vos modifications SQL ici
   
   SELECT 'Migration 002 terminée' as status;
   ```

## 🌱 Données de test

### Utilisateurs de test

| Email | Nom d'utilisateur | Mot de passe | Type |
|-------|------------------|--------------|------|
| admin@freetube.com | admin | password123 | Admin |
| marie.tech@email.com | marie_tech | password123 | Créateur |
| pierre.gaming@email.com | pierre_gaming | password123 | Créateur |
| sophie.cuisine@email.com | sophie_cuisine | password123 | Créateur |
| alice.viewer@email.com | alice_viewer | password123 | Viewer |
| bob.watcher@email.com | bob_watcher | password123 | Viewer |

### Réinitialiser les données

```bash
# Supprimer et recréer la base
docker-compose down -v
docker-compose up database -d
```

## 🔒 Sécurité

### Bonnes pratiques implémentées

- ✅ Mots de passe hashés avec bcrypt
- ✅ UUID pour éviter l'énumération
- ✅ Contraintes d'intégrité référentielle
- ✅ Index optimisés pour les requêtes
- ✅ Validation des données au niveau BDD
- ✅ Soft delete pour données critiques

### Variables d'environnement

```bash
# Copier .env.example vers .env et configurer :
POSTGRES_DB=freetube_db
POSTGRES_USER=freetube_user
POSTGRES_PASSWORD=your_secure_password
```

## 📈 Performance

### Index principaux

- Recherche full-text sur titres/descriptions
- Index composites pour requêtes fréquentes
- Index partiels pour optimiser l'espace

### Monitoring

```sql
-- Statistiques des tables
SELECT * FROM pg_stat_user_tables;

-- Requêtes lentes
SELECT * FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;

-- Taille des tables
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## 🐛 Dépannage

### Problèmes courants

**Base de données ne démarre pas**
```bash
# Vérifier les logs
docker-compose logs database

# Vérifier l'espace disque
docker system df
```

**Connexion refusée**
```bash
# Vérifier que le service est up
docker-compose ps database

# Tester la connexion
docker-compose exec database pg_isready -U freetube_user
```

**Données corrompues**
```bash
# Sauvegarder et restaurer
docker-compose exec database pg_dump -U freetube_user freetube_db > backup.sql
docker-compose down -v
docker-compose up database -d
docker-compose exec -T database psql -U freetube_user freetube_db < backup.sql
```

## 📚 Ressources

- [Documentation PostgreSQL](https://www.postgresql.org/docs/)
- [Guide des migrations](./migrations/README.md)
- [Schéma détaillé](./schema-design.md)
- [Roadmap du projet](../ROADMAP.md)
