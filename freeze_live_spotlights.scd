(
s.waitForBoot{ fork{
	~ebf = SoundFile.collectIntoBuffers("/Users/justin/Documents/github/Spotlights/grainEnv/" ++ "*");
	~buf = Buffer.alloc(s, s.sampleRate*3);

	SynthDef(\icy_live, {
		arg buf=0, envbuf = -1, pitchshift=1, winsz=0.8, overlaps=40, resettrig=0, startpos=0.0, endpos=1.0, rand=0.1, ratemin=2.0, ratemax=0.00001,  atk=0.05, rel=0.8, crv = -6, gate=1, width = 0.03;
		var sig, ix, krate, in, writehead, durenv,sig2;
		var amp = \amp.kr(1.0,0.03);
		durenv = EnvGen.ar(Env.asr(atk, 1, rel, curve: crv),gate,doneAction:2);
		writehead = Phasor.ar(0, BufRateScale.kr(buf), 0, BufFrames.kr(buf));
		in = BufWr.ar(SoundIn.ar(0), buf, writehead);
		krate = \rate.kr(1, 0.05).linlin(0.0, 1.0, ratemin, ratemax);
		ix = Phasor.kr(resettrig, ((1.0/ControlRate.ir)/(BufFrames.kr(buf)/SampleRate.ir))*krate, startpos, endpos);
		sig = Warp1.ar(1, buf, ix, pitchshift, winsz, envbuf, overlaps,rand);
		sig2 = DelayC.ar(sig, 0.2, width);
		Out.ar(0, [sig, sig2]*durenv*amp);
	}).add;

	SynthDef(\deci, {
		var rate, bits, sig, in;
		rate = \rate.kr(44100,0.05);
		bits = \bits.kr(24,0.05);
		in = SoundIn.ar(0);
		sig = Decimator.ar(in, LFTri.kr(0.05).range(300, 8000), LFTri.kr(0.04).range(4,12));
		Out.ar(0, sig);
	}).add
}}
)
x = Synth(\icy_live, [\buf, ~buf, \winsz, 0.6, \overlaps, 17, \rand, 0.1, \envbuf, ~ebf[0],\ratemin,5, \ratemax, 0.00000001, \rate, 0.98, \rel, 2, \crv, -6 ]);
x.set(\rate, 0.98, \envbuf, ~ebf[0]);
x.free;
s.meter

a = Synth(\deci);
a.set(\rate, 500, \bits, 8);

//use trrand to change rate, use lfo and regularish trigger so that it decends and ascends use control bus etc
//use writehead phasor trigger to randomly trigger to other parts of the buffer so change is not so regular
//each trigger triggers a different interval to wait for next trigger