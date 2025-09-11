# Aura Back

**Aura** est une **API backend** pour une application de bien-être mental, développée avec **Vapor** et **MariaDB**. Elle permet de gérer des fonctionnalités comme la méditation, la respiration, les défis, le suivi de l’humeur, et un journal de gratitude.

---

## 📌 Fonctionnalités
- **Gestion des utilisateurs** : Inscription/connexion sécurisée avec **JWT**.
- **Activités bien-être** : Méditations guidées, exercices de respiration, et défis personnalisés.
- **Suivi quotidien** : Humeur, journal de gratitude, et sommeil.
- **Système de récompenses** : Badges pour motiver les utilisateurs.

---

## 🛠 Technologies
- **Backend** : Swift + Vapor
- **Base de données** : MariaDB
- **Authentification** : JWT
- **Outils** : Fluent (ORM)

---

```
Aura-Server/
├── Package.swift
├── Package.resolved
├── Public/
├── Resources/
├── Sources/
│   └── Aura/
│       ├── Controllers/
│       ├── JWT/
│       ├── Middleware/
│       ├── Migrations/
│       ├── Models/
│       ├── configure.swift
│       ├── entrypoint.swift  # ou main.swift
│       └── routes.swift
├── Tests/
│   └── AuraTests/
│       └── AuraTests.swift
├── docker-compose.yml
└── README.md
```



## 🚀 Installation

### Prérequis
- [Swift 5.6+](https://swift.org/download/)
- [Vapor Toolbox](https://docs.vapor.codes/install/macos/)

### Étapes
1. Cloner le dépôt :
   ```bash
   git clone https://github.com/ton-utilisateur/aura-back.git
   cd aura-back

