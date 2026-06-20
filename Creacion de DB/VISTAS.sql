
CREATE VIEW vw_TurnosDelDia
AS
SELECT
    t.IDTurno AS 'Número de Turno',
    p.Nombre + ' ' + p.Apellido AS 'Paciente',
    p.DNI AS 'DNI',
    c.Direccion AS 'Sucursal',
    e.Nombre AS 'Tipo de Atención',
    t.Hora AS 'Hora',
    et.Nombre AS 'Estado',
    d.Nombre + ' ' + d.Apellido AS 'Doctor'
FROM Turnos t
INNER JOIN Pacientes p ON t.IDPaciente = p.IDPaciente
INNER JOIN ConsultoriosxDoctor cd ON t.IDConsultoriosxDoctor = cd.IDConsultoriosxDoc
INNER JOIN Consultorios c ON cd.IDConsultorio = c.IDConsultorio
INNER JOIN Doctores d ON cd.IDDoctor = d.IDDoctor
INNER JOIN Especialidades e ON d.IDEspecialidad = e.IDEspecialidad
INNER JOIN EstadosTurnos et ON t.IDEstado = et.IDEstado
WHERE t.Fecha = CAST(GETDATE() AS DATE) 

--********************************************

CREATE VIEW vw_ConsultoriosxDoctor
AS
    SELECT  C.Direccion,
            C.Mail,
            C.Telefono,
            CONCAT(D.Apellido,', ',D.Nombre ) AS Doctores,
            E.Nombre AS Especialidad
        FROM Consultorios C
        INNER JOIN ConsultoriosxDoctor CD ON
        C.IDConsultorio = CD.IDConsultorio
        INNER JOIN Doctores D ON
        CD.IDDoctor = D.IDDoctor
        INNER JOIN Especialidades E ON
        D.IDEspecialidad = E.IDEspecialidad

--********************************************

CREATE VIEW vw_ObraSocialxDoctor
AS
    SELECT CONCAT(D.Nombre,', ',D.Apellido) AS Doctores,
            D.Mail AS Email,
            OS.Nombre AS Obras_Sociales,
            E.Nombre AS Especialidad
        FROM Doctores D
        INNER JOIN DoctoresxObraSocial DOS ON 
        D.IDDoctor = DOS.IDDoctor
        INNER JOIN ObraSocial OS ON
        DOS.IDObraSocial = OS.IDObraSocial
        INNER JOIN Especialidades E ON
        D.IDEspecialidad = E.IDEspecialidad
        WHERE D.Activo = 1

--********************************************

