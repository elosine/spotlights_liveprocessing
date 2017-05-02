

(
t = NetAddr("127.0.0.1", 1231);
~wt = 0.005;
~numspts = 10;
~skw = 1280;
~skh = 960;
//12x9 grid
~grid = Array.newClear(2)!108;
9.do{|ix|
	var xinc=~skw/12, yinc=~skh/9;
	12.do{|ix2|
		var ixx = (12*ix)+ix2;
		~grid[ixx][0]=xinc*ix2;
		~grid[ixx][1]=yinc*ix;
	}

};
//CREATE STATIC SPOTS
~clrs = ["pine", "orange", "red", "green", "blue", "white", "mint", "purple", "pink", "sunshine"];
~limegreen = Color.new255(153, 255, 0);
~mksptsF = {|numspts|
	{
		numspts.do{|ix|
			var spsz, gap;
			gap = 10;
			spsz = ((1280-gap)/numspts)-gap;
			t.sendMsg("/mkspot", /*ix*/ix, /*x*/gap+(spsz/2)+((gap+spsz)*ix), /*y*/(spsz/2)+gap, /*sz*/spsz, ~clrs[ix%numspts], /*velx*/0.0, /*vely*/ 0.0 );
			0.05.wait;
		}
	}.fork
};

//REMOVE SPOTS
~rmvsptsF = {|numspts|
	{
		numspts.do{|ix|
			t.sendMsg("/rmvspot", /*ix*/ix);
			0.01.wait;
		}
	}.fork
};

//SET INITIAL VELOCITY-Y

~ivelF = {|numspts vx vy del|
	{
		numspts.do{|ix|
			t.sendMsg("/setvel", /*ix*/ix, /*velx*/vx, /*vely*/vy);
			del.wait;
		}
	}.fork
};

//Stop all
~stopallF = {|numspts|
	{
		numspts.do{|ix|
			t.sendMsg("/setvel", /*ix*/ix, /*velx*/0.0, /*vely*/0.0);
			0.01.wait;
		}
	}.fork
};
~mksquigsF = {|num|
	var coord = ~grid.scramble;
	{
		num.do{|ix|
			t.sendMsg("/mksqig", /*ix*/ix, /*x*/coord[ix%coord.size][0].asInteger, /*y*/coord[ix%coord.size][1].asInteger, /*w*/80, /*h*/80, /*density*/rrand(11, 30).asInteger, ~clrs.choose);
			t.sendMsg("/anisqig", /*ix*/ix, /*go*/1, /*freqlow*/2, /*freqhi*/1);
			0.01.wait;
		}
	}.fork
};
~rmvsquigsF = {|num| {num.do{|ix| t.sendMsg("/rmvsqig", /*ix*/ix); 0.01.wait;}}.fork };
~lockF = {|tog| t.sendMsg("/lock", /*tog*/tog)};
~bouncyF = {|tog| {~numspts.do{|ix| t.sendMsg("/bouncy", /*ix*/ix, /*tog*/tog); 0.01.wait;}}.fork};
~goallF = {|sx sy| t.sendMsg("/goall", /*x*/sx, /*y*/sy)};




//A&L Cell locations

~alY = [20, 100, 180, 260, 340, 420, 500];
~alX = [20, 100, 180, 260, 340, 420, 500, 580, 660, 740, 820, 900, 980];
~alX = Array.fill(13,{|ix| var inc = ~skw/13; inc*ix});
~alY = Array.fill(7,{|ix| var inc = ~skh/7; inc*ix});
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
	~als = ~als.add([ix, it[1].asInteger, it[0].asInteger, ~alA2[ix][0].asInteger, ~alA2[ix][1].asInteger ]);
});

~alRout = Task{
	~als.do({ |it|
		t.sendMsg("/mkal", it[0], it[1], it[2], it[3], it[4]);
		rand(2.5, 7.7).wait;
	});
};

~violetred = Color.new255(208, 32, 144);
~goldenrod = Color.new255(218,165,32);
~indigo = Color.new255(75,0,130);
~orange = Color.new255(255,128,130);
~mint = Color.new255(189,252,201);
~nicegreen = Color.new255(138,216,20);
~peacock = Color.new255(0,130,137);
~sunshine = Color.new255(255,234,100);

~mksptsB = Button().states_([ ["Remove Spots (1)", Color.white, ~violetred], ["Make Spots (1)", Color.black, ~limegreen]  ])
.value_(1)
.action_({|bt| switch(bt.value, 1,{~rmvsptsF.value(~numspts)}, 0, {~mksptsF.value(~numspts)}) })
.minHeight_(50);

