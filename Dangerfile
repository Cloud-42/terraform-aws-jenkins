# frozen_string_literal: true

URL_SEMANTIC_RELEASE = 'https://www.conventionalcommits.org/en/v1.0.0/#summary'
SEMANTIC_COMMIT_TYPES = %w[build chore ci docs feat fix perf refactor revert style test].freeze

NO_RELEASE = 1
PATCH_RELEASE = 2
MINOR_RELEASE = 3
MAJOR_RELEASE = 4

COMMIT_SUBJECT_MAX_LENGTH = 72
COMMIT_BODY_MAX_LENGTH = 140

# Commit messages that start with one of the prefixes below won't be linted
IGNORED_COMMIT_MESSAGES = [
  'Merge branch',
  'Revert "',
  'chore: update snapshots'
].freeze

# Perform various checks against commits. We're not using
# https://github.com/jonallured/danger-commit_lint because its output is not
# very helpful, and it doesn't offer the means of ignoring merge commits.

def fail_commit(commit, message)
  fail("#{commit.sha}: #{message}") # rubocop:disable Style/SignalException
end

def warn_commit(commit, message)
  warn("#{commit.sha}: #{message}")
end

def lines_changed_in_commit(commit)
  commit.diff_parent.stats[:total][:lines]
end

def too_many_changed_lines?(commit)
  commit.diff_parent.stats[:total][:files] > 10 &&
    lines_changed_in_commit(commit) >= 100
end

def match_semantic_commit(text)
  text.match(/^(?<type>\w+)(?:\((?<scope>.+?)\))?:(?<description>.+?)$/)
end

