CREATE TABLE IF NOT EXISTS "Usuario"
(
    id bigint NOT NULL,
    nombre character varying(20)  NOT NULL,
    email character varying(40)  NOT NULL,
    contrasenna character varying(20) ,
    CONSTRAINT "Usuario_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "Tipo_Facturacion"
(
    id bigint NOT NULL,
    nombre character varying(20) ,
    CONSTRAINT "Tipo_Facturacion_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "Datos_Facturacion"
(
    id bigint NOT NULL,
    tarjeta character varying ,
    tipo bigint,
    CONSTRAINT "Datos_Facturacion_pkey" PRIMARY KEY (id),
    CONSTRAINT "Datos_Facturacion_tipo_fkey" FOREIGN KEY (tipo)
        REFERENCES "Tipo_Facturacion" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE IF NOT EXISTS "Pago"
(
    id bigint NOT NULL,
    fecha timestamp with time zone NOT NULL,
    monto numeric(8,2) NOT NULL,
    CONSTRAINT "Pago_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "Curso"
(
    id bigint NOT NULL,
    nombre character varying  NOT NULL,
    descripcion text ,
    precio numeric(6,2),
    duracion character varying(10) ,
    CONSTRAINT "Curso_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "Modulo"
(
    id bigint,
    nombre character varying(50) ,
    id_curso bigint NOT NULL,
    url text ,
    CONSTRAINT "Modulo_pkey" PRIMARY KEY (id_curso),
    CONSTRAINT "Modulo_id_curso_fkey" FOREIGN KEY (id_curso)
        REFERENCES "Curso" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS "Profesor"
(
    id bigint,
    nombre character varying(30) ,
    email character varying(30) ,
    direccion character varying(50) ,
    telefono character varying(12) ,
    id_usuario bigint NOT NULL,
    CONSTRAINT "Profesor_pkey" PRIMARY KEY (id_usuario),
    CONSTRAINT "FK_usuario" FOREIGN KEY (id_usuario)
        REFERENCES "Usuario" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS "Alumno"
(
    id bigint NOT NULL,
    nombre character varying(30) ,
    email character varying(30) ,
    direccion character varying(50) ,
    datos_facturacion bigint,
    CONSTRAINT "Alumno_pkey" PRIMARY KEY (id),
    CONSTRAINT "Alumno_datos_facturacion_fkey" FOREIGN KEY (datos_facturacion)
        REFERENCES "Datos_Facturacion" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE IF NOT EXISTS "Alumno_Curso"
(
    id bigint,
    id_alumno bigint NOT NULL,
    id_curso bigint NOT NULL,
    fecha_inicio date,
    nota_final numeric(2,1),
    id_datos_pago bigint,
    CONSTRAINT "Alumno_Curso_pkey" PRIMARY KEY (id_alumno),
    CONSTRAINT "Alumno_Curso_id_alumno_fkey" FOREIGN KEY (id_alumno)
        REFERENCES "Alumno" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Alumno_Curso_id_curso_fkey" FOREIGN KEY (id_curso)
        REFERENCES "Curso" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Alumno_Curso_id_datos_pago_fkey" FOREIGN KEY (id_datos_pago)
        REFERENCES "Pago" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
