
(
t = NetAddr("127.0.0.1", 1231);
~wt = 0.005;

//CREATE STATIC SPOTS
~mksptsA = [
	/*1*/{ t.sendMsg("/mkspot", /*ix*/1, /*x*/133.0, /*y*/80.0, /*sz*/120.0, "darkorange", /*velx*/0.0, /*vely*/ 0.0 )},
	/*2*/ {t.sendMsg("/mkspot", /*ix*/2, /*x*/333.0, /*y*/80.0, /*sz*/120.0, "springgreen", /*velx*/0.0, /*vely*/ 0.0 )},
	/*3*/{ t.sendMsg("/mkspot", /*ix*/3, /*x*/533.0, /*y*/80.0, /*sz*/120.0, "royalblue", /*velx*/0.0, /*vely*/ 0.0 )},
	/*4*/ {t.sendMsg("/mkspot", /*ix*/4, /*x*/733.0, /*y*/80.0, /*sz*/120.0, "violetred", /*velx*/0.0, /*vely*/ 0.0 )},
	/*5*/{ t.sendMsg("/mkspot", /*ix*/5, /*x*/933.0, /*y*/80.0, /*sz*/120.0, "sunshine", /*velx*/0.0, /*vely*/ 0.0 )}
];

//REMOVE SPOTS
~rmvsptsA = [
	/*1*/{ t.sendMsg("/rmvspot", /*ix*/1) },
	/*2*/{ t.sendMsg("/rmvspot", /*ix*/2) },
	/*3*/{ t.sendMsg("/rmvspot", /*ix*/3) },
	/*4*/{ t.sendMsg("/rmvspot", /*ix*/4) },
	/*5*/{ t.sendMsg("/rmvspot", /*ix*/5) }
];

//SET INITIAL VELOCITY-Y
~ivelx = 0.0;
~ively = 300.0;
~ivelA = [
	/*1*/ {t.sendMsg("/setvel", /*ix*/1, /*velx*/~ivelx, /*vely*/~ively)},
	/*2*/ {t.sendMsg("/setvel", /*ix*/2, /*velx*/~ivelx, /*vely*/~ively)},
	/*3*/ {t.sendMsg("/setvel", /*ix*/3, /*velx*/~ivelx, /*vely*/~ively)},
	/*4*/ {t.sendMsg("/setvel", /*ix*/4, /*velx*/~ivelx, /*vely*/~ively)},
	/*5*/ {t.sendMsg("/setvel", /*ix*/5, /*velx*/~ivelx, /*vely*/~ively)}
];

//Stop all
~stopA = [
	/*1*/ {t.sendMsg("/setvel", /*ix*/1, /*velx*/0.0, /*vely*/0.0)},
	/*2*/ {t.sendMsg("/setvel", /*ix*/2, /*velx*/0.0, /*vely*/0.0)},
	/*3*/ {t.sendMsg("/setvel", /*ix*/3, /*velx*/0.0, /*vely*/0.0)},
	/*4*/ {t.sendMsg("/setvel", /*ix*/4, /*velx*/0.0, /*vely*/0.0)},
	/*5*/ {t.sendMsg("/setvel", /*ix*/5, /*velx*/0.0, /*vely*/0.0)}
];

//SQUIGGLES
~sqgA = [
/*1*/ {t.sendMsg("/mksqig", /*ix*/1, /*x*/93, /*y*/111, /*w*/80, /*h*/80, /*density*/30, "pink")},
/*1*/ {t.sendMsg("/anisqig", /*ix*/1, /*go*/1, /*freqlow*/3, /*freqhi*/8)},
/*2*/{ t.sendMsg("/mksqig", /*ix*/2, /*x*/278, /*y*/222, /*w*/110, /*h*/110, /*density*/30, "seagreen")},
/*2*/{ t.sendMsg("/anisqig", /*ix*/2, /*go*/1, /*freqlow*/2, /*freqhi*/4)},
/*3*/{ t.sendMsg("/mksqig", /*ix*/3, /*x*/503, /*y*/333, /*w*/60, /*h*/60, /*density*/13, "beet")},
/*3*/{ t.sendMsg("/anisqig", /*ix*/3, /*go*/1, /*freqlow*/2, /*freqhi*/9)},
/*4*/{ t.sendMsg("/mksqig", /*ix*/4, /*x*/663, /*y*/370, /*w*/140, /*h*/140, /*density*/21, "sunshine")},
/*4*/{ t.sendMsg("/anisqig", /*ix*/4, /*go*/1, /*freqlow*/2, /*freqhi*/11)},
/*5*/{ t.sendMsg("/mksqig", /*ix*/5, /*x*/873, /*y*/164, /*w*/120, /*h*/120, /*density*/50, "orange")},
/*5*/{t.sendMsg("/anisqig", /*ix*/5, /*go*/1, /*freqlow*/2, /*freqhi*/11)}
];

//REMOVE SQUIGS
~rmvsqgA = [
	/*1*/{ t.sendMsg("/rmvsqig", /*ix*/1) },
	/*2*/{ t.sendMsg("/rmvsqig", /*ix*/2) },
	/*3*/{ t.sendMsg("/rmvsqig", /*ix*/3) },
	/*4*/{ t.sendMsg("/rmvsqig", /*ix*/4) },
	/*5*/{ t.sendMsg("/rmvsqig", /*ix*/5) }
];

//SAW ON
~sawonA = [
	/*1*/{ t.sendMsg("/sawon", /*ix*/1, /*minsize*/120.0, /*maxsize*/30.0, /*dur*/ 7.0)},
/*1*/ {t.sendMsg("/sawon", /*ix*/2, /*minsize*/30.0, /*maxsize*/120.0, /*dur*/ 9.0)},
/*1*/{ t.sendMsg("/sawon", /*ix*/3, /*minsize*/30.0, /*maxsize*/120.0, /*dur*/ 13.0)},
/*1*/{ t.sendMsg("/sawon", /*ix*/4, /*minsize*/30.0, /*maxsize*/120.0, /*dur*/ 6.0)},
/*1*/ {t.sendMsg("/sawon", /*ix*/5, /*minsize*/30.0, /*maxsize*/120.0, /*dur*/ 21.0)}
];

//SAW OFF
~sawoffA = [
	/*1*/{ t.sendMsg("/sawoff", /*ix*/1) },
	/*2*/{ t.sendMsg("/sawoff", /*ix*/2) },
	/*3*/{ t.sendMsg("/sawoff", /*ix*/3) },
	/*4*/{ t.sendMsg("/sawoff", /*ix*/4) },
	/*5*/{ t.sendMsg("/sawoff", /*ix*/5) }
];

//RESIZE ALL
~szall = 120.0;
~rszallA = [
	/*1*/ {t.sendMsg("/sz", /*ix*/1, /*sz*/~szall)},
	/*2*/ {t.sendMsg("/sz", /*ix*/2, /*velx*/~szall)},
	/*3*/ {t.sendMsg("/sz", /*ix*/3, /*velx*/~szall)},
	/*4*/ {t.sendMsg("/sz", /*ix*/4, /*velx*/~szall)},
	/*5*/ {t.sendMsg("/sz", /*ix*/5, /*velx*/~szall)}
];

//ORBIT OFF ALL
~orbitoffallA = [
	/*1*/{ t.sendMsg("/orbitoff", /*ix*/1) },
	/*2*/{ t.sendMsg("/orbitoff", /*ix*/2) },
	/*3*/{ t.sendMsg("/orbitoff", /*ix*/3) },
	/*4*/{ t.sendMsg("/orbitoff", /*ix*/4) },
	/*5*/{ t.sendMsg("/orbitoff", /*ix*/5) }
];



~mksptsR = Routine{ ~mksptsA.do({ |it| it.value; ~wt.wait }) };
~rmvsptsR = Routine{ ~rmvsptsA.do({ |it| it.value; ~wt.wait }) };
~ivelR = Routine{ ~ivelA.do({ |it| it.value; ~wt.wait }) };
~sqgR = Routine{ ~sqgA.do({ |it| it.value; ~wt.wait }) };
~rmvsqgR = Routine{ ~rmvsqgA.do({ |it| it.value; ~wt.wait }) };
~sawonR = Routine{ ~sawonA.do({ |it| it.value; ~wt.wait }) };
~sawoffR = Routine{ ~sawoffA.do({ |it| it.value; ~wt.wait }) };
~rszallR = Routine{ ~rszallA.do({ |it| it.value; ~wt.wait }) };
~stopR = Routine{ ~stopA.do({ |it| it.value; ~wt.wait }) };
~orbitoffallR = Routine{ ~orbitoffallA.do({ |it| it.value; ~wt.wait }) };

 //A&L Cell locations
~alY = [20, 100, 180, 260, 340, 420, 500];
~alX = [20, 100, 180, 260, 340, 420, 500, 580, 660, 740, 820, 900, 980];
 //make an array of all of the combinations
~alLocA = Array.newClear(0);
~alY.do({|it, ix| ~alX.do({|jt, jx| ~alLocA = ~alLocA.add([it, jt])})});

//make an array of all of the combinations
~alc = Array.fill(20, {|ix| ix});
~alA = Array.newClear(0);
~alc.do({|it| ~alc.do({|jt| if(jt>=it, {~alA = ~alA.add([it, jt])})})});

//Array ~als will contain all of the arguments for making a Arcs & Lines cell
~als = Array.newClear(0);
~alLocA2 = ~alLocA.scramble;
~alA2 = ~alA.scramble;
~alLocA2.do({ |it, ix|
	~als = ~als.add([ix, it[1], it[0], ~alA2[ix][0], ~alA2[ix][1] ]);
});

~alRout = Task{
	~als.do({ |it|
		t.sendMsg("/mkal", it[0], it[1], it[2], it[3], it[4]);
		rand(2.5, 7.7).wait;
	});
};

~mksptsB = Button().states_([ ["Make Spots", Color.black, Color.green] ]).mouseDownAction_({ ~mksptsR.play; ~mksptsR.reset });
~rmvsptsB = Button().states_([ ["Remove Spots", Color.black, Color.yellow] ]).mouseDownAction_({ ~rmvsptsR.play; ~rmvsptsR.reset });

~stopB = Button().states_([ ["Stop Spots", Color.black, Color.green] ]).mouseDownAction_({ ~stopR.play; ~stopR.reset });

~ivelxT = NumberBox().value_(0.0).action_({ |it| ~ivelx=it.value });
~ivelyT = NumberBox().value_(300.0).action_({ |it| ~ively=it.value });
~ivelB = Button().states_([ ["Velocity", Color.black, Color.green] ]).mouseDownAction_({ ~ivelR.play; ~ivelR.reset });

~pix=1; ~px=0.0; ~py=25.0;
~pushyB = Button().states_([ ["Push", Color.black, Color.green] ]).mouseDownAction_({ t.sendMsg("/adjvel", ~pix, ~px, ~py) });
~pixN = NumberBox().value_(1).action_({ |it| ~pix=it.value.asInteger }).step_(1);
~pxN = NumberBox().value_(0.0).action_({ |it| ~px=it.value });
~pyN = NumberBox().value_(20.0).action_({ |it| ~py=it.value }).step_(10);

~sqgB = Button().states_([ ["Squigs", Color.black, Color.green] ]).mouseDownAction_({ ~sqgR.play; ~sqgR.reset });
~rmvsqgB = Button().states_([ ["Remove Sqigs", Color.black, Color.yellow] ]).mouseDownAction_({ ~rmvsqgR.play; ~rmvsqgR.reset });

~sawonB = Button().states_([ ["Saw On", Color.black, Color.green] ]).mouseDownAction_({ ~sawonR.play; ~sawonR.reset });
~sawoffB = Button().states_([ ["Saw Off", Color.black, Color.green] ]).mouseDownAction_({ ~sawoffR.play; ~sawoffR.reset });

~szallN = NumberBox().value_(120.0).action_({ |it| ~szall=it.value });
~szallB = Button().states_([ ["Resize All", Color.black, Color.green] ]).mouseDownAction_({ ~rszallR.play; ~rszallR.reset });

~sz1 = 120.0; ~sz1ix = 1;
~sz1B = Button().states_([ ["Resize", Color.black, Color.green] ]).mouseDownAction_({ t.sendMsg("/sz", ~sz1ix, ~sz1) });
~sz1ixN = NumberBox().value_(1).action_({ |it| ~sz1ix=it.value.asInteger }).step_(1);
~sz1N = NumberBox().value_(120.0).action_({ |it| ~sz1=it.value });

~mkalB = Button().states_([ ["Arcs&Lines", Color.black, Color.green] ]).mouseDownAction_({ ~alRout.start });
~pausealB = Button().states_([ ["Pause A&L", Color.black, Color.green] ]).mouseDownAction_({ ~alRout.pause });
~resumealB = Button().states_([ ["Resume A&L", Color.black, Color.green] ]).mouseDownAction_({ ~alRout.resume });
~stopalB = Button().states_([ ["Stop A&L", Color.black, Color.green] ]).mouseDownAction_({ ~alRout.stop; ~alRout.reset });

~rmvalB = Button().states_([ ["Remove A&L", Color.black, Color.yellow] ]).mouseDownAction_({ t.sendMsg("/rmvallal") });

~spinix = 1;
~spinN = NumberBox().value_(1).action_({ |it| ~spinix=it.value.asInteger }).step_(1);
~spinonB = Button().states_([ ["Spin On", Color.black, Color.green] ]).mouseDownAction_({ t.sendMsg("/spin", ~spinix, 1); t.sendMsg("/setvel", ~spinix, 0.0, 0.0)});
~spinoffB = Button().states_([ ["Spin Off", Color.black, Color.green] ]).mouseDownAction_({ t.sendMsg("/spin", ~spinix, 0) });

~orbix = 1; ~orbspd=0.0020; ~orbw=200.0; ~orbh=200.0;
~orbB = Button().states_([ ["Orbit", Color.black, Color.green] ]).mouseDownAction_({ t.sendMsg("/orbit", /*ix*/~orbix, /*spd*/~orbspd, /*w*/~orbw, /*h*/~orbh, /*ctx*/533.0, /*cty*/300.0) });
~orboffB = Button().states_([ ["Orbit Off", Color.black, Color.green] ]).mouseDownAction_({ t.sendMsg("/orbitoff", /*ix*/~orbix) });
~orbN = NumberBox().value_(1).action_({ |it| ~orbix=it.value.asInteger }).step_(1);
~orbspdN = NumberBox().value_(0.0020).action_({ |it| ~orbspd=it.value }).minDecimals_(4);
~orbwN = NumberBox().value_(200.0).action_({ |it| ~orbw=it.value });
~orbhN = NumberBox().value_(200.0).action_({ |it| ~orbh=it.value });

~orbitoffallB = Button().states_([ ["All Off", Color.black, Color.yellow] ]).mouseDownAction_({~orbitoffallR.play; ~orbitoffallR.reset });

~notes = TextView().string_("1: Unison Impacts\n2: Out of Phase\n3: Squigs\n4: Spin\n5: X-Velocity; Saw On\n6: Stop/Start; Change Size\n7: Spin\n8: Orbit/Arcs & Lines\n9: Start/Stop; Spin\n10: Speed Change\n11: Bounce w/A&L; Velocity\n12: Halt & Remove Spots\n1=orange, 2=green, 3=blue, 4=magenta, 5=yellow");

w = Window.new(bounds:Rect(10,800,500,800)).layout_(
	    VLayout (
		~mksptsB,
		HLayout(~ivelB, ~ivelxT, ~ivelyT),
		~stopB,
		~sqgB,
		HLayout(~pushyB, ~pixN, ~pxN, ~pyN),
		HLayout(~sawonB, ~sawoffB),
		HLayout(~szallB, ~szallN),
		HLayout(~sz1B, ~sz1ixN, ~sz1N),
		HLayout(~spinonB, ~spinoffB, ~spinN),
		HLayout(~mkalB, ~pausealB, ~resumealB, ~stopalB),
		HLayout(~orbB, ~orboffB, ~orbitoffallB, ~orbN, ~orbspdN, ~orbwN, ~orbhN),
		~rmvalB,
		~rmvsqgB,
		~rmvsptsB,
		~notes
	    )
).front;
)

//13 X 7 grid
//20px margins
//15 space
//X - 20, 100, 180, 260, 340, 420, 500, 580, 660, 740, 820, 900, 980
//Y - 20, 100, 180, 260, 340, 420, 500
