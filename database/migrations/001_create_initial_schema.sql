-- Migration 001: Création du schéma initial Freetube
-- Date: 2025-01-27
-- Description: Tables principales pour utilisateurs, chaînes, vidéos et interactions

-- Extension pour UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- 1. TABLE UTILISATEURS
-- =============================================================================
CREATE TABLE utilisateurs (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email                 VARCHAR(255) UNIQUE NOT NULL,
    nom_utilisateur       VARCHAR(50) UNIQUE NOT NULL,
    mot_de_passe_hash     VARCHAR(255), -- NULL si OAuth uniquement
    nom_affichage         VARCHAR(100),
    photo_profil_url      VARCHAR(500),
    date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    derniere_connexion    TIMESTAMP,
    statut                VARCHAR(20) DEFAULT 'actif' CHECK (statut IN ('actif', 'suspendu', 'supprime')),
    type_compte           VARCHAR(20) DEFAULT 'standard' CHECK (type_compte IN ('standard', 'premium', 'admin')),
    email_verifie         BOOLEAN DEFAULT FALSE,
    
    -- OAuth2 fields
    google_id             VARCHAR(100) UNIQUE,
    microsoft_id          VARCHAR(100) UNIQUE,
    
    -- Métadonnées
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_utilisateurs_email ON utilisateurs(email);
CREATE INDEX idx_utilisateurs_nom_utilisateur ON utilisateurs(nom_utilisateur);
CREATE INDEX idx_utilisateurs_google_id ON utilisateurs(google_id) WHERE google_id IS NOT NULL;
CREATE INDEX idx_utilisateurs_microsoft_id ON utilisateurs(microsoft_id) WHERE microsoft_id IS NOT NULL;

-- =============================================================================
-- 2. TABLE CHAINES
-- =============================================================================
CREATE TABLE chaines (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    nom_affichage         VARCHAR(100) NOT NULL,
    description           TEXT,
    photo_profil_url      VARCHAR(500),
    banniere_url          VARCHAR(500),
    date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nombre_abonnes        INTEGER DEFAULT 0 CHECK (nombre_abonnes >= 0),
    nombre_videos         INTEGER DEFAULT 0 CHECK (nombre_videos >= 0),
    statut                VARCHAR(20) DEFAULT 'active' CHECK (statut IN ('active', 'suspendue')),
    
    -- Métadonnées
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Contrainte : un utilisateur ne peut avoir qu'une seule chaîne
    CONSTRAINT unique_utilisateur_chaine UNIQUE (utilisateur_id)
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_chaines_utilisateur ON chaines(utilisateur_id);
CREATE INDEX idx_chaines_nom_affichage ON chaines(nom_affichage);

-- =============================================================================
-- 3. TABLE VIDEOS
-- =============================================================================
CREATE TABLE videos (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chaine_id             UUID NOT NULL REFERENCES chaines(id) ON DELETE CASCADE,
    titre                 VARCHAR(200) NOT NULL,
    description           TEXT,
    fichier_video_url     VARCHAR(500) NOT NULL,
    miniature_url         VARCHAR(500),
    duree_secondes        INTEGER CHECK (duree_secondes > 0),
    taille_fichier        BIGINT CHECK (taille_fichier > 0), -- en bytes
    format_video          VARCHAR(10) CHECK (format_video IN ('mp4', 'webm', 'avi', 'mov')),
    resolution            VARCHAR(10) CHECK (resolution IN ('480p', '720p', '1080p', '1440p', '4K')),
    
    -- Visibilité et statut
    visibilite            VARCHAR(20) DEFAULT 'public' CHECK (visibilite IN ('public', 'prive', 'non_liste')),
    statut                VARCHAR(20) DEFAULT 'active' CHECK (statut IN ('active', 'en_traitement', 'supprimee')),
    
    -- Statistiques
    nombre_vues           INTEGER DEFAULT 0 CHECK (nombre_vues >= 0),
    nombre_likes          INTEGER DEFAULT 0 CHECK (nombre_likes >= 0),
    nombre_dislikes       INTEGER DEFAULT 0 CHECK (nombre_dislikes >= 0),
    nombre_commentaires   INTEGER DEFAULT 0 CHECK (nombre_commentaires >= 0),
    
    -- Dates
    date_upload           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_publication      TIMESTAMP, -- peut être différée
    date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Métadonnées
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les requêtes fréquentes et recherche
CREATE INDEX idx_videos_chaine_date ON videos(chaine_id, date_publication DESC NULLS LAST);
CREATE INDEX idx_videos_visibilite_statut ON videos(visibilite, statut);
CREATE INDEX idx_videos_date_publication ON videos(date_publication DESC NULLS LAST) WHERE statut = 'active';
CREATE INDEX idx_videos_titre_gin ON videos USING gin(to_tsvector('french', titre));
CREATE INDEX idx_videos_description_gin ON videos USING gin(to_tsvector('french', description));

-- =============================================================================
-- 4. TABLE COMMENTAIRES
-- =============================================================================
CREATE TABLE commentaires (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id              UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    commentaire_parent_id UUID REFERENCES commentaires(id) ON DELETE CASCADE, -- pour les réponses
    contenu               TEXT NOT NULL CHECK (LENGTH(contenu) > 0),
    nombre_likes          INTEGER DEFAULT 0 CHECK (nombre_likes >= 0),
    nombre_dislikes       INTEGER DEFAULT 0 CHECK (nombre_dislikes >= 0),
    statut                VARCHAR(20) DEFAULT 'active' CHECK (statut IN ('active', 'modere', 'supprime')),
    
    -- Dates
    date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Métadonnées
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_commentaires_video_date ON commentaires(video_id, date_creation DESC);
CREATE INDEX idx_commentaires_utilisateur ON commentaires(utilisateur_id);
CREATE INDEX idx_commentaires_parent ON commentaires(commentaire_parent_id) WHERE commentaire_parent_id IS NOT NULL;

-- =============================================================================
-- 5. TABLE LIKES
-- =============================================================================
CREATE TABLE likes (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    video_id              UUID REFERENCES videos(id) ON DELETE CASCADE,
    commentaire_id        UUID REFERENCES commentaires(id) ON DELETE CASCADE,
    type_like             VARCHAR(10) NOT NULL CHECK (type_like IN ('like', 'dislike')),
    date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Contraintes : un utilisateur ne peut liker qu'une fois le même contenu
    CONSTRAINT unique_video_like UNIQUE (utilisateur_id, video_id),
    CONSTRAINT unique_commentaire_like UNIQUE (utilisateur_id, commentaire_id),
    CONSTRAINT check_target CHECK (
        (video_id IS NOT NULL AND commentaire_id IS NULL) OR 
        (video_id IS NULL AND commentaire_id IS NOT NULL)
    )
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_likes_video_type ON likes(video_id, type_like) WHERE video_id IS NOT NULL;
CREATE INDEX idx_likes_commentaire_type ON likes(commentaire_id, type_like) WHERE commentaire_id IS NOT NULL;
CREATE INDEX idx_likes_utilisateur ON likes(utilisateur_id);

-- =============================================================================
-- 6. TABLE ABONNEMENTS
-- =============================================================================
CREATE TABLE abonnements (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    chaine_id             UUID NOT NULL REFERENCES chaines(id) ON DELETE CASCADE,
    date_abonnement       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notifications_actives BOOLEAN DEFAULT TRUE,
    
    -- Contrainte : un utilisateur ne peut s'abonner qu'une fois à une chaîne
    CONSTRAINT unique_abonnement UNIQUE (utilisateur_id, chaine_id)
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_abonnements_utilisateur ON abonnements(utilisateur_id);
CREATE INDEX idx_abonnements_chaine ON abonnements(chaine_id);
CREATE INDEX idx_abonnements_date ON abonnements(date_abonnement DESC);

-- =============================================================================
-- 7. TABLE PLAYLISTS
-- =============================================================================
CREATE TABLE playlists (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    nom                   VARCHAR(100) NOT NULL CHECK (LENGTH(nom) > 0),
    description           TEXT,
    visibilite            VARCHAR(20) DEFAULT 'prive' CHECK (visibilite IN ('public', 'prive')),
    est_defaut            BOOLEAN DEFAULT FALSE, -- pour "À consulter plus tard"
    nombre_videos         INTEGER DEFAULT 0 CHECK (nombre_videos >= 0),
    
    -- Dates
    date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Métadonnées
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_playlists_utilisateur ON playlists(utilisateur_id);
CREATE INDEX idx_playlists_defaut ON playlists(utilisateur_id, est_defaut) WHERE est_defaut = TRUE;

-- =============================================================================
-- 8. TABLE PLAYLIST_VIDEOS
-- =============================================================================
CREATE TABLE playlist_videos (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    playlist_id           UUID NOT NULL REFERENCES playlists(id) ON DELETE CASCADE,
    video_id              UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    ordre                 INTEGER NOT NULL CHECK (ordre > 0),
    date_ajout            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Contrainte : une vidéo ne peut être qu'une fois dans une playlist
    CONSTRAINT unique_playlist_video UNIQUE (playlist_id, video_id)
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_playlist_videos_playlist_ordre ON playlist_videos(playlist_id, ordre);
CREATE INDEX idx_playlist_videos_video ON playlist_videos(video_id);

-- =============================================================================
-- 9. TABLE HISTORIQUE_VISIONNAGE
-- =============================================================================
CREATE TABLE historique_visionnage (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    video_id              UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    duree_visionnee       INTEGER CHECK (duree_visionnee >= 0), -- en secondes
    pourcentage_visionne  DECIMAL(5,2) CHECK (pourcentage_visionne >= 0 AND pourcentage_visionne <= 100), -- 0.00 à 100.00
    date_visionnage       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_historique_utilisateur_date ON historique_visionnage(utilisateur_id, date_visionnage DESC);
CREATE INDEX idx_historique_video ON historique_visionnage(video_id);

-- =============================================================================
-- 10. TABLE SESSIONS
-- =============================================================================
CREATE TABLE sessions (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id        UUID NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    token_hash            VARCHAR(255) NOT NULL,
    adresse_ip            INET,
    user_agent            TEXT,
    date_creation         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration       TIMESTAMP NOT NULL,
    est_active            BOOLEAN DEFAULT TRUE
);

-- Index pour les requêtes de validation
CREATE INDEX idx_sessions_token ON sessions(token_hash);
CREATE INDEX idx_sessions_utilisateur ON sessions(utilisateur_id);
CREATE INDEX idx_sessions_expiration ON sessions(date_expiration) WHERE est_active = TRUE;

-- =============================================================================
-- 11. TABLE STATISTIQUES_VIDEOS
-- =============================================================================
CREATE TABLE statistiques_videos (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id              UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    date_statistique      DATE NOT NULL,
    nombre_vues           INTEGER DEFAULT 0 CHECK (nombre_vues >= 0),
    nombre_likes          INTEGER DEFAULT 0 CHECK (nombre_likes >= 0),
    nombre_dislikes       INTEGER DEFAULT 0 CHECK (nombre_dislikes >= 0),
    nombre_commentaires   INTEGER DEFAULT 0 CHECK (nombre_commentaires >= 0),
    duree_moyenne_visionnage INTEGER CHECK (duree_moyenne_visionnage >= 0), -- en secondes
    
    -- Contrainte : une seule entrée par vidéo par jour
    CONSTRAINT unique_video_date UNIQUE (video_id, date_statistique)
);

-- Index pour les requêtes d'analytics
CREATE INDEX idx_statistiques_video_date ON statistiques_videos(video_id, date_statistique DESC);
CREATE INDEX idx_statistiques_date ON statistiques_videos(date_statistique DESC);

-- =============================================================================
-- TRIGGERS POUR MISE À JOUR AUTOMATIQUE
-- =============================================================================

-- Fonction pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers pour updated_at
CREATE TRIGGER update_utilisateurs_updated_at BEFORE UPDATE ON utilisateurs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_chaines_updated_at BEFORE UPDATE ON chaines FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_videos_updated_at BEFORE UPDATE ON videos FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_commentaires_updated_at BEFORE UPDATE ON commentaires FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_playlists_updated_at BEFORE UPDATE ON playlists FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================================================
-- FONCTIONS UTILITAIRES
-- =============================================================================

-- Fonction pour créer une playlist par défaut
CREATE OR REPLACE FUNCTION creer_playlist_defaut()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO playlists (utilisateur_id, nom, description, est_defaut)
    VALUES (NEW.id, 'À consulter plus tard', 'Playlist par défaut pour sauvegarder des vidéos', TRUE);
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour créer automatiquement la playlist par défaut
CREATE TRIGGER trigger_creer_playlist_defaut 
    AFTER INSERT ON utilisateurs 
    FOR EACH ROW EXECUTE FUNCTION creer_playlist_defaut();

-- =============================================================================
-- VUES UTILES
-- =============================================================================

-- Vue pour les vidéos avec informations de chaîne
CREATE VIEW vue_videos_avec_chaine AS
SELECT 
    v.*,
    c.nom_affichage as nom_chaine,
    c.photo_profil_url as photo_chaine,
    u.nom_utilisateur as createur_nom_utilisateur
FROM videos v
JOIN chaines c ON v.chaine_id = c.id
JOIN utilisateurs u ON c.utilisateur_id = u.id
WHERE v.statut = 'active';

-- Vue pour les statistiques des chaînes
CREATE VIEW vue_statistiques_chaines AS
SELECT 
    c.id,
    c.nom_affichage,
    c.nombre_abonnes,
    c.nombre_videos,
    COALESCE(SUM(v.nombre_vues), 0) as total_vues,
    COALESCE(SUM(v.nombre_likes), 0) as total_likes,
    COALESCE(SUM(v.nombre_commentaires), 0) as total_commentaires
FROM chaines c
LEFT JOIN videos v ON c.id = v.chaine_id AND v.statut = 'active'
GROUP BY c.id, c.nom_affichage, c.nombre_abonnes, c.nombre_videos;

-- =============================================================================
-- COMMENTAIRES SUR LES TABLES
-- =============================================================================

COMMENT ON TABLE utilisateurs IS 'Table des comptes utilisateurs avec support OAuth2';
COMMENT ON TABLE chaines IS 'Table des chaînes Freetube (une par utilisateur)';
COMMENT ON TABLE videos IS 'Table des vidéos uploadées par les créateurs';
COMMENT ON TABLE commentaires IS 'Table des commentaires sur les vidéos (avec support réponses)';
COMMENT ON TABLE likes IS 'Table des likes/dislikes sur vidéos et commentaires';
COMMENT ON TABLE abonnements IS 'Table des abonnements utilisateur → chaîne';
COMMENT ON TABLE playlists IS 'Table des playlists utilisateur';
COMMENT ON TABLE playlist_videos IS 'Table de liaison playlist ↔ vidéo';
COMMENT ON TABLE historique_visionnage IS 'Table de l\'historique de visionnage utilisateur';
COMMENT ON TABLE sessions IS 'Table des sessions utilisateur actives';
COMMENT ON TABLE statistiques_videos IS 'Table des statistiques quotidiennes par vidéo';

-- Migration terminée
SELECT 'Migration 001 terminée avec succès' as status;
