# 🎬 Freetube - Plateforme de partage vidéo

## 📋 Description

Freetube est une alternative moderne à YouTube développée pour l'entreprise Framinfo. Cette plateforme permet aux créateurs de contenu de partager leurs vidéos et aux utilisateurs de les découvrir et interagir avec elles.

## 🚀 Technologies utilisées

- **Frontend** : Angular 20+ avec TypeScript
- **Backend** : NestJS avec Node.js
- **Base de données** : PostgreSQL
- **Containerisation** : Docker & Docker Compose
- **Authentification** : JWT + OAuth2 (Google, Microsoft)

## 🏗️ Architecture

```
freetube/
├── frontend/          # Application Angular
├── backend/           # API NestJS
├── database/          # Scripts SQL et migrations
├── docker/            # Fichiers Docker
├── docs/              # Documentation
└── docker-compose.yml # Configuration des services
```

## 📦 Installation

### Prérequis

- Node.js (v18+)
- npm (v8+)
- Docker & Docker Compose
- Git

### Installation rapide

```bash
# Cloner le repository
git clone https://github.com/alexandre-juillard/freetube_project.git
cd freetube_project

# Installer les dépendances
npm install

# Lancer avec Docker
npm run docker:up
```

## 🛠️ Développement

### Scripts disponibles

```bash
# Développement
npm run dev:frontend    # Lancer le frontend Angular
npm run dev:backend     # Lancer l'API NestJS

# Build
npm run build:frontend  # Build de production Angular
npm run build:backend   # Build de production NestJS

# Tests
npm run test:frontend   # Tests unitaires Angular
npm run test:backend    # Tests unitaires NestJS

# Docker
npm run docker:up       # Lancer tous les services
npm run docker:down     # Arrêter tous les services
npm run docker:build    # Rebuild les images
```

### Développement local

1. **Frontend** (port 4200)
   ```bash
   cd frontend
   ng serve
   ```

2. **Backend** (port 3000)
   ```bash
   cd backend
   npm run start:dev
   ```

3. **Base de données** (port 5432)
   ```bash
   docker-compose up database
   ```

## 🔐 Sécurité

- Authentification JWT sécurisée
- Validation stricte des données
- Protection CORS configurée
- Chiffrement des mots de passe (bcrypt)
- Headers de sécurité (Helmet.js)

## 📚 Documentation

- [Roadmap du projet](./ROADMAP.md)
- [Cahier des charges](./CDC.md)
- [Bonnes pratiques](./best-practices.md)
- Documentation API : `http://localhost:3000/api` (Swagger)

## 🚦 Statut du projet

- [x] Phase 1 : Configuration environnement
- [ ] Phase 2 : Base de données
- [ ] Phase 3 : Backend API
- [ ] Phase 4 : Frontend Angular
- [ ] Phase 5 : Intégration
- [ ] Phase 6 : Containerisation
- [ ] Phase 7 : Tests et finalisation

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Équipe

Développé par l'équipe Framinfo

---

**Version** : 1.0.0  
**Dernière mise à jour** : Janvier 2025