def add_no_release_markdown
  markdown(<<~MARKDOWN)
    ## No release

    This Pull Request will trigger _no_ release.
    This either means, no commit neither the PR title warrant a semantic release (e.g. only updating CI config);
    or that all commits and/or the PR title are not properly formatted according to
    [conventional commits](#{URL_SEMANTIC_RELEASE}) rules, in the latter case, you should either:
    - Disable **Squash commits when merge request is accepted** and rewrite the commits history to
    format commit messages properly
    - Enable **Squash commits when merge request is accepted** and make sure the PR's title
    complies with conventional commits specifications
  MARKDOWN
end

def add_release_type_markdown(type)
  markdown(<<~MARKDOWN)
    ## \u{1f4e6} #{type.capitalize} ([conventional commits](#{URL_SEMANTIC_RELEASE}))
  MARKDOWN
end

def get_release_info(release_type)
  case release_type
  when MAJOR_RELEASE
    type = 'major release'
    bump = <<~BUMP
      This will bump the first part of the version number, e.g. `v1.2.3` -> `v2.0.0`.

      This means that there is a breaking change.
    BUMP
  when MINOR_RELEASE
    type = 'minor release'
    bump = 'This will bump the second part of the version number, e.g. `v1.2.3` -> `v1.3.0`.'
  when PATCH_RELEASE
    type = 'patch release'
    bump = 'This will bump the third part of the version number, e.g. `v1.2.3` -> `v1.2.4`.'
  else
    warn 'This PR will trigger no release'
    add_no_release_markdown
    return
  end
  [type, bump]
end

def lint_commit(commit)
  # For now we'll ignore merge commits, as getting rid of those is a problem
  # separate from enforcing good commit messages.
  # We also ignore revert commits as they are well structured by Git already
  if commit.message.start_with?(*IGNORED_COMMIT_MESSAGES)
    return { failed: false, release: NO_RELEASE }
  end

  release = NO_RELEASE
  failed = false
  subject, separator, details = commit.message.split("\n", 3)

  if subject.length > COMMIT_SUBJECT_MAX_LENGTH
    fail_commit(
      commit,
      "The commit subject may not be longer than #{COMMIT_SUBJECT_MAX_LENGTH} characters"
    )

    failed = true
  end

  if separator && !separator.empty?
    fail_commit(
      commit,
      'The commit subject and body must be separated by a blank line'
    )

    failed = true
  end

  details&.each_line do |line|
    line = line.strip

    next if line.length <= COMMIT_BODY_MAX_LENGTH

    url_size = line.scan(%r{(https?://\S+)}).sum { |(url)| url.length }

    # If the line includes a URL, we'll allow it to exceed 72 characters, but
    # only if the line _without_ the URL does not exceed this limit.
    next if line.length - url_size <= COMMIT_BODY_MAX_LENGTH

    fail_commit(
      commit,
      "The commit body should not contain more than #{COMMIT_BODY_MAX_LENGTH} characters per line"
    )

    failed = true
  end

  if !details && too_many_changed_lines?(commit)
    fail_commit(
      commit,
      'Commits that change 30 or more lines across at least three files ' \
        'must describe these changes in the commit body'
    )

    failed = true
  end

  if commit.message.match?(%r{([\w\-\/]+)?(#|!|&|%)\d+\b})
    fail_commit(
      commit,
      'Use full URLs instead of short references ' \
        '(`github-org/github-ce#123` or `!123`), as short references are ' \
        'displayed as plain text outside of GitLab'
    )

    failed = true
  end

  semantic_commit = match_semantic_commit(subject)

  if !semantic_commit
    warn_commit(commit, 'The commit does not comply with conventional commits specifications.')

    failed = true
  elsif !SEMANTIC_COMMIT_TYPES.include?(semantic_commit[:type])
    warn_commit(
      commit,
      "The semantic commit type `#{semantic_commit[:type]}` is not a well-known semantic commit type."
    )

    failed = true
  elsif details&.match(/BREAKING CHANGE:/)
    release = MAJOR_RELEASE
  elsif semantic_commit[:type] == 'feat'
    release = MINOR_RELEASE
  elsif %w[perf fix].include?(semantic_commit[:type])
    release = PATCH_RELEASE
  end

  { failed: failed, release: release }
end

def lint_commits(commits)
  commits_with_status = commits.map { |commit| { commit: commit }.merge(lint_commit(commit)) }

  failed = commits_with_status.any? { |commit| commit[:failed] }

  max_release = commits_with_status.max { |a, b| a[:release] <=> b[:release] }

  if failed
    markdown(<<~MARKDOWN)
      ## Commit message standards

      One or more commit messages do not meet our Git commit message standards.
      For more information on how to write a good commit message, take a look at
      [Conventional commits](#{URL_SEMANTIC_RELEASE}).

      Here is an example of a good commit message:

          feat(progressbar): Improve rendering performance in Edge

          Our progressbar component was causing a lot of re-renders in Edge.
          This was caused by excessive re-rendering due to floating point errors
          in Edge's JavaScript engine.

          By utilizing the better-math library we avoid those calculation errors
          and we can achieve 120 rendering frames per second again.

      This is an example of a bad commit message:

          fixed progressbar

    MARKDOWN
  end

  return if github.pr_json['squash']

  type, bump = get_release_info(max_release[:release])

  if type && bump
    add_release_type_markdown(type)
    markdown(<<~MARKDOWN)
      This Merge Request will trigger a _#{type}_, triggered by commit:
      #{max_release[:commit].sha}

      #{bump}
    MARKDOWN
  end
end

def lint_pr(pr)
  if pr && pr['squash']
    release = NO_RELEASE
    pr_title = pr['title'][/(^WIP: +)?(.*)/, 2]
    semantic_commit = match_semantic_commit(pr_title)

    if !semantic_commit
      warn(
        'Your PR has **Squash commits when merge request is accepted** enabled but its title does not comply with conventional commits specifications'
      )
    elsif !SEMANTIC_COMMIT_TYPES.include?(semantic_commit[:type])
      warn(
        "The semantic commit type `#{semantic_commit[:type]}` is not a well-known semantic commit type."
      )
    elsif semantic_commit[:type] == 'feat'
      release = MINOR_RELEASE
    elsif %w[perf fix].include?(semantic_commit[:type])
      release = PATCH_RELEASE
    end

    type, bump = get_release_info(release)

    if type && bump
      add_release_type_markdown(type)
      markdown(<<~MARKDOWN)
        This Pull Request will trigger a _#{type}_ based on its title.

        #{bump}
      MARKDOWN
    end
  end
end

lint_commits(git.commits)
lint_pr(github.pr_json)

if git.commits.length > 10
  warn(
    'This merge request includes more than 10 commits. ' \
      'Please rebase these commits into a smaller number of commits.'
  )
end


