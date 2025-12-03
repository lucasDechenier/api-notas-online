---
applyTo: '**'
description: "Language-agnostic clean code principles and best practices for maintainable, readable, and reliable software development."
---

# Clean Code Best Practices

## Your Mission

As a programming assistant, you must understand and apply clean code principles that transcend specific programming languages. Your goal is to help developers write code that is readable, maintainable, testable, and follows universal best practices. When generating or reviewing code, always consider clarity, simplicity, and expressiveness regardless of the programming language being used.

## Introduction

Clean code is code that is easy to read, understand, and modify. It follows consistent conventions, has clear intent, and minimizes complexity. These principles apply universally across programming languages and paradigms, forming the foundation of professional software development.

**Key Benefits of Clean Code:**
- **Readability:** Code is easy to understand by other developers
- **Maintainability:** Changes and bug fixes are straightforward
- **Testability:** Code can be easily tested and verified
- **Scalability:** Code can grow and evolve without becoming unwieldy
- **Collaboration:** Teams can work together more effectively

## Variables and Naming

### Use Meaningful and Pronounceable Names

Names should clearly express what a variable, function, or class does. Avoid abbreviations and cryptic naming.

**Principles:**
- Use intention-revealing names
- Make names pronounceable and searchable
- Use domain-specific terminology when appropriate
- Avoid mental mapping and abbreviations

**Bad Examples (Concept):**
- `yyyymmdstr` → unclear what this represents
- `d` → what kind of data?
- `usr` → abbreviation forces mental mapping

**Good Examples (Concept):**
- `currentDate` → clearly represents today's date
- `userData` → clearly indicates user information
- `userRepository` → clearly indicates data access layer

### Use Consistent Vocabulary

Use the same word for the same concept throughout your codebase. Don't mix synonyms for the same concept.

**Principles:**
- Pick one word per concept and stick with it
- Avoid using different words for the same concept
- Create a consistent naming convention for your domain

**Bad Examples (Concept):**
- `getUserInfo()`, `getClientData()`, `getCustomerRecord()` → three different words for the same concept

**Good Examples (Concept):**
- `getUser()`, `getClient()`, `getCustomer()` → consistent naming pattern

### Use Searchable Names

Avoid magic numbers and single-letter variables. Use named constants for values that have meaning.

**Principles:**
- Replace magic numbers with named constants
- Use descriptive names instead of single letters
- Make important values easy to find and understand

### Avoid Mental Mapping

Explicit is better than implicit. Don't force readers to translate your names into concepts they understand.

**Principles:**
- Use descriptive names instead of cryptic ones
- Avoid single-letter variables except for very short loops
- Write code that reads like prose

### Don't Add Unneeded Context

If your class or module name provides context, don't repeat it in variable names.

**Principles:**
- Remove redundant information from names
- Let context provide meaning
- Keep names concise but descriptive

## Functions and Methods

### Function Arguments (2 or Fewer Ideally)

Limit the number of function parameters to make testing and understanding easier.

**Principles:**
- Aim for 0-2 parameters when possible
- Use parameter objects for multiple related values
- Consider breaking complex functions into smaller ones
- Use dependency injection for complex dependencies

### Functions Should Do One Thing

This is the most important rule in software engineering. Functions should have a single, well-defined responsibility.

**Principles:**
- Each function should have one reason to change
- Function names should clearly indicate their purpose
- Break complex operations into smaller, focused functions
- Follow the Single Responsibility Principle

### Function Names Should Say What They Do

Function names should be descriptive and indicate the action being performed.

**Principles:**
- Use verb-noun combinations for actions
- Be specific about what the function does
- Avoid ambiguous names
- Use domain-specific language

### Functions Should Only Be One Level of Abstraction

Each function should operate at a consistent level of abstraction.

**Principles:**
- Keep functions at the same conceptual level
- Extract lower-level operations into separate functions
- Make the main function read like a table of contents
- Use the Step-down Rule

### Remove Duplicate Code

Duplication is one of the primary enemies of a well-designed system.

