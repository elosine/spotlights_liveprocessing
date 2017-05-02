///check if git works

//COMPOSE SEVERAL SENARIOS IN SC AND THEN WORRY ABOUT CONTROL
//IRIS FOR DYNAMICS
//PATTERNS:
//////SQUIGGLES
//////ACCELERATING VERTICAL LINES
//////SOL LEWITT LIVE DRAWINGS - AUTOMATIC
//SPOTLIGHT CONTROL - PATTERNS
//////CONCENTRIC CIRCLES

/*
MAKE INITIAL VIDEOS
     squiggles
     live drawing
     set movement patterns with repetition
     physical movement

     Description of projector set up
     Set up Rehearsals and reserve lab and tech to dave

YOUTUBE
MAKE SWF INTERACTIVE
YOUSENDIT

QUIET IMPACTS, VERTICAL, SAME TEMPO/DIFFERENT PHASE
DYNAMICS SAW, SPEED UP
FREEZE AT TOP AND LARGER DYNAMIC
--MOVE--
UNISON IMPACT W SQUIGGLES COMMING IN GRADUALLY
DYNAMICS SAW
--FREEZE AND MOVE--
CROSS TRAFFIC
STOP START
--MOVE SELECTED--
LIVE DRAWING WITH CIRCULAR PATTERN
CIRCULAR PATTERN WITH CHANGING RADIUS AND NO IMPACT
--MOVE SELECTED--
TURN ON IMPACT, NEW LIVE DRAWING, SLOW, SINGLE DIAMETER LITTLE, NOT TOUCHING PATTERN
STOP ONE SO THAT IT COLLIDES WITH OTHERS
VERY GRADUALLY GET BIGGER W/O SAW
KEEP PUSHING UNTIL FASTER AND FASTER
REMOVE EDGES FOR END

*/


//INIT
t = NetAddr("127.0.0.1", 1231);
OSCdef(\spsqdetect, {|msg|
	var clr = msg[1].asString;
	var state = msg[2].asInteger;
	msg.postln;
}, "/spsqdetect");

//spsq detect
/*1*/ t.sendMsg("/mkspot", /*ix*/0, /*x*/133.0, /*y*/80.0, /*sz*/120.0, "darkorange", /*velx*/0.0, /*vely*/ 80.0 );
/*1*/ t.sendMsg("/mksqig", /*ix*/0, /*x*/76, /*y*/211, /*w*/180, /*h*/180, /*density*/30, "pink");
/*1*/ t.sendMsg("/anisqig", /*ix*/0, /*go*/1, /*freqlow*/3, /*freqhi*/8);
t.sendMsg("/mkspSqDetect", 0, 0, 0);


//TABLEAUX ONE - BOUNCING AT DIFFERENT TEMPI
(
//CREATE STATIC SPOTS
/*1*/ t.sendMsg("/mkspot", /*ix*/1, /*x*/133.0, /*y*/80.0, /*sz*/120.0, "darkorange", /*velx*/0.0, /*vely*/ 0.0 );
/*2*/ t.sendMsg("/mkspot", /*ix*/2, /*x*/333.0, /*y*/80.0, /*sz*/120.0, "springgreen", /*velx*/0.0, /*vely*/ 0.0 );
/*3*/ t.sendMsg("/mkspot", /*ix*/3, /*x*/533.0, /*y*/80.0, /*sz*/120.0, "royalblue", /*velx*/0.0, /*vely*/ 0.0 );
/*4*/ t.sendMsg("/mkspot", /*ix*/4, /*x*/733.0, /*y*/80.0, /*sz*/120.0, "violetred", /*velx*/0.0, /*vely*/ 0.0 );
/*5*/ t.sendMsg("/mkspot", /*ix*/5, /*x*/933.0, /*y*/80.0, /*sz*/120.0, "sunshine", /*velx*/0.0, /*vely*/ 0.0 );
)

(
//SET INITIAL VELOCITY-Y
/*1*/ t.sendMsg("/setvel", /*ix*/1, /*velx*/0.0, /*vely*/300.0);
/*2*/ t.sendMsg("/setvel", /*ix*/2, /*velx*/0.0, /*vely*/300.0);
/*3*/ t.sendMsg("/setvel", /*ix*/3, /*velx*/0.0, /*vely*/300.0);
/*4*/ t.sendMsg("/setvel", /*ix*/4, /*velx*/0.0, /*vely*/300.0);
/*5*/ t.sendMsg("/setvel", /*ix*/5, /*velx*/0.0, /*vely*/300.0);
)

