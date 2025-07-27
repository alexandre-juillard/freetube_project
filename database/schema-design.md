# 🗄️ Conception du schéma de base de données - Freetube

## 📋 Analyse des besoins (basée sur CDC.md)

### Entités principales identifiées :

1. **Utilisateurs** - Comptes utilisateurs avec authentification
2. **Chaînes** - Chaînes Freetube des créateurs de contenu  
3. **Vidéos** - Contenu vidéo uploadé par les créateurs
4. **Commentaires** - Interactions sur les vidéos
5. **Likes** - Système de likes sur vidéos et commentaires
6. **Abonnements** - Relations utilisateur ↔ chaîne
7. **Playlists** - Collections de vidéos organisées par utilisateur
8. **Historique** - Historique de visionnage des utilisateurs
9. **Sessions** - Gestion des sessions utilisateur
10. **Statistiques** - Métriques et analytics

---

## 🎯 Diagramme Entité-Relations (ERD)

### 1. Table `utilisateurs`
```sql
utilisateurs {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  email                 VARCHAR(255) UNIQUE NOT NULL
  nom_utilisateur       VARCHAR(50) UNIQUE NOT NULL
  mot_de_passe_hash     VARCHAR(255) -- NULL si OAuth uniquement
  nom_affichage         VARCHAR(100)
  photo_profil_url      VARCHAR(500)
  date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  derniere_connexion    TIMESTAMP
  statut                VARCHAR(20) DEFAULT 'actif' -- actif, suspendu, supprime
  type_compte           VARCHAR(20) DEFAULT 'standard' -- standard, premium, admin
  email_verifie         BOOLEAN DEFAULT FALSE
  
  -- OAuth2 fields
  google_id             VARCHAR(100) UNIQUE
  microsoft_id          VARCHAR(100) UNIQUE
  
  -- Métadonnées
  created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

### 2. Table `chaines`
```sql
chaines {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE
  nom_affichage         VARCHAR(100) NOT NULL
  description           TEXT
  photo_profil_url      VARCHAR(500)
  banniere_url          VARCHAR(500)
  date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  nombre_abonnes        INTEGER DEFAULT 0
  nombre_videos         INTEGER DEFAULT 0
  statut                VARCHAR(20) DEFAULT 'active' -- active, suspendue
  
  -- Métadonnées
  created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

### 3. Table `videos`
```sql
videos {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  chaine_id             UUID NOT NULL REFERENCES chaines(id) ON DELETE CASCADE
  titre                 VARCHAR(200) NOT NULL
  description           TEXT
  fichier_video_url     VARCHAR(500) NOT NULL
  miniature_url         VARCHAR(500)
  duree_secondes        INTEGER
  taille_fichier        BIGINT -- en bytes
  format_video          VARCHAR(10) -- mp4, webm, avi
  resolution            VARCHAR(10) -- 720p, 1080p, 4K
  
  -- Visibilité et statut
  visibilite            VARCHAR(20) DEFAULT 'public' -- public, prive, non_liste
  statut                VARCHAR(20) DEFAULT 'active' -- active, en_traitement, supprimee
  
  -- Statistiques
  nombre_vues           INTEGER DEFAULT 0
  nombre_likes          INTEGER DEFAULT 0
  nombre_dislikes       INTEGER DEFAULT 0
  nombre_commentaires   INTEGER DEFAULT 0
  
  -- Dates
  date_upload           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  date_publication      TIMESTAMP -- peut être différée
  date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  
  -- Métadonnées
  created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

### 4. Table `commentaires`
```sql
commentaires {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  video_id              UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE
  utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE
  commentaire_parent_id UUID REFERENCES commentaires(id) ON DELETE CASCADE -- pour les réponses
  contenu               TEXT NOT NULL
  nombre_likes          INTEGER DEFAULT 0
  nombre_dislikes       INTEGER DEFAULT 0
  statut                VARCHAR(20) DEFAULT 'active' -- active, modere, supprime
  
  -- Dates
  date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  
  -- Métadonnées
  created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

### 5. Table `likes`
```sql
likes {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE
  video_id              UUID REFERENCES videos(id) ON DELETE CASCADE
  commentaire_id        UUID REFERENCES commentaires(id) ON DELETE CASCADE
  type_like             VARCHAR(10) NOT NULL -- like, dislike
  date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  
  -- Contraintes : un utilisateur ne peut liker qu'une fois le même contenu
  CONSTRAINT unique_video_like UNIQUE (utilisateur_id, video_id),
  CONSTRAINT unique_commentaire_like UNIQUE (utilisateur_id, commentaire_id),
  CONSTRAINT check_target CHECK (
    (video_id IS NOT NULL AND commentaire_id IS NULL) OR 
    (video_id IS NULL AND commentaire_id IS NOT NULL)
  )
}
```

### 6. Table `abonnements`
```sql
abonnements {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE
  chaine_id             UUID NOT NULL REFERENCES chaines(id) ON DELETE CASCADE
  date_abonnement       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  notifications_actives BOOLEAN DEFAULT TRUE
  
  -- Contrainte : un utilisateur ne peut s'abonner qu'une fois à une chaîne
  CONSTRAINT unique_abonnement UNIQUE (utilisateur_id, chaine_id)
}
```

### 7. Table `playlists`
```sql
playlists {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE
  nom                   VARCHAR(100) NOT NULL
  description           TEXT
  visibilite            VARCHAR(20) DEFAULT 'prive' -- public, prive
  est_defaut            BOOLEAN DEFAULT FALSE -- pour "À consulter plus tard"
  nombre_videos         INTEGER DEFAULT 0
  
  -- Dates
  date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  
  -- Métadonnées
  created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
}
```

### 8. Table `playlist_videos`
```sql
playlist_videos {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  playlist_id           UUID NOT NULL REFERENCES playlists(id) ON DELETE CASCADE
  video_id              UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE
  ordre                 INTEGER NOT NULL
  date_ajout            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  
  -- Contrainte : une vidéo ne peut être qu'une fois dans une playlist
  CONSTRAINT unique_playlist_video UNIQUE (playlist_id, video_id)
}
```

### 9. Table `historique_visionnage`
```sql
historique_visionnage {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE
  video_id              UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE
  duree_visionnee       INTEGER -- en secondes
  pourcentage_visionne  DECIMAL(5,2) -- 0.00 à 100.00
  date_visionnage       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  
  -- Index pour les requêtes fréquentes
  INDEX idx_historique_utilisateur_date (utilisateur_id, date_visionnage DESC)
}
```

### 10. Table `sessions`
```sql
sessions {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE
  token_hash            VARCHAR(255) NOT NULL
  adresse_ip            INET
  user_agent            TEXT
  date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  date_expiration       TIMESTAMP NOT NULL
  est_active            BOOLEAN DEFAULT TRUE
  
  -- Index pour les requêtes de validation
  INDEX idx_sessions_token (token_hash),
  INDEX idx_sessions_utilisateur (utilisateur_id)
}
```

### 11. Table `statistiques_videos`
```sql
statistiques_videos {
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid()
  video_id              UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE
  date_statistique      DATE NOT NULL
  nombre_vues           INTEGER DEFAULT 0
  nombre_likes          INTEGER DEFAULT 0
  nombre_dislikes       INTEGER DEFAULT 0
  nombre_commentaires   INTEGER DEFAULT 0
  duree_moyenne_visionnage INTEGER -- en secondes
  
  -- Contrainte : une seule entrée par vidéo par jour
  CONSTRAINT unique_video_date UNIQUE (video_id, date_statistique)
}
```

---

## 🔗 Relations principales

### Relations One-to-Many (1:N)
- `utilisateurs` → `chaines` (un utilisateur peut avoir une chaîne)
- `chaines` → `videos` (une chaîne peut avoir plusieurs vidéos)
- `videos` → `commentaires` (une vidéo peut avoir plusieurs commentaires)
- `commentaires` → `commentaires` (commentaires parents/enfants)
- `utilisateurs` → `playlists` (un utilisateur peut avoir plusieurs playlists)

### Relations Many-to-Many (N:M)
- `utilisateurs` ↔ `videos` (via `likes`)
- `utilisateurs` ↔ `commentaires` (via `likes`)
- `utilisateurs` ↔ `chaines` (via `abonnements`)
- `playlists` ↔ `videos` (via `playlist_videos`)
- `utilisateurs` ↔ `videos` (via `historique_visionnage`)

---

## 📊 Index et optimisations

### Index principaux
```sql
-- Recherche et performance
CREATE INDEX idx_videos_titre ON videos USING gin(to_tsvector('french', titre));
CREATE INDEX idx_videos_description ON videos USING gin(to_tsvector('french', description));
CREATE INDEX idx_videos_chaine_date ON videos(chaine_id, date_publication DESC);
CREATE INDEX idx_videos_visibilite_statut ON videos(visibilite, statut);

-- Statistiques et analytics
CREATE INDEX idx_likes_video_type ON likes(video_id, type_like);
CREATE INDEX idx_commentaires_video_date ON commentaires(video_id, date_creation DESC);
CREATE INDEX idx_abonnements_chaine ON abonnements(chaine_id);

-- Performance des requêtes utilisateur
CREATE INDEX idx_historique_utilisateur ON historique_visionnage(utilisateur_id, date_visionnage DESC);
CREATE INDEX idx_playlist_videos_ordre ON playlist_videos(playlist_id, ordre);
```

---

## 🔒 Sécurité et contraintes

### Contraintes de sécurité
- Tous les mots de passe sont hashés avec bcrypt (rounds=12)
- Les tokens de session ont une expiration forcée
- Les UUID sont utilisés pour éviter l'énumération
- Soft delete pour les données critiques

### Contraintes métier
- Un utilisateur ne peut avoir qu'une seule chaîne
- Les vidéos privées ne sont accessibles que par lien direct
- Les playlists par défaut ("À consulter plus tard") sont créées automatiquement
- Les statistiques sont agrégées quotidiennement

---

## 📈 Évolutivité

### Partitioning potentiel
- `historique_visionnage` par mois
- `statistiques_videos` par année
- `sessions` par semaine (avec purge automatique)

### Réplication
- Lecture/écriture séparées pour les statistiques
- Cache Redis pour les données fréquemment consultées
- CDN pour les fichiers média

Cette conception respecte les principes ACID et est optimisée pour les cas d'usage de Freetube.
