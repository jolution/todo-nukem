# TODO NUKEM - PR Ticket Link Action

Automatically adds ticket links to Pull Request descriptions based on branch names.

## Usage

```yaml
- name: Add TODO NUKEM ticket link
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

## Branch Naming

Your branch names must contain a ticket ID:

- ✅ `feature/PROJ-123`
- ✅ `fix/TICKET-456`
- ✅ `PROJ-789-refactor`
- ❌ `feature/my-feature` (no ticket ID)

## Result

Creates a PR description footer like:

```markdown
---

[🎫 PROJ-123](https://jira.example.com/browse/PROJ-123)

_via [TODO NUKEM](https://github.com/jolution/todo-nukem)_
```

## Inputs

| Name           | Description                 | Required | Default               |
| -------------- | --------------------------- | -------- | --------------------- |
| `github-token` | GitHub token for API access | Yes      | `${{ github.token }}` |

## Related

- [TODO NUKEM](https://github.com/jolution/todo-nukem) - Main project