**Principles:**
- Follow the DRY (Don't Repeat Yourself) principle
- Extract common functionality into shared functions
- Use abstraction to handle similar but different operations
- Consider when abstraction might be premature

### Avoid Side Effects

Functions should be predictable and not modify state unexpectedly.

**Principles:**
- Minimize side effects in functions
- Make side effects explicit and documented
- Prefer pure functions when possible
- Centralize state changes

### Use Default Parameters

Provide sensible defaults instead of forcing callers to handle undefined values.

**Principles:**
- Use default parameters instead of conditional logic
- Make common use cases simple
- Document default behavior clearly
- Validate parameters when necessary

### Don't Use Flags as Function Parameters

Boolean flags often indicate that a function is doing more than one thing.

**Principles:**
- Split functions that take boolean flags
- Use polymorphism instead of flags
- Make function behavior explicit
- Consider the Command pattern for complex cases

## Classes and Objects

### Single Responsibility Principle (SRP)

A class should have only one reason to change.

**Principles:**
- Each class should have one job
- Changes should affect only one class
- High cohesion within classes
- Loose coupling between classes

### Open/Closed Principle (OCP)

Software entities should be open for extension but closed for modification.

**Principles:**
- Extend behavior through inheritance or composition
- Don't modify existing stable code
- Use interfaces and abstractions
- Follow the Strategy pattern when appropriate

### Dependency Inversion Principle (DIP)

Depend on abstractions, not concretions.

**Principles:**
- High-level modules should not depend on low-level modules
- Both should depend on abstractions
- Use dependency injection
- Program to interfaces, not implementations

### Prefer Composition Over Inheritance

Favor object composition over class inheritance when possible.

**Principles:**
- Use inheritance for "is-a" relationships
- Use composition for "has-a" relationships
- Avoid deep inheritance hierarchies
- Consider the Decorator and Strategy patterns

### Encapsulate Data

Keep internal state private and provide controlled access through methods.

**Principles:**
- Make fields private by default
- Provide public methods for necessary access
- Validate data on input
- Maintain object invariants

## Error Handling

### Use Exceptions for Exceptional Cases

Don't use exceptions for normal program flow.

**Principles:**
- Exceptions should indicate unexpected conditions
- Use return values for expected error conditions
- Provide meaningful error messages
- Document what exceptions your functions can throw

### Don't Ignore Caught Errors

Always handle errors appropriately, don't silently ignore them.

**Principles:**
- Log errors appropriately
- Provide user-friendly error messages
- Clean up resources in error conditions
- Consider the caller's needs when handling errors

### Provide Context with Exceptions

Error messages should provide enough information to diagnose the problem.

**Principles:**
- Include relevant context in error messages
- Use structured error information
- Provide suggestions for resolution when possible
- Log additional diagnostic information

## Comments and Documentation

### Only Comment Things That Have Business Logic Complexity

Comments should explain why, not what.

**Principles:**
- Good code mostly documents itself
- Comment the intent, not the implementation
- Explain business rules and domain concepts
- Update comments when code changes

### Don't Leave Commented Out Code

Version control systems handle code history.

**Principles:**
- Delete dead code instead of commenting it out
- Use version control for code history
- Keep the codebase clean and focused
- Remove TODO comments that are no longer relevant

### Avoid Positional Markers

Let proper indentation and formatting provide visual structure.

**Principles:**
- Use proper code formatting
- Let the code structure speak for itself
- Group related functionality logically
- Use whitespace effectively

## Code Organization

### Keep Related Code Close Together

Functions that call each other should be close in the source file.

**Principles:**
- Follow the newspaper metaphor
- Put calling functions above called functions
- Group related functionality together
- Use consistent organization patterns

### Use Consistent Formatting

Consistent formatting makes code easier to read and understand.

**Principles:**
- Follow team coding standards
- Use automated formatting tools
- Be consistent within a project
- Make formatting invisible to the reader

### Organize Imports and Dependencies

Keep dependencies organized and minimal.

**Principles:**
- Group imports logically
- Remove unused imports
- Prefer explicit imports over wildcards
- Document external dependencies

## Testing Principles

### Write Tests First

Test-driven development leads to better design.

**Principles:**
- Write failing tests before implementation
- Keep tests simple and focused
- Test behavior, not implementation
- Maintain test code quality

### One Concept Per Test

Each test should verify one specific behavior.

**Principles:**
- Test one thing at a time
- Use descriptive test names
- Follow the Arrange-Act-Assert pattern
- Make test failures easy to diagnose

### Keep Tests Independent

Tests should not depend on each other or external state.

**Principles:**
- Each test should set up its own data
- Tests should be able to run in any order
- Clean up after tests
- Use test doubles for external dependencies

## Performance Considerations

### Don't Optimize Prematurely

Write clear code first, then optimize where needed.

**Principles:**
- Measure before optimizing
- Focus on algorithmic improvements
- Don't sacrifice readability for micro-optimizations
- Profile to find real bottlenecks

### Remove Dead Code

Unused code adds complexity without benefit.

**Principles:**
- Delete code that's no longer used
- Remove commented-out code
- Clean up after refactoring
- Use tools to detect dead code

### Favor Readability Over Cleverness

Code is read more often than it's written.

**Principles:**
- Write code for the next developer
- Use clear, straightforward approaches
- Avoid overly clever solutions
- Document complex algorithms when necessary

## Universal Anti-Patterns to Avoid

### Ambiguous Naming
- Vague or unclear names
- Inconsistent terminology
- Abbreviations that require context

### Overly Complex Functions
- Functions that do too many things
- Deep nesting and complex conditionals
- Long parameter lists

### Poor Error Handling
- Swallowing exceptions silently
- Generic error messages
- Not cleaning up resources

### Tight Coupling
- Classes that know too much about each other
- Hard-coded dependencies
- Circular dependencies

### Magic Numbers and Strings
- Unexplained numeric constants
- Hard-coded text values
- Configuration mixed with logic

## Conclusion

Clean code is not about following rules blindly, but about making code that is easy to understand, modify, and maintain. These principles should guide your decisions, but always consider the specific context of your project and team.

Remember:
- **Clarity over cleverness**
- **Simplicity over complexity**
- **Consistency over personal preference**
- **Maintainability over short-term convenience**

The goal is to write code that your future self and your teammates will thank you for.
