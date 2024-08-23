#!/bin/bash

# Function to remove all Flatpak applications for the user
remove_flatpaks() {
    apps=$(flatpak list --columns=application --user)

    if [ -z "$apps" ]; then
        echo "No user Flatpak applications found."
        return
    fi

    echo "Found user Flatpak applications:"
    echo "$apps"

    echo "Uninstalling user Flatpak applications..."
    for app in $apps; do
        flatpak uninstall --delete-data --user "$app"
    done
}

# Remove all Flatpak applications
remove_flatpaks

# Remove remaining Flatpak data
echo "Removing application data..."
rm -rf ~/.var/app/*

echo "Removing configuration files..."
rm -rf ~/.config/flatpak/*

echo "Removing cache files..."
rm -rf ~/.cache/flatpak/*

echo "Removing desktop entry files..."
rm -f ~/.local/share/flatpak/exports/share/applications/*

echo "Cleanup completed."

# Verify that no Flatpak applications remain
echo "Remaining Flatpak applications for user:"
flatpak list --user
