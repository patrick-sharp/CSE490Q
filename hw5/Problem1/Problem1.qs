namespace Problem1 {
	open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Intrinsic;
	open Microsoft.Quantum.Arrays;

	operation RandomBit() : Result {
		mutable r = Zero;

		using (q = Qubit()) {
			H(q);
			set r = M(q);
			Reset(q);
		}
		return r;
	}

	@EntryPoint()
	operation Problem1() : Unit {
		for(i in 1..10) {
			Message($"{i}: {RandomBit()}");
		}
	}
}
