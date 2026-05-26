# Registro de decisiones técnicas (ADR)

## ADR-001 — Kotlin sobre Java para Android
**Decisión:** Usar Kotlin como lenguaje principal de la app Android.  
**Motivo:** Es el estándar oficial de Android desde 2019. Compatible con el conocimiento previo de Java del desarrollador. Más conciso y seguro (null safety).

## ADR-002 — FastAPI sobre Django/Flask
**Decisión:** Usar FastAPI para el backend.  
**Motivo:** Más rápido de desarrollar que Django para APIs puras. Genera documentación automática (Swagger). Tipado nativo con Python 3.11+.

## ADR-003 — Supabase sobre Firebase
**Decisión:** Usar Supabase (PostgreSQL) como base de datos.  
**Motivo:** El desarrollador ya conoce SQL. Control total sobre el esquema. Plan gratuito generoso. Incluye Storage para imágenes y autenticación si se necesita.

## ADR-004 — Monorepo vs repos separados
**Decisión:** 4 repositorios separados (docs, backend, app, web).  
**Motivo:** Cada componente tiene su propio ciclo de deploy y dependencias. Más fácil de manejar para un desarrollador solo.

## ADR-005 — Sin módulo de clientes
**Decisión:** No se implementa módulo de clientes con historial.  
**Motivo:** La pizzería no identifica clientes. Los datos de delivery (nombre, dirección, teléfono) se guardan por pedido pero no se vinculan a un perfil de cliente.

## ADR-006 — Precio de media pizza
**Decisión:** Precio = mayor precio entre las dos mitades + plus configurable.  
**Motivo:** Refleja la lógica de negocio real de la pizzería. El plus es configurable desde la app sin tocar código.

## ADR-007 — Descuentos vía combos
**Decisión:** No hay descuentos ad-hoc. Las promociones se manejan como combos con precio fijo.  
**Motivo:** Simplifica el flujo de cobro. Evita errores humanos al aplicar descuentos. El precio especial queda registrado como combo en el historial.
