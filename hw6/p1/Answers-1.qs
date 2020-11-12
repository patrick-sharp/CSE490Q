namespace p1 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;    
    
    /// # Summary
    /// Given two qubit registers in state |a> and |b>, sets the qubits to state 
    /// |a>|b + a>
    operation Add(a: Qubit[], b: Qubit[], carry: Qubit) : Unit 
    is Adj + Ctl { 
        Message("!!TODO: Implement `Add` operation in `Answers-1.qs`!!");
    }

    /// # Summary
    /// Given two qubit registers in state |a> and |b>, sets the qubits to state 
    /// |a>|b - a>
    operation Subtract(a: Qubit[], b: Qubit[], carry: Qubit) : Unit 
    is Adj + Ctl { 
        Message("!!TODO: Implement `Subtract` operation in `Answers-1.qs`!!");
    }
}