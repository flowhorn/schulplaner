Schulplaner Beta Web App

##BASICS:
Wie wird die App auf firebase-hosting published?
Mit folgendem Command:
1. Kompilieren der WebApp:
flutter build web
2. Build Ordner in web_app/public verschieben
3. Auf firebase-hosting deployen:
firebase deploy --only hosting:beta-web-app