namespace p3 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Result[] {            
        let n = 4;
        let domain = IntAsDouble((1 <<< n) - 1);
        let iterations = Floor(Sqrt(domain));
        Message($"iterations: {iterations}");
        
        // Select any oracle from p2
        let oracle = p2.Oracle_6;

        using (register = Qubit[n]) {
            GroversSearch(register, oracle, iterations);            
            return MultiM(register);
        }
    }

    /// # Summary
    ///     Implements GroverSearch by calling the GroverIteration `iterations`
    operation GroversSearch (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        ApplyToEachA(H, register);
        
        for (i in 1..iterations) {
            GroverIteration(register, OracleConverter(oracle));
        }
    }


    /// # Summary
    ///     Helper operation that returns a phase-flipping oracle 
    ///     (an oracle that takes a 
    ///     register and flips the phase of the register if it satisfies this condition)
    ///    from a marking oracle
    ///     (an oracle that takes a register and a target qubit and 
    ///      flips the target qubit if the register satisfies a certain condition).
    function OracleConverter (markingOracle : ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        return ToPhaseFlip(markingOracle, _);
    }

    /// # Summary
    ///     Helper operation that transforms a marking oracle
    ///     (an oracle that takes a register and a target qubit and 
    ///      flips the target qubit if the register satisfies a certain condition)
    ///     and transfoms it into a phase-flipping oracle (an oracle that takes a 
    ///     register and flips the phase of the register if it satisfies this condition).
    ///     as required by the Grover algorithm.
    operation ToPhaseFlip (markingOracle : ((Qubit[], Qubit) => Unit is Adj), qubits: Qubit[]) : Unit 
    is Adj {
        using (target = Qubit()) {
            within {
                X(target);
                H(target);
            } apply {
                markingOracle(qubits, target);
            }
        }
    }
}
