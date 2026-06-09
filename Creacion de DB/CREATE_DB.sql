CREATE DATABASE DB_TPINTEGRADOR

USE  DB_TPINTEGRADOR
GO

CREATE TABLE Especialidades(
    IDEspecialidad int primary key identity(1,1),
    Nombre varchar(35)

)

CREATE TABLE Doctores
(
     IDDoctor int identity(1,1) primary key,
     IDEspecialidad int not null,
     Nombre varchar(30) not null,
     Apellido varchar(30) not null,
     Matricula varchar(20) not null,
     Telefono varchar(15) not null,
     Mail varchar (70) not null unique,

    CONSTRAINT FK_Doctores_Especialidades FOREIGN KEY(IDEspecialidad) REFERENCES Especialidades(IDEspecialidad)
)

CREATE TABLE Pacientes
(
    IDPaciente int identity(1,1) primary key,
    DNI varchar(10) not null unique,
    Nombre varchar(30) not null,
    Apellido varchar(30) not null,
    FechaNacimiento date not null,
    Telefono varchar(20) not null unique,
    Mail varchar(70) not null unique,
    ObraSocial varchar(20) not null

)

CREATE TABLE Consultorios
(
    IDConsultorio int primary key identity(1,1),
    Direccion varchar(45) null,
    Telefono varchar(20) not null,
    Mail varchar(70) not null unique    

)


CREATE TABLE ConsultoriosxDoctor
(
    IDConsultoriosxDoc int identity(1,1) primary key,
    IDDoctor int not null,
    IDConsultorio int not null,
    FechaContratacion date not null,
    FechaFinContrat date null,

    CONSTRAINT FK_ConsuloriosxDoctor_Doctores FOREIGN KEY (IDDoctor) REFERENCES Doctores(IDDoctor),
    CONSTRAINT FK_ConsultoriosxDoctor_Consultorio FOREIGN KEY (IDConsultorio) REFERENCES Consultorios(IDConsultorio)
)

CREATE TABLE EstadosTurnos
(
    IDEstado int identity(1,1) primary key,
    Nombre varchar(30) not null
)



CREATE TABLE Turnos
(
    IDTurno int primary key identity(1,1),
    IDPaciente int not null,
    IDConsultoriosxDoctor int not null,
    IDEstado int not null,
    Fecha date not null,
    Hora Time not null,

    CONSTRAINT FK_Turnos_Pacientes FOREIGN KEY (IDPaciente) REFERENCES Pacientes(IDPaciente),
    CONSTRAINT FK_Turnos_Estados FOREIGN KEY (IDEstado) REFERENCES EstadosTurnos(IDEstado),
    CONSTRAINT FK_Turnos_ConsultoriosxDoctor FOREIGN KEY (IDConsultoriosxDoctor) REFERENCES ConsultoriosxDoctor(IDConsultoriosxDoc)

)

CREATE TABLE GestionTurnos
(
    IDGestion int identity(1,1) primary key,
    IDTurno int not null,
    FechaCambio date not null,
    IDEstadoAnterior int not null,
    IDEstadoActual int not null,
    Motivo varchar(50) null,

    CONSTRAINT FK_Gestiones_Turnos FOREIGN KEY (IDTurno) REFERENCES Turnos(IDTurno),
    CONSTRAINT FK_Gestion_EstadosAnt FOREIGN KEY (IDEstadoAnterior) REFERENCES EstadosTurnos(IDEstado),
    CONSTRAINT FK_Gestion_EstadoAct FOREIGN KEY (IDEstadoActual) REFERENCES EstadosTurnos (IDEstado)
)




CREATE TABLE AgendaDoctor
(
    IDAgenda int identity(1,1) primary key,
    IDConsultoriosxDoctor int not null,
    DiasAtencion varchar (50) not null,
    HoraInicio time not null,
    HoraFin time not null,

    CONSTRAINT FK_AgendaDoctor_ConsultoriosxDoctor FOREIGN KEY (IDConsultoriosxDoctor) REFERENCES ConsultoriosxDoctor(IDConsultoriosxDoc)

)


CREATE TABLE HistorialConsultas
(
    IDHistorial int identity(1,1) primary key,
    IDPaciente int not null,
    IDTurno int not null,
    IDConsultoriosxDoctor int not null,
    Fecha date not null,
    Diagnostico varchar(200) null,

    CONSTRAINT FK_HistorialConsultas_Pacientes FOREIGN KEY(IDPaciente) REFERENCES Pacientes(IDPaciente),
    CONSTRAINT FK_HistorialConsultas_Turnos FOREIGN KEY (IDTurno) REFERENCES Turnos(IDTurno),
    CONSTRAINT FK_HistorialConsultas_ConsultoriosxDoctor FOREIGN KEY (IDConsultoriosxDoctor) REFERENCES ConsultoriosxDoctor(IDConsultoriosxDoc)
 

)

CREATE TABLE ResultadosLaboratorio
(
    IDResultados int identity(1,1) primary key,
    IDPaciente int not null,
    IDConsultorio int not null,
    Estado varchar(30) not null,
    FechaResultado date not null,
    Observaciones varchar(200) null,

    CONSTRAINT FK_ResultadosLaboratorio_Pacientes FOREIGN KEY (IDPaciente) REFERENCES Pacientes(IDPaciente),
    CONSTRAINT FK_ResultadosLaboratorio_Consultorios FOREIGN KEY (IDConsultorio) REFERENCES Consultorios(IDConsultorio)
)