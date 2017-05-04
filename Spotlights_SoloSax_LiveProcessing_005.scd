(
s.options.numAudioBusChannels = 1000;
s.options.memSize = 163840;
s.options.numOutputBusChannels = 8;

s.waitForBoot{ fork{
	~ebf = SoundFile.collectIntoBuffers("/Users/justin/Documents/github/Spotlights/grainEnv/" ++ "*");
	~buf = Buffer.alloc(s, s.sampleRate*5);

	SynthDef(\livein, {
		arg ibs, obs=0,atk=0.02,rel=0.1,crv= 0,gate=1;
		var sig, env, amp;
		amp = \amp.kr(0.85,0.01);
		env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
		sig = SoundIn.ar(ibs);
		Out.ar(obs, sig*amp*env);
	}).add;

	SynthDef(\icy, {
		arg ibs, buf=0, envbuf = -1, pitchshift=1, winsz=0.8, overlaps=40, resettrig=0, startpos=0.0, endpos=1.0, rand=0.1, ratemin=2.0, ratemax=0.00001,  atk=0.05, rel=0.8, crv = -6, gate=1, width = 0.03, mvidx=1, wrRate=1;
		var sig, ix, krate, in, writehead, durenv,sig2;
		var amp = \amp.kr(1.0,0.03);
		durenv = EnvGen.ar(Env.asr(atk, 1, rel, curve: crv),gate,doneAction:0);
		writehead = Phasor.ar(0, BufRateScale.kr(buf)*wrRate, 0, BufFrames.kr(buf));
		in = BufWr.ar(In.ar(ibs), buf, writehead);
		krate = \rate.kr(1, 0.05).linlin(0.0, 1.0, ratemin, ratemax);
		ix = Phasor.kr(resettrig, ((1.0/ControlRate.ir)/(BufFrames.kr(buf)/SampleRate.ir))*krate, startpos, endpos);
		sig = Warp1.ar(1, buf, ix, pitchshift, winsz, envbuf, overlaps,rand);
		sig2 = DelayC.ar(sig, 0.2, width);
		Out.ar(0, [sig, sig2]*durenv*amp);
	}).add;

	SynthDef(\deci, {
		var ibs, rate, bits, sig, in;
		var inamp = \inamp.kr(1.0, 0.05);
		var amp = \amp.kr(1.0, 0.05);
		rate = \rate.kr(44100,0.05);
		bits = \bits.kr(24,0.05);
		in = In.ar(0)*inamp;
		sig = Decimator.ar(in, LFTri.kr(0.05).range(300, 8000), LFTri.kr(0.04).range(4,12));
		Out.ar(0, sig*amp);
	}).add;

	SynthDef(\lpc, {
		arg caribs, modibs, obs=0, modobs=99, carobs=98, atk=0.02, rel=0.1, crv= 0, gate=1;
		var car, mod, mod2, sig, env, amp, caramp, modamp;
		caramp = \caramp.kr(1.0, 0.01).dbamp;
		modamp = \modamp.kr(1.0, 0.01).dbamp;
		amp = \amp.kr(1,0.01).dbamp;
		env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
		car = In.ar(caribs, 1);
		//Out.ar(carobs, car);
		mod = In.ar(modibs, 2);
		//Out.ar(modobs, mod);
		sig = LPCAnalyzer.ar([car,car]*caramp, mod*modamp);
		Out.ar(obs, sig*amp*env);
	}).add;

	SynthDef(\spectralvocoder, {
		arg ibs1, ibs2, inamp1=1, inamp2=1,obs=0, freeze = 0, mode=2.4,gate=1;
		var bufA, bufB, bufC, bufD, chain1a, chain1b, chain2a, chain2b, sig1, sig2, out1, out2, freq, amp, env;
		amp = \amp.kr(0.85, 0.05);
		env = EnvGen.ar(Env.asr(0.01, 1, 0.1),gate, doneAction:2);
		bufA = LocalBuf.new(2048);
		bufB = LocalBuf.new(2048);
		bufC = LocalBuf.new(2048);
		bufD = LocalBuf.new(2048);
		chain1a = FFT(bufA, In.ar(ibs1)*inamp1); // to be filtered
		chain2a = FFT(bufB, In.ar(ibs2)*inamp2);
		sig1 = PV_SpectralMap(chain1a, chain2a, 0.0, freeze, mode, 1);
		chain1b = FFT(bufC, In.ar(ibs1)*inamp1); // to be filtered
		chain2b = FFT(bufD, In.ar(ibs2+1)*inamp2);
		sig2 = PV_SpectralMap(chain1b, chain2b, 0.0, freeze, mode, 1);
		out1 = IFFT(sig1);
		out1 = HPF.ar(out1, 50);
		out2 = IFFT(sig2);
		out2 = HPF.ar(out2, 50);
		Out.ar(obs, [out1,out2]*env*amp);
	}).add;

	SynthDef(\playbuf_s, {
		arg obs=0, buf, amp=1;
		var sig = PlayBuf.ar(2, buf, loop:1);
		Out.ar(obs, sig*amp);
	}).add;


	//Duster
	SynthDef(\duster, {
		arg ibs,obs=0,atk=0.02,rel=0.1,crv= 0,gate=1,
		dens=2, gatk=0.01, grel=0.1, gcrv= -4;
		var src, sig, env, amp, trig, trigenv, inamp, rpos, pansig;
		inamp = \inamp.kr(1.0, 0.01);
		trig = Dust.kr(dens);
		trigenv = EnvGen.ar(Env.perc(gatk, grel, curve:gcrv), trig);
		rpos = TRand.kr(-1.0, 1.0, trig);
		amp = \amp.kr(0.85,0.01);
		env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
		src = In.ar(ibs);
		sig = src*trigenv;
		pansig = Pan2.ar(sig, rpos);
		Out.ar(obs, pansig*amp);
	}).add;

	//Pitched Resonant Filters
	SynthDef(\pitchedfilters, {
		arg ibs,obs=0,atk=0.02,rel=0.1,crv= 0,gate=1,
		decay1=0.08, decay2=0.08, pch1=60, pch2=62, pch3=64, pch4=66, pch5=68, pch6=70, pch7=72, mix=0.98, pslo1= -12, pshi1=12, pslo2= -12, pshi2 = 12;
		var src1, src2, sig1, sig2, env, amp, freq1, hasfreq1, freq2, hasfreq2, famp, sig3, sig4, sig5, sig6, sig7;
		amp = \amp.kr(5,0.01);
		famp = \famp.kr(13.0, 0.01);
		env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
		src1 = In.ar(ibs);
		src1 = HPF.ar(src1, 80);
		src2 = In.ar(ibs+1);
		src2 = HPF.ar(src2, 80);
		# freq1, hasfreq1 = Tartini.kr(src1);
		# freq2, hasfreq2 = Tartini.kr(src1);
		sig1 = ComplexRes.ar(src1, (freq1.cpsmidi+SinOsc.kr(pch1).range(pslo1, pshi1)).midicps, decay1)*famp;
		sig2 = ComplexRes.ar(src2, (freq2.cpsmidi+SinOsc.kr(pch2).range(pslo2, pshi2)).midicps, decay2)*famp;
		sig3 = ComplexRes.ar(src1, (freq1.cpsmidi+SinOsc.kr(pch3).range(pslo1, pshi1)).midicps, decay1)*famp;
		sig4 = ComplexRes.ar(src2, (freq2.cpsmidi+SinOsc.kr(pch4).range(pslo2, pshi2)).midicps, decay2)*famp;
		sig5 = ComplexRes.ar(src2, (freq2.cpsmidi+SinOsc.kr(pch5).range(pslo2, pshi2)).midicps, decay2)*famp;
		sig6 = ComplexRes.ar(src1, (freq1.cpsmidi+SinOsc.kr(pch6).range(pslo1, pshi1)).midicps, decay1)*famp;
		sig7 = ComplexRes.ar(src2, (freq2.cpsmidi+SinOsc.kr(pch7).range(pslo2, pshi2)).midicps, decay2)*famp;
		sig1 = Mix.ar([sig1*mix, src1*(1.0-mix), sig3*mix, sig6*mix]);
		sig2 = Mix.ar([sig2*mix, src2*(1.0-mix), sig4*mix, sig5*mix, sig7*mix]);
		Out.ar(obs, [sig1, sig2]*amp);
	}).add;

	0.15.wait;


	//bruckner buffer
	//	~br = Buffer.read(s, "/Users/justin/Documents/github/Spotlights/BrucknerSlow3.aif", bufnum:9);

	t = NetAddr("127.0.0.1", 1231);

	OSCdef(\spsqdetect, {|msg|
		var clr = msg[1].asString;
		var state = msg[2].asInteger;
		msg.postln;
		//darkorange
		//mint
		//dodgerblue
		//violetred
		switch(clr,
			"pink", {"pk".postln},
			"mint", {"mt".postln},
			"dodgerblue", {"db".postln},
			"violetred", {"vr".postln}
		);
		s.sendMsg(\n_set, 1000, \gate, state);
	}, "/spsqdetect");

	//groups
	s.sendMsg(\g_new, 2000);
	9.do{|ix| s.sendMsg(\g_new, 2001+ix, 3, 2000+ix)};

	//live in - out obs 200
	s.sendMsg( \s_new, \livein, 3000, 0, 2002, \ibs, 0, \obs, 200);

	//Freezes
	~fz1 = Synth(\icy, [\ibs, 200, \buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.993, \atk, 0.2, \rel, 1, \crv, -6 , \gate, 0], 2005);
	~fz2 = Synth(\icy, [\ibs, 200, \buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.8, \atk, 0.2, \rel, 1, \crv, -6,  \gate, 0], 2005);
	~fz3 = Synth(\icy, [\ibs, 200, \buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.0, \atk, 0.2, \rel, 1, \crv, -6,  \gate, 0], 2005);
	~fz4 = Synth(\icy, [\ibs, 200, \buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.98, \atk, 0.2, \rel, 1, \crv, -6,  \gate, 0], 2005);




}} //end s.wait and fork
)

