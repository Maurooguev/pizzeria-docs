-- ============================================================
-- POS Pizzería — Schema completo
-- Base de datos: PostgreSQL (Supabase)
-- ============================================================

-- ============================================================
-- USUARIOS
-- ============================================================
CREATE TABLE usuarios (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    rol         VARCHAR(20) NOT NULL CHECK (rol IN ('dueño', 'empleado')),
    activo      BOOLEAN NOT NULL DEFAULT TRUE,
    creado_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ============================================================
-- CATEGORIAS
-- ============================================================
CREATE TABLE categorias (
    id      SERIAL PRIMARY KEY,
    nombre  VARCHAR(50) NOT NULL,
    color   VARCHAR(7) NOT NULL DEFAULT '#FF6B00',  -- hex color
    orden   INT NOT NULL DEFAULT 0,
    activo  BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================================
-- PRODUCTOS
-- (pizzas, bebidas, otros — NO empanadas, esas van por sabor)
-- ============================================================
CREATE TABLE productos (
    id           SERIAL PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    descripcion  TEXT,
    precio       NUMERIC(10,2) NOT NULL,
    categoria_id INT NOT NULL REFERENCES categorias(id),
    tipo         VARCHAR(20) NOT NULL CHECK (tipo IN ('pizza', 'bebida', 'otro')),
    foto_url     TEXT,
    color        VARCHAR(7),
    orden        INT NOT NULL DEFAULT 0,
    activo       BOOLEAN NOT NULL DEFAULT TRUE,
    creado_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ============================================================
-- MODIFICADORES (extras para pizzas)
-- ============================================================
CREATE TABLE modificadores (
    id               SERIAL PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    precio_adicional NUMERIC(10,2) NOT NULL DEFAULT 0,
    activo           BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================================
-- SABORES DE EMPANADA
-- ============================================================
CREATE TABLE sabores_empanada (
    id     SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    orden  INT NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================================
-- PRESENTACIONES DE EMPANADA
-- ============================================================
CREATE TABLE presentaciones_empanada (
    id       SERIAL PRIMARY KEY,
    nombre   VARCHAR(50) NOT NULL,  -- 'unidad', 'media_docena', 'docena'
    cantidad INT NOT NULL,
    precio   NUMERIC(10,2) NOT NULL,
    activo   BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================================
-- COMBOS
-- ============================================================
CREATE TABLE combos (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio      NUMERIC(10,2) NOT NULL,
    foto_url    TEXT,
    color       VARCHAR(7),
    orden       INT NOT NULL DEFAULT 0,
    activo      BOOLEAN NOT NULL DEFAULT TRUE,
    creado_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Componentes de cada combo
CREATE TABLE combo_componentes (
    id           SERIAL PRIMARY KEY,
    combo_id     INT NOT NULL REFERENCES combos(id) ON DELETE CASCADE,
    tipo         VARCHAR(20) NOT NULL CHECK (tipo IN ('pizza', 'empanadas')),
    cantidad     INT NOT NULL DEFAULT 1
    -- Si tipo='pizza': cantidad de pizzas a elegir
    -- Si tipo='empanadas': cantidad total de empanadas incluidas
);

-- ============================================================
-- CONFIGURACION GENERAL
-- ============================================================
CREATE TABLE configuracion (
    id     SERIAL PRIMARY KEY,
    clave  VARCHAR(50) NOT NULL UNIQUE,
    valor  TEXT NOT NULL
);

-- ============================================================
-- PEDIDOS
-- ============================================================
CREATE TABLE pedidos (
    id                 SERIAL PRIMARY KEY,
    tipo               VARCHAR(20) NOT NULL CHECK (tipo IN ('delivery', 'mostrador')),
    nombre_cliente     VARCHAR(100),
    direccion          TEXT,
    telefono           VARCHAR(20),
    costo_envio        NUMERIC(10,2) NOT NULL DEFAULT 0,
    subtotal           NUMERIC(10,2) NOT NULL DEFAULT 0,
    total              NUMERIC(10,2) NOT NULL DEFAULT 0,
    metodo_pago_1      VARCHAR(20) CHECK (metodo_pago_1 IN ('efectivo', 'transferencia')),
    monto_pago_1       NUMERIC(10,2),
    metodo_pago_2      VARCHAR(20) CHECK (metodo_pago_2 IN ('efectivo', 'transferencia')),
    monto_pago_2       NUMERIC(10,2),
    estado             VARCHAR(20) NOT NULL DEFAULT 'abierto' CHECK (estado IN ('abierto', 'cobrado', 'cancelado')),
    motivo_cancelacion TEXT,
    sincronizado       BOOLEAN NOT NULL DEFAULT TRUE,
    usuario_id         INT NOT NULL REFERENCES usuarios(id),
    creado_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    cerrado_at         TIMESTAMP
);

-- ============================================================
-- ITEMS DEL PEDIDO
-- ============================================================
CREATE TABLE items_pedido (
    id                      SERIAL PRIMARY KEY,
    pedido_id               INT NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
    tipo_item               VARCHAR(20) NOT NULL CHECK (tipo_item IN ('producto', 'media_pizza', 'empanadas', 'combo')),
    -- Para productos simples y pizzas enteras
    producto_id             INT REFERENCES productos(id),
    -- Para media pizza
    mitad_1_producto_id     INT REFERENCES productos(id),
    mitad_2_producto_id     INT REFERENCES productos(id),
    -- Para empanadas sueltas
    presentacion_empanada_id INT REFERENCES presentaciones_empanada(id),
    -- Para combos
    combo_id                INT REFERENCES combos(id),
    cantidad                INT NOT NULL DEFAULT 1,
    precio_unitario         NUMERIC(10,2) NOT NULL,
    subtotal                NUMERIC(10,2) NOT NULL,
    notas                   TEXT
);

-- ============================================================
-- MODIFICADORES POR ITEM
-- ============================================================
CREATE TABLE items_modificadores (
    id               SERIAL PRIMARY KEY,
    item_pedido_id   INT NOT NULL REFERENCES items_pedido(id) ON DELETE CASCADE,
    modificador_id   INT NOT NULL REFERENCES modificadores(id),
    precio_adicional NUMERIC(10,2) NOT NULL
);

-- ============================================================
-- SABORES ELEGIDOS POR ITEM DE EMPANADAS
-- ============================================================
CREATE TABLE items_sabores_empanada (
    id                  SERIAL PRIMARY KEY,
    item_pedido_id      INT NOT NULL REFERENCES items_pedido(id) ON DELETE CASCADE,
    sabor_empanada_id   INT NOT NULL REFERENCES sabores_empanada(id),
    cantidad            INT NOT NULL DEFAULT 1
    -- La suma de cantidad debe igualar la cantidad de la presentación
);

-- ============================================================
-- PIZZAS ELEGIDAS DENTRO DE UN COMBO
-- ============================================================
CREATE TABLE combo_pizzas_elegidas (
    id             SERIAL PRIMARY KEY,
    item_pedido_id INT NOT NULL REFERENCES items_pedido(id) ON DELETE CASCADE,
    producto_id    INT NOT NULL REFERENCES productos(id),
    posicion       INT NOT NULL DEFAULT 1  -- si el combo tiene 2 pizzas: posicion 1 y 2
);

-- ============================================================
-- INDICES para mejorar performance de consultas frecuentes
-- ============================================================
CREATE INDEX idx_pedidos_estado      ON pedidos(estado);
CREATE INDEX idx_pedidos_creado_at   ON pedidos(creado_at);
CREATE INDEX idx_pedidos_tipo        ON pedidos(tipo);
CREATE INDEX idx_items_pedido_id     ON items_pedido(pedido_id);
CREATE INDEX idx_items_tipo          ON items_pedido(tipo_item);

-- ============================================================
-- DATOS INICIALES
-- ============================================================

-- Categorías
INSERT INTO categorias (nombre, color, orden) VALUES
    ('Pizzas',    '#E74C3C', 1),
    ('Empanadas', '#E67E22', 2),
    ('Combos',    '#27AE60', 3),
    ('Bebidas',   '#2980B9', 4);

-- Pizzas
INSERT INTO productos (nombre, precio, categoria_id, tipo, orden) VALUES
    ('Muzzarella',    14000, 1, 'pizza', 1),
    ('Napolitana',    16000, 1, 'pizza', 2),
    ('Muzza con Jamón', 16000, 1, 'pizza', 3),
    ('Fugazzeta',     16000, 1, 'pizza', 4),
    ('Huevo',         16000, 1, 'pizza', 5),
    ('Roquefort',     16000, 1, 'pizza', 6),
    ('Anchoa',        17000, 1, 'pizza', 7),
    ('Calabresa',     17000, 1, 'pizza', 8),
    ('Jamón y Morrón', 17000, 1, 'pizza', 9),
    ('Provolone',     17000, 1, 'pizza', 10);

-- Modificadores
INSERT INTO modificadores (nombre, precio_adicional) VALUES
    ('Doble Muzza', 7000),
    ('Agregado',    1000);

-- Sabores de empanada
INSERT INTO sabores_empanada (nombre, orden) VALUES
    ('Carne',         1),
    ('Carne Cuchillo', 2),
    ('Jamón y Queso', 3),
    ('Humita',        4),
    ('Verdura',       5),
    ('Capresse',      6),
    ('Roquefort',     7),
    ('Pollo',         8);

-- Presentaciones de empanada
INSERT INTO presentaciones_empanada (nombre, cantidad, precio) VALUES
    ('Unidad',       1,  2500),
    ('Media docena', 6,  15000),
    ('Docena',       12, 28000);

-- Combos
INSERT INTO combos (nombre, precio, orden) VALUES
    ('1 Muzza + 1 Jamón y Morrón', 28000, 1),
    ('1 Muzza + 1 Napo',           28000, 2),
    ('1 Napo + 1 Jamón y Morrón',  31000, 3),
    ('1 Muzza + 6 Empanadas',      26000, 4),
    ('1 Muzza + 12 Empanadas',     40000, 5),
    ('12 Empanadas',               28000, 6),
    ('2 Muzza',                    26000, 7),
    ('3 Muzza',                    40000, 8);

-- Componentes de los combos
-- Combo 1: 1 Muzza + 1 Jamón y Morrón
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (1, 'pizza', 2);
-- Combo 2: 1 Muzza + 1 Napo
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (2, 'pizza', 2);
-- Combo 3: 1 Napo + 1 Jamón y Morrón
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (3, 'pizza', 2);
-- Combo 4: 1 Muzza + 6 Empanadas
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (4, 'pizza', 1);
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (4, 'empanadas', 6);
-- Combo 5: 1 Muzza + 12 Empanadas
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (5, 'pizza', 1);
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (5, 'empanadas', 12);
-- Combo 6: 12 Empanadas
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (6, 'empanadas', 12);
-- Combo 7: 2 Muzza
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (7, 'pizza', 2);
-- Combo 8: 3 Muzza
INSERT INTO combo_componentes (combo_id, tipo, cantidad) VALUES (8, 'pizza', 3);

-- Configuración general
INSERT INTO configuracion (clave, valor) VALUES
    ('plus_media_pizza', '4000');

-- Usuario dueño inicial (password: cambiar antes de usar en producción)
-- El hash corresponde a la contraseña 'admin123' — CAMBIAR EN PRODUCCIÓN
INSERT INTO usuarios (nombre, email, password_hash, rol) VALUES
    ('Dueño', 'dueno@pizzeria.com', '$2b$12$placeholder_cambiar_en_produccion', 'dueño');
