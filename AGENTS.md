# Review Guidelines

- You must write all code review feedback strictly in Korean.

## Architecture / Design

- You must classify any code flow that violates the project’s adopted architectural pattern (e.g., MVC, MVVM, VIPER, Clean Architecture) as P0.
- You must classify cases where a ViewController, View, or any UI layer component directly handles networking, persistence, business logic, or navigation orchestration beyond its defined responsibility as P0.
- You must classify instances where a single function, class, or struct performs multiple unrelated responsibilities, violating the Single Responsibility Principle (SRP), as P0.
- You must classify dependency direction violations (e.g., UI layer depending directly on concrete data/network implementations) as P0.

## Complexity / Control Flow

- You must classify cases where cyclomatic complexity exceeds the acceptable threshold as P1.
- You must classify logic that is difficult to trace due to excessive control flow nesting as P1.
- You must classify overly fragmented optional binding or guard/if nesting that significantly reduces readability as P1.

## Coupling / Testability

- You must classify structural designs that induce tight coupling between objects and hinder unit testing as P1.
- You must classify direct instantiation of external dependencies (e.g., URLSession.shared, NotificationCenter.default, Date()) without dependency injection as P1.
- You must classify reliance on global mutable state or singleton state that affects determinism and testability as P1.

## Memory Management / ARC

- You must classify strong reference cycles or potential retain cycles (e.g., improper closure captures, delegate strong references) as P0.
- You must classify missing or incorrect capture lists in closures that may lead to memory leaks as P0.

## Error Handling

- You must classify swallowed errors (e.g., empty catch blocks, excessive use of try?) that obscure failure causes as P1.
- You must classify forced unwrapping that may lead to runtime crashes as P0.

## UIKit / UI Stability

- You must classify cell reuse mismanagement (e.g., missing prepareForReuse cleanup, uncancelled image loading) as P1.
- You must classify UI state being mutated from multiple uncontrolled sources leading to inconsistent rendering as P1.
- You must classify Auto Layout configurations that may cause constraint conflicts or ambiguity as P1.

## Naming / Readability / Standards

- You must classify naming conventions (variables, functions, classes, etc.) that obscure the original intent as P1.
- You must classify unnecessarily abbreviated or cryptic logic that hinders context comprehension as P1.
- You must classify violations of the Swift API Design Guidelines and the official Swift coding conventions as P1.
