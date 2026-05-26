# Guía: Configurar Android Studio

## Requisitos previos
- Android Studio Hedgehog o superior
- JDK 17
- Tablet con Android 8.0+ con modo desarrollador activado

## Activar modo desarrollador en la tablet
1. Ajustes → Acerca del dispositivo
2. Tocar "Número de compilación" 7 veces
3. Ajustes → Opciones de desarrollador → Activar "Depuración USB"

## Clonar y abrir
```bash
git clone https://github.com/tu-usuario/pizzeria-app.git
```
Android Studio → Open → seleccionar la carpeta

## Configurar local.properties
```
sdk.dir=/ruta/a/tu/android/sdk
BASE_URL=http://localhost:8000/
```

## Correr en la tablet
1. Conectar tablet por USB y aceptar la solicitud de depuración
2. Seleccionar la tablet en Android Studio
3. Presionar Run ▶