~lockB = Button().states_([  ["Lock (q)", Color.black, ~goldenrod], ["Unlock (q)", Color.white, ~violetred] ])
.value_(1)
.action_({|bt| switch(bt.value, 0,{~lockF.value(1)}, 1, {~lockF.value(0)}) })
.minHeight_(50)
.maxWidth_(100);

~ivelB1 = Button().states_([ ["IVelocty=0 (3)", Color.black, ~peacock] ])
.action_({~ivelF.value(~numspts, 0.0, 700.0, 0)})
.minHeight_(50)
.maxWidth_(150);
~ivelB2 = Button().states_([ ["IVelocty=0.05 (4)", Color.black, ~peacock] ])
.action_({~ivelF.value(~numspts, 0.0, 700.0, 0.05)})
.minHeight_(50)
.maxWidth_(150);
~ivelB3 = Button().states_([ ["IVelocty=0.2 (5)", Color.black, ~peacock] ])
.action_({~ivelF.value(~numspts, 0.0, 700.0, 0.2)})
.minHeight_(50)
.maxWidth_(150);
~ivelB4 = Button().states_([ ["IVelocty=0.2 (6)", Color.black, ~peacock] ])
.action_({~ivelF.value(~numspts, 0.0, 700.0, 0.5)})
.minHeight_(50)
.maxWidth_(150);

~stopB = Button().states_([ ["STOP (2)", Color.black, Color.red] ])
.action_({~stopallF.value(~numspts)})
.minHeight_(50);

~sqgB = Button().states_([ ["Rmv Squigs (a)", Color.white, ~violetred], ["Mk Squigs (a)", Color.black, ~sunshine] ])
.value_(1)
.action_({|bt| switch(bt.value, 0,{~mksquigsF.value(13)}, 1, {~rmvsquigsF.value(13)}) })
.minHeight_(50)
.maxWidth_(100);

~mkalB = Button().states_([ ["Arcs&Lines (s)", Color.black, ~mint] ]).action_({ ~alRout.start }).minHeight_(50);
~pausealB = Button().states_([ ["Pause A&L (d)", Color.black, ~mint] ]).action_({ ~alRout.pause }).minHeight_(50);
~resumealB = Button().states_([ ["Resume A&L (f)", Color.black, ~mint] ]).action_({ ~alRout.resume }).minHeight_(50);
~stopalB = Button().states_([ ["Stop A&L (g)", Color.black, ~mint] ]).action_({ ~alRout.stop; ~alRout.reset }).minHeight_(50);
~rmvalB = Button().states_([ ["Remove A&L (h)", Color.black, Color.yellow] ]).action_({ t.sendMsg("/rmvallal") }).minHeight_(50);

~pix=1; ~px=1000.0; ~py=1200.0;
~pushyB = Button().states_([ ["Push (w)", Color.black, Color.green] ]).action_({ t.sendMsg("/adjveli", ~pix, ~px, ~py) }).minHeight_(50);
~pixN = NumberBox().value_(1).action_({ |it| ~pix=it.value.asInteger }).step_(1).minHeight_(50);
~pxN = NumberBox().value_(0.0).action_({ |it| ~px=it.value }).minHeight_(50);
~pyN = NumberBox().value_(20.0).action_({ |it| ~py=it.value }).step_(10).minHeight_(50);

w = Window.new("SPOTLIGHT CONTROL", Rect(1000,800,600,250)).background_(Color.black).layout_(
	VLayout (
		HLayout(~lockB,~mksptsB ),
		HLayout(~ivelB1, ~ivelB2, ~ivelB3, ~ivelB4, ~stopB),
				HLayout(~pushyB, ~pixN, ~pxN, ~pyN),
		~sqgB,
		HLayout(~mkalB, ~pausealB, ~resumealB, ~stopalB, ~rmvalB),
	)
)
.view.keyDownAction_({|vw ch mod uni key|
	key.postln;
	switch( key,
		18,{~mksptsB.valueAction=(~mksptsB.value+1)%2},
		12,{~lockB.valueAction=(~lockB.value+1)%2},
		20,{~ivelB1.valueAction=0},
		21,{~ivelB2.valueAction=0},
		23,{~ivelB3.valueAction=0},
		22,{~ivelB4.valueAction=0},
		19,{~stopB.valueAction=0},
		13,{~pushyB.valueAction=0},
		0,{~sqgB.valueAction=(~sqgB.value+1)%2},
		1,{~mkalB.valueAction=0},
		2,{~pausealB.valueAction=0},
		3,{~resumealB.valueAction=0},
		5,{~stopalB.valueAction=0},
		4,{~rmvalB.valueAction=0}
)})
.front;
)

//13 X 7 grid
//20px margins
//15 space
//X - 20, 100, 180, 260, 340, 420, 500, 580, 660, 740, 820, 900, 980
//Y - 20, 100, 180, 260, 340, 420, 500
