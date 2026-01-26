# GitHub Copilot Instructions

## Commit Messages

When suggesting commit messages, always use the Angular Conventional Commits format.

**Reference**: [Angular Commit Message Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type
Must be one of the following:

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Scope
The scope should be the name of the affected module, component, or area (optional but recommended).

Examples:
- `(auth)`
- `(user-service)`
- `(list-field-wrapper)`
- `(docker)`
- `(frontend)`
- `(backend)`

### Subject
- Use the imperative, present tense: "change" not "changed" nor "changes"
- Don't capitalize the first letter
- No dot (.) at the end
- Maximum 72 characters

### Body (optional)
- Use the imperative, present tense
- Include motivation for the change and contrast with previous behavior
- Wrap at 72 characters

### Footer (optional)
- Reference tickets: `[ticket: TDN-123]`
- Note breaking changes: `BREAKING CHANGE: description`

### Examples

```
feat(list-field-wrapper): add delete button for PSP list entries

Implement functionality to delete individual PSP list entries.
The delete button is only shown when appropriate based on form type.

Closes [ticket: TDN-123]
```

```
fix(auth): resolve token expiration handling

Update token refresh logic to prevent premature expiration.
This ensures users remain authenticated during long sessions.
```

```
refactor(dynamic-form): simplify computed property logic

Extract complex conditionals into separate computed signals
for better readability and maintainability.
```

```
docs(readme): update installation instructions
```

```
chore(deps): upgrade Angular to v20
```

```
refactor(auth): remove obsolete login check

Clean up unused authentication logic after migration.

[ticket: TDN-456]
```

## Code Style

- Follow Angular style guide
- Use TypeScript strict mode
- Prefer signals over observables where appropriate
- Use standalone components
- Follow existing patterns in the codebase
- Adhere to ESLint rules configured in the project
- Never use `any` type in TypeScript - use proper types, interfaces, or generics
- Use explicit return types for functions
- Avoid using `@ts-ignore` or `@ts-nocheck` - fix type issues properly

## TODO Comments

Follow the [TODO NUKEM](https://github.com/jolution/todo-nukem) convention for all TODO comments in code.

### Format

```
// TODO: [priority] [type] [context] <description> [optional meta]
```

### Required Classification Blocks

1. **Priority**: `[low]`, `[medium]`, or `[high]`
2. **Type**: `[feature]` or `[fix]`
3. **Context**: `[design]`, `[doc]`, `[test]`, `[perf]`, `[lang]`, `[sec]`, `[update]`, `[optimize]`, or `[review]`

### Optional Meta Blocks

- `[tbd]` - To Be Discussed
- `[scope: ComponentName]` - Specify scope
- `[ticket: TDN-123]` - Link to ticket
- `[until: 2025-Q1]` - Deadline
- `[assignee: Name]` - Assign to person
- `[author: Name]` - Author of TODO
- `[version: v1]` - Version
- `[docs]` - Documentation related
- `[block-commit]` - Prevent commit (requires git hook configuration)

### Examples

```typescript
// TODO: [low] [feature] [optimize] Improve caching strategy
// TODO: [medium] [fix] [update] Handle edge case for empty arrays [ticket: TDN-456]
// TODO: [high] [feature] [test] Add unit tests for new service [block-commit]
```
