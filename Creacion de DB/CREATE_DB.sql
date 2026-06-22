CREATE DATABASE DB_TPINTEGRADOR;

CREATE TABLE Roles (
    IdRol INT IDENTITY(1,1),
    Nombre VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT PK_Roles PRIMARY KEY (IdRol)
);

CREATE TABLE ObraSocial (
    IDObraSocial INT IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    CONSTRAINT PK_ObraSocial PRIMARY KEY (IDObraSocial)
);


CREATE TABLE Especialidades (
    IDEspecialidad INT IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Especialidades PRIMARY KEY (IDEspecialidad)
);

CREATE TABLE EstadosTurnos (
    IDEstado INT IDENTITY(1,1),
    Nombre VARCHAR(30) NOT NULL,
    CONSTRAINT PK_EstadosTurnos PRIMARY KEY (IDEstado)
);

CREATE TABLE Consultorios (
    IDConsultorio INT IDENTITY(1,1),
    Direccion VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20) NULL,
    Mail VARCHAR(70) NULL,
    CONSTRAINT PK_Consultorios PRIMARY KEY (IDConsultorio)
);

CREATE TABLE Usuarios (
    IdUsuario INT IDENTITY(1,1),
    IdRol INT NOT NULL,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    Contrasenia VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Usuarios PRIMARY KEY (IdUsuario),
    CONSTRAINT FK_Usuarios_Roles FOREIGN KEY (IdRol) REFERENCES Roles(IdRol)
);

CREATE TABLE Doctores (
    IDDoctor INT IDENTITY(1,1),
    IDEspecialidad INT NOT NULL,
    Nombre VARCHAR(30) NOT NULL,
    Apellido VARCHAR(30) NOT NULL,
    Matricula VARCHAR(20) NOT NULL,
    Telefono VARCHAR(15) NULL,
    Mail VARCHAR(70) NOT NULL,
    IdUsuario INT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Doctores PRIMARY KEY (IDDoctor),
    CONSTRAINT FK_Doctores_Especialidades FOREIGN KEY (IDEspecialidad) REFERENCES Especialidades(IDEspecialidad),
    CONSTRAINT FK_Doctores_Usuarios FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario)
);

CREATE TABLE Pacientes (
    IDPaciente INT IDENTITY(1,1),
    DNI INT NOT NULL UNIQUE,
    Nombre VARCHAR(30) NOT NULL,
    Apellido VARCHAR(30) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Telefono INT NULL,
    Mail VARCHAR(70) NOT NULL,
    IDObraSocial INT NULL,
    IdUsuario INT NULL,
    CONSTRAINT PK_Pacientes PRIMARY KEY (IDPaciente),
    CONSTRAINT FK_Pacientes_ObraSocial FOREIGN KEY (IDObraSocial) REFERENCES ObraSocial(IDObraSocial),
    CONSTRAINT FK_Pacientes_Usuarios FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario)
);

CREATE TABLE DoctoresxObraSocial (
    IDDoctor INT NOT NULL,
    IDObraSocial INT NOT NULL,
    FechaAlta DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    FechaBaja DATE NULL,
    CONSTRAINT PK_DoctoresxObraSocial PRIMARY KEY (IDDoctor, IDObraSocial),
    CONSTRAINT FK_DxOS_Doctores FOREIGN KEY (IDDoctor) REFERENCES Doctores(IDDoctor),
    CONSTRAINT FK_DxOS_ObraSocial FOREIGN KEY (IDObraSocial) REFERENCES ObraSocial(IDObraSocial)
);

CREATE TABLE ConsultoriosxDoctor (
    IDConsultoriosxDoc INT IDENTITY(1,1), 
    IDDoctor INT NOT NULL,
    IDConsultorio INT NOT NULL,
    FechaContratacion DATE NOT NULL,
    FechaFinContrat DATE NULL,
    CONSTRAINT PK_ConsultoriosxDoctor PRIMARY KEY (IDConsultoriosxDoc),
    CONSTRAINT FK_CxD_Doctores FOREIGN KEY (IDDoctor) REFERENCES Doctores(IDDoctor),
    CONSTRAINT FK_CxD_Consultorios FOREIGN KEY (IDConsultorio) REFERENCES Consultorios(IDConsultorio)
);

CREATE TABLE AgendaDoctor (
    IDAgenda INT IDENTITY(1,1),
    IDConsultoriosxDoctor INT NOT NULL, 
    DiaSemana TINYINT NOT NULL, 
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    CONSTRAINT PK_AgendaDoctor PRIMARY KEY (IDAgenda),
    CONSTRAINT CK_DiaSemana CHECK (DiaSemana BETWEEN 1 AND 7),
    CONSTRAINT FK_Agenda_ConsultorioDoc FOREIGN KEY (IDConsultoriosxDoctor) REFERENCES ConsultoriosxDoctor(IDConsultoriosxDoc)
);

CREATE TABLE Turnos (
    IDTurno INT IDENTITY(1,1),
    IDConsultoriosxDoctor INT NOT NULL,
    IDEstado INT NOT NULL,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    IDPaciente INT NOT NULL,
    CONSTRAINT PK_Turnos PRIMARY KEY (IDTurno),
    CONSTRAINT FK_Turnos_ConsultoriosxDoctor FOREIGN KEY (IDConsultoriosxDoctor) REFERENCES ConsultoriosxDoctor(IDConsultoriosxDoc),
    CONSTRAINT FK_Turnos_EstadosTurnos FOREIGN KEY (IDEstado) REFERENCES EstadosTurnos(IDEstado),
    CONSTRAINT FK_Turnos_Pacientes FOREIGN KEY (IDPaciente) REFERENCES Pacientes(IDPaciente)
);

CREATE TABLE GestionTurnos(
    IDGestion int IDENTITY(1,1) NOT NULL,
    IDTurno int NOT NULL,
    FechaCambio date NOT NULL,
    IDEstadoAnterior int NOT NULL,
    IDEstadoActual int NOT NULL,
    Motivo varchar(50) NULL,
    CONSTRAINT PK_GestionTurnos PRIMARY KEY (IDGestion),
    CONSTRAINT FK_Gestion_EstadoAct FOREIGN KEY(IDEstadoActual) REFERENCES EstadosTurnos(IDEstado),
    CONSTRAINT FK_Gestion_EstadosAnt FOREIGN KEY(IDEstadoAnterior) REFERENCES EstadosTurnos(IDEstado),
    CONSTRAINT FK_Gestiones_Turnos FOREIGN KEY(IDTurno) REFERENCES Turnos(IDTurno)
);