//Live In
s.sendMsg( \s_new, \livein, 3000, 0, 2002, \ibs, 0, \obs, 0);
s.sendMsg(\n_set,3000,\obs,200);
s.meter;

//Freeze
x = Synth(\icy, [\ibs, 200, \buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.98, \rel, 2, \crv, -6 ], 2005);
s.sendMsg(\n_set, 1000, \wrRate, 0, \rate, 0.98);
s.sendMsg(\n_set, 1000, \wrRate, 0, \rate, 0.997, \atk, 0.2);
s.sendMsg(\n_set, 1000, \wrRate, 1, \amp, 0.7);
s.sendMsg(\n_free, 1000);


//spotlight trigger freeze
//different colors with different versions of the freeze (rate & envbuf) use regular lang side messaging
//spsq detect
/*1*/ t.sendMsg("/mkspot", /*ix*/0, /*x*/133.0, /*y*/80.0, /*sz*/120.0, "darkorange", /*velx*/0.0, /*vely*/ 80.0 );
/*1*/ t.sendMsg("/mksqig", /*ix*/0, /*x*/76, /*y*/211, /*w*/180, /*h*/180, /*density*/30, "pink");
/*1*/ t.sendMsg("/anisqig", /*ix*/0, /*go*/1, /*freqlow*/3, /*freqhi*/8);
t.sendMsg("/mkspSqDetect", 0, 0, 0);

