namespace p1 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    
    // Set carryOut to the carry of adding a, b, and carryIn
    operation ThreeBitCarryAdd(a: Qubit, b: Qubit, carryIn: Qubit, carryOut: Qubit): Unit
    is Adj + Ctl {
        CCNOT(a, b, carryOut);
        CCNOT(a, carryIn, carryOut);
        CCNOT(b, carryIn, carryOut);
    }

    // Set b equal to a xor b xor carryIn
    operation ThreeBitInPlaceAdd(a: Qubit, b: Qubit, carryIn: Qubit): Unit
    is Adj + Ctl {
        CNOT(a, b);
        CNOT(carryIn, b);
    }
    
    /// # Summary
    /// Given two qubit registers in state |a> and |b>, sets the qubits to state 
    /// |a>|b + a>
    operation Add(a: Qubit[], b: Qubit[], carry: Qubit) : Unit 
    is Adj + Ctl { 
        using (carries = Qubit[3]) {       
            CCNOT(a[0], b[0], carries[0]); // set the carry for a[0] + b[0]
            ThreeBitCarryAdd(a[1], b[1], carries[0], carries[1]);
            ThreeBitCarryAdd(a[2], b[2], carries[1], carries[2]);
            ThreeBitCarryAdd(a[3], b[3], carries[2], carry);
            
            ThreeBitInPlaceAdd(a[3], b[3], carries[2]);
            Adjoint ThreeBitCarryAdd(a[2], b[2], carries[1], carries[2]);
            ThreeBitInPlaceAdd(a[2], b[2], carries[1]);
            Adjoint ThreeBitCarryAdd(a[1], b[1], carries[0], carries[1]);
            ThreeBitInPlaceAdd(a[1], b[1], carries[0]);
            Adjoint CCNOT(a[0], b[0], carries[0]);
            CNOT(a[0], b[0]); // add a[0] and b[0]
        }

    }

    // Set carryOut to the carry of b - a
    operation TwoBitCarrySub(a: Qubit, b: Qubit, carryOut: Qubit): Unit 
    is Adj + Ctl {
        X(b);
        CCNOT(a, b, carryOut);
        X(b);
    }
     // Set carryOut to the carry of b - a - carryIn
    operation ThreeBitCarrySub(a: Qubit, b: Qubit, carryIn: Qubit, carryOut: Qubit): Unit
    is Adj + Ctl {
        X(b);
        ThreeBitCarryAdd(a, b, carryIn, carryOut);
        X(b);
    }

    operation TwoBitInPlaceSub(a: Qubit, b: Qubit): Unit 
    is Adj + Ctl {
        X(b);
        CNOT(a, b);
        X(b);
    }

    operation ThreeBitInPlaceSub(a: Qubit, b: Qubit, carryIn: Qubit): Unit
    is Adj + Ctl {
        X(b);
        ThreeBitInPlaceAdd(a, b, carryIn);
        X(b);
    }

    /// # Summary
    /// Given two qubit registers in state |a> and |b>, sets the qubits to state 
    /// |a>|b - a>
    operation Subtract(a: Qubit[], b: Qubit[], carry: Qubit) : Unit 
    is Adj + Ctl { 
        using (carries = Qubit[3]) {
            TwoBitCarrySub(a[0], b[0], carries[0]);
            ThreeBitCarrySub(a[1], b[1], carries[0], carries[1]);
            ThreeBitCarrySub(a[2], b[2], carries[1], carries[2]);
            ThreeBitCarrySub(a[3], b[3], carries[2], carry);
            
            ThreeBitInPlaceSub(a[3], b[3], carries[2]);
            Adjoint ThreeBitCarrySub(a[2], b[2], carries[1], carries[2]);
            ThreeBitInPlaceSub(a[2], b[2], carries[1]);
            Adjoint ThreeBitCarrySub(a[1], b[1], carries[0], carries[1]);
            ThreeBitInPlaceSub(a[1], b[1], carries[0]);
            Adjoint TwoBitCarrySub(a[0], b[0], carries[0]);
            TwoBitInPlaceSub(a[0], b[0]);
        }
    }
}