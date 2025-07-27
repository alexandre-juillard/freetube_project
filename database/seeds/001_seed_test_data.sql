-- Seed Data 001: Données de test pour Freetube
-- Date: 2025-01-27
-- Description: Jeu de données de test pour développement et tests

-- =============================================================================
-- UTILISATEURS DE TEST
-- =============================================================================

INSERT INTO utilisateurs (id, email, nom_utilisateur, mot_de_passe_hash, nom_affichage, photo_profil_url, email_verifie, statut) VALUES
-- Utilisateur admin
('550e8400-e29b-41d4-a716-446655440001', 'admin@freetube.com', 'admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VjPoyNdO2', 'Administrateur Freetube', 'https://via.placeholder.com/150/0000FF/FFFFFF?text=ADMIN', true, 'actif'),

-- Créateurs de contenu
('550e8400-e29b-41d4-a716-446655440002', 'marie.tech@email.com', 'marie_tech', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VjPoyNdO2', 'Marie Tech', 'https://via.placeholder.com/150/FF0000/FFFFFF?text=MT', true, 'actif'),

('550e8400-e29b-41d4-a716-446655440003', 'pierre.gaming@email.com', 'pierre_gaming', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VjPoyNdO2', 'Pierre Gaming', 'https://via.placeholder.com/150/00FF00/FFFFFF?text=PG', true, 'actif'),

('550e8400-e29b-41d4-a716-446655440004', 'sophie.cuisine@email.com', 'sophie_cuisine', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VjPoyNdO2', 'Sophie Cuisine', 'https://via.placeholder.com/150/FFFF00/000000?text=SC', true, 'actif'),

-- Utilisateurs OAuth (Google)
('550e8400-e29b-41d4-a716-446655440005', 'julien.oauth@gmail.com', 'julien_oauth', NULL, 'Julien OAuth', 'https://via.placeholder.com/150/FF00FF/FFFFFF?text=JO', true, 'actif'),

-- Utilisateurs standards
('550e8400-e29b-41d4-a716-446655440006', 'alice.viewer@email.com', 'alice_viewer', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VjPoyNdO2', 'Alice Viewer', 'https://via.placeholder.com/150/00FFFF/000000?text=AV', true, 'actif'),

('550e8400-e29b-41d4-a716-446655440007', 'bob.watcher@email.com', 'bob_watcher', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VjPoyNdO2', 'Bob Watcher', 'https://via.placeholder.com/150/FFA500/FFFFFF?text=BW', true, 'actif');

-- Mettre à jour les Google ID pour l'utilisateur OAuth
UPDATE utilisateurs SET google_id = '123456789012345678901' WHERE id = '550e8400-e29b-41d4-a716-446655440005';

-- =============================================================================
-- CHAÎNES DE TEST
-- =============================================================================

INSERT INTO chaines (id, utilisateur_id, nom_affichage, description, photo_profil_url, banniere_url, nombre_abonnes, nombre_videos) VALUES
-- Chaîne de Marie Tech
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'Tech avec Marie', 'Chaîne dédiée aux tutoriels de développement web et aux nouvelles technologies. Apprenez Angular, React, Node.js et bien plus !', 'https://via.placeholder.com/150/FF0000/FFFFFF?text=TECH', 'https://via.placeholder.com/1200x300/FF0000/FFFFFF?text=TECH+AVEC+MARIE', 1250, 15),

-- Chaîne de Pierre Gaming
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', 'Pierre Gaming Pro', 'Gaming, tests de jeux vidéo, live streams et guides pour devenir un pro gamer !', 'https://via.placeholder.com/150/00FF00/FFFFFF?text=GAMING', 'https://via.placeholder.com/1200x300/00FF00/FFFFFF?text=PIERRE+GAMING+PRO', 2340, 28),

-- Chaîne de Sophie Cuisine
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', 'Cuisine de Sophie', 'Recettes faciles, astuces de chef et découvertes culinaires du monde entier !', 'https://via.placeholder.com/150/FFFF00/000000?text=CUISINE', 'https://via.placeholder.com/1200x300/FFFF00/000000?text=CUISINE+DE+SOPHIE', 890, 22);

-- =============================================================================
-- VIDÉOS DE TEST
-- =============================================================================

INSERT INTO videos (id, chaine_id, titre, description, fichier_video_url, miniature_url, duree_secondes, taille_fichier, format_video, resolution, visibilite, statut, nombre_vues, nombre_likes, nombre_dislikes, nombre_commentaires, date_publication) VALUES

-- Vidéos de Marie Tech
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'Angular 17 : Les nouveautés à connaître', 'Découvrez toutes les nouveautés d''Angular 17 : standalone components, signals, control flow et bien plus ! Un tutoriel complet pour les développeurs.', 'https://storage.freetube.com/videos/angular17-nouveautes.mp4', 'https://storage.freetube.com/thumbnails/angular17-thumb.jpg', 1245, 125000000, 'mp4', '1080p', 'public', 'active', 3420, 156, 8, 23, CURRENT_TIMESTAMP - INTERVAL '5 days'),

('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', 'NestJS : Créer une API REST sécurisée', 'Apprenez à créer une API REST complète avec NestJS, JWT, validation et documentation Swagger. Parfait pour les débutants !', 'https://storage.freetube.com/videos/nestjs-api-rest.mp4', 'https://storage.freetube.com/thumbnails/nestjs-thumb.jpg', 2180, 218000000, 'mp4', '1080p', 'public', 'active', 2890, 134, 5, 31, CURRENT_TIMESTAMP - INTERVAL '3 days'),

('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', 'Docker pour les développeurs', 'Maîtrisez Docker et Docker Compose pour vos projets de développement. De l''installation au déploiement !', 'https://storage.freetube.com/videos/docker-developpeurs.mp4', 'https://storage.freetube.com/thumbnails/docker-thumb.jpg', 1890, 189000000, 'mp4', '1080p', 'public', 'active', 4120, 201, 12, 45, CURRENT_TIMESTAMP - INTERVAL '1 day'),

-- Vidéos de Pierre Gaming
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440002', 'Test : Cyberpunk 2077 après les mises à jour', 'Test complet de Cyberpunk 2077 en 2025. Le jeu a-t-il tenu ses promesses ? Mon avis après 50h de jeu !', 'https://storage.freetube.com/videos/cyberpunk-test.mp4', 'https://storage.freetube.com/thumbnails/cyberpunk-thumb.jpg', 1650, 165000000, 'mp4', '1080p', 'public', 'active', 8750, 412, 28, 89, CURRENT_TIMESTAMP - INTERVAL '7 days'),

('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440002', 'Live : Découverte de Baldur''s Gate 3', 'Première découverte de Baldur''s Gate 3 en live ! Création de personnage et premières heures de jeu.', 'https://storage.freetube.com/videos/baldurs-gate-live.mp4', 'https://storage.freetube.com/thumbnails/baldurs-gate-thumb.jpg', 7200, 720000000, 'mp4', '1080p', 'public', 'active', 5420, 298, 15, 67, CURRENT_TIMESTAMP - INTERVAL '2 days'),

-- Vidéos de Sophie Cuisine
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440003', 'Pâtes carbonara authentiques', 'La vraie recette des pâtes carbonara comme en Italie ! Ingrédients, technique et astuces de chef.', 'https://storage.freetube.com/videos/carbonara-authentique.mp4', 'https://storage.freetube.com/thumbnails/carbonara-thumb.jpg', 890, 89000000, 'mp4', '1080p', 'public', 'active', 6230, 287, 9, 52, CURRENT_TIMESTAMP - INTERVAL '4 days'),

('770e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440003', 'Desserts de Noël faciles', 'Mes 5 desserts de Noël préférés, faciles à réaliser et qui impressionnent toujours !', 'https://storage.freetube.com/videos/desserts-noel.mp4', 'https://storage.freetube.com/thumbnails/desserts-noel-thumb.jpg', 1420, 142000000, 'mp4', '1080p', 'public', 'active', 4890, 234, 6, 38, CURRENT_TIMESTAMP - INTERVAL '6 days');

-- =============================================================================
-- ABONNEMENTS DE TEST
-- =============================================================================

INSERT INTO abonnements (utilisateur_id, chaine_id, date_abonnement, notifications_actives) VALUES
-- Alice s'abonne à toutes les chaînes
('550e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440001', CURRENT_TIMESTAMP - INTERVAL '30 days', true),
('550e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440002', CURRENT_TIMESTAMP - INTERVAL '25 days', true),
('550e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440003', CURRENT_TIMESTAMP - INTERVAL '20 days', false),

-- Bob s'abonne à Pierre Gaming et Sophie Cuisine
('550e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440002', CURRENT_TIMESTAMP - INTERVAL '15 days', true),
('550e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440003', CURRENT_TIMESTAMP - INTERVAL '10 days', true),

-- Julien s'abonne à Marie Tech
('550e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440001', CURRENT_TIMESTAMP - INTERVAL '5 days', true),

-- Les créateurs s'abonnent entre eux
('550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', CURRENT_TIMESTAMP - INTERVAL '40 days', true),
('550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', CURRENT_TIMESTAMP - INTERVAL '35 days', true),
('550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440002', CURRENT_TIMESTAMP - INTERVAL '30 days', true);

-- =============================================================================
-- LIKES DE TEST
-- =============================================================================

INSERT INTO likes (utilisateur_id, video_id, commentaire_id, type_like, date_creation) VALUES
-- Likes sur les vidéos de Marie Tech
('550e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440001', NULL, 'like', CURRENT_TIMESTAMP - INTERVAL '4 days'),
('550e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440001', NULL, 'like', CURRENT_TIMESTAMP - INTERVAL '4 days'),
('550e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440002', NULL, 'like', CURRENT_TIMESTAMP - INTERVAL '2 days'),

-- Likes sur les vidéos de Pierre Gaming
('550e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440004', NULL, 'like', CURRENT_TIMESTAMP - INTERVAL '6 days'),
('550e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440005', NULL, 'like', CURRENT_TIMESTAMP - INTERVAL '1 day'),

-- Likes sur les vidéos de Sophie Cuisine
('550e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440006', NULL, 'like', CURRENT_TIMESTAMP - INTERVAL '3 days'),
('550e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440007', NULL, 'like', CURRENT_TIMESTAMP - INTERVAL '5 days');

-- =============================================================================
-- COMMENTAIRES DE TEST
-- =============================================================================

INSERT INTO commentaires (id, video_id, utilisateur_id, commentaire_parent_id, contenu, nombre_likes, date_creation) VALUES
-- Commentaires sur la vidéo Angular de Marie
('880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', NULL, 'Excellent tutoriel ! Les signals d''Angular 17 sont vraiment révolutionnaires. Merci Marie !', 12, CURRENT_TIMESTAMP - INTERVAL '4 days'),

('880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440007', NULL, 'Très bien expliqué, j''ai enfin compris les standalone components !', 8, CURRENT_TIMESTAMP - INTERVAL '4 days'),

-- Réponse au premier commentaire
('880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440001', 'Merci Alice ! Content que ça t''ait aidé 😊', 5, CURRENT_TIMESTAMP - INTERVAL '3 days'),

-- Commentaires sur la vidéo Cyberpunk de Pierre
('880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440006', NULL, 'Enfin un test honnête ! Le jeu s''est vraiment amélioré depuis le lancement.', 15, CURRENT_TIMESTAMP - INTERVAL '6 days'),

('880e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440007', NULL, 'J''hésite encore à l''acheter... Ça vaut le coup maintenant ?', 3, CURRENT_TIMESTAMP - INTERVAL '5 days'),

-- Commentaires sur la recette carbonara de Sophie
('880e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440006', NULL, 'J''ai testé ta recette hier soir, un délice ! Ma famille a adoré 👨‍🍳', 18, CURRENT_TIMESTAMP - INTERVAL '3 days'),

('880e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440005', NULL, 'Merci pour les astuces, surtout celle sur les œufs !', 7, CURRENT_TIMESTAMP - INTERVAL '2 days');

-- =============================================================================
-- PLAYLISTS DE TEST (en plus des playlists par défaut créées automatiquement)
-- =============================================================================

INSERT INTO playlists (id, utilisateur_id, nom, description, visibilite, est_defaut, nombre_videos) VALUES
-- Playlists d'Alice
('990e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', 'Mes tutos préférés', 'Collection de mes tutoriels favoris pour apprendre', 'public', false, 2),
('990e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440006', 'Gaming détente', 'Vidéos gaming pour se détendre le soir', 'prive', false, 1),

-- Playlists de Bob
('990e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440007', 'Recettes à tester', 'Recettes que je veux absolument essayer', 'prive', false, 2);

-- =============================================================================
-- PLAYLIST_VIDEOS DE TEST
-- =============================================================================

INSERT INTO playlist_videos (playlist_id, video_id, ordre, date_ajout) VALUES
-- Playlist "Mes tutos préférés" d'Alice
('990e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 1, CURRENT_TIMESTAMP - INTERVAL '3 days'),
('990e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440002', 2, CURRENT_TIMESTAMP - INTERVAL '2 days'),

-- Playlist "Gaming détente" d'Alice
('990e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440005', 1, CURRENT_TIMESTAMP - INTERVAL '1 day'),

-- Playlist "Recettes à tester" de Bob
('990e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440006', 1, CURRENT_TIMESTAMP - INTERVAL '3 days'),
('990e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440007', 2, CURRENT_TIMESTAMP - INTERVAL '2 days');

-- =============================================================================
-- HISTORIQUE DE VISIONNAGE DE TEST
-- =============================================================================

INSERT INTO historique_visionnage (utilisateur_id, video_id, duree_visionnee, pourcentage_visionne, date_visionnage) VALUES
-- Historique d'Alice
('550e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440001', 1245, 100.00, CURRENT_TIMESTAMP - INTERVAL '4 days'),
('550e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440002', 1890, 86.70, CURRENT_TIMESTAMP - INTERVAL '3 days'),
('550e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440006', 890, 100.00, CURRENT_TIMESTAMP - INTERVAL '2 days'),

-- Historique de Bob
('550e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440004', 1200, 72.73, CURRENT_TIMESTAMP - INTERVAL '5 days'),
('550e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440005', 3600, 50.00, CURRENT_TIMESTAMP - INTERVAL '1 day'),

-- Historique de Julien
('550e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440002', 2180, 100.00, CURRENT_TIMESTAMP - INTERVAL '2 days'),
('550e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440003', 945, 50.00, CURRENT_TIMESTAMP - INTERVAL '1 day');

-- =============================================================================
-- STATISTIQUES VIDÉOS DE TEST
-- =============================================================================

INSERT INTO statistiques_videos (video_id, date_statistique, nombre_vues, nombre_likes, nombre_dislikes, nombre_commentaires, duree_moyenne_visionnage) VALUES
-- Statistiques pour la vidéo Angular de Marie (derniers 7 jours)
('770e8400-e29b-41d4-a716-446655440001', CURRENT_DATE - INTERVAL '7 days', 420, 18, 1, 3, 1100),
('770e8400-e29b-41d4-a716-446655440001', CURRENT_DATE - INTERVAL '6 days', 680, 35, 2, 8, 1150),
('770e8400-e29b-41d4-a716-446655440001', CURRENT_DATE - INTERVAL '5 days', 890, 52, 3, 12, 1180),
('770e8400-e29b-41d4-a716-446655440001', CURRENT_DATE - INTERVAL '4 days', 1200, 78, 4, 18, 1200),
('770e8400-e29b-41d4-a716-446655440001', CURRENT_DATE - INTERVAL '3 days', 1580, 98, 5, 21, 1210),
('770e8400-e29b-41d4-a716-446655440001', CURRENT_DATE - INTERVAL '2 days', 2100, 125, 6, 23, 1220),
('770e8400-e29b-41d4-a716-446655440001', CURRENT_DATE - INTERVAL '1 day', 2890, 156, 8, 23, 1225),

-- Statistiques pour la vidéo Cyberpunk de Pierre (derniers 7 jours)
('770e8400-e29b-41d4-a716-446655440004', CURRENT_DATE - INTERVAL '7 days', 1200, 45, 3, 12, 1400),
('770e8400-e29b-41d4-a716-446655440004', CURRENT_DATE - INTERVAL '6 days', 2100, 89, 8, 25, 1420),
('770e8400-e29b-41d4-a716-446655440004', CURRENT_DATE - INTERVAL '5 days', 3500, 156, 12, 45, 1380),
('770e8400-e29b-41d4-a716-446655440004', CURRENT_DATE - INTERVAL '4 days', 5200, 234, 18, 67, 1350),
('770e8400-e29b-41d4-a716-446655440004', CURRENT_DATE - INTERVAL '3 days', 6800, 312, 22, 78, 1340),
('770e8400-e29b-41d4-a716-446655440004', CURRENT_DATE - INTERVAL '2 days', 7900, 378, 25, 85, 1330),
('770e8400-e29b-41d4-a716-446655440004', CURRENT_DATE - INTERVAL '1 day', 8750, 412, 28, 89, 1320);

-- =============================================================================
-- MISE À JOUR DES COMPTEURS
-- =============================================================================

-- Mise à jour des compteurs de chaînes
UPDATE chaines SET 
    nombre_abonnes = (SELECT COUNT(*) FROM abonnements WHERE chaine_id = chaines.id),
    nombre_videos = (SELECT COUNT(*) FROM videos WHERE chaine_id = chaines.id AND statut = 'active');

-- Mise à jour des compteurs de playlists
UPDATE playlists SET 
    nombre_videos = (SELECT COUNT(*) FROM playlist_videos WHERE playlist_id = playlists.id);

-- =============================================================================
-- VÉRIFICATIONS
-- =============================================================================

-- Vérifier que les données ont été insérées correctement
SELECT 'Utilisateurs créés: ' || COUNT(*) as info FROM utilisateurs
UNION ALL
SELECT 'Chaînes créées: ' || COUNT(*) FROM chaines
UNION ALL
SELECT 'Vidéos créées: ' || COUNT(*) FROM videos
UNION ALL
SELECT 'Commentaires créés: ' || COUNT(*) FROM commentaires
UNION ALL
SELECT 'Likes créés: ' || COUNT(*) FROM likes
UNION ALL
SELECT 'Abonnements créés: ' || COUNT(*) FROM abonnements
UNION ALL
SELECT 'Playlists créées: ' || COUNT(*) FROM playlists
UNION ALL
SELECT 'Historique créé: ' || COUNT(*) FROM historique_visionnage;

-- Seed data terminé
SELECT 'Seed data 001 terminé avec succès' as status;
