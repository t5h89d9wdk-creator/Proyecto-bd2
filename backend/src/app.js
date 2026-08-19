const express = require('express');
const cors = require('cors');
const { connectMongo } = require('./config/mongo');
const pool = require('./config/mysql');
const authRoutes = require('./routes/auth.routes');
const incidenciasRoutes = require('./routes/incidencias.routes');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.static('src/frontend'));

app.use('/api/auth', authRoutes);
app.use('/api/incidencias', incidenciasRoutes);

app.get('/api/reportes/estados', async (req, res) => {
  try {
    const [filas] = await pool.query(`
      SELECT e.nombre AS estado, COUNT(i.id_incidencia) AS total
      FROM estados_incidencia e
      LEFT JOIN incidencias i ON e.id_estado = i.id_estado
      GROUP BY e.id_estado, e.nombre
    `);
    res.json(filas);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/reportes/tecnicos', async (req, res) => {
  try {
    const [filas] = await pool.query('SELECT * FROM vw_resumen_por_tecnico');
    res.json(filas);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

async function startServer() {
  try {
    await pool.query('SELECT 1');
    console.log(' Conectado exitosamente a MySQL');
    await connectMongo();
    app.listen(PORT, () => console.log(` Servidor CampusFix en http://localhost:${PORT}`));
  } catch (err) {
    console.error('❌ Error al iniciar servidor:', err);
  }
}

startServer();
