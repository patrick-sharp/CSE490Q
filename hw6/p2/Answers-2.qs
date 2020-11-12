namespace p2 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;    
    
    /// # Summary
    /// Transform state |x,y. into state $|x, y + f(x)>, 
    /// i.e., flip the target state if all qubits of the query register are in the |1⟩ state, 
    /// and leave it unchanged otherwise.
    ///
    /// Leave the query register in the same state it started in.
    operation Oracle_And (queryRegister : Qubit[], target : Qubit) : Unit 
    is Adj {
        Message("!!TODO: Implement `Oracle_And` operation in `Answers-2.qs`!!");
    }

    /// # Summary
    /// Transform state |x,y. into state $|x, y + f(x)>, 
    /// i.e., flip the target state if the qubits of the query register are in the |6⟩ state, 
    /// and leave it unchanged otherwise.
    ///
    /// Leave the query register in the same state it started in.
    operation Oracle_6 (queryRegister : Qubit[], target : Qubit) : Unit 
    is Adj {
        Message("!!TODO: Implement `Oracle_6` operation in `Answers-2.qs`!!");
    }

    /// # Summary
    /// Transform state |x,y. into state $|x, y + f(x)>, 
    /// i.e., flip the target state if at least one qubit of the query register is in the |1⟩ 
    /// and leave it unchanged otherwise.
    ///
    /// Leave the query register in the same state it started in.
    operation Oracle_Or (queryRegister : Qubit[], target : Qubit) : Unit 
    is Adj {
        Message("!!TODO: Implement `Oracle_Or` operation in `Answers-2.qs`!!");
    }
    
    /// # Summary
    /// Transform state |x,y. into state $|x, y + f(x)>, 
    /// i.e., flip the target state if at all of the qubits of the query register match the state represented
    /// by the SAT `clause`. Each tuple in the clause is an (Int, Bool) pair in which:
    ///	    - the first element is the index j of the qubit x𝑗, 
    ///	    - the second element is true if the corresponding qubit is included as itself (x𝑗) 
    ///         and false if it is included as a negation (¬x𝑗).
    /// For example:
    ///     The clause 𝑥0 ∨ ¬𝑥1 can be represented as [(0, true), (1, false)].
    ///
    /// Leave the query register in the same state it started in.
    operation Oracle_SATClause (queryRegister : Qubit[], target : Qubit, clause : (Int, Bool)[]) : Unit 
    is Adj {
        Message("!!TODO: Implement `Oracle_SATClause` operation in `Answers-2.qs`!!");
    }

    /// # Summary
    /// Transform state |x,y. into state $|x, y + f(x)>, 
    /// i.e., flip the target state if at any of the qubits of the query register match the state represented
    /// by the SAT `clause`. Each tuple in the clause is an (Int, Bool) pair in which:
    ///	    - the first element is the index j of the qubit x𝑗, 
    ///	    - the second element is true if the corresponding qubit is included as itself (x𝑗) 
    ///         and false if it is included as a negation (¬x𝑗).
    /// For example:
    ///     The clause 𝑥0 ∨ ¬𝑥1 can be represented as [(0, true), (1, false)].
    ///
    /// Leave the query register in the same state it started in.
    operation Oracle_SAT (queryRegister : Qubit[], target : Qubit, clause : (Int, Bool)[][]) : Unit 
    is Adj {
        Message("!!TODO: Implement `Oracle_SAT` operation in `Answers-2.qs`!!");
    }
}