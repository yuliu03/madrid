var turno=-1;
// var posOrigen=document.getElementById("section2");
// var t=posOrigen.style.width;
// console.log(posOrigen);

function myMove(e) {
  var elem = document.getElementById(e);   
  var pos = 0;
  var grado = 0;
  var id = setInterval(frame, 5);
 console.log(turno);
   if(turno != -1){
             document.getElementById(turno).style.marginLeft = 0 + 'px'; 
      }

  function frame() {
    if (pos == 85) {
      clearInterval(id);
       // elem.style.marginLeft = pos + '%'; 
      turno = e;
      console.log(turno);

    } else {
      pos++; 
      grado=grado+15;
      //elem.style.marginTop = pos + 'px'; 
      elem.style.marginLeft = pos + '%'; 
        // Code for Safari
   elem.style.WebkitTransform = "rotateZ("+grado+"deg)";
    // Code for IE9
    elem.style.msTransform = "rotateZ("+grado+"deg)";
          // Standard syntax
      elem.style.transform = "rotateZ("+grado+"deg)";
    }
  }
}

function myMove2(e) {
  var elem = document.getElementById(e);   
  var pos = 0;
  var grado = 0;
  var id = setInterval(frame, 5);
   console.log(turno);
  if(turno != -1){
             document.getElementById(turno).style.marginLeft = 0 + 'px'; 
      }
  function frame() {
    if (pos == 85) {
      clearInterval(id);
      turno = e;   
       console.log(turno); 
  } else {
      pos++; 
      grado=grado+15;
      //elem.style.marginTop = pos + 'px'; 
      elem.style.marginLeft = pos + '%'; 
        // Code for Safari
      elem.style.WebkitTransform = "rotateY("+grado+"deg)";
      // Code for IE9
      elem.style.msTransform = "rotateY("+grado+"deg)";
      // Standard syntax
      elem.style.transform = "rotateY("+grado+"deg)";
    }
  }
}

function myMove3(e) {
  var elem = document.getElementById(e);   
  var pos = 0;
  var grado = 0;
  var id = setInterval(frame, 5);
  if(turno != -1){
             document.getElementById(turno).style.marginLeft = 0 + 'px'; 
      }
  function frame() {
    if (pos == 85) {
      clearInterval(id);
         turno = e; 
    } else {
      pos++; 
      grado=grado+15;
      //elem.style.marginTop = pos + 'px'; 
      elem.style.marginLeft = pos + '%'; 
        // Code for Safari
      elem.style.WebkitTransform = "rotateX("+grado+"deg)";
      // Code for IE9
      elem.style.msTransform = "rotateX("+grado+"deg)";
      // Standard syntax
      elem.style.transform = "rotateX("+grado+"deg)";
    }
  }
}