#!/bin/bash
# Script d'initialisation de la base de données Freetube
# Ce script est exécuté automatiquement par Docker lors du premier démarrage

set -e

echo "🚀 Initialisation de la base de données Freetube..."

# Variables d'environnement
DB_NAME=${POSTGRES_DB:-freetube_db}
DB_USER=${POSTGRES_USER:-freetube_user}

echo "📋 Base de données: $DB_NAME"
echo "👤 Utilisateur: $DB_USER"

# Exécution des migrations dans l'ordre
echo "🔧 Exécution des migrations..."
for migration in /docker-entrypoint-initdb.d/migrations/*.sql; do
    if [ -f "$migration" ]; then
        echo "   ➤ Exécution de $(basename "$migration")"
        psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_NAME" -f "$migration"
    fi
done

# Exécution des seeds si en mode développement
if [ "${NODE_ENV:-development}" = "development" ]; then
    echo "🌱 Insertion des données de test..."
    for seed in /docker-entrypoint-initdb.d/seeds/*.sql; do
        if [ -f "$seed" ]; then
            echo "   ➤ Exécution de $(basename "$seed")"
            psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_NAME" -f "$seed"
        fi
    done
else
    echo "⚠️  Mode production détecté - pas d'insertion de données de test"
fi

echo "✅ Initialisation terminée avec succès!"

# Affichage des statistiques
echo "📊 Statistiques de la base de données:"
psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_NAME" -c "
    SELECT 
        schemaname,
        tablename,
        n_tup_ins as insertions,
        n_tup_upd as updates,
        n_tup_del as deletions
    FROM pg_stat_user_tables 
    ORDER BY tablename;
"

echo "🎉 Base de données Freetube prête à l'emploi!"