(
//ADJUST VELOCITY-Y
/*1*/ t.sendMsg("/adjvel", /*ix*/1, /*velx*/0.0, /*vely*/300.0);
/*2*/ t.sendMsg("/adjvel", /*ix*/2, /*velx*/0.0, /*vely*/300.0);
/*3*/ t.sendMsg("/adjvel", /*ix*/3, /*velx*/0.0, /*vely*/50.0);
/*4*/ t.sendMsg("/adjvel", /*ix*/4, /*velx*/0.0, /*vely*/800.0);
/*5*/ t.sendMsg("/adjvel", /*ix*/5, /*velx*/0.0, /*vely*/-200.0);
)

(
//STOP SPOTS
/*1*/ t.sendMsg("/setvel", /*ix*/1, /*velx*/0.0, /*vely*/0.0);
/*2*/ t.sendMsg("/setvel", /*ix*/2, /*velx*/0.0, /*vely*/0.0);
/*3*/ t.sendMsg("/setvel", /*ix*/3, /*velx*/0.0, /*vely*/0.0);
/*4*/ t.sendMsg("/setvel", /*ix*/4, /*velx*/0.0, /*vely*/0.0);
/*5*/ t.sendMsg("/setvel", /*ix*/5, /*velx*/0.0, /*vely*/0.0);
)

t.sendMsg("/rmvspot", 5);

//TABLEAUX TWO - DYNAMICS AND HITTING EACH OTHER
(
//CREATE STATIC SPOTS
/*1*/ t.sendMsg("/mkspot", /*ix*/1, /*x*/106.0, /*y*/80.0, /*sz*/120.0, "darkorange", /*velx*/0.0, /*vely*/ 0.0 );
/*2*/ t.sendMsg("/mkspot", /*ix*/2, /*x*/319.0, /*y*/80.0, /*sz*/120.0, "springgreen", /*velx*/0.0, /*vely*/ 0.0 );
/*3*/ t.sendMsg("/mkspot", /*ix*/3, /*x*/531.0, /*y*/80.0, /*sz*/120.0, "royalblue", /*velx*/0.0, /*vely*/ 0.0 );
/*4*/ t.sendMsg("/mkspot", /*ix*/4, /*x*/754.0, /*y*/80.0, /*sz*/120.0, "violetred", /*velx*/0.0, /*vely*/ 0.0 );
/*5*/ t.sendMsg("/mkspot", /*ix*/5, /*x*/967.0, /*y*/80.0, /*sz*/120.0, "sunshine", /*velx*/0.0, /*vely*/ 0.0 );
)

(
//CHANGE SIZE - FIX IN PROCESSING BY AN IF THEN - IF CLOSE TO EDGE STOP CHANGING SIZE
/*1*/ t.sendMsg("/sawon", /*ix*/1, /*minsize*/120.0, /*maxsize*/30.0, /*dur*/ 7.0);
/*1*/ t.sendMsg("/sawon", /*ix*/2, /*minsize*/30.0, /*maxsize*/120.0, /*dur*/ 9.0);
/*1*/ t.sendMsg("/sawon", /*ix*/3, /*minsize*/30.0, /*maxsize*/120.0, /*dur*/ 13.0);
/*1*/ t.sendMsg("/sawon", /*ix*/4, /*minsize*/30.0, /*maxsize*/120.0, /*dur*/ 6.0);
/*1*/ t.sendMsg("/sawon", /*ix*/5, /*minsize*/30.0, /*maxsize*/120.0, /*dur*/ 21.0);
)


(
//SET INITIAL VELOCITY-Y
/*1*/ t.sendMsg("/setvel", /*ix*/1, /*velx*/0.0, /*vely*/500.0);
/*2*/ t.sendMsg("/setvel", /*ix*/2, /*velx*/0.0, /*vely*/727.0);
/*3*/ t.sendMsg("/setvel", /*ix*/3, /*velx*/0.0, /*vely*/242.0);
/*4*/ t.sendMsg("/setvel", /*ix*/4, /*velx*/0.0, /*vely*/689.0);
/*5*/ t.sendMsg("/setvel", /*ix*/5, /*velx*/0.0, /*vely*/364.0);
)

