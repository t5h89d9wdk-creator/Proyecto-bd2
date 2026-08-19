const { Router } = require('express');
const router = Router();
const controller = require('../controllers/incidencias.controller');

router.get('/', controller.listarIncidencias);
router.post('/', controller.registrarIncidencia);
router.get('/:id', controller.obtenerDetalleIntegrado);
router.put('/:id/asignar', controller.asignarTecnico);
router.put('/:id/estado', controller.cambiarEstado);
router.post('/:id/diagnosticos', controller.registrarDiagnostico);
router.post('/:id/evidencias', controller.registrarEvidencia);

module.exports = router;
