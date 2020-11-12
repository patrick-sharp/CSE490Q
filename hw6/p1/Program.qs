namespace p1 {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    @EntryPoint()
    operation Main(x: Int, y: Int) : Unit {
        let n = 4; // Number of qubits

        using (qubits = Qubit[(n*2) + 1]) {
            let carry = qubits[0];
            let a = qubits[1..n];
            let b = qubits[n+1..n*2];

            // Encode x & y into the state of the qubits, i.e.
            // the state of the system will be: a == |x>, b == |y>
            EncodeInt(a, x);
            EncodeInt(b, y);

            // Call the Add operation, after calling Add the state
            // a == |x>, b == |y + x>
            Add(a, b, carry);

            // Read the result from b
            let r = DecodeInt(b, carry);
            Message($"{x} + {y} = {r}");
            
            // Call the Substract operation, after calling it the state should be back to
            // a == |x>, b == |y>
            Subtract(a, b, carry);

            // Read the result from b
            let final = DecodeInt(b, carry);
            Message($"{x} + {y} - {x} = {final}");

            // To avoid errors from releasing non-measured qubits.
            ResetAll(qubits);
        }
    }

    /// #Summary
    ///     Given an array of Qubits, it prepares its state
    ///     to match the value given, in LittleEndian notation.
    operation EncodeInt(a: Qubit[], value: Int) : Unit 
    is Adj {
        for(i in 0..(Length(a) - 1)) {
            if (((value >>> i) &&& 1) == 1) {
                X(a[i]);
            }
        }
    }

    /// #Summary
    ///     Given an array of Qubits, it measures the value of each
    ///     and return the value of the corresponding bits in LittleEndian notation.
    operation DecodeInt(a: Qubit[], carry: Qubit) : Int {
        mutable r = 0;
        
        for(i in 0..(Length(a) - 1)) {
            if (M(a[i]) == One) {
                set r += (1 <<< i);
            }
        }

        if (M(carry) == One) {
            set r += (1 <<< Length(a));
        }

        return r;
    }
}
