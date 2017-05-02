(
s.waitForBoot{ fork{
	~ebf = SoundFile.collectIntoBuffers("/Users/justin/Documents/github/Spotlights/grainEnv/" ++ "*");
	~buf = Buffer.alloc(s, s.sampleRate*4);

	SynthDef(\icy_live, {
		arg buf=0, envbuf = -1, pitchshift=1, winsz=0.8, overlaps=40, resettrig=0, startpos=0.0, endpos=1.0, rand=0.1, ratemin=2.0, ratemax=0.00001,  atk=0.05, rel=0.8, crv = -6, gate=1, width = 0.03, mvidx=1, wrRate=1;
		var sig, ix, krate, in, writehead, durenv,sig2;
		var amp = \amp.kr(1.0,0.03);
		durenv = EnvGen.ar(Env.asr(atk, 1, rel, curve: crv),gate,doneAction:2);
		writehead = Phasor.ar(0, BufRateScale.kr(buf)*wrRate, 0, BufFrames.kr(buf));
		in = BufWr.ar(SoundIn.ar(0), buf, writehead);
		krate = \rate.kr(1, 0.05).linlin(0.0, 1.0, ratemin, ratemax);
		ix = Phasor.kr(resettrig, ((1.0/ControlRate.ir)/(BufFrames.kr(buf)/SampleRate.ir))*krate, startpos, endpos);
		sig = Warp1.ar(1, buf, ix, pitchshift, winsz, envbuf, overlaps,rand);
		sig2 = DelayC.ar(sig, 0.2, width);
		Out.ar(0, [sig, sig2]*durenv*amp);
	}).add;

	SynthDef(\deci, {
		var rate, bits, sig, in;
		var inamp = \inamp.kr(1.0, 0.05);
		var amp = \amp.kr(1.0, 0.05);
		rate = \rate.kr(44100,0.05);
		bits = \bits.kr(24,0.05);
		in = SoundIn.ar(0)*inamp;
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

	SynthDef(\livein, {
		arg ibs=0, obs=0, buf, amp=1;
		var in = SoundIn.ar(ibs);
		Out.ar(obs, in*amp);
	}).add;


	//bruckner buffer
//	~br = Buffer.read(s, "/Users/justin/Documents/github/Spotlights/BrucknerSlow3.aif", bufnum:9);

	//groups
	s.sendMsg(\g_new, 2000);
	9.do{|ix| s.sendMsg(\g_new, 2001+ix, 3, 2000+ix)};


}} //end s.wait and fork
)


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