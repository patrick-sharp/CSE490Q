namespace Problem3 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation Entangle(qs: Qubit[]) : Unit 
    is Adj {
        H(qs[0]);
        CNOT(qs[0], qs[1]);
    }

    operation EncodeBits(q: Qubit, bit1: Bool, bit2: Bool) : Unit {
        if (bit2) {
            X(q);
        }
        if (bit1) {
            Z(q);
        }
    }

    operation DecodeBits(qs: Qubit[]) : (Bool, Bool) {
        Adjoint Entangle(qs);
        return (M(qs[0]) == One, M(qs[1]) == One);
    }

    operation PrintEncodeDecode(bit1: Bool, bit2: Bool) : Unit {
        using (qs = Qubit[2]) {
            Entangle(qs);
            EncodeBits(qs[0], bit1, bit2);
            let (decodedBit1, decodedBit2) = DecodeBits(qs);
            Message($"Original bits: ({bit1}, {bit2})");
            Message($"Decoded bits:  ({decodedBit1}, {decodedBit2})");
            ResetAll(qs);
        }
    }

    @EntryPoint()
    operation Problem3(b1: Bool, b2: Bool) : Unit {
        PrintEncodeDecode(b1, b2);
    }
}
