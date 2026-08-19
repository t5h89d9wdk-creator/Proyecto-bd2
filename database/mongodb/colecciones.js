db = db.getSiblingDB('campusfix_nosql');

db.createCollection('diagnosticos', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['incidenciaId', 'tecnicoId', 'descripcion', 'fecha'],
      properties: {
        incidenciaId: { bsonType: 'int', description: 'ID relacional de la incidencia' },
        tecnicoId: { bsonType: 'int', description: 'ID del técnico' },
        descripcion: { bsonType: 'string', description: 'Descripción técnica obligatoria' },
        pruebasRealizadas: { bsonType: 'array', items: { bsonType: 'string' } },
        causaProbable: { bsonType: 'string' },
        solucionAplicada: { bsonType: 'string' },
        fecha: { bsonType: 'date' }
      }
    }
  }
});
db.diagnosticos.createIndex({ incidenciaId: 1 }, { name: "idx_diagnosticos_incidenciaId" });

db.createCollection('evidencias', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['incidenciaId', 'tipo', 'nombre', 'url', 'fecha'],
      properties: {
        incidenciaId: { bsonType: 'int', description: 'ID relacional de la incidencia' },
        tipo: { bsonType: 'string', enum: ['imagen', 'documento', 'video', 'log'] },
        nombre: { bsonType: 'string' },
        url: { bsonType: 'string' },
        descripcion: { bsonType: 'string' },
        fecha: { bsonType: 'date' }
      }
    }
  }
});
db.evidencias.createIndex({ incidenciaId: 1 }, { name: "idx_evidencias_incidenciaId" });
