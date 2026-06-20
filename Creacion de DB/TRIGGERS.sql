CREATE TRIGGER TR_ImpedirTurnoDoble 
ON Turnos 	
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS( 
        SELECT 1
        FROM Turnos t1
        INNER JOIN inserted i ON t1.IDPaciente = i.IDPaciente
        WHERE t1.Fecha = i.Fecha
          AND t1.Hora = i.Hora
          AND t1.IDTurno != i.IDTurno
    )
    BEGIN
        ROLLBACK TRANSACTION 
        RAISERROR('El paciente ya tiene un turno programado para esa fecha y hora.', 16, 1) 
    END
END

--********************************************

  CREATE TRIGGER tr_CheckDoctorActivo ON Turnos
    AFTER INSERT
        AS 
    BEGIN TRY
    BEGIN TRANSACTION
    DECLARE @IDTurno INT,
            @IDConsultorio INT,
            @IDEstado INT,
            @Fecha DATE,
            @Hora TIME(7),
            @IDPaciente INT,
            @Activo BIT
            SELECT  @IDTurno = IDTurno,
                    @IDConsultorio = IDConsultoriosxDoctor,
                    @IDEstado = IDEstado,
                    @Fecha = Fecha,
                    @Hora = Hora,
                    @IDPaciente = IDPaciente
            FROM INSERTED
            SELECT @Activo = D.Activo
            FROM Doctores D
            INNER JOIN ConsultoriosxDoctor CD ON
            D.IDDoctor = CD.IDDoctor
            INNER JOIN INSERTED I ON
            CD.IDConsultoriosxDoc = I.IDConsultoriosxDoctor
            IF(@Activo = 0 OR @Activo IS NULL)
            BEGIN
            RAISERROR('El doctor solicitado no está activo.',16,1)
            ROLLBACK TRANSACTION
            RETURN
            END
            COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
    RAISERROR('Surgió un error inesperado.',16,1)
    ROLLBACK TRANSACTION
    RETURN
END CATCH

--********************************************

CREATE TRIGGER TR_ValidarCoberturaTurno
ON Turnos
AFTER INSERT
AS
BEGIN;
    -- Validamos con tu estructura de tablas real
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Pacientes p ON i.IDPaciente = p.IDPaciente --con join a pacientes para obtener la obra social del paciente
        JOIN ConsultoriosxDoctor cxd ON i.IDConsultoriosxDoctor = cxd.IDConsultoriosxDoc 
        WHERE p.IDObraSocial IS NOT NULL 
          AND p.IDObraSocial NOT IN (
              SELECT dos.IDObraSocial 
              FROM DoctoresxObraSocial dos 
              WHERE dos.IDDoctor = cxd.IDDoctor 
                AND dos.FechaBaja IS NULL
          )
    )
    BEGIN
        RAISERROR ('Error: El doctor asignado a este consultorio no atiende la Obra Social del paciente.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
