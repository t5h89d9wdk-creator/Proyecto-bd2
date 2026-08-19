const mysqlPool = require('../config/mysql');
const { connectMongo } = require('../config/mongo');

exports.listarIncidencias = async (req, res) => {
  try {
    const [filas] = await mysqlPool.query('SELECT * FROM vw_incidencias_activas');
    res.json(filas);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.obtenerDetalleIntegrado = async (req, res) => {
  const { id } = req.params;
  const incidenciaIdNum = parseInt(id, 10);
  if (isNaN(incidenciaIdNum)) return res.status(400).json({ error: 'ID no válido' });

  try {
    const sqlQuery = `
      SELECT 
        i.id_incidencia AS id, i.codigo, i.titulo, i.descripcion, i.prioridad,
        e.nombre AS estado, u_rep.nombre AS reportado_por, u_tec.nombre AS tecnico,
        a.codigo_activo, ub.nombre AS ubicacion, i.fecha_registro
      FROM incidencias i
      INNER JOIN estados_incidencia e ON i.id_estado = e.id_estado
      INNER JOIN usuarios u_rep ON i.id_usuario_reporta = u_rep.id_usuario
      INNER JOIN activos a ON i.id_activo = a.id_activo
      INNER JOIN ubicaciones ub ON a.id_ubicacion = ub.id_ubicacion
      LEFT JOIN asignaciones asg ON i.id_incidencia = asg.id_incidencia AND asg.activo = 1
      LEFT JOIN usuarios u_tec ON asg.id_tecnico = u_tec.id_usuario
      WHERE i.id_incidencia = ?
    `;
    const [rows] = await mysqlPool.query(sqlQuery, [incidenciaIdNum]);
    if (rows.length === 0) return res.status(404).json({ error: 'Incidencia no encontrada' });

    const mongoDb = await connectMongo();
    const diagnosticos = await mongoDb.collection('diagnosticos').find({ incidenciaId: incidenciaIdNum }).toArray();
    const evidencias = await mongoDb.collection('evidencias').find({ incidenciaId: incidenciaIdNum }).toArray();

    res.json({
      incidencia: rows[0],
      diagnosticos,
      evidencias
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.registrarIncidencia = async (req, res) => {
  const { titulo, descripcion, prioridad, id_activo, id_usuario } = req.body;
  try {
    await mysqlPool.query('CALL sp_registrar_incidencia(?, ?, ?, ?, ?)', [
      titulo, descripcion, prioridad || 'Media', id_activo, id_usuario
    ]);
    res.status(201).json({ mensaje: 'Incidencia registrada exitosamente' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.asignarTecnico = async (req, res) => {
  const { id } = req.params;
  const { id_tecnico, id_admin } = req.body;
  try {
    await mysqlPool.query('CALL sp_asignar_tecnico(?, ?, ?)', [id, id_tecnico, id_admin]);
    res.json({ mensaje: 'Técnico asignado correctamente' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.cambiarEstado = async (req, res) => {
  const { id } = req.params;
  const { nuevo_estado, id_usuario, observacion } = req.body;
  const incidenciaIdNum = parseInt(id, 10);

  try {
    if (nuevo_estado === 'Resuelta') {
      const mongoDb = await connectMongo();
      const countDiag = await mongoDb.collection('diagnosticos').countDocuments({ incidenciaId: incidenciaIdNum });
      if (countDiag === 0) {
        return res.status(400).json({ error: 'No se puede marcar Resuelta sin diagnóstico en MongoDB.' });
      }
    }

    await mysqlPool.query('CALL sp_cambiar_estado(?, ?, ?, ?)', [
      incidenciaIdNum, nuevo_estado, id_usuario, observacion || 'Cambio de estado'
    ]);
    res.json({ mensaje: `Estado cambiado a ${nuevo_estado}` });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.registrarDiagnostico = async (req, res) => {
  const { id } = req.params;
  const { tecnicoId, descripcion, pruebasRealizadas, causaProbable, solucionAplicada } = req.body;
  try {
    const mongoDb = await connectMongo();
    await mongoDb.collection('diagnosticos').insertOne({
      incidenciaId: parseInt(id, 10),
      tecnicoId: parseInt(tecnicoId, 10),
      descripcion,
      pruebasRealizadas: pruebasRealizadas || [],
      causaProbable: causaProbable || '',
      solucionAplicada: solucionAplicada || '',
      fecha: new Date()
    });
    res.status(201).json({ mensaje: 'Diagnóstico guardado en MongoDB' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.registrarEvidencia = async (req, res) => {
  const { id } = req.params;
  const { tipo, nombre, url, descripcion } = req.body;
  try {
    const mongoDb = await connectMongo();
    await mongoDb.collection('evidencias').insertOne({
      incidenciaId: parseInt(id, 10),
      tipo: tipo || 'imagen',
      nombre,
      url,
      descripcion: descripcion || '',
      fecha: new Date()
    });
    res.status(201).json({ mensaje: 'Evidencia guardada en MongoDB' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
