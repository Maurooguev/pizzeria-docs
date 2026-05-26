# pizzeria-docs

Documentación central del proyecto POS Pizzería.

## Contenido

```
pizzeria-docs/
├── requerimientos.md        # Requerimientos funcionales y no funcionales
├── modelo-sql.md            # Modelo de base de datos completo
├── arquitectura.md          # Diagrama y decisiones de arquitectura
├── decisiones.md            # Registro de decisiones técnicas (ADR)
└── guias/
    ├── setup-backend.md     # Cómo levantar el backend
    ├── setup-android.md     # Cómo configurar Android Studio
    └── setup-web.md         # Cómo levantar el panel web
```

## Repositorios del proyecto

| Repo | Descripción |
|---|---|
| `pizzeria-docs` | Este repositorio — documentación |
| `pizzeria-backend` | API REST en FastAPI (Python) |
| `pizzeria-app` | App Android en Kotlin |
| `pizzeria-web` | Panel web de reportes en React |

## Stack

- **App:** Android (Kotlin), mínimo Android 8.0
- **Backend:** Python 3.11+, FastAPI, SQLAlchemy
- **Base de datos:** PostgreSQL (Supabase)
- **Panel web:** React + Recharts
- **Auth:** JWT con roles (dueño / empleado)
