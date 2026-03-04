# TODO NUKEM - PR Ticket Link Action

Automatically adds ticket links to Pull Request descriptions based on branch names.

## Quick Setup

Create `.github/workflows/todo-nukem-pr-ticket-link.yml` in your project:

```yaml
name: TODO NUKEM - Add Ticket Link to PR

on:
  pull_request:
    types: [opened]

jobs:
  add-ticket-link:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Add ticket link to PR
        uses: jolution/todo-nukem/github-actions/pr-ticket-link@main
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Configuration

Add `ticketBaseUrl` to your `package.json`:

```json
{
  "todonukem": {
    "ticketBaseUrl": "https://jira.example.com/browse/"
  }
}
```

Or create a `.todonukem.json` file (overrides `package.json`):

```json
{
  "ticketBaseUrl": "https://your-company.atlassian.net/browse/"
}
```

### Optional: Ticket Prefix

Add a `ticketPrefix` to display a system-specific prefix in the ticket link text (prefix is only used for display, not in the URL):

```json
{
  "ticketBaseUrl": "https://dev.azure.com/myorg/myproject/_workitems/edit/",
  "ticketPrefix": "AB#"
}
```

**Examples:**

- **Azure DevOps** ([Learn more](https://learn.microsoft.com/en-us/azure/devops/boards/github/link-to-from-github?view=azure-devops)):
  ```json
  {
    "ticketBaseUrl": "https://dev.azure.com/myorg/myproject/_workitems/edit/",
    "ticketPrefix": "AB#"
  }
  ```
  Branch: `feature/AB#1234-my-feature` → Shows: `[ 🎫 [AB#1234](...) ]`

- **JIRA, Linear, or others** (default, no prefix):
  ```json
  {
    "ticketBaseUrl": "https://jira.example.com/browse/"
  }
  ```
  Branch: `feature/PROJ-1234-my-feature` → Shows: `[ 🎫 [1234](...) ]`

## Branch Naming

Your branch names must contain a ticket ID:

- ✅ `feature/PROJ-123`
- ✅ `fix/TICKET-456`
- ✅ `PROJ-789-refactor`
- ❌ `feature/my-feature` (no ticket ID)

## Result

Appends a footer to the PR description like:

```markdown
---
<!-- TODO NUKEM PR Ticket Link -->
[ 🎫 [PROJ-123](https://jira.example.com/browse/PROJ-123) ]

*via [TODO NUKEM](https://github.com/jolution/todo-nukem)*
```

The HTML comment acts as a marker to prevent duplicate entries on subsequent runs.

## Inputs

| Name            | Description                              | Required | Default               |
| --------------- | ---------------------------------------- | -------- | --------------------- |
| `github-token`  | GitHub token for API access              | Yes      | `${{ github.token }}` |
| `hidePromotion` | Hide the 'via TODO NUKEM' promotion link | No       | `false`               |

## Related

- [TODO NUKEM](https://github.com/jolution/todo-nukem) - Main project
