const { Router } = require('express');
const router = Router();
const pool = require('../config/mysql');
const jwt = require('jsonwebtoken');

router.post('/login', async (req, res) => {
  const { correo } = req.body;
  try {
    const [rows] = await pool.query(
      'SELECT u.*, r.nombre AS rol FROM usuarios u INNER JOIN roles r ON u.id_rol = r.id_rol WHERE u.correo = ? AND u.activo = 1',
      [correo]
    );
    if (rows.length === 0) return res.status(401).json({ error: 'Credenciales inválidas o inactivo' });

    const token = jwt.sign(
      { id: rows[0].id_usuario, rol: rows[0].rol },
      process.env.JWT_SECRET || 'secret',
      { expiresIn: '8h' }
    );

    res.json({
      mensaje: 'Login exitoso',
      token,
      usuario: { id: rows[0].id_usuario, nombre: rows[0].nombre, rol: rows[0].rol }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
