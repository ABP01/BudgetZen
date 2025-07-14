# BudgetZen - Application de Gestion Budgétaire 💰

## 🎨 Design Premium
Application mobile Flutter avec un design professionnel utilisant :
- **Couleurs** : #a28ef9 (Primary), #a4f5a6 (Success), #ffd89d (Warning), #eceef0 (Background)
- **Police** : Fustat (Regular & Medium)
- **Style** : UI moderne avec dégradés, animations fluides et composants premium

## 🏗 Architecture
- **Frontend** : Flutter avec Provider + GoRouter
- **Backend** : Node.js + Express + PostgreSQL
- **État** : Provider pattern pour la gestion d'état réactive
- **Navigation** : GoRouter avec routes shell et bottom navigation

## 📱 Fonctionnalités

### ✨ Interface Utilisateur
- **Splash Screen** : Animation d'ouverture élégante
- **Authentification** : Login/Register avec validation
- **Dashboard** : Vue d'ensemble avec statistiques en temps réel
- **Transactions** : Gestion complète des revenus/dépenses
- **Budget** : Suivi par catégorie avec alertes
- **Statistiques** : Graphiques et analyses personnalisées
- **Profil** : Paramètres utilisateur et déconnexion

### 🔧 Fonctionnalités Techniques
- **API REST** : Intégration complète avec le backend
- **Authentification** : Système de sessions sécurisé
- **Persistance** : SharedPreferences pour les données locales
- **Animations** : Transitions fluides et micro-interactions
- **Responsive** : Interface adaptée à tous les écrans

## 🚀 Installation et Démarrage

### Prérequis
- Flutter SDK (>= 3.0)
- Node.js (>= 16.0)
- PostgreSQL
- Git

### Installation Rapide
1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd BudgetZen
   ```

2. **Configuration Backend**
   ```bash
   cd backend
   npm install
   # Configurer la base de données PostgreSQL
   # Modifier les variables dans config/db.js
   ```

3. **Configuration Mobile**
   ```bash
   cd mobile/budgetzen
   flutter pub get
   ```

4. **Démarrage automatique**
   ```bash
   # Windows
   double-click start_app.bat
   
   # Ou manuellement :
   # Terminal 1: cd backend && node src/server.js
   # Terminal 2: cd mobile/budgetzen && flutter run
   ```

## 📂 Structure du Projet

```
BudgetZen/
├── backend/                    # Serveur Node.js
│   ├── src/
│   │   ├── server.js          # Point d'entrée
│   │   ├── config/            # Configuration DB
│   │   ├── controllers/       # Logique métier
│   │   ├── middleware/        # Rate limiting
│   │   └── routes/           # Endpoints API
│   └── package.json
│
├── mobile/budgetzen/          # Application Flutter
│   ├── lib/
│   │   ├── main.dart         # Point d'entrée
│   │   ├── core/             # Configuration & thème
│   │   │   ├── constants/    # Couleurs & constantes
│   │   │   ├── config/       # Router & API
│   │   │   └── theme/        # Thème Fustat
│   │   ├── data/             # Modèles & services
│   │   │   ├── models/       # Transaction, User
│   │   │   └── services/     # API services
│   │   ├── presentation/     # Interface utilisateur
│   │   │   ├── screens/      # Écrans principaux
│   │   │   └── widgets/      # Composants réutilisables
│   │   └── providers/        # Gestion d'état
│   ├── assets/               # Police Fustat & images
│   └── pubspec.yaml
│
└── start_app.bat             # Script de démarrage automatique
```

## 🎯 Endpoints API

### Authentification
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `POST /api/auth/logout` - Déconnexion

### Transactions
- `GET /api/transactions` - Liste des transactions
- `POST /api/transactions` - Créer une transaction
- `PUT /api/transactions/:id` - Modifier une transaction
- `DELETE /api/transactions/:id` - Supprimer une transaction
- `GET /api/transactions/stats` - Statistiques

## 🎨 Guide des Couleurs

```dart
// Palette principale
primary: #a28ef9        // Violet principal
success: #a4f5a6        // Vert succès
warning: #ffd89d        // Orange avertissement
background: #eceef0     // Gris fond

// Couleurs dérivées
primaryLight: #b8a3fa
primaryExtraLight: #e8e1fe
textPrimary: #1a1a1a
textSecondary: #666666
```

## 🔧 Configuration

### Base de Données
Configurer PostgreSQL dans `backend/config/db.js` :
```javascript
const config = {
  host: 'localhost',
  port: 5432,
  database: 'budgetzen',
  user: 'your_user',
  password: 'your_password'
};
```

### API URL
Modifier l'URL du backend dans `mobile/budgetzen/lib/core/config/api_config.dart` :
```dart
static const String baseUrl = 'http://localhost:3000';
```

## 🐛 Résolution de Problèmes

### Backend ne démarre pas
```bash
# Vérifier Node.js
node --version

# Réinstaller les dépendances
cd backend
rm -rf node_modules
npm install
```

### Flutter ne compile pas
```bash
# Nettoyer le cache
cd mobile/budgetzen
flutter clean
flutter pub get

# Vérifier la configuration
flutter doctor
```

### Erreurs de connexion API
1. Vérifier que le backend est démarré sur le port 3000
2. Tester l'API : `curl http://localhost:3000/api/transactions`
3. Vérifier la configuration réseau (pare-feu, antivirus)

## 📖 Utilisation

1. **Première utilisation**
   - Créer un compte via l'écran d'inscription
   - Ajouter votre première transaction

2. **Gestion quotidienne**
   - Ajouter transactions via le bouton FAB
   - Consulter le dashboard pour un aperçu
   - Suivre le budget par catégorie

3. **Analyse financière**
   - Accéder aux statistiques détaillées
   - Consulter les tendances mensuelles
   - Recevoir des conseils personnalisés

## 🔄 Développement

### Ajouter une nouvelle fonctionnalité
1. Backend : Créer route + controller
2. Frontend : Créer service + provider + UI
3. Tester l'intégration complète

### Modifier le design
1. Couleurs : `core/constants/app_colors.dart`
2. Thème : `core/theme/app_theme.dart`
3. Composants : `presentation/widgets/`

## 📱 Captures d'Écran
[TODO: Ajouter des captures d'écran une fois l'app testée]

## 🤝 Contribution
1. Fork le projet
2. Créer une branche feature
3. Commit les changements
4. Créer une Pull Request

## 📄 Licence
MIT License - Voir le fichier LICENSE pour plus de détails.

---

**BudgetZen** - Gérez votre budget avec style ! 💜✨
