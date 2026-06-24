CREATE TRIGGER TR_ImpedirTurnoDoble 
ON Turnos   
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS( 
        SELECT 1
        FROM Turnos t1
        INNER JOIN inserted i 
            ON t1.IDPaciente = i.IDPaciente
           AND t1.IDTurno != i.IDTurno
           AND CAST(t1.Fecha AS DATETIME) + CAST(t1.Hora AS DATETIME)
               = CAST(i.Fecha AS DATETIME) + CAST(i.Hora AS DATETIME)
    )
    BEGIN
        ROLLBACK TRANSACTION 
        RAISERROR('El paciente ya tiene un turno programado para esa fecha y hora.', 16, 1) 
        RETURN
    END
END
GO;
--********************************************

  CREATE TRIGGER tr_CheckDoctorActivo ON Turnos
AFTER INSERT
AS
BEGIN
    DECLARE @IDConsultorio INT,
            @IDDOCTOR INT,
            @Activo BIT;

    SELECT @IDConsultorio = IDConsultoriosxDoctor
    FROM INSERTED;

    SELECT @IDDOCTOR = CD.IDDoctor
    FROM ConsultoriosxDoctor CD
    WHERE CD.IDConsultoriosxDoc = @IDConsultorio;

    IF(@IDDOCTOR IS NULL)
    BEGIN
        RAISERROR('No existe doctor asociado al consultorio ingresado.',16,1);
        ROLLBACK TRANSACTION; 
        RETURN;
    END

    SELECT @Activo = Activo
    FROM Doctores
    WHERE IDDoctor = @IDDOCTOR;

    IF(@Activo = 0)
    BEGIN
        RAISERROR('El doctor solicitado no se encuentra activo.',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;


--********************************************

CREATE TRIGGER TR_ValidarCoberturaTurno
ON Turnos
AFTER INSERT
AS
BEGIN
    DECLARE @IDPaciente INT;
    DECLARE @IDConsultoriosxDoctor INT;
    DECLARE @IDObraSocialPaciente INT;
    DECLARE @IDDoctor INT;

    SELECT 
        @IDPaciente = IDPaciente,
        @IDConsultoriosxDoctor = IDConsultoriosxDoctor
    FROM inserted;

    SELECT @IDObraSocialPaciente = IDObraSocial
    FROM Pacientes
    WHERE IDPaciente = @IDPaciente;

    SELECT @IDDoctor = IDDoctor
    FROM ConsultoriosxDoctor
    WHERE IDConsultoriosxDoc = @IDConsultoriosxDoctor;

    IF NOT EXISTS (
        SELECT 1
        FROM DoctoresxObraSocial
        WHERE IDDoctor = @IDDoctor
          AND IDObraSocial = @IDObraSocialPaciente
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('Error: El doctor asignado a este consultorio no atiende la Obra Social del paciente.', 16, 1);
        RETURN;
    END
END;
