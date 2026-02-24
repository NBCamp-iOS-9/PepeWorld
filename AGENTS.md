# Review Guidelines

- You must write all code review feedback strictly in Korean.
- Classify cases where cyclomatic complexity exceeds the acceptable threshold as P1.
- Classify logic that is difficult to trace due to excessive control flow nesting as P1.
- Classify instances where a single function, class, or struct performs too many roles, violating the Single Responsibility Principle (SRP), as P0.
- Classify code flows that violate the project's adopted architectural pattern as P0.
- Classify structural designs that induce tight coupling between objects and hinder unit testing as P1.
- Classify naming conventions (variables, functions, classes, etc.) that obscure the original intent as P1.
- Classify logic that is unnecessarily abbreviated or overly cryptic, hindering context comprehension, as P1.
- Classify any violations of the official Swift coding standards as P1.
