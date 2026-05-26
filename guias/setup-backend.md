# Guía: Levantar el backend

## Requisitos previos
- Python 3.11 o superior
- Cuenta en Supabase (gratuita)
- Git

## Paso 1 — Crear proyecto en Supabase
1. Ir a supabase.com → New Project
2. Elegir nombre, contraseña y región
3. Guardar la Database URL y el anon key desde Settings → API

## Paso 2 — Clonar y configurar
```bash
git clone https://github.com/tu-usuario/pizzeria-backend.git
cd pizzeria-backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```
Editar .env con tu DATABASE_URL y JWT_SECRET

## Paso 3 — Correr migraciones
```bash
alembic upgrade head
```

## Paso 4 — Levantar
```bash
uvicorn app.main:app --reload
```
Documentación en: http://localhost:8000/docs
