# Guía: Levantar el panel web

## Requisitos previos
- Node.js 18 o superior

## Clonar y configurar
```bash
git clone https://github.com/tu-usuario/pizzeria-web.git
cd pizzeria-web
npm install
cp .env.example .env
```
Editar .env: VITE_API_URL=http://localhost:8000

## Levantar en desarrollo
```bash
npm run dev
```
Panel en: http://localhost:5173

## Deploy en Vercel
1. vercel.com → New Project → importar repo desde GitHub
2. Variable de entorno: VITE_API_URL=https://tu-backend.com
3. Deploy automático en cada push a main