/*1*/ t.sendMsg("/mksqig", /*ix*/1, /*x*/276, /*y*/111, /*w*/180, /*h*/180, /*density*/30, "mint");
/*1*/ t.sendMsg("/anisqig", /*ix*/1, /*go*/1, /*freqlow*/3, /*freqhi*/8);
t.sendMsg("/mkspSqDetect", 1, 0, 1);

/*1*/ t.sendMsg("/mksqig", /*ix*/2, /*x*/376, /*y*/311, /*w*/180, /*h*/180, /*density*/30, "dodgerblue");
/*1*/ t.sendMsg("/anisqig", /*ix*/2, /*go*/1, /*freqlow*/3, /*freqhi*/8);
t.sendMsg("/mkspSqDetect", 2, 0, 2);

/*1*/ t.sendMsg("/mksqig", /*ix*/3, /*x*/576, /*y*/211, /*w*/180, /*h*/180, /*density*/30, "violetred");
/*1*/ t.sendMsg("/anisqig", /*ix*/3, /*go*/1, /*freqlow*/3, /*freqhi*/8);
t.sendMsg("/mkspSqDetect", 3, 0, 3);


/*1*/ t.sendMsg("/adjvel", /*ix*/0, /*velx*/1000.0, /*vely*/300.0);
/*1*/ t.sendMsg("/setvel", /*ix*/0, /*velx*/700.0, /*vely*/500.0);



s.queryAllNodes;

//FM Filters
//Start Duster node-3010, group 204, in from abus 200, out 6
s.sendMsg(\s_new, \duster, 3010, 0, 2004, \ibs, 200, \obs, 6, \dens, 7, \amp, 3, \gatk, 0.01, \grel, 0.08, \gcrv, -3);
s.sendMsg(\n_set, 3010, \gatk, 0.01, \grel, 0.08, \gcrv, -3, \dens, 11, \amp, 5, \obs, 202);
s.sendMsg(\n_free, 3010);

