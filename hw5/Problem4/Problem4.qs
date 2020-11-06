namespace Problem4 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    operation Entangle(q1: Qubit, q2: Qubit) : Unit 
    is Adj {
        H(q1);
        CNOT(q1, q2);
    }

    operation PreparePlus(q: Qubit) : Unit
    is Adj + Ctl {
        H(q);
    }

    operation PrepareMinus(q: Qubit) : Unit
    is Adj + Ctl {
        X(q);
        H(q);
    }

    operation EncodeMessage(alice: Qubit, plus: Bool) : (Bool, Bool) {
        mutable msgBit = false;
        mutable aliceBit = false;

        using (msg = Qubit()) {
            if (plus) {
                PreparePlus(msg);
            } else {
                PrepareMinus(msg);
            }
            Adjoint Entangle(msg, alice);

            set msgBit = M(msg) == One;
            set aliceBit = M(alice) == One;
            Reset(msg);
        }
        return (msgBit, aliceBit);
    }

    operation DecodeMessage(q: Qubit, msgBit: Bool, aliceBit: Bool): Unit {
        if (aliceBit) {
            X(q);
        }
        if (msgBit) {
            Z(q);
        }
    }

    operation PrintEncodeDecode(plus: Bool): Unit {
        using ((alice, bob) = (Qubit(), Qubit())) {
            Entangle(alice, bob);
            let (msgBit, aliceBit) = EncodeMessage(alice, plus);
            DecodeMessage(bob, msgBit, aliceBit);
            // H(plus) = Zero
            // H(minus) = One
            H(bob);
            if (plus) {
                Message("Original message was |+>");
                AssertQubit(Zero, bob); // only works if bob was plus after DecodeMessage
            } else {
                Message("Original message was |->");
                AssertQubit(One, bob); // only works if bob was minus after DecodeMessage
            }
            if (M(bob) == Zero) {
                Message("Decoded message is   |+> ");
            } else {
                Message("Decoded message is   |-> ");
            }
            Reset(alice);
            Reset(bob);
        }
    }

    @EntryPoint()
    operation Problem4(plus: Bool) : Unit {
        PrintEncodeDecode(plus);
    }
}
