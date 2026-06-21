⚕️Sistema de Gestión para Consultorio Médico.

🧑‍🎓Contexto Académico:

Este sistema fue desarrollado para la materia Base de datos II de la Tecnicatura Universitaria 
en Programación de la UTN-FRGP en el año 2026 por los integrantes:

- Guillermo Ezequiel Hernandez.
- Máximo Rinaldelli.

⚙️ Descripción del sistema.
  
La base permite a los usuarios:
  - Sacar turnos médicos según el consultorio y las especialidades.
  - Ver los médicos disponibles según direcciones y especialidades.
  - Ver las obras sociales que atienden los doctores.
  - Cancelar y reagendar turnos.

   La base de datos respalda la lógica de:
  - Doctores
  - Pacientes
  - Usuarios con sus roles
  - Consultorios
  - Obras Sociales
  - Especialidades médicas
  - Turnos médicos
   
  🔧Funciones del sistema.

Procedimientos almacenados:
- sp_CancelarTurnos.
- sp_FiltrarxEspecialidad.
- sp_AgendarTurno
  
Triggers:
- TR_ImpedirTurnoDoble.
- tr_CheckDoctorActivo.
- TR_ValidarCoberturaTurno.

   Vistas:
  - vw_TurnosDelDia
  - vw_ConsultoriosxDoctor
  - vw_ObraSocialxDoctor
     
     
  
  
