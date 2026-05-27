# Requerimientos — El Hornito POS

**Versión:** 1.3  
**Fecha:** Mayo 2026  
**Stack:** Android (Kotlin) + FastAPI (Python) + PostgreSQL (Supabase)

---

## 1. Contexto y objetivo

Aplicación de punto de venta (POS) personalizada para una pizzería con fuerte componente de delivery. Reemplaza el uso de Loyverse con una solución propia que permita control total de los datos y reportes desde el navegador.

La app corre en una **tablet Android** en el local. Los reportes se consultan desde un **panel web** accesible desde cualquier dispositivo con navegador.

---

## 2. Roles y usuarios

| Rol | Acceso |
|---|---|
| **Dueño** | Todo: ventas, productos, reportes completos, configuración |
| **Empleado** | Tomar y cobrar pedidos + ver reporte solo del día actual |

### Autenticación
- La tablet **queda logueada siempre** (no se cierra sesión al salir de la app)
- El empleado opera sin necesidad de ingresar credenciales cada vez
- Para acceder a reportes completos y configuración, la app solicita la **contraseña del dueño**
- El panel web requiere login con usuario y contraseña

---

## 3. Catálogo de productos

### 3.1 Pizzas
- Talla única (un solo precio por pizza)
- Se pueden pedir **enteras** o **por mitad**
- **Precio de media pizza** = precio de la mitad más cara + plus fijo configurable
- Soportan **modificadores/extras** opcionales con precio adicional (ej: doble queso)
- Organizadas por categoría

**Pizzas del catálogo actual:**

| Pizza | Precio |
|---|---|
| Muzzarella | $14.000 |
| Napolitana | $16.000 |
| Muzza con Jamón | $16.000 |
| Fugazzeta | $16.000 |
| Huevo | $16.000 |
| Roquefort | $16.000 |
| Anchoa | $17.000 |
| Calabresa | $17.000 |
| Jamón y Morrón | $17.000 |
| Provolone | $17.000 |

**Modificadores actuales:**

| Modificador | Precio adicional |
|---|---|
| Doble Muzza | $7.000 |
| Agregado | $1.000 |

### 3.2 Empanadas
- Precio unitario fijo: **$2.500**
- Presentaciones disponibles:

| Presentación | Cantidad | Precio |
|---|---|---|
| Unidad | 1 | $2.500 |
| Media docena | 6 | $15.000 |
| Docena | 12 | $28.000 |

- **Selector de sabores por botones:** al elegir una presentación, la app muestra los sabores como botones. Tocar un sabor suma una unidad. El total no puede superar la cantidad de la presentación.
- Se pueden mezclar sabores libremente (ej: 3 carne + 3 jamón y queso)

**Sabores actuales:** Carne, Carne Cuchillo, Jamón y Queso, Humita, Verdura, Capresse, Roquefort, Pollo

### 3.3 Combos
- Precio fijo definido por el dueño, independiente de los productos que lo componen
- Pueden incluir cualquier combinación: pizza + empanadas, solo pizzas, solo empanadas
- Al seleccionar un combo la app permite elegir la/s pizza/s y los sabores de empanadas

**Combos actuales:**

| Combo | Precio |
|---|---|
| 1 Muzza + 1 Jamón y Morrón | $28.000 |
| 1 Muzza + 1 Napo | $28.000 |
| 1 Napo + 1 Jamón y Morrón | $31.000 |
| 1 Muzza + 6 Empanadas | $26.000 |
| 1 Muzza + 12 Empanadas | $40.000 |
| 12 Empanadas | $28.000 |
| 2 Muzza | $26.000 |
| 3 Muzza | $40.000 |

### 3.4 Otros productos
- Bebidas y cualquier otro ítem: precio fijo, sin variantes
- Organizados por categoría

### 3.5 Gestión del catálogo
- Disponible tanto desde la app (sección configuración, solo dueño) como desde el panel web
- Operaciones: crear, editar, activar/desactivar productos, categorías, sabores, modificadores y combos
- Desactivar no elimina — sirve para productos de temporada

---

## 4. Pantallas de la app

