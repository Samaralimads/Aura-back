#  Aura
**Backend API for Mental Wellbeing**
---
## 📖 About
Aura is a backend API designed to manage :
- Mood tracking (journal, emotions)
- Meditation and breathing exercises
- Challenge and reward system
---
## 🛠 Technologies
- **Framework**: [Vapor 4](https://vapor.code) (Swift)
- **Database**: MariaDB/MySQL (with [Fluent ORM](https://docs.vapor.code/fluent/overview/))
- **Authentication**: JWT (JSON Web Tokens)
- **Deployment**: Docker
---
## 📂 Project Structure
```
Aura-back/
├── Package.resolved
├── LICENSE
├── Dockerfile
├── docker-compose.yml
├── Public/
├── Resources/
├── Sources/
│   └── Aura/
│       ├── Controllers/
│       ├── DTOs/
│       ├── JWT/
│       ├── Middleware/
│       ├── Migrations/
│       ├── Models/
│       ├── configure.swift
│       ├── routes.swift
│       └── entrypoint.swift
├── Tests/
│   └── AuraTests/
├── Package.swift
└── README.md
```
---
### 📦 Installation
To get started, clone the repository :

- `git clone https://github.com/Samaralimads/Aura-back`
---
## 👥 Contributors
- [@Alitchoum](https://github.com/Alitchoum)
- [@chabane23](https://github.com/chabane23)
- [@mlegoul](https://github.com/mlegoul)
- [@Samaralimads](https://github.com/Samaralimads)
---
## 📄 License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
