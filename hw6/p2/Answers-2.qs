namespace p2 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;    
    
    /// # Summary
    /// Transform state |x,y. into state $|x, y + f(x)>, 
    /// i.e., flip the target state if all qubits of the query register are in the |1⟩ state, 
    /// and leave it unchanged otherwise.
    ///
    /// Leave the query register in the same state it started in.
    operation Oracle_And (queryRegister : Qubit[], target : Qubit) : Unit 
    is Adj {
        let n = Length(queryRegister);
        using (internals = Qubit[n]) {
            CCNOT(queryRegister[0], queryRegister[1], internals[0]);
            for (i in 1..n-2) {
                CCNOT(queryRegister[i+1], internals[i-1], internals[i]);
            }
            CNOT(internals[n-2], target);
            for (i in n-2..-1..1) {
                CCNOT(queryRegister[i+1], internals[i-1], internals[i]);
            }
            CCNOT(queryRegister[0], queryRegister[1], internals[0]);
        }       
    }

    /// # Summary
    /// Transform state |x,y. into state $|x, y + f(x)>, 
    /// i.e., flip the target state if the qubits of the query register are in the |6⟩ state, 
    /// and leave it unchanged otherwise.
    ///
    /// Leave the query register in the same state it started in.
    operation Oracle_6 (queryRegister : Qubit[], target : Qubit) : Unit 
    is Adj {
        let n = Length(queryRegister);
        using (internals = Qubit[n-1]) {
            // make sure the first three bits are Zero, One, and One (0b110)
            X(queryRegister[0]);
            CCNOT(queryRegister[0], queryRegister[1], internals[0]);
            CCNOT(queryRegister[2], internals[0], internals[1]);
            // make sure every other bit is Zero
            for (i in 2..n-2) {
                X(queryRegister[i+1]);
                CCNOT(queryRegister[i+1], internals[i-1], internals[i]);
            }

            // xor with our target bit
            CNOT(internals[n-2], target);

            // reset everything
            for (i in n-2..-1..2) {
                CCNOT(queryRegister[i+1], internals[i-1], internals[i]);
                X(queryRegister[i+1]);
            }
            CCNOT(queryRegister[2], internals[0], internals[1]);
            CCNOT(queryRegister[0], queryRegister[1], internals[0]);
            X(queryRegister[0]);
        }
    }

    /// # Summary
    /// Transform state |x,y. into state $|x, y + f(x)>, 
    /// i.e., flip the target state if at least one qubit of the query register is in the |1⟩ 
    /// and leave it unchanged otherwise.
    ///
    /// Leave the query register in the same state it started in.
    operation Oracle_Or (queryRegister : Qubit[], target : Qubit) : Unit 
    is Adj {
        let n = Length(queryRegister);
        // flip every bit
        for (i in 0..n-1) {
            X(queryRegister[i]);
        }
        // use previous oracle. Only sets target to One iff all bits were Zero before swap
        Oracle_And(queryRegister, target);
        // swap so that target == Zero iff all bits were Zero
        X(target);

        // reset everything
        for (i in 0..n-1) {
            X(queryRegister[i]);
        }
        
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
        let n = Length(clause);
        using (internals = Qubit[n]) {
            let (index0, boolean0) = clause[0];
            if (boolean0) {
                X(queryRegister[index0]);
            }
            CNOT(queryRegister[index0], internals[0]);
            for (i in 1..n-1) {
                let (index, boolean) = clause[i];
                if (boolean) {
                    X(queryRegister[index]);
                }
                CCNOT(queryRegister[index], internals[i-1], internals[i]);
            }
            X(internals[n-1]);
            CNOT(internals[n-1], target);

            // reset
            X(internals[n-1]);
            for (i in 1..n-1) {
                let (index, boolean) = clause[i];
                CCNOT(queryRegister[index], internals[i-1], internals[i]);
                if (boolean) {
                    X(queryRegister[index]);
                }
            }
            CNOT(queryRegister[index0], internals[0]);
            if (boolean0) {
                X(queryRegister[index0]);
            }
        }
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
        let n = Length(clause);
        using ((runningTotal, eachClause) = (Qubit[n], Qubit[n])) {
            for (i in 0..n-1) {
                Oracle_SATClause(queryRegister, eachClause[i], clause[i]);
            }
            DumpRegister((), eachClause);
            CNOT(eachClause[0], runningTotal[0]);
            for (i in 1..n-1) {
                CCNOT(runningTotal[i-1], eachClause[i], runningTotal[i]);
            }
            DumpRegister((), runningTotal);
            CNOT(runningTotal[n-1], target);
            
            for (i in n-1..-1..1) {
                CCNOT(runningTotal[i-1], eachClause[i], runningTotal[i]);
            }
            CNOT(eachClause[0], runningTotal[0]);
            for (i in n-1..-1..0) {
                Adjoint Oracle_SATClause(queryRegister, eachClause[i], clause[i]);
            }
        }
    }
}