### 4.1 Pantalla principal — Carta
- **Layout:** mitad izquierda carta, mitad derecha resumen del pedido (panel lateral fijo)
- **Carta:** grilla de fotos con nombre y precio, igual a Loyverse
- **Navegación por categorías:** pestañas en la parte superior (Pizzas / Empanadas / Bebidas / Combos)
- **Idioma:** español únicamente

### 4.2 Detalle de producto
Al tocar un producto se abre un panel/dialog con:
- Nombre y precio
- Botón "Agregar al pedido"
- Para pizzas: botón "Media pizza" que abre el selector de segunda mitad
- Para pizzas: selector de modificadores/extras opcionales
- Para empanadas: selector de presentación → luego selector de sabores con botones
- Campo de nota libre por ítem

### 4.3 Media pizza
- Al tocar "Media pizza" en el detalle de una pizza, se abre un selector de segunda mitad
- El selector muestra solo los nombres de las pizzas (sin foto)
- **Precio:** se toma el mayor precio entre las dos mitades + plus fijo configurable
- Se muestra en el pedido como "½ [Pizza A] + ½ [Pizza B]"

### 4.4 Panel lateral del pedido
Visible siempre en la mitad derecha de la pantalla mientras se arma el pedido. Muestra:
- Lista de ítems agregados con cantidad, detalle y subtotal
- Botones para modificar cantidad o eliminar un ítem
- Subtotal, costo de envío (si aplica), total
- Botón "Cobrar"

### 4.5 Flujo completo de un pedido
1. Tocar "Nuevo pedido"
2. Elegir tipo: **Delivery** o **Mostrador** (botones grandes)
3. Armar el pedido desde la carta (panel lateral visible todo el tiempo)
4. Tocar "Cobrar"
5. Si es **Delivery**: ingresar nombre, dirección y teléfono + costo de envío
6. Elegir método de pago: Efectivo / Transferencia / Dividido
7. Confirmar cobro → pedido cerrado

### 4.6 Pantalla de cobro
- Muestra resumen final del pedido
- Si es delivery: formulario con nombre, dirección, teléfono, costo de envío
- Método de pago: Efectivo / Transferencia / Dividido (en dividido se ingresan los montos de cada parte)
- Efectivo: solo confirmar, sin calculadora de vuelto
- Botón "Confirmar cobro"

### 4.7 Historial de pedidos
- Accesible desde el menú principal
- Filtro por rango de fechas libre
- Lista de pedidos con: tipo, nombre cliente (si aplica), total, estado, hora
- Al tocar un pedido: ver detalle completo + reimprimir ticket
- Empleado ve solo pedidos del día actual
- Dueño ve todos con filtro libre

### 4.8 Cancelación de pedido
- Solo desde el detalle de un pedido abierto
- Al cancelar: campo obligatorio de motivo (texto libre)
- El pedido queda en el historial con estado "Cancelado" y el motivo registrado
- Un pedido cobrado no se puede modificar — se cancela y se hace uno nuevo

---

## 5. Cobro y pagos

### 5.1 Métodos de pago
- Efectivo
- Transferencia / QR
- Dividido: parte en efectivo + parte en transferencia (se ingresan los montos de cada parte)

### 5.2 Costo de envío
- Campo numérico propio del pedido, no un producto del catálogo
- Se ingresa en la pantalla de cobro si el pedido es delivery
- Se muestra desglosado en el resumen y en el ticket

### 5.3 Descuentos
- No se aplican descuentos ad-hoc
- Las promociones se manejan a través del sistema de combos con precio fijo

---

## 6. Conectividad y modo offline

- Si se va internet mientras se arma un pedido, **el pedido se guarda localmente**
- Cuando vuelve la conexión, se sincroniza automáticamente con el servidor
- Se muestra un indicador visible cuando la app está operando sin conexión

---

## 7. Impresión de tickets

- Soporte para impresora térmica Bluetooth
- El ticket incluye: tipo de pedido, datos del cliente (si delivery), detalle de ítems con notas y modificadores, costo de envío, total, método de pago, fecha y hora
- Nice-to-have en v1, obligatorio en v2

---

