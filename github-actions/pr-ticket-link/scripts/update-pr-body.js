/**
 * Updates PR body with ticket link
 * @param {Object} params - Parameters
 * @param {Object} params.github - GitHub API client
 * @param {Object} params.context - GitHub Actions context
 * @param {Object} params.env - Environment variables
 */
async function updatePrBody({ github, context, env }) {
  const hidePromotion = env.HIDE_PROMOTION === 'true';
  const ticketNumber = env.TICKET_NUMBER;
  const ticketBaseUrl = env.TICKET_BASE_URL;
  const ticketPrefix = env.TICKET_PREFIX || '';
  const prNumber = context.payload.pull_request.number;

  // Get current PR
  const { data: pr } = await github.rest.pulls.get({
    owner: context.repo.owner,
    repo: context.repo.repo,
    pull_number: prNumber
  });

  const currentBody = pr.body || '';

  // Check if ticket link already exists
  const displayText = ticketPrefix ? `${ticketPrefix}${ticketNumber}` : ticketNumber;
  const escapedDisplayText = displayText.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const escapedBaseUrl = ticketBaseUrl.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const ticketLinkPattern = new RegExp(`🎫.*${escapedDisplayText}.*${escapedBaseUrl}${ticketNumber}`);
  
  if (ticketLinkPattern.test(currentBody)) {
    console.log('✅ Ticket link already exists in PR description, skipping update');
    return;
  }

  const promotion = hidePromotion ? '' : '\n\n*via [TODO NUKEM](https://github.com/jolution/todo-nukem)*';
  const ticketLink = `[ 🎫 [${displayText}](${ticketBaseUrl}${ticketNumber}) ]${promotion}`;

  // Append ticket link to existing description
  const newBody = currentBody 
    ? `${currentBody}\n\n---\n${ticketLink}`
    : ticketLink;

  await github.rest.pulls.update({
    owner: context.repo.owner,
    repo: context.repo.repo,
    pull_number: prNumber,
    body: newBody
  });

  console.log('✅ PR description updated with ticket link');
}

// For github-script usage
if (typeof github !== 'undefined' && typeof context !== 'undefined') {
  await updatePrBody({ github, context, env: process.env });
}

// For testing
export { updatePrBody };
