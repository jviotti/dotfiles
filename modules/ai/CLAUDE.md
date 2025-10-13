# Global Conventions

## Common for Software Projects

These conventions apply to EVERY software project. However, check the language
specific guides in the rest of the file for language specific requests.

- IMPORTANT: Always try to copy the existing coding conventions from the
  current file you are editing and/or other related files in the project. Every
  code you write must look like it was written by the same developer that wrote
  the other code. DO NOT invent conventions of your own.

- Never use acronyms or short variable names. Prefer descriptive names instead
  for readability purposes. For example, prefer `index` instead of `i` and
  `attributes` instead of `attrs`

- For every change you make, re-compile and run the entire test suite of the
  project (if any) to confirm that you didn't break anything

- Prioritise performance whenever possible. Avoid unnecessary copies, memory
  allocations, or complex abstractions whenever possible

- Correctness and reliability are paramount. For modules that implement or
  reference specifications like RFCs, fetch the standards first, read them, and
  take them as the source of truth. DO NOT deviate from standards.

- Avoid writing code comments unless they are absolutely needed and what they
  said cannot be inferred by just looking at the code.

- NEVER attempt to create one-off programs for testing or debugging reasons. If
  you need to dig deeper, you can print logs from the relevant parts of the
  project and see the output when running tests, given that you remove the
  debugging comments when you are done

## C++

- If the project comes with a top-level `Makefile`, avoid directly running the
  `cmake` command. Instead, only compile the project and run the tests using
  the `Makefile`. In most projects, `make` will configure, compile, and test
  the project
- Use `camel_case` for variable names, uppercase `CamelCase` for classes,
  structures, or aliases
- Make sure that there are no unnecessary system includes for any C++ file
- Every system include must have a right comment noting the symbols it is
  imported for, for reference purposes. This convention DOES NOT apply to
  non-system includes (i.e. includes to other headers part of the library or
  their dependencies)
- Prefer curly brace initialisers (i.e. `std::string foo{"bar"}`) instead of
  parenthesis initialisers (i.e. `std::string foo("bar")`) or the assignment
  operator (i.e. `std::string foo = "bar"`)
- Use trailing return types, including for `void`
- If unsure about the C++ standard, assume C++20
- Use `auto` if omitting the full type declaration is possible
- When referencing class members or methods from within the class, ALWAYS use
  the explicit `this->` form to avoid ambiguity over where those variables or
  methods come from
- Apart from right comments on system includes, avoid writing comments at the
  right of code lines. Put the comments above the line you want to comment
