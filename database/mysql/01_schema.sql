DROP DATABASE IF EXISTS campusfix;
CREATE DATABASE campusfix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE campusfix;

CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    activo TINYINT(1) DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
) ENGINE=InnoDB;

CREATE TABLE ubicaciones (
    id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE activos (
    id_activo INT AUTO_INCREMENT PRIMARY KEY,
    id_ubicacion INT NOT NULL,
    codigo_activo VARCHAR(50) NOT NULL UNIQUE,
    tipo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    CONSTRAINT fk_activos_ubicaciones FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
) ENGINE=InnoDB;

CREATE TABLE estados_incidencia (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE incidencias (
    id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(30) UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    prioridad ENUM('Baja', 'Media', 'Alta', 'Crítica') DEFAULT 'Media',
    id_activo INT NOT NULL,
    id_usuario_reporta INT NOT NULL,
    id_estado INT NOT NULL DEFAULT 1,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_incidencias_activos FOREIGN KEY (id_activo) REFERENCES activos(id_activo),
    CONSTRAINT fk_incidencias_usuario FOREIGN KEY (id_usuario_reporta) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_incidencias_estado FOREIGN KEY (id_estado) REFERENCES estados_incidencia(id_estado)
) ENGINE=InnoDB;

CREATE TABLE asignaciones (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_incidencia INT NOT NULL,
    id_tecnico INT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo TINYINT(1) DEFAULT 1,
    CONSTRAINT fk_asignaciones_incidencia FOREIGN KEY (id_incidencia) REFERENCES incidencias(id_incidencia),
    CONSTRAINT fk_asignaciones_tecnico FOREIGN KEY (id_tecnico) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE historial_estados (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_incidencia INT NOT NULL,
    id_estado INT NOT NULL,
    id_usuario_cambio INT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacion VARCHAR(255),
    CONSTRAINT fk_historial_incidencia FOREIGN KEY (id_incidencia) REFERENCES incidencias(id_incidencia),
    CONSTRAINT fk_historial_estado FOREIGN KEY (id_estado) REFERENCES estados_incidencia(id_estado),
    CONSTRAINT fk_historial_usuario FOREIGN KEY (id_usuario_cambio) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;
