namespace p3 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    // Helper function for the conditional phase shift of the grover iteration circuit
    operation ConditionalPhaseShift(register: Qubit[]): Unit 
    is Adj {
        within {
            ApplyToEachA(X, register);
        } apply {
            let len = Length(register);
            Controlled Z(register[0..(len - 2)], register[len - 1]);
        }
    }
    
    /// # Summary
    ///     Implements the Grover Iteration, namely:
    ///       1. Apply the Oracle
    ///       2.	Apply the Hadamard transform
    ///       3.	Perform a conditional phase shift
    ///       4.	Apply the Hadamard transform again
    operation GroverIteration (register : Qubit[], oracle : (Qubit[] => Unit is Adj)) : Unit 
    is Adj {
        oracle(register);
        within {
            ApplyToEachA(H, register);
        } apply {
            ConditionalPhaseShift(register);
        }

    }
}