#!/bin/bash

# Script de construction d'ArchimedeOS
# Ce script utilise mkarchiso pour créer une image ISO personnalisée

# Arrêt du script en cas d'erreur
set -e

# Vérification des dépendances
if ! command -v mkarchiso &> /dev/null; then
    echo "Erreur: mkarchiso n'est pas installé. Veuillez installer archiso."
    exit 1
fi

# Vérification des permissions
if [ "$EUID" -ne 0 ]; then
    echo "Erreur: Ce script doit être exécuté en tant que root (sudo)"
    exit 1
fi

# Définition des variables
WORK_DIR="./work"
OUTPUT_DIR="./out"
ISO_DIR="../iso"

# Nettoyage des répertoires de travail existants
echo "Nettoyage des répertoires de travail..."
rm -rf "$WORK_DIR" "$OUTPUT_DIR"

# Création de l'ISO
echo "Début de la construction de l'ISO..."
if mkarchiso -v -w "$WORK_DIR" -o "$OUTPUT_DIR" "$ISO_DIR"; then
    echo "Construction de l'ISO terminée avec succès !"
    echo "L'image ISO se trouve dans le répertoire: $OUTPUT_DIR"
else
    echo "Erreur lors de la construction de l'ISO"
    exit 1
fi
