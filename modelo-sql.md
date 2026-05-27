# Modelo de base de datos — POS Pizzería

## Diagrama de tablas

```
usuarios
categorias
productos ──────────── items_pedido
modificadores ─────── items_modificadores
sabores_empanada ──── items_sabores_empanada
presentaciones_empanada
combos ─────────────── combo_componentes
configuracion
pedidos ────────────── items_pedido
                       items_modificadores
                       items_sabores_empanada
                       combo_pizzas_elegidas
```

---

## Descripción de cada tabla

### usuarios
Almacena dueño y empleados. El rol determina qué puede ver y hacer cada uno.

### categorias
Categorías de productos (Pizzas, Empanadas, Bebidas, Combos, etc.) con nombre y color personalizable.

### productos
Todos los productos del catálogo: pizzas, bebidas, otros. Las empanadas se manejan por sabor en `sabores_empanada`.

### modificadores
Extras opcionales para pizzas (Doble Muzza, Agregado). Se asocian a ítems del pedido.

### sabores_empanada
Lista de sabores disponibles para empanadas (Carne, Humita, etc.).

### presentaciones_empanada
Las formas en que se venden las empanadas: unidad, media docena, docena.

### combos
Combos con precio fijo (ej: 1 Muzza + 6 Empanadas = $26.000).

### combo_componentes
Define qué incluye cada combo: cuántas pizzas y/o cuántas empanadas.

### configuracion
Parámetros generales del sistema (ej: plus de media pizza).

### pedidos
Cada pedido realizado: tipo, datos del cliente, totales, método de pago, estado.

### items_pedido
Cada línea del pedido: qué se pidió, en qué cantidad, a qué precio.

### items_modificadores
Modificadores aplicados a un ítem (ej: doble queso en una pizza).

### items_sabores_empanada
Detalle de sabores elegidos para un ítem de empanadas.

### combo_pizzas_elegidas
Pizzas elegidas al seleccionar un combo.

---

## Script SQL completo

Ver archivo `schema.sql`
