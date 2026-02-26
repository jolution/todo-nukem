import { describe, it, expect, beforeEach, vi } from 'vitest';
import { updatePrBody } from '../scripts/update-pr-body.js';

describe('update-pr-body', () => {
  let mockGithub;
  let mockContext;
  let mockEnv;
  let consoleLogSpy;

  beforeEach(() => {
    // Mock environment variables
    mockEnv = {
      HIDE_PROMOTION: 'false',
      TICKET_NUMBER: '1234',
      TICKET_BASE_URL: 'https://jira.example.com/browse/'
    };

    // Mock console.log
    consoleLogSpy = vi.spyOn(console, 'log').mockImplementation(() => {});

    // Mock github API
    mockGithub = {
      rest: {
        pulls: {
          get: vi.fn(),
          update: vi.fn()
        }
      }
    };

    // Mock context
    mockContext = {
      payload: {
        pull_request: {
          number: 42
        }
      },
      repo: {
        owner: 'testowner',
        repo: 'testrepo'
      }
    };
  });

  it('should add ticket link when PR body is empty', async () => {
    mockGithub.rest.pulls.get.mockResolvedValue({
      data: {
        body: ''
      }
    });

    await updatePrBody({ github: mockGithub, context: mockContext, env: mockEnv });

    expect(mockGithub.rest.pulls.get).toHaveBeenCalledWith({
      owner: 'testowner',
      repo: 'testrepo',
      pull_number: 42
    });

    expect(mockGithub.rest.pulls.update).toHaveBeenCalledWith({
      owner: 'testowner',
      repo: 'testrepo',
      pull_number: 42,
      body: '[ 🎫 [1234](https://jira.example.com/browse/1234) ]\n\n*via [TODO NUKEM](https://github.com/jolution/todo-nukem)*'
    });

    expect(consoleLogSpy).toHaveBeenCalledWith('✅ PR description updated with ticket link');
  });

  it('should append ticket link to existing PR body', async () => {
    mockGithub.rest.pulls.get.mockResolvedValue({
      data: {
        body: 'Existing PR description'
      }
    });

    await updatePrBody({ github: mockGithub, context: mockContext, env: mockEnv });

    expect(mockGithub.rest.pulls.update).toHaveBeenCalledWith({
      owner: 'testowner',
      repo: 'testrepo',
      pull_number: 42,
      body: 'Existing PR description\n\n---\n[ 🎫 [1234](https://jira.example.com/browse/1234) ]\n\n*via [TODO NUKEM](https://github.com/jolution/todo-nukem)*'
    });
  });

  it('should skip update when ticket link already exists', async () => {
    mockGithub.rest.pulls.get.mockResolvedValue({
      data: {
        body: 'PR body with 🎫 [1234](https://jira.example.com/browse/1234)'
      }
    });

    await updatePrBody({ github: mockGithub, context: mockContext, env: mockEnv });

    expect(mockGithub.rest.pulls.update).not.toHaveBeenCalled();
    expect(consoleLogSpy).toHaveBeenCalledWith('✅ Ticket link already exists in PR description, skipping update');
  });

  it('should hide promotion when HIDE_PROMOTION is true', async () => {
    mockEnv.HIDE_PROMOTION = 'true';

    mockGithub.rest.pulls.get.mockResolvedValue({
      data: {
        body: ''
      }
    });

    await updatePrBody({ github: mockGithub, context: mockContext, env: mockEnv });

    expect(mockGithub.rest.pulls.update).toHaveBeenCalledWith({
      owner: 'testowner',
      repo: 'testrepo',
      pull_number: 42,
      body: '[ 🎫 [1234](https://jira.example.com/browse/1234) ]'
    });
  });

  it('should handle special characters in ticket base URL', async () => {
    mockEnv.TICKET_BASE_URL = 'https://jira.example.com/browse?id=';

    mockGithub.rest.pulls.get.mockResolvedValue({
      data: {
        body: ''
      }
    });

    await updatePrBody({ github: mockGithub, context: mockContext, env: mockEnv });

    expect(mockGithub.rest.pulls.update).toHaveBeenCalledWith({
      owner: 'testowner',
      repo: 'testrepo',
      pull_number: 42,
      body: '[ 🎫 [1234](https://jira.example.com/browse?id=1234) ]\n\n*via [TODO NUKEM](https://github.com/jolution/todo-nukem)*'
    });
  });

  it('should use ticketPrefix when provided', async () => {
    mockEnv.TICKET_PREFIX = 'AB#';

    mockGithub.rest.pulls.get.mockResolvedValue({
      data: {
        body: ''
      }
    });

    await updatePrBody({ github: mockGithub, context: mockContext, env: mockEnv });

    expect(mockGithub.rest.pulls.update).toHaveBeenCalledWith({
      owner: 'testowner',
      repo: 'testrepo',
      pull_number: 42,
      body: '[ 🎫 [AB#1234](https://jira.example.com/browse/1234) ]\n\n*via [TODO NUKEM](https://github.com/jolution/todo-nukem)*'
    });
  });

  it('should work without ticketPrefix', async () => {
    // No TICKET_PREFIX in env

    mockGithub.rest.pulls.get.mockResolvedValue({
      data: {
        body: ''
      }
    });

    await updatePrBody({ github: mockGithub, context: mockContext, env: mockEnv });

    expect(mockGithub.rest.pulls.update).toHaveBeenCalledWith({
      owner: 'testowner',
      repo: 'testrepo',
      pull_number: 42,
      body: '[ 🎫 [1234](https://jira.example.com/browse/1234) ]\n\n*via [TODO NUKEM](https://github.com/jolution/todo-nukem)*'
    });
  });
});
