// Conexión o cambio a la base de datos de CampusFix en MongoDB
db = db.getSiblingDB('campusfix_nosql');

// ==========================================================
// 1. Colección: diagnosticos
// ==========================================================
db.createCollection('diagnosticos', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['incidenciaId', 'tecnicoId', 'descripcion', 'fecha'],
      properties: {
        incidenciaId: {
          bsonType: 'int',
          description: 'ID relacional de la incidencia (obligatorio, entero)'
        },
        tecnicoId: {
          bsonType: 'int',
          description: 'ID relacional del técnico (obligatorio, entero)'
        },
        descripcion: {
          bsonType: 'string',
          description: 'Descripción detallada del diagnóstico (obligatorio)'
        },
        pruebasRealizadas: {
          bsonType: 'array',
          items: { bsonType: 'string' },
          description: 'Lista de pruebas ejecutadas por el técnico'
        },
        causaProbable: {
          bsonType: 'string',
          description: 'Causa raíz identificada del problema'
        },
        solucionAplicada: {
          bsonType: 'string',
          description: 'Solución implementada'
        },
        fecha: {
          bsonType: 'date',
          description: 'Fecha y hora del diagnóstico (obligatorio)'
        }
      }
    }
  }
});

// Índice obligatorio en incidenciaId para optimizar consultas híbridas
db.diagnosticos.createIndex({ incidenciaId: 1 }, { name: "idx_diagnosticos_incidenciaId" });


// ==========================================================
// 2. Colección: evidencias
// ==========================================================
db.createCollection('evidencias', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['incidenciaId', 'tipo', 'nombre', 'url', 'fecha'],
      properties: {
        incidenciaId: {
          bsonType: 'int',
          description: 'ID relacional de la incidencia (obligatorio, entero)'
        },
        tipo: {
          bsonType: 'string',
          enum: ['imagen', 'documento', 'video', 'log'],
          description: 'Tipo de archivo o evidencia'
        },
        nombre: {
          bsonType: 'string',
          description: 'Nombre del archivo (obligatorio)'
        },
        url: {
          bsonType: 'string',
          description: 'Ruta o URL del recurso (obligatorio)'
        },
        descripcion: {
          bsonType: 'string',
          description: 'Detalle o descripción de la evidencia'
        },
        fecha: {
          bsonType: 'date',
          description: 'Fecha y hora de registro de la evidencia (obligatorio)'
        }
      }
    }
  }
});

// Índice obligatorio en incidenciaId
db.evidencias.createIndex({ incidenciaId: 1 }, { name: "idx_evidencias_incidenciaId" });