(
//CROSS TRAFFIC
/*2*/ t.sendMsg("/setvel", /*ix*/2, /*velx*/800.0, /*vely*/0.0);
/*4*/ t.sendMsg("/setvel", /*ix*/4, /*velx*/500.0, /*vely*/0.0);
)

(
//ADJUST VELOCITY-Y
/*1*/ t.sendMsg("/adjvel", /*ix*/1, /*velx*/600.0, /*vely*/0.0);
/*2*/ t.sendMsg("/adjvel", /*ix*/2, /*velx*/0.0, /*vely*/400.0);
/*3*/ t.sendMsg("/adjvel", /*ix*/3, /*velx*/0.0, /*vely*/-500.0);
/*4*/ t.sendMsg("/adjvel", /*ix*/4, /*velx*/800.0, /*vely*/0.0);
/*5*/ t.sendMsg("/adjvel", /*ix*/5, /*velx*/0.0, /*vely*/-200.0);
)

(
//STOP SPOTS
/*1*/ t.sendMsg("/setvel", /*ix*/1, /*velx*/0.0, /*vely*/0.0);
/*2*/ t.sendMsg("/setvel", /*ix*/2, /*velx*/0.0, /*vely*/0.0);
/*3*/ t.sendMsg("/setvel", /*ix*/3, /*velx*/0.0, /*vely*/0.0);
/*4*/ t.sendMsg("/setvel", /*ix*/4, /*velx*/0.0, /*vely*/0.0);
/*5*/ t.sendMsg("/setvel", /*ix*/5, /*velx*/0.0, /*vely*/0.0);
)

//TABLEAUX THREE - SQUIGGLES
(
//CREATE STATIC SPOTS
/*1*/ t.sendMsg("/mkspot", /*ix*/1, /*x*/106.0, /*y*/80.0, /*sz*/120.0, "darkorange", /*velx*/0.0, /*vely*/ 444.0 );
/*2*/ t.sendMsg("/mkspot", /*ix*/2, /*x*/319.0, /*y*/80.0, /*sz*/120.0, "springgreen", /*velx*/0.0, /*vely*/ 444.0 );
/*3*/ t.sendMsg("/mkspot", /*ix*/3, /*x*/531.0, /*y*/80.0, /*sz*/120.0, "royalblue", /*velx*/0.0, /*vely*/ 444.0 );
/*4*/ t.sendMsg("/mkspot", /*ix*/4, /*x*/754.0, /*y*/80.0, /*sz*/120.0, "violetred", /*velx*/0.0, /*vely*/ 444.0 );
/*5*/ t.sendMsg("/mkspot", /*ix*/5, /*x*/967.0, /*y*/80.0, /*sz*/120.0, "sunshine", /*velx*/0.0, /*vely*/ 444.0 );
)

//SQUIGGLES
(
/*1*/ t.sendMsg("/mksqig", /*ix*/1, /*x*/66, /*y*/111, /*w*/80, /*h*/80, /*density*/30, "pink");
/*1*/ t.sendMsg("/anisqig", /*ix*/1, /*go*/1, /*freqlow*/3, /*freqhi*/8);
/*2*/ t.sendMsg("/mksqig", /*ix*/2, /*x*/264, /*y*/222, /*w*/110, /*h*/110, /*density*/30, "seagreen");
/*2*/ t.sendMsg("/anisqig", /*ix*/2, /*go*/1, /*freqlow*/2, /*freqhi*/4);
/*3*/ t.sendMsg("/mksqig", /*ix*/3, /*x*/501, /*y*/333, /*w*/60, /*h*/60, /*density*/13, "beet");
/*3*/ t.sendMsg("/anisqig", /*ix*/3, /*go*/1, /*freqlow*/2, /*freqhi*/9);
/*4*/ t.sendMsg("/mksqig", /*ix*/4, /*x*/684, /*y*/370, /*w*/140, /*h*/140, /*density*/21, "sunshine");
/*4*/ t.sendMsg("/anisqig", /*ix*/4, /*go*/1, /*freqlow*/2, /*freqhi*/11);
/*5*/ t.sendMsg("/mksqig", /*ix*/5, /*x*/907, /*y*/164, /*w*/120, /*h*/120, /*density*/50, "orange");
/*5*/ t.sendMsg("/anisqig", /*ix*/5, /*go*/1, /*freqlow*/2, /*freqhi*/11);
)

