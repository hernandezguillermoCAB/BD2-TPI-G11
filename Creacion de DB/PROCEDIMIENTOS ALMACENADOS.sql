CREATE PROCEDURE sp_CancelarTurno(
    @IDTurno INT,
    @Motivo VARCHAR(50)
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Turnos WHERE IDTurno = @IDTurno)
    BEGIN
        RAISERROR('El turno con ID %d no existe.', 16, 1, @IDTurno);
        RETURN;
    END
    DECLARE @IDEstadoAnterior INT;
    SELECT @IDEstadoAnterior = IDEstado FROM Turnos WHERE IDTurno = @IDTurno;

    INSERT INTO GestionTurnos (IDTurno, FechaCambio, IDEstadoAnterior, IDEstadoActual, Motivo)
    VALUES (@IDTurno, CAST(GETDATE() AS DATE), @IDEstadoAnterior, 3, @Motivo);
    UPDATE Turnos
    SET IDEstado = 3 --id turno cancelado
    WHERE IDTurno = @IDTurno;
END

--********************************************

CREATE PROCEDURE sp_FiltrarxEspecialidad
    @Especialidad varchar(100)
    AS 
        BEGIN
            IF NOT EXISTS   (SELECT 1 FROM Especialidades E
                            WHERE LOWER(E.Nombre) LIKE '%' + LOWER(@Especialidad) +'%')
                BEGIN
                RAISERROR('La especialidad ingresada no existe',16,1)
                RETURN
                END

                SELECT  Direccion,
                        Mail,
                        Telefono,
                        Doctores,
                        Especialidad
                FROM vw_ConsultoriosxDoctor
                WHERE LOWER(Especialidad) LIKE '%' + LOWER(@Especialidad) +'%' 

END

--********************************************

ALTER PROCEDURE sp_AgendarTurno( 
    @IDPaciente int, 
    @IDConsultoriosxDoctor int, 
    @Fecha date, 
    @Hora time
) 
AS 
BEGIN 
    DECLARE @IDTurno int 
    DECLARE @IDEstado INT = (SELECT TOP 1 IDEstado FROM EstadosTurnos WHERE Nombre = 'Pendiente') 
    
    INSERT INTO Turnos (IDPaciente, IDConsultoriosxDoctor, IDEstado, Fecha, Hora) 
    VALUES (@IDPaciente, @IDConsultoriosxDoctor, @IDEstado, @Fecha, @Hora)     
    
    SET @IDTurno = SCOPE_IDENTITY()   
    SELECT @IDTurno as IDTurnoAgendado 
END 