//fm filters
s.sendMsg(\s_new, \pitchedfilters, 3011, 0, 2005, \ibs, 202, \obs, 6, \famp, 3, \decay1, 0.08, \decay2, 0.08, \mix, 0.92, \amp, 3, \pch1, 50, \pch2, 70, \pch3, 55, \pch4, 87, \pch5, 100, \pch6, 47, \pch7, 35, \pslo1, -22, \pshi1,  22, \pslo2, -21, \pshi2, 21);

s.sendMsg(\n_set, 3020, \famp, 7, \decay1, 0.08, \decay2, 0.08, \mix, 0.82, \amp, 6, \pch1, 50, \pch2, 70, \pch3, 55, \pch4, 87, \pch5, 100, \pch6, 47, \pch7, 35, \pslo1, -22, \pshi1,  22, \pslo2, -21, \pshi2, 21, \ibs, 202);

s.sendMsg(\n_set, 3020, \famp, 5, \decay1, 0.08, \decay2, 0.08, \mix, 0.98, \amp, 6, \pch1, 0.1, \pch2, 0.1, \pch3, 0.1, \pch4, 0.1, \pch5, 0.1, \pch6, 0.1, \pch7, 1, \pslo1, -2, \pshi1,  2, \pslo2, -4, \pshi2, 4, \ibs, 150);

s.sendMsg(\n_free, 3011);






//freeze
x = Synth(\icy_live, [\buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.98, \rel, 2, \crv, -6 ], 2005);
x.set(\rate, 0.98, \envbuf, ~ebf[0]);
x.set(\wrRate, 0);
x.set(\wrRate, 1);
x.free;
s.meter
s.queryAllNodes

s.sendMsg(\s_new, \icy_live, 3300, 0, 2009, \buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.98, \rel, 2, \crv, -6);

s.sendMsg(\s_new, \icy_live, 3200, 0, 2005, \buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0], \ratemin, 5, \ratemax, 0.00000001, \rate, 0.98, \rel, 2, \crv, -6);
s.sendMsg(\n_set, 3300, \buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.98, \rel, 2, \crv, -6);
s.sendMsg(\n_free, 3300);

//decimator
s.sendMsg(\s_new, \deci, 3100, 0, 2005);
s.sendMsg(\n_set, 3100, \inamp, 3, \amp, 2);
s.sendMsg(\n_free, 3100);

//spectral vocoder
s.sendMsg(\s_new, \playbuf_s, 3000, 0, 2003, \buf, 9);
s.sendMsg(\n_set, 3000, \obs, 50);

s.sendMsg(\s_new, \livein, 3001, 0, 2003);
s.sendMsg(\n_set, 3001, \obs, 52);

s.sendMsg(\s_new, \spectralvocoder, 3002, 0, 2005, \ibs1, 52, \ibs2, 50);
s.sendMsg(\n_set, 3002, \ibs1, 52, \ibs2, 50, \inamp2, 50, \inamp1, 1, \amp, 0.5);

//LPC
s.sendMsg(\s_new, \playbuf_s, 3000, 0, 2003, \buf, 9);
s.sendMsg(\n_set, 3000, \obs, 50);

s.sendMsg(\s_new, \livein, 3001, 0, 2003);
s.sendMsg(\n_set, 3001, \obs, 52);

s.sendMsg(\s_new, \lpc, 3003, 0, 2005, \caribs, 52, \modibs, 50);
s.sendMsg(\n_set, 3003, \caramp, 18, \modamp, -8, \amp, -12,\caribs, 52, \modibs, 50);


s.meter
arg caribs, modibs, obs=0, modobs=99, carobs=98, atk=0.02, rel=0.1, crv= 0, gate=1;
var car, mod, mod2, sig, env, amp, caramp, modamp;
caramp = \caramp.kr(0.0, 0.01).dbamp;
modamp = \modamp.kr(0.0, 0.01).dbamp;
amp = \amp.kr(0,0.01).dbamp;

//use trrand to change rate, use lfo and regularish trigger so that it decends and ascends use control bus etc
//use writehead phasor trigger to randomly trigger to other parts of the buffer so change is not so regular
//each trigger triggers a different interval to wait for next trigger