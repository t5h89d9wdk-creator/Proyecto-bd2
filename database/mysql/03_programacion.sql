USE campusfix;

DELIMITER $$

-- Trigger: Generar código de incidencia
CREATE TRIGGER trg_generar_codigo_incidencia
BEFORE INSERT ON incidencias
FOR EACH ROW
BEGIN
    DECLARE v_siguiente INT;
    IF NEW.codigo IS NULL OR NEW.codigo = '' THEN
        SELECT IFNULL(MAX(id_incidencia), 0) + 1 INTO v_siguiente FROM incidencias;
        SET NEW.codigo = CONCAT('INC-2026-', LPAD(v_siguiente, 4, '0'));
    END IF;
END$$

-- Trigger: Auditoría automática a historial_estados
CREATE TRIGGER trg_auditoria_historial_estado
AFTER UPDATE ON incidencias
FOR EACH ROW
BEGIN
    IF OLD.id_estado <> NEW.id_estado THEN
        INSERT INTO historial_estados (id_incidencia, id_estado, id_usuario_cambio, observacion)
        VALUES (NEW.id_incidencia, NEW.id_estado, NULL, 'Cambio automático por trigger');
    END IF;
END$$

-- Trigger: Impedir eliminación de resuelta
CREATE TRIGGER trg_impedir_eliminacion_resuelta
BEFORE DELETE ON incidencias
FOR EACH ROW
BEGIN
    DECLARE v_nombre_estado VARCHAR(50);
    SELECT nombre INTO v_nombre_estado FROM estados_incidencia WHERE id_estado = OLD.id_estado;
    IF v_nombre_estado = 'Resuelta' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar físicamente una incidencia resuelta.';
    END IF;
END$$

