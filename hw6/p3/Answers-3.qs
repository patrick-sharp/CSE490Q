namespace p3 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;    
    
    /// # Summary
    ///     Implements the Grover Iteration, namely:
    ///       1. Apply the Oracle
    ///       2.	Apply the Hadamard transform
    ///       3.	Perform a conditional phase shift
    ///       4.	Apply the Hadamard transform again
    operation GroverIteration (register : Qubit[], oracle : (Qubit[] => Unit is Adj)) : Unit 
    is Adj {
        Message("!!TODO: Implement `GroverIteration` operation in `Answers-3.qs`!!");
    }
}