namespace Problem2 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    operation Entangle (qs: Qubit[]) : Unit {
        H(qs[0]);
        CNOT(qs[0], qs[1]);
    }

    @EntryPoint()
    operation Problem2() : Unit {
        for (i in 1..10) {
            using (qs = Qubit[2]) {
                Entangle(qs);
                Message($"{i}: {MultiM(qs)}");
                ResetAll(qs);
            }
        }
    }
}
