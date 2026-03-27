# TODO NUKEM - PR Ticket Link Action

> [!NOTE]
> **This action has moved to its own repository.** We recommend updating your workflow to use the new path:
>
> Replace `jolution/todo-nukem/github-actions/pr-ticket-link@main` with `jolution/todo-nukem-pr-ticket-link@v1`
>
> → [jolution/todo-nukem-pr-ticket-link](https://github.com/jolution/todo-nukem-pr-ticket-link)

Automatically adds ticket links to Pull Request descriptions based on branch names.

## Quick Setup

Create `.github/workflows/todo-nukem-pr-ticket-link.yml` in your project:

```yaml
name: ☢️ TODO NUKEM - Add Ticket Link to PR

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  add-ticket-link:
    runs-on: ubuntu-slim
    permissions:
      contents: read
      pull-requests: write
    steps:
      - name: Checkout
        uses: actions/checkout@v6

      - name: 🔗 Add ticket link to PR
        uses: jolution/todo-nukem-pr-ticket-link@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          hidePromotion: false
          linkStyle: plaintext
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

Add a `ticketPrefix` to display a system-specific prefix in the ticket reference (prefix is only used for display, not in the URL):

```json
{
  "ticketBaseUrl": "https://dev.azure.com/myorg/myproject/_workitems/edit/",
  "ticketPrefix": "AB#"
}
```

**Examples:**

- **Azure DevOps with auto-linking** ([Learn more](https://learn.microsoft.com/en-us/azure/devops/boards/github/link-to-from-github?view=azure-devops)):

  GitHub ↔ Azure DevOps can auto-link plain text like `AB#123` into a work-item link. Set `linkStyle: plaintext` in your workflow and optionally `ticketPrefix` in your config:

  ```yaml
  - name: Add ticket link to PR
    uses: jolution/todo-nukem-pr-ticket-link@v1
    with:
      github-token: ${{ secrets.GITHUB_TOKEN }}
      linkStyle: plaintext
  ```

  ```json
  { "ticketPrefix": "AB#" }
  ```

  Branch: `feature/AB-1234-my-feature` → Shows: `[ 🎫 AB#1234 ]` (auto-linked by Azure DevOps)

- **Azure DevOps with explicit link**:

  ```json
  {
    "ticketBaseUrl": "https://dev.azure.com/myorg/myproject/_workitems/edit/",
    "ticketPrefix": "AB#"
  }
  ```

  Branch: `feature/AB-1234-my-feature` → Shows: `[ 🎫 [AB#1234](...) ]`

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

Appends a footer to the PR description. The exact format depends on `ticketLinkStyle`:

**`markdown` (default)**

```markdown
---

<!-- TODO NUKEM PR Ticket Link -->

[ 🎫 [PROJ-123](https://jira.example.com/browse/PROJ-123) ]

_via [TODO NUKEM](https://github.com/jolution/todo-nukem)_
```

**`plaintext`** (e.g. for Azure DevOps auto-linking)

```markdown
---

<!-- TODO NUKEM PR Ticket Link -->

[ 🎫 AB#123 ]

_via [TODO NUKEM](https://github.com/jolution/todo-nukem)_
```

The HTML comment acts as a marker to prevent duplicate entries on subsequent runs.

## Inputs

| Name            | Description                                                                                                                     | Required | Default               |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------- | -------- | --------------------- |
| `github-token`  | GitHub token for API access                                                                                                     | Yes      | `${{ github.token }}` |
| `hidePromotion` | Hide the 'via TODO NUKEM' promotion link                                                                                        | No       | `false`               |
| `linkStyle`     | Format of the ticket reference: `markdown` (Markdown hyperlink) or `plaintext` (plain text, e.g. for Azure DevOps auto-linking) | No       | `markdown`            |

## Related

- [TODO NUKEM](https://github.com/jolution/todo-nukem) - Main project
