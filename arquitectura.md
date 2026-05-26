# Arquitectura del sistema

## Diagrama general

```
┌─────────────────────────────┐
│        Tablet Android       │
│      (App Kotlin/POS)       │
│                             │
│  ┌──────────┐  ┌─────────┐  │
│  │  SQLite  │  │  UI POS │  │
│  │ (offline)│  │         │  │
│  └────┬─────┘  └────┬────┘  │
└───────┼─────────────┼───────┘
        │             │
        └──────┬───────┘
               │ HTTPS (REST API)
               ▼
┌──────────────────────────────┐
│        FastAPI Backend       │
│         (Python 3.11)        │
│                              │
│  - Autenticación JWT         │
│  - Lógica de negocio         │
│  - Endpoints REST            │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│     PostgreSQL (Supabase)    │
│                              │
│  - Datos de producción       │
│  - Imágenes (Supabase Storage│
└──────────────────────────────┘
               ▲
               │ HTTPS
┌──────────────────────────────┐
│       Panel Web (React)      │
│                              │
│  - Reportes y gráficos       │
│  - Gestión de productos      │
│  - Acceso desde cualquier    │
│    navegador                 │
└──────────────────────────────┘
```

## Decisiones de arquitectura

### App Android
- Se comunica con el backend vía API REST (JSON/HTTPS)
- Guarda pedidos en SQLite local cuando no hay internet
- Al recuperar conexión sincroniza automáticamente
- La tablet queda siempre logueada (token persistente)

### Backend
- API REST stateless con FastAPI
- JWT para autenticación con dos roles: dueño y empleado
- Una sola instancia, sin microservicios (YAGNI para v1)

### Base de datos
- PostgreSQL en Supabase (plan gratuito para v1)
- Supabase Storage para imágenes de productos
- SQLite en la tablet solo para pedidos offline

### Panel web
- React SPA (Single Page Application)
- Se conecta al mismo backend que la app
- Desplegado en Vercel (plan gratuito)
