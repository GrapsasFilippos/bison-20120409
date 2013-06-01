Exercise about the compilers for college. Syntax analysis (using GNU Bison) for the code in the file: `test-final.txt`.

### Download
[bison-20120409](http://github.com/GrapsasFilippos/bison-20120409)  
[GFQueue](http://github.com/GrapsasFilippos/GFQueue)  
[GFBinarySearchTree](http://github.com/GrapsasFilippos/GFBinarySearchTree)

### Compile
`make CPPFLAGS='-I path/to/GFQueue -I path/to/GFBinarySearchTree'`

### Run
`./bison-20120409 < test.txt`

### Clean
`make clean`

### Precompiler options
Select the level of verbose messages at compile time:

* `DBML` : for the output of the lectical analyzer,
* `DBMP` : for the output of the syntax analyzer (by default) and
* `DBMA` : for both

For example:  
`make CPPFLAGS='-D DBML -I path/to/GFQueue -I path/to/GFBinarySearchTree'`
