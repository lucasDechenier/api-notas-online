---
description: 'Improve code quality, apply security best practices, and enhance design whilst maintaining green tests and GitHub issue compliance.'
tools: ['edit/editFiles', 'search', 'runCommands', 'jira/search', 'problems', 'testFailure']
---
# TDD Refactor Phase - Improve Quality & Security

Clean up code, apply security best practices, and enhance design whilst keeping all tests green and maintaining GitHub issue compliance.

## GitHub Issue Integration

### Issue Completion Validation
- **Verify all acceptance criteria met** - Cross-check implementation against GitHub issue requirements
- **Update issue status** - Mark issue as completed or identify remaining work
- **Document design decisions** - Comment on issue with architectural choices made during refactor
- **Link related issues** - Identify technical debt or follow-up issues created during refactoring

### Quality Gates
- **Definition of Done adherence** - Ensure all issue checklist items are satisfied
- **Security requirements** - Address any security considerations mentioned in issue
- **Performance criteria** - Meet any performance requirements specified in issue
- **Documentation updates** - Update any documentation referenced in issue

## Core Principles

### Code Quality Improvements
- **Use JS/TS Guidelines** - ALWAYS Use JS/TS code guidelines defined in [Guidelines Instructions](../instructions/js-guideline.instructions.md)

### Security Hardening
- **Input validation** - Sanitise and validate all external inputs per issue security requirements
- **Authentication/Authorisation** - Implement proper access controls if specified in issue
- **Data protection** - Encrypt sensitive data, use secure connection strings
- **Error handling** - Avoid information disclosure through exception details
- **Dependency scanning** - Check for vulnerable lib packages
- **Secrets management** - Never hard-code credentials
- **OWASP compliance** - Address security concerns mentioned in issue and in [Security and OWASP Instructions](../instructions/security-and-owasp.instructions.md)

### Design Excellence
- **Design patterns** - Apply appropriate patterns (Repository, Factory, Strategy, etc.)
- **Dependency injection** - Use DI container for loose coupling
- **Configuration management** - Externalise settings using IOptions pattern
- **Logging and monitoring** - Add structured logging with Serilog for issue troubleshooting
- **Performance optimisation** - Use async/await, efficient collections, caching

### C# Best Practices
- **Nullable reference types** - Enable and properly configure nullability
- **Modern C# features** - Use pattern matching, switch expressions, records
- **Memory efficiency** - Consider Span<T>, Memory<T> for performance-critical code
- **Exception handling** - Use specific exception types, avoid catching Exception

## Security Checklist
- [ ] Input validation on all public methods
- [ ] SQL injection prevention (parameterised queries)
- [ ] XSS protection for web applications
- [ ] Authorisation checks on sensitive operations
- [ ] Secure configuration (no secrets in code)
- [ ] Error handling without information disclosure
- [ ] Dependency vulnerability scanning
- [ ] OWASP Top 10 considerations addressed

## Execution Guidelines

1. **Review issue completion** - Ensure GitHub issue acceptance criteria are fully met
2. **Ensure green tests** - All tests must pass before refactoring
3. **Confirm your plan with the user** - Ensure understanding of requirements and edge cases. NEVER start making changes without user confirmation
4. **Small incremental changes** - Refactor in tiny steps, running tests frequently
5. **Apply one improvement at a time** - Focus on single refactoring technique
6. **Run security analysis** - Use static analysis tools (SonarQube, Checkmarx)
7. **Document security decisions** - Add comments for security-critical code
8. **Update issue** - Comment on final implementation and close issue if complete

## Refactor Phase Checklist
- [ ] GitHub issue acceptance criteria fully satisfied
- [ ] Code duplication eliminated
- [ ] Names clearly express intent aligned with issue domain
- [ ] Methods have single responsibility
- [ ] Security vulnerabilities addressed per issue requirements
- [ ] Performance considerations applied
- [ ] All tests remain green
- [ ] Code coverage maintained or improved
- [ ] Issue marked as complete or follow-up issues created
- [ ] Documentation updated as specified in issue