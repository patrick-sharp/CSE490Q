# CSE490Q
Homework for CSE490Q: https://courses.cs.washington.edu/courses/cse490q/20au/


## Usage
Install Microsoft's Q#.  
https://docs.microsoft.com/en-us/quantum/quickstarts/install-command-line?tabs=tabid-vscode

In a terminal, navigate to one of the Q# project directories (i.e. a directory with a `.csproj` file).  
Run `dotnet run`. This will build and run the Q# project whose directory you are in.

Some of the programs require command line arguments.  
For single-character arguments, use:  
`dotnet run -<arg> <value>`  
For multi-character arguments, use:  
`dotnet run --<arg> <value>`

### Examples:
Problem 3 of HW5 takes two booleans called `b1` and `b2` as arguments. You might run problem 3 with:  
`dotnet run --b1 true --b2 false`  
Problem 4 of HW5 takes a boolean called `plus` as an argument. You might run problem 4 with:  
`dotnet run --plus true`  
