( s.options.numAudioBusChannels=300; s.waitForBoot{ fork{
	//GROUPS
	s.sendMsg(\g_new, 900, 1, 1);
	9.do{|ix| s.sendMsg(\g_new, 901+ix, 3 /*add after*/, 900+ix)};
	//LOAD SAMPLES
	~path ="/Users/justin/Documents/github/liveprocessing/samples/" ;
	//sax sample at buffer #300
	s.sendMsg(\b_allocRead, 300, ~path ++ "saxsample.aif");
	//SYNTH DEFS

	/*
	SynthDef(\template, {
	arg ibs,obs=0,atk=0.02,rel=0.1,crv= 0,gate=1;
	var src, sig, env, amp;
	amp = \amp.kr(0.85,0.01);
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
	src = In.ar(ibs);
	sig = FX(source);
	Out.ar(obs, sig*amp*env);
	}).add;
	*/

	SynthDef(\playsamp_m, {
		arg obs=0,atk=0.02,rel=0.1,crv= 0,gate=1,
		buf;
		var sig, env, amp;
		amp = \amp.kr(0.85,0.01);
		env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
		sig = PlayBuf.ar(1, buf, loop:1);
		Out.ar(obs, sig*amp*env);
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
		src2 = In.ar(ibs+1);
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
		Out.ar(0, [sig1, sig2]*amp);
	}).add;


	0.5.wait;

	//Start Sax Loop Playing to Private Audio Bus #100, node, 3000, group 903
	s.sendMsg(\s_new, \playsamp_m, 3000, 0, 903, \buf, 300, \obs, 100, \amp, 1.5);

}})

//Start Duster node-3010, group 904, in from abus 100
s.sendMsg(\s_new, \duster, 3010, 0, 904, \ibs, 100, \obs, 0, \dens, 3);
s.sendMsg(\n_set, 3010, \gatk, 0.01, \grel, 0.08, \gcrv, -3, \dens, 7, \amp, 3, \obs, 150);
s.sendMsg(\n_free, 3010);
s.meter;

//PUT DENSITY ON A RANDOM TRIGGER
//PUT PSHI/LO ON RANDOM TRIGGERS
//random rate/pitch triggers based on messiaen modes - add more filters


s.sendMsg(\s_new, \pitchedfilters, 3020, 0, 905, \ibs, 150, \obs, 0);
s.sendMsg(\n_set, 3020, \famp, 3, \decay1, 0.08, \decay2, 0.08, \mix, 0.92, \amp, 6, \pch1, 50, \pch2, 70, \pch3, 55, \pch4, 87, \pch5, 100, \pch6, 47, \pch7, 35, \pslo1, -22, \pshi1,  22, \pslo2, -21, \pshi2, 21, \ibs, 150);
s.sendMsg(\n_set, 3020, \famp, 5, \decay1, 0.08, \decay2, 0.08, \mix, 0.98, \amp, 6, \pch1, 0.1, \pch2, 0.1, \pch3, 0.1, \pch4, 0.1, \pch5, 0.1, \pch6, 0.1, \pch7, 1, \pslo1, -2, \pshi1,  2, \pslo2, -4, \pshi2, 4, \ibs, 150);
s.sendMsg(\n_free, 3020);

add harmonics
add lfo to rate

//set up live in
//4 channel set up with freeze
//set up more lfos or random triggers for pch1-7 and ps lo and hi