## 8. Panel web — Reportes

Accesible desde cualquier dispositivo con navegador. Requiere login.

### Dueño ve:
- **Ventas y facturación:** total por día / semana / mes, desglose productos vs envíos, por método de pago, por tipo de pedido
- **Productos más vendidos:** ranking de pizzas, productos, sabores de empanadas y combos
- **Comparación de períodos:** entre dos rangos de fechas, por día de la semana
- **Cancelaciones:** listado con motivo
- **Exportación:** CSV del período seleccionado

### Empleado ve (solo desde la app, no desde el panel web):
- Resumen del día: total vendido, cantidad de pedidos, desglose por método de pago

---

## 9. Gestión de productos (configuración)

Disponible desde la app (solo dueño, con contraseña) y desde el panel web:
- ABM de productos, categorías, sabores de empanadas, modificadores y combos
- Configuración del plus de media pizza
- Cambio de contraseñas

---

## 10. Requerimientos no funcionales

| Atributo | Detalle |
|---|---|
| **Plataforma** | Android (tablet), mínimo Android 8.0 |
| **Distribución** | Google Play Store |
| **Idioma** | Español |
| **Conectividad** | Internet requerido, con soporte offline para pedidos en curso |
| **Backend** | FastAPI (Python), REST API con JSON |
| **Base de datos** | PostgreSQL en Supabase |
| **Autenticación** | JWT con roles, tablet siempre logueada |
| **Panel web** | React, accesible desde cualquier dispositivo |
| **Seguridad** | HTTPS obligatorio, tokens con expiración |
| **Notificaciones** | No requeridas |

---

## 11. Fuera de scope (v1)

- Facturación electrónica / AFIP
- Módulo de clientes con historial
- Control de stock / inventario
- Integración con plataformas de delivery (PedidosYa, Rappi)
- Múltiples sucursales
- Calculadora de vuelto
- Notificaciones push

---

## 12. Modelo de datos

```
usuarios
  id, nombre, email, password_hash, rol (dueño|empleado), activo

categorias
  id, nombre, orden, activo

productos
  id, nombre, descripcion, precio, categoria_id,
  tipo (pizza|empanada|bebida|otro), activo

sabores_empanada
  id, nombre, activo
  -- Carne, Carne Cuchillo, Jamón y Queso, Humita, Verdura, Capresse, Roquefort, Pollo

presentaciones_empanada
  id, nombre, cantidad, precio
  -- unidad($2.500), media_docena($15.000), docena($28.000)

modificadores
  id, nombre, precio_adicional, activo
  -- Doble Muzza($7.000), Agregado($1.000)

configuracion
  id, clave, valor
  -- plus_media_pizza, etc.

combos
  id, nombre, descripcion, precio, activo

combo_componentes
  id, combo_id, tipo (pizza|empanadas), cantidad
  -- define qué incluye el combo y cuántas unidades

pedidos
  id, tipo (delivery|mostrador), nombre_cliente, direccion, telefono,
  costo_envio, subtotal, total,
  metodo_pago_1, monto_pago_1, metodo_pago_2, monto_pago_2,
  estado (abierto|cobrado|cancelado), motivo_cancelacion,
  sincronizado (bool),
  usuario_id, creado_at, cerrado_at

items_pedido
  id, pedido_id, tipo_item (producto|media_pizza|empanadas|combo),
  producto_id,
  mitad_1_producto_id, mitad_2_producto_id,
  presentacion_empanada_id,
  combo_id,
  cantidad, precio_unitario, subtotal, notas

items_sabores_empanada
  id, item_pedido_id, sabor_empanada_id, cantidad

items_modificadores
  id, item_pedido_id, modificador_id, precio_adicional

combo_pizzas_elegidas
  id, item_pedido_id, producto_id, posicion
  -- pizzas elegidas al armar un combo
```

---

## 13. Roadmap de desarrollo

