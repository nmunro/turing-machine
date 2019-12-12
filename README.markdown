# Turing

Turing is a small virtual machine demonstrating the principles of computation, it is intended as a learning tool for those who wish to learn more about computer science.

## Usage
Turing is written in Common Lisp using the SBCL interpreter, other interpreters were not tested, however no special extensions were used so it *should* be portable among implementations.

To use simply call the function `run-machine` in the `turing` namespace, an example is shown below.

Prorgrams are strings enclosed in double quotes with operations and operands separated by commas, spaces are not permitted in a program, only numbers and commas.

      $ cd turing-machine
      $ sbcl
      This is SBCL 1.5.9, an implementation of ANSI Common Lisp.
      More information about SBCL is available at
      <http://www.sbcl.org/>.
      SBCL is free software, provided as is, with absolutely no warranty.
      It is mostly in the public domain; some portions are provided under BSD-style licenses.  See the CREDITS and COPYING files in the distribution for more information.
      * (load "src/main")
      T
      * (turing:run-machine "101,0,0,3,0")
      * (101 0 0 202 0)
      * (quit)

Inside the session, if you wish to run the test suite that comes with this project you can.

    (asdf:run-system :turing)

## Installation
Ensure that you have sbcl installed and available in your path and the following instructions and sample program should be enough. You will probably need to ensure you have [quicklisp](https://www.quicklisp.org/beta/) installed in order to install the [rove](http://quickdocs.org/rove/) test framework in which the tests are written.

    $ git clone github.com/nmunro/turing-machine

## Op Codes

These are the implemented op-codes in the virtual machine, these are classified by type.

Numbers less than 100 are reserved for halting and no-op.
Numbers beginning with 10 are arithmetic operations.
Numbers beginning with 20 are program flow.
Numbers beginning with 30 are comparison/equality operators.

| Number | Name | Arguements |
|---|------------------|-----------------|
| 0 | Halt             | - |
| 1 | Noop             | - |
|101| Add              |3: position of first number, position of second number, position to write result to|
|102|Multiply          |3: position of first number, position of second number, position to write result to|
|103|Subtract          |3: position of first number, position of second number, position to write result to|
|104|Divide            |3: position of first number, position of second number, position to write result to|
|105|Increment         |1: position of number to increase by 1|
|106|Decrement         |1: position of number to decrement by 1|
|201|Jump              |1: position to jump to|
|202|Jump if           |3: boolean check, position if true, position if false|
|203|Jump if not       |3: boolean check, position if true, position if false|
|301|Equals            |3: position of first number, position of second number, position to write result to|
|302|Greater than      |3: position of first number, position of second number, position to write result to|
|303|Greater than equal|3: position of first number, position of second number, position to write result to|
|304|Less than         |3: position of first number, position of second number, position to write result to|
|305|Less than equal   |3: position of first number, position of second number, position to write result to|



