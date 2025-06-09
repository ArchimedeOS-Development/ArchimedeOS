#!/bin/bash

# Script de restauration d'ArchimedeOS
# Ce script nettoie les répertoires de travail et de sortie

# Arrêt du script en cas d'erreur
set -e

# Vérification des permissions
if [ "$EUID" -ne 0 ]; then
    echo "Erreur: Ce script doit être exécuté en tant que root (sudo)"
    exit 1
fi

# Définition des répertoires à nettoyer
WORK_DIR="work"
OUTPUT_DIR="out"

# Vérification de l'existence des répertoires
echo "Vérification des répertoires à nettoyer..."
if [ ! -d "$WORK_DIR" ] && [ ! -d "$OUTPUT_DIR" ]; then
    echo "Les répertoires de travail sont déjà propres."
    exit 0
fi

# Nettoyage des répertoires
echo "Nettoyage en cours..."
if [ -d "$WORK_DIR" ]; then
    echo "Suppression du répertoire de travail ($WORK_DIR)..."
    rm -rf "$WORK_DIR"
fi

if [ -d "$OUTPUT_DIR" ]; then
    echo "Suppression du répertoire de sortie ($OUTPUT_DIR)..."
    rm -rf "$OUTPUT_DIR"
fi

echo "Nettoyage terminé avec succès !"