-- Función: Días transcurridos
CREATE FUNCTION fn_dias_transcurridos(p_id_incidencia INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_dias INT;
    SELECT DATEDIFF(NOW(), fecha_registro) INTO v_dias FROM incidencias WHERE id_incidencia = p_id_incidencia;
    RETURN IFNULL(v_dias, 0);
END$$

-- Función: Incidencias activas técnico
CREATE FUNCTION fn_incidencias_activas_tecnico(p_id_tecnico INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(DISTINCT a.id_incidencia) INTO v_total
    FROM asignaciones a
    INNER JOIN incidencias i ON a.id_incidencia = i.id_incidencia
    INNER JOIN estados_incidencia e ON i.id_estado = e.id_estado
    WHERE a.id_tecnico = p_id_tecnico AND a.activo = 1 AND e.nombre IN ('Asignada', 'En proceso');
    RETURN IFNULL(v_total, 0);
END$$

-- SP: Registrar incidencia
CREATE PROCEDURE sp_registrar_incidencia(
    IN p_titulo VARCHAR(150),
    IN p_descripcion TEXT,
    IN p_prioridad ENUM('Baja', 'Media', 'Alta', 'Crítica'),
    IN p_id_activo INT,
    IN p_id_usuario INT
)
BEGIN
    DECLARE v_id_estado_reg INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        SELECT id_estado INTO v_id_estado_reg FROM estados_incidencia WHERE nombre = 'Registrada' LIMIT 1;
        INSERT INTO incidencias (titulo, descripcion, prioridad, id_activo, id_usuario_reporta, id_estado)
        VALUES (p_titulo, p_descripcion, p_prioridad, p_id_activo, p_id_usuario, v_id_estado_reg);
        
        INSERT INTO historial_estados (id_incidencia, id_estado, id_usuario_cambio, observacion)
        VALUES (LAST_INSERT_ID(), v_id_estado_reg, p_id_usuario, 'Registro inicial de incidencia');
    COMMIT;
END$$

-- SP: Asignar técnico (Transacción)
CREATE PROCEDURE sp_asignar_tecnico(
    IN p_id_incidencia INT,
    IN p_id_tecnico INT,
    IN p_id_admin INT
)
BEGIN
    DECLARE v_id_estado_asig INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        SELECT id_estado INTO v_id_estado_asig FROM estados_incidencia WHERE nombre = 'Asignada' LIMIT 1;
        UPDATE asignaciones SET activo = 0 WHERE id_incidencia = p_id_incidencia;
        INSERT INTO asignaciones (id_incidencia, id_tecnico, activo) VALUES (p_id_incidencia, p_id_tecnico, 1);
        UPDATE incidencias SET id_estado = v_id_estado_asig WHERE id_incidencia = p_id_incidencia;
        INSERT INTO historial_estados (id_incidencia, id_estado, id_usuario_cambio, observacion)
        VALUES (p_id_incidencia, v_id_estado_asig, p_id_admin, CONCAT('Asignado a técnico ID: ', p_id_tecnico));
    COMMIT;
END$$

-- SP: Cambiar estado
CREATE PROCEDURE sp_cambiar_estado(
    IN p_id_incidencia INT,
    IN p_nuevo_estado_nombre VARCHAR(50),
    IN p_id_usuario INT,
    IN p_observacion VARCHAR(255)
)
BEGIN
    DECLARE v_id_nuevo_estado INT;
    DECLARE v_tecnico_asignado INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        SELECT id_estado INTO v_id_nuevo_estado FROM estados_incidencia WHERE nombre = p_nuevo_estado_nombre LIMIT 1;
        IF v_id_nuevo_estado IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado no válido.';
        END IF;

        IF p_nuevo_estado_nombre = 'En proceso' THEN
            SELECT COUNT(*) INTO v_tecnico_asignado FROM asignaciones WHERE id_incidencia = p_id_incidencia AND activo = 1;
            IF v_tecnico_asignado = 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede pasar a En proceso sin técnico asignado.';
            END IF;
        END IF;

        UPDATE incidencias SET id_estado = v_id_nuevo_estado WHERE id_incidencia = p_id_incidencia;
        INSERT INTO historial_estados (id_incidencia, id_estado, id_usuario_cambio, observacion)
        VALUES (p_id_incidencia, v_id_nuevo_estado, p_id_usuario, p_observacion);
    COMMIT;
END$$

DELIMITER ;

-- Vistas
CREATE OR REPLACE VIEW vw_incidencias_activas AS
SELECT 
    i.id_incidencia, i.codigo, i.titulo, i.prioridad, e.nombre AS estado,
    u_rep.nombre AS reportado_por, u_tec.nombre AS tecnico_asignado,
    a.codigo_activo, ub.nombre AS ubicacion, i.fecha_registro,
    fn_dias_transcurridos(i.id_incidencia) AS dias_abierta
FROM incidencias i
INNER JOIN estados_incidencia e ON i.id_estado = e.id_estado
INNER JOIN usuarios u_rep ON i.id_usuario_reporta = u_rep.id_usuario
INNER JOIN activos a ON i.id_activo = a.id_activo
INNER JOIN ubicaciones ub ON a.id_ubicacion = ub.id_ubicacion
LEFT JOIN asignaciones asg ON i.id_incidencia = asg.id_incidencia AND asg.activo = 1
LEFT JOIN usuarios u_tec ON asg.id_tecnico = u_tec.id_usuario
WHERE e.nombre <> 'Resuelta';

CREATE OR REPLACE VIEW vw_resumen_por_tecnico AS
SELECT 
    u.id_usuario AS id_tecnico, u.nombre AS tecnico,
    fn_incidencias_activas_tecnico(u.id_usuario) AS incidencias_activas,
    COUNT(CASE WHEN e.nombre = 'Resuelta' THEN 1 END) AS incidencias_resueltas
FROM usuarios u
INNER JOIN roles r ON u.id_rol = r.id_rol
LEFT JOIN asignaciones asg ON u.id_usuario = asg.id_tecnico
LEFT JOIN incidencias i ON asg.id_incidencia = i.id_incidencia
LEFT JOIN estados_incidencia e ON i.id_estado = e.id_estado
WHERE r.nombre = 'Técnico'
GROUP BY u.id_usuario, u.nombre;