| Fase | Contenido | Estimado |
|---|---|---|
| **1 — Modelo SQL** | Tablas, relaciones, datos reales de la pizzería | 1-2 días |
| **2 — API FastAPI** | Endpoints de productos, pedidos, cobro, auth, reportes | 1 semana |
| **3 — App Android** | Carta, pedido, cobro, media pizza, empanadas, historial | 3-4 semanas |
| **4 — Panel web** | Reportes, comparación, exportación CSV | 1-2 semanas |
| **5 — Play Store** | Cuenta, firma APK, publicación | 1-2 días |
| **6 — Impresión** | Integración impresora térmica Bluetooth | 1 semana |

---

## 14. Gestión de productos — Detalle de pantallas

### 14.1 Vista general del catálogo (app y panel web)
- Grilla de cuadrados con foto o color de fondo (si no tiene foto), igual a Loyverse
- Cada cuadrado muestra: foto/color, nombre, precio y categoría
- Filtro por categoría en la parte superior
- Botón "Agregar producto" visible siempre
- Botón "Editar orden" que activa el modo drag & drop para reordenar

### 14.2 Categorías
- Cada categoría tiene nombre y color personalizable
- Se crean y editan libremente (no son fijas)
- Ejemplos iniciales: Pizzas, Empanadas, Bebidas, Combos
- Las categorías se usan como pestañas en la carta y como filtro en configuración

### 14.3 Alta / edición de producto
Formulario con:
- Nombre (texto)
- Precio (numérico)
- Categoría (selector)
- Foto: subir desde galería de la tablet / opcional
- Color de fondo: selector de color (si no tiene foto)
- Estado: activo / inactivo (switch)
- Para pizzas: selector de modificadores aplicables
- Botón guardar y botón eliminar (con confirmación)

### 14.4 Eliminación de productos
- Dos opciones disponibles:
  - **Desactivar:** el producto se oculta de la carta pero queda en el historial
  - **Eliminar permanentemente:** con diálogo de confirmación. Solo si el producto nunca fue usado en un pedido; si fue usado, solo se puede desactivar

### 14.5 Alta / edición de combo
Formulario con:
- Nombre (texto)
- Precio fijo (numérico)
- Foto o color de fondo
- Componentes: lista de qué incluye el combo
  - Tipo: pizza o empanadas
  - Cantidad (ej: 1 pizza, 12 empanadas)
  - Se pueden agregar múltiples componentes
- Estado: activo / inactivo

### 14.6 Alta / edición de sabores de empanada
- Lista simple con nombre y estado activo/inactivo
- Botón agregar sabor
- Edición inline (tocar el nombre para editar)

### 14.7 Alta / edición de modificadores de pizza
- Lista con nombre, precio adicional y estado activo/inactivo
- Botón agregar modificador
- Edición inline

### 14.8 Configuración general
- **Plus de media pizza:** campo numérico editable (precio adicional que se suma al mayor de las dos mitades)

### 14.9 Permisos
- Todo lo anterior es exclusivo del dueño
- El empleado no ve la sección de configuración ni gestión de productos

---

## 15. Panel web — Detalle de pantallas

### 15.1 Estructura general
- Login con usuario y contraseña
- Navegación por pestañas: **Ventas / Cancelaciones / Productos**
- Selector de rango de fechas global (afecta todas las pestañas)

### 15.2 Pestaña Ventas
**Gráficos:**
- Barras: ventas por día en el período seleccionado
- Torta: distribución por método de pago (efectivo vs transferencia)
- Barras: comparación entre dos períodos (si se seleccionan dos rangos)

**Tablas:**
- Resumen: total vendido, cantidad de pedidos, ticket promedio, total envíos
- Desglose por tipo de pedido (delivery vs mostrador)
- Desglose por día de la semana
- Listado de pedidos del período con: fecha, tipo, cliente, total, método de pago

**Exportación:** botón para descargar CSV del período seleccionado

### 15.3 Pestaña Cancelaciones
**Tabla:**
- Listado de pedidos cancelados: fecha, tipo, cliente, total que hubiera sido, motivo
- Total de cancelaciones en el período

### 15.4 Pestaña Productos
**Gráficos:**
- Barras horizontales: ranking de productos más vendidos
- Barras horizontales: sabores de empanadas más elegidos

**Tablas:**
- Ranking completo de productos con cantidad vendida e ingresos generados
- Ranking de combos más vendidos
- Ranking de sabores de empanadas