/*5*/ t.sendMsg("/rmvsqig", /*ix*/5);

t.sendMsg("/mkspSqDetect", 0, 0, 0);


//TABLEAUX FOUR - SPINNER
(
//CREATE  SPOTS
/*1*/ t.sendMsg("/mkspot", /*ix*/1, /*x*/106.0, /*y*/80.0, /*sz*/120.0, "darkorange", /*velx*/0.0, /*vely*/ 444.0 );
/*2*/ t.sendMsg("/mkspot", /*ix*/2, /*x*/319.0, /*y*/80.0, /*sz*/120.0, "springgreen", /*velx*/0.0, /*vely*/ 744.0 );
/*3*/ t.sendMsg("/mkspot", /*ix*/3, /*x*/531.0, /*y*/80.0, /*sz*/120.0, "royalblue", /*velx*/0.0, /*vely*/ 694.0 );
/*4*/ t.sendMsg("/mkspot", /*ix*/4, /*x*/754.0, /*y*/80.0, /*sz*/120.0, "violetred", /*velx*/0.0, /*vely*/ 284.0 );
/*5*/ t.sendMsg("/mkspot", /*ix*/5, /*x*/967.0, /*y*/80.0, /*sz*/120.0, "sunshine", /*velx*/0.0, /*vely*/ 1444.0 );
)

(
//STOP & SPIN
/*1*/ t.sendMsg("/spin", /*ix*/1, /*on*/1);
/*2*/ t.sendMsg("/spin", /*ix*/2, /*on*/1);
/*3*/ t.sendMsg("/spin", /*ix*/3, /*on*/1);
/*4*/ t.sendMsg("/spin", /*ix*/4, /*on*/1);
/*5*/ t.sendMsg("/spin", /*ix*/5, /*on*/1);
//STOP SPOTS
/*1*/ t.sendMsg("/setvel", /*ix*/1, /*velx*/0.0, /*vely*/0.0);
/*2*/ t.sendMsg("/setvel", /*ix*/2, /*velx*/0.0, /*vely*/0.0);
/*3*/ t.sendMsg("/setvel", /*ix*/3, /*velx*/0.0, /*vely*/0.0);
/*4*/ t.sendMsg("/setvel", /*ix*/4, /*velx*/0.0, /*vely*/0.0);
/*5*/ t.sendMsg("/setvel", /*ix*/5, /*velx*/0.0, /*vely*/0.0);
)



(
//STOP & SPIN
/*1*/ t.sendMsg("/spin", /*ix*/1, /*on*/0);
/*2*/ t.sendMsg("/spin", /*ix*/2, /*on*/0);
/*3*/ t.sendMsg("/spin", /*ix*/3, /*on*/0);
/*4*/ t.sendMsg("/spin", /*ix*/4, /*on*/0);
/*5*/ t.sendMsg("/spin", /*ix*/5, /*on*/0);
//STOP SPOTS
/*1*/ t.sendMsg("/setvel", /*ix*/1, /*velx*/0.0, /*vely*/300.0);
/*2*/ t.sendMsg("/setvel", /*ix*/2, /*velx*/0.0, /*vely*/200.0);
/*3*/ t.sendMsg("/setvel", /*ix*/3, /*velx*/0.0, /*vely*/1700.0);
/*4*/ t.sendMsg("/setvel", /*ix*/4, /*velx*/0.0, /*vely*/900.0);
/*5*/ t.sendMsg("/setvel", /*ix*/5, /*velx*/0.0, /*vely*/550.0);
)

//Arcs & Lines
t.sendMsg("/mkal", 1, 106, 100, 1, 18);
t.sendMsg("/mkal", 2, 206, 300, 8, 11);
t.sendMsg("/rmval", 1);


t.sendMsg("/sz", 1, 120.0);



