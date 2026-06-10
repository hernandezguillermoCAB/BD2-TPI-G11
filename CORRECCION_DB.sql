USE DB_TPINTEGRADOR
GO

DROP TABLE AgendaDoctor;
GO

CREATE TABLE AgendaDoctor
(
    IDAgenda int identity(1,1) primary key,
    IDConsultoriosxDoctor int not null,
    DiaSemana tinyint not null CHECK (DiaSemana BETWEEN 1 AND 7), 
    HoraInicio time not null,
    HoraFin time not null,

    CONSTRAINT FK_AgendaDoctor_ConsultoriosxDoctor FOREIGN KEY (IDConsultoriosxDoctor) REFERENCES ConsultoriosxDoctor(IDConsultoriosxDoc)
);
GO
-- Creamos tablas Roles para manejar los accesos y limitar las acciones dentro de la app web, ademas la tabla usuario con  un id nombre y contrasenia (ademas de relacionarse con roles)
CREATE TABLE Roles 
(
    IdRol int identity(1,1) PRIMARY KEY,
    Nombre varchar(20) not null unique -- Le sumamos un UNIQUE para evitar roles duplicados
)

CREATE TABLE Usuarios
(
    IdUsuario int identity(1,1) PRIMARY KEY,
    IdRol int not null,
    NombreUsuario varchar(50) not null unique,
    Contrasenia varchar(100) not null,

    CONSTRAINT FK_Rol_Usuario FOREIGN KEY(IdRol) REFERENCES Roles(IdRol)
)
GO

ALTER TABLE Doctores ADD IdUsuario int null;
GO
ALTER TABLE Doctores ALTER COLUMN IdUsuario int NOT NULL;
GO
ALTER TABLE Doctores ADD CONSTRAINT FK_Doctores_Usuarios FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario);
GO

ALTER TABLE Pacientes ADD IdUsuario int null;
GO
ALTER TABLE Pacientes ALTER COLUMN IdUsuario int NOT NULL;
GO
ALTER TABLE Pacientes ADD CONSTRAINT FK_Pacientes_Usuarios FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario);
GO