USE campusfix;

-- Roles
INSERT INTO roles (id_rol, nombre) VALUES
(1, 'Administrador'), (2, 'Técnico'), (3, 'Usuario');

-- Usuarios
INSERT INTO usuarios (id_usuario, id_rol, nombre, correo, password, activo) VALUES
(1, 1, 'Carlos Mendoza', 'admin.carlos@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(2, 1, 'Valeria Morales', 'admin.valeria@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(3, 2, 'Ana Torres', 'tec.ana@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(4, 2, 'David Paredes', 'tec.david@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(5, 2, 'Jorge Salavarría', 'tec.jorge@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(6, 2, 'Elena Gómez', 'tec.elena@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(7, 3, 'René Ibarra', 'rene.ibarra@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(8, 3, 'Lucía Fernández', 'lucia.f@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(9, 3, 'Mateo Cevallos', 'mateo.c@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1),
(10, 3, 'Sofía Ramírez', 'sofia.r@ecotec.edu.ec', '$2b$10$wN7Kk5r9Z4pA2y4XqB5xte1GqX2Y3Z4A5B6C7D8E9F0G1H2I3J4K5', 1);

-- Ubicaciones
INSERT INTO ubicaciones (id_ubicacion, nombre, descripcion) VALUES
(1, 'Laboratorio de Cómputo 1', 'Planta Baja - Bloque A'),
(2, 'Laboratorio de Cómputo 2', 'Planta Alta - Bloque A'),
(3, 'Aula Magna 204', 'Segundo Piso - Bloque Central'),
(4, 'Biblioteca General', 'Edificio Central - Zona de Estudio'),
(5, 'Auditorio Principal', 'Planta Baja - Bloque Administrativo');

-- Activos
INSERT INTO activos (id_activo, id_ubicacion, codigo_activo, tipo, descripcion) VALUES
(1, 1, 'ACT-PC-001', 'Computador', 'Dell OptiPlex 7090 - Core i7, 16GB RAM'),
(2, 1, 'ACT-PC-002', 'Computador', 'Dell OptiPlex 7090 - Core i7, 16GB RAM'),
(3, 1, 'ACT-PC-003', 'Computador', 'Dell OptiPlex 7090 - Core i7, 16GB RAM'),
(4, 1, 'ACT-PR-001', 'Proyector', 'Epson PowerLite X49 HDMI'),
(5, 2, 'ACT-PC-004', 'Computador', 'HP ProDesk 400 G6 - Core i5, 8GB RAM'),
(6, 2, 'ACT-PC-005', 'Computador', 'HP ProDesk 400 G6 - Core i5, 8GB RAM'),
(7, 2, 'ACT-SW-001', 'Switch Red', 'Cisco Catalyst 24 Puertos Gigabit'),
(8, 3, 'ACT-PR-002', 'Proyector', 'BenQ Láser Interactivo 4K'),
(9, 3, 'ACT-AU-001', 'Sistema Audio', 'Consola Mezcladora Yamaha + 2 Parlantes'),
(10, 4, 'ACT-PC-006', 'Computador', 'Lenovo ThinkCentre M70q'),
(11, 4, 'ACT-PC-007', 'Computador', 'Lenovo ThinkCentre M70q'),
(12, 4, 'ACT-IMP-001', 'Impresora', 'HP LaserJet Enterprise Multifuncional'),
(13, 5, 'ACT-PR-003', 'Proyector', 'Epson Pro L1070U Alta Luminosidad'),
(14, 5, 'ACT-AU-002', 'Sistema Audio', 'Microfonía inalámbrica Shure doble canal'),
(15, 5, 'ACT-AP-001', 'Access Point', 'Ubiquiti UniFi AP 6 Pro');

-- Estados
INSERT INTO estados_incidencia (id_estado, nombre) VALUES
(1, 'Registrada'), (2, 'Asignada'), (3, 'En proceso'), (4, 'Resuelta');

-- Incidencias
INSERT INTO incidencias (id_incidencia, codigo, titulo, descripcion, prioridad, id_activo, id_usuario_reporta, id_estado, fecha_registro) VALUES
(1, 'INC-2026-0001', 'Pantalla azul recurrente', 'El equipo se reinicia constantemente al abrir programas.', 'Alta', 1, 7, 4, '2026-08-01 08:30:00'),
(2, 'INC-2026-0002', 'Lámpara de proyector parpadea', 'La imagen pierde intensidad después de 15 minutos de uso.', 'Media', 4, 8, 4, '2026-08-01 09:15:00'),
(3, 'INC-2026-0003', 'Fallo de puerto Ethernet', 'No recibe dirección IP por DHCP.', 'Media', 2, 9, 4, '2026-08-02 10:00:00'),
(4, 'INC-2026-0004', 'Impresora traba papel', 'Bandeja 2 atasca las hojas continuamente.', 'Baja', 12, 10, 4, '2026-08-02 11:20:00'),
(5, 'INC-2026-0005', 'Sin señal HDMI en proyector', 'El cable en pared no envía señal de video al proyector.', 'Alta', 8, 7, 4, '2026-08-03 08:00:00'),
(6, 'INC-2026-0006', 'Ruido excesivo en ventilador', 'Ventilador del chasis suena muy fuerte al encender.', 'Baja', 5, 8, 4, '2026-08-03 14:10:00'),
(7, 'INC-2026-0007', 'Interferencia de audio', 'Microfonía inalámbrica presenta chillido constante.', 'Media', 14, 9, 4, '2026-08-04 09:00:00'),
(8, 'INC-2026-0008', 'Corte intermitente de Wi-Fi', 'El AP reinicia su transmisión periódicamente.', 'Crítica', 15, 10, 4, '2026-08-04 11:45:00'),
(9, 'INC-2026-0009', 'Lentitud extrema en inicio', 'Tarda más de 10 minutos en arrancar el sistema operativo.', 'Baja', 10, 7, 4, '2026-08-05 08:40:00'),
(10, 'INC-2026-0010', 'Puertos USB frontales inoperativos', 'No reconoce memorias USB ni periféricos en el frontal.', 'Media', 3, 8, 4, '2026-08-05 13:00:00'),
(11, 'INC-2026-0011', 'Teclado y ratón no responden', 'Se desconectan solos cada pocos minutos.', 'Baja', 6, 9, 4, '2026-08-06 10:15:00'),
(12, 'INC-2026-0012', 'Computador no da video', 'Enciende los ventiladores pero no muestra imagen en monitor.', 'Alta', 11, 10, 4, '2026-08-06 15:30:00'),
(13, 'INC-2026-0013', 'Switch con puertos caídos', 'Puertos del 1 al 8 no levantan enlace.', 'Crítica', 7, 7, 3, '2026-08-07 09:20:00'),
(14, 'INC-2026-0014', 'Consola no enciende', 'No responde al interruptor de encendido general.', 'Alta', 9, 8, 3, '2026-08-07 11:00:00'),
(15, 'INC-2026-0015', 'Proyector con manchas amarillas', 'La óptica presenta manchas notorias en proyecciones oscuras.', 'Media', 13, 9, 3, '2026-08-08 08:50:00'),
(16, 'INC-2026-0016', 'Bloqueo al cargar software CAD', 'El equipo se cuelga al iniciar modelado 3D.', 'Alta', 1, 10, 3, '2026-08-08 14:00:00'),
(17, 'INC-2026-0017', 'Error de cartucho negro', 'Impresora indica cartucho incompatible o no instalado.', 'Baja', 12, 7, 3, '2026-08-09 10:30:00'),
(18, 'INC-2026-0018', 'Pérdida de paquetes en red', 'Alta latencia hacia el servidor interno.', 'Crítica', 7, 8, 3, '2026-08-09 12:15:00'),
(19, 'INC-2026-0019', 'Altavoz derecho sin audio', 'Solo reproduce canal izquierdo del audio ambiental.', 'Media', 9, 9, 3, '2026-08-10 09:00:00'),
(20, 'INC-2026-0020', 'Fuente de poder zumba', 'Emite un zumbido eléctrico al estar en carga máxima.', 'Alta', 2, 10, 3, '2026-08-10 16:20:00'),
(21, 'INC-2026-0021', 'Mala calibración táctil', 'El lápiz interactivo no apunta en la zona correcta.', 'Baja', 8, 7, 2, '2026-08-11 08:30:00'),
(22, 'INC-2026-0022', 'Monitores secundarios parpadean', 'Pantallas auxiliares se apagan por 1 segundo.', 'Media', 3, 8, 2, '2026-08-11 11:10:00'),
(23, 'INC-2026-0023', 'No guarda configuraciones BIOS', 'La hora y fecha se resetean al desconectar energía.', 'Baja', 5, 9, 2, '2026-08-12 09:40:00'),
(24, 'INC-2026-0024', 'Desconexión de red inalámbrica', 'Desconecta a usuarios pasados 20 minutos de sesión.', 'Alta', 15, 10, 2, '2026-08-12 14:50:00'),
(25, 'INC-2026-0025', 'Falla de sensor de tóner', 'No lee nivel correcto de consumibles.', 'Baja', 12, 7, 2, '2026-08-13 10:00:00'),
(26, 'INC-2026-0026', 'Ventilador proyector bloqueado', 'Muestra aviso de filtro o ventilador obstruido.', 'Media', 4, 8, 1, '2026-08-13 15:10:00'),
(27, 'INC-2026-0027', 'Disco duro con sectores dañados', 'Aparecen advertencias SMART al iniciar el BIOS.', 'Alta', 6, 9, 1, '2026-08-14 08:20:00'),
(28, 'INC-2026-0028', 'Filtro de polvo saturado', 'Proyector se apaga automáticamente por temperatura.', 'Media', 13, 10, 1, '2026-08-14 11:30:00'),
(29, 'INC-2026-0029', 'Audio saturado en micro 2', 'Nivel de ganancia distorsiona la voz.', 'Baja', 14, 7, 1, '2026-08-15 09:10:00'),
(30, 'INC-2026-0030', 'Error de asignación VLAN', 'Puerto 12 asignado a VLAN de invitados por error.', 'Crítica', 7, 8, 1, '2026-08-15 13:40:00');

-- Asignaciones
INSERT INTO asignaciones (id_asignacion, id_incidencia, id_tecnico, fecha_asignacion, activo) VALUES
(1, 1, 3, '2026-08-01 09:00:00', 1), (2, 2, 4, '2026-08-01 10:00:00', 1),
(3, 3, 5, '2026-08-02 10:30:00', 1), (4, 4, 6, '2026-08-02 12:00:00', 1),
(5, 5, 3, '2026-08-03 08:30:00', 1), (6, 6, 4, '2026-08-03 14:30:00', 1),
(7, 7, 5, '2026-08-04 09:30:00', 1), (8, 8, 6, '2026-08-04 12:00:00', 1),
(9, 9, 3, '2026-08-05 09:00:00', 1), (10, 10, 4, '2026-08-05 13:30:00', 1),
(11, 11, 5, '2026-08-06 10:45:00', 1), (12, 12, 6, '2026-08-06 16:00:00', 1),
(13, 13, 3, '2026-08-07 10:00:00', 1), (14, 14, 4, '2026-08-07 11:30:00', 1),
(15, 15, 5, '2026-08-08 09:15:00', 1), (16, 16, 6, '2026-08-08 14:30:00', 1),
(17, 17, 3, '2026-08-09 11:00:00', 1), (18, 18, 4, '2026-08-09 13:00:00', 1),
(19, 19, 5, '2026-08-10 09:30:00', 1), (20, 20, 6, '2026-08-10 17:00:00', 1);

-- Historial
INSERT INTO historial_estados (id_historial, id_incidencia, id_estado, id_usuario_cambio, fecha_cambio, observacion) VALUES
(1, 1, 1, 7, '2026-08-01 08:30:00', 'Registro de incidencia'),
(2, 1, 2, 1, '2026-08-01 09:00:00', 'Asignada a Ana Torres'),
(3, 1, 3, 3, '2026-08-01 10:00:00', 'En revisión técnica'),
(4, 1, 4, 3, '2026-08-01 12:00:00', 'Resuelta con cambio de memoria'),
(5, 2, 1, 8, '2026-08-01 09:15:00', 'Registro de incidencia'),
(6, 2, 2, 1, '2026-08-01 10:00:00', 'Asignada a David Paredes'),
(7, 2, 3, 4, '2026-08-01 11:00:00', 'Iniciando diagnóstico óptico'),
(8, 2, 4, 4, '2026-08-01 14:00:00', 'Lámpara sustituida y calibrada'),
(9, 3, 1, 9, '2026-08-02 10:00:00', 'Registro de incidencia'),
(10, 3, 2, 2, '2026-08-02 10:30:00', 'Asignada a Jorge Salavarría'),
(11, 3, 3, 5, '2026-08-02 11:00:00', 'Probando conector de red'),
(12, 3, 4, 5, '2026-08-02 13:30:00', 'Conector RJ45 crimpado nuevamente'),
(13, 4, 1, 10, '2026-08-02 11:20:00', 'Registro de incidencia'),
(14, 4, 2, 2, '2026-08-02 12:00:00', 'Asignada a Elena Gómez'),
(15, 4, 3, 6, '2026-08-02 14:00:00', 'Mantenimiento de rodillos'),
(16, 4, 4, 6, '2026-08-02 16:00:00', 'Rodillo de alimentación limpiado'),
(17, 5, 1, 7, '2026-08-03 08:00:00', 'Registro de incidencia'),
(18, 5, 2, 1, '2026-08-03 08:30:00', 'Asignada a Ana Torres'),
(19, 5, 4, 3, '2026-08-03 11:00:00', 'Cable HDMI reemplazado'),
(20, 6, 1, 8, '2026-08-03 14:10:00', 'Registro de incidencia'),
(21, 6, 2, 1, '2026-08-03 14:30:00', 'Asignada a David Paredes'),
(22, 6, 4, 4, '2026-08-03 17:00:00', 'Ventilador lubricado y fijado'),
(23, 7, 1, 9, '2026-08-04 09:00:00', 'Registro de incidencia'),
(24, 7, 2, 2, '2026-08-04 09:30:00', 'Asignada a Jorge Salavarría'),
(25, 7, 4, 5, '2026-08-04 12:30:00', 'Frecuencia de canal ajustada'),
(26, 8, 1, 10, '2026-08-04 11:45:00', 'Registro de incidencia'),
(27, 8, 2, 2, '2026-08-04 12:00:00', 'Asignada a Elena Gómez'),
(28, 8, 4, 6, '2026-08-04 15:00:00', 'Firmware actualizado a versión estable'),
(29, 9, 1, 7, '2026-08-05 08:40:00', 'Registro de incidencia'),
(30, 9, 2, 1, '2026-08-05 09:00:00', 'Asignada a Ana Torres'),
(31, 9, 4, 3, '2026-08-05 11:30:00', 'Optimización de servicios de arranque'),
(32, 10, 1, 8, '2026-08-05 13:00:00', 'Registro de incidencia'),
(33, 10, 2, 1, '2026-08-05 13:30:00', 'Asignada a David Paredes'),
(34, 10, 4, 4, '2026-08-05 16:00:00', 'Conector de placa madre reconectado'),
(35, 11, 1, 9, '2026-08-06 10:15:00', 'Registro de incidencia'),
(36, 11, 2, 2, '2026-08-06 10:45:00', 'Asignada a Jorge Salavarría'),
(37, 11, 4, 5, '2026-08-06 12:45:00', 'Reemplazo de periféricos defectuosos'),
(38, 12, 1, 10, '2026-08-06 15:30:00', 'Registro de incidencia'),
(39, 12, 2, 2, '2026-08-06 16:00:00', 'Asignada a Elena Gómez'),
(40, 12, 4, 6, '2026-08-06 18:00:00', 'Reasentamiento de tarjeta gráfica');