### 15.5 Gestión de productos desde el panel web
- Misma funcionalidad que desde la app: ABM de productos, categorías, combos, sabores, modificadores
- La foto se sube desde el navegador (archivo desde el dispositivo)
- Requiere login como dueño


---

## 16. Edge cases y comportamiento ante errores

### 16.1 Conectividad
- Si se va internet mientras se arma un pedido, la app guarda el pedido localmente en SQLite
- El pedido offline se sincroniza automáticamente cuando vuelve la conexión
- Si no vuelve internet en 24 horas, el pedido offline se descarta automáticamente
- Si se va internet justo al tocar "Confirmar cobro", el cobro se guarda localmente y sincroniza después
- Si hay pedidos pendientes de sincronizar, el empleado puede seguir tomando pedidos normalmente
- La app muestra un indicador visible cuando está operando sin conexión

### 16.2 Precios y productos
- Si el dueño cambia el precio de un producto mientras hay un pedido abierto con ese producto, el precio se actualiza automáticamente en el pedido
- Los precios se guardan en el ítem al momento de confirmar el cobro, para que el historial refleje el precio real cobrado
- Si se elimina un producto que tenía foto, la imagen desaparece y el producto queda sin imagen en el historial
- Si un cliente pide un sabor de empanada que no está cargado en el sistema, el empleado no puede agregarlo en el momento — debe usar las notas del ítem o el dueño debe agregar el sabor desde configuración

### 16.3 Datos del pedido
- Los datos de delivery (nombre, dirección, teléfono) se pueden editar en cualquier momento antes de confirmar el cobro
- Una vez cobrado el pedido, no se puede modificar — se debe cancelar y crear uno nuevo
- Cada pedido es independiente, no existe la función de repetir un pedido anterior

### 16.4 Acceso y contraseñas
- La tablet queda siempre logueada, no hay cierre de sesión automático
- Si el dueño olvida su contraseña, solo puede recuperarla accediendo directamente a la base de datos en Supabase — no hay recuperación por email en v1
- El empleado no tiene contraseña propia, opera con la sesión de la tablet

### 16.5 Sincronización de combos y precios offline
- Cuando la app está offline, usa la última versión del catálogo descargada
- Al recuperar conexión, el catálogo se actualiza automáticamente
- Si un combo fue modificado mientras la app estaba offline, el pedido sincroniza con los datos que tenía en ese momento

---

## 17. Diseño visual

### 17.1 Temas
- La app soporta **tema oscuro** y **tema claro**
- El usuario lo cambia desde configuración
- Por defecto: tema oscuro (más cómodo para trabajar de noche en el local)

### 17.2 Colores
- Color principal (botones, precios, categoría activa): **rojo** `#C0392B`
- Tema oscuro: fondo `#1E1E1E`, superficies `#2A2A2A`, texto `#EEEEEE`
- Tema claro: fondo `#F5F5F5`, superficies `#FFFFFF`, texto `#1A1A1A`
- Indicador de conexión: verde `#27AE60`

### 17.3 Grilla de productos
- 4 columnas en la carta principal
- Tarjetas cuadradas y compactas: foto, nombre y precio
- Tamaño de foto: 44×44px con border-radius
- Si no tiene foto: color de fondo personalizado por producto

### 17.4 Layout principal
- Mitad izquierda: carta con pestañas de categorías + grilla de productos
- Mitad derecha (220px fija): panel del pedido siempre visible
- Barra inferior: indicador de estado de conexión (online/offline)

### 17.5 Estilo general
- Bordes finos (0.5px), esquinas redondeadas
- Sin gradientes ni sombras
- Tipografía limpia, tamaños pequeños para aprovechar el espacio de la tablet
- Inspirado en Loyverse: simple, directo, funcional

---

## 18. Nombre e identidad de la app

- **Nombre:** El Hornito POS
- **Nombre en Play Store:** El Hornito POS
- **Nombre en la tablet:** El Hornito
- **Ícono:** horno o pizza en rojo `#C0392B`
- El nombre refleja el nombre real de la pizzería