// SPDX-License-Identifier: MIT

pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//   ALUMNO  !  ID     !    NOTAS    !
//  ----------------------------------
//    Luis   !  95689A !      8      !
//    Jose   !  69743B !      7      !
//    Roy    !  58765C !      9      !
//    Andrew !  48765D !      8      !
//    Juan   !  37654E !      7      !
//    Cesar  !  47867F !      5      !
//------------------------------------


contract notas{
    // Direccion del profesor
    address public profesor;
     // Asignamos a la variable profesor el valor de la direcion que despliegue el contrato
     constructor() public {
         profesor = msg.sender;
     }

     //mapping para relacionar el hash que identifica al alumno con su nota obtenida en el examen
     mapping (bytes32 => uint) Notas;

     // Array de los alumnos que soliciten revision de examenes

     string[] Revisiones;

     //Eventos
     event Alumno_evaluado(bytes32 , uint);
     event Alumno_revision(string);


     //Funcion para evaluar 
     function evaluar(string memory _idAlumno , uint _notas) public soloProfesor(msg.sender){
         //Hash de la identificacion del alumno
         bytes32 hash_alumno = keccak256(abi.encodePacked(_idAlumno));
         //Relacion entre el hash de la identificacion del alumno y su nota por medio del mapping

         Notas[hash_alumno] = _notas;

         //Emitir evento 
         emit Alumno_evaluado(hash_alumno , _notas);
     }

     // control de quien ejecuta la funcion de evaluar en este caso siempre sera el profesor 

     modifier soloProfesor(address _direccion){
         // Requiere que la direccion pasada por parametro sea igual a el owner del contrato que vendria siendo la del profesor
         require(_direccion == profesor , "No tienes autorizacion para evaluar esto solo lo hace el profesor");
         _;
     }

    // Funcion para ver las notas del alumno 

    function VerNotas(string memory _idAlumno) public view returns (uint){
        //Hash de la identificacion del alumno
        bytes32 hash_alumno = keccak256(abi.encodePacked(_idAlumno));
        //Nota asociada al hash del alumno
       uint nota_alumno = Notas[hash_alumno];
         //Retornamos la nota del alumno
        return nota_alumno;
    }

     //Funcion para pedir una revision del la nota 

     function Revision(string memory _idAlumno) public{
         //se agrega al array de revisiones 
         Revisiones.push(_idAlumno);

         //Emitimos un evento de revision

         emit Alumno_revision(_idAlumno);
     }

     //Funcion para ver las revisiones de examenes
     function VerRevisiones() public view soloProfesor(msg.sender) returns (string[] memory){
         return Revisiones; //retornamos el array de revisiones
     }
}