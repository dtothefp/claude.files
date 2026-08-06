# Google Workspace CLI (gws) Skill

## CRITICAL: Do NOT use Gmail or Google Drive MCP connectors

**ALWAYS use the `gws` CLI via `./scripts/gws-multi.sh` for ALL Gmail, Google
Drive, Google Calendar, and Google Sheets operations.** NEVER use the built-in
Gmail or Google Drive MCP connectors — they are not scoped to this project's
Google account and will access the wrong inbox/drive.

This project is configured with a specific Google account. The gws wrapper
ensures all API calls use the correct credentials for this project.

## Description

Provides programmatic access to Gmail, Google Drive, and other Google Workspace
APIs via the `gws` CLI. Each project has a single mapped Google account with
credentials stored locally.

## Triggers

- "send email", "read email", "check gmail", "list emails", "check inbox"
- "search drive", "list drive files", "upload to drive"
- "calendar events", "check calendar", "schedule meeting"
- "google workspace", "gws"
- Any Gmail, Google Drive, Google Calendar, or Google Sheets operation

## How It Works

Each project has:
- `.gws-accounts.json` — account registry (alias, email, credential path, project_id, optional client_secret_file, plus a top-level default_client_secret_file)
- `.credentials/<alias>.json` — OAuth refresh token for the mapped account
- `.credentials/client_secret_default.json` — shared OAuth desktop client metadata (the source of truth for `~/.config/gws/client_secret.json`)
- `.credentials/client_secret_<alias>.json` — per-account OAuth client override (only if the account has its own GCP project, e.g. codecorp Workspace fallback)
- `.bin/gws` — Linux arm64 binary (Cowork VM) or Homebrew `gws` on macOS

The `gws-multi.sh` wrapper script does the following on every call:

1. Resolves the active account from `.gws-accounts.json`.
2. Computes a per-account isolated config dir at `~/.config/gws/accounts/<alias>` and ensures it exists. This is the critical isolation primitive: gws stores its keyring under the active config dir, and a single shared dir would let one account's credentials clobber another's. `GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE` alone is NOT sufficient, gws silently ignores it once the keyring is populated.
3. Materializes `<config_dir>/client_secret.json` from the account's `client_secret_file` (or the registry-wide `default_client_secret_file`). Deterministic copy with a no-op fast path via `cmp -s`.
4. Execs gws with `GOOGLE_WORKSPACE_CLI_CONFIG_DIR` set to the per-account dir, `GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE` set to the per-account refresh token file, and `GOOGLE_WORKSPACE_CLI_KEYRING_BACKEND=file`.

The wrapper auto-detects the gws binary (prefers Homebrew, falls back to `.bin/gws`).

## Usage

### Wrapper script (preferred)

```bash
# Uses the project's default (and only) account
./scripts/gws-multi.sh gmail messages list --maxResults=5
./scripts/gws-multi.sh drive files list --q="mimeType='application/pdf'"
./scripts/gws-multi.sh oauth2 userinfo.get
```

### Direct gws with credential env var

```bash
GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=.credentials/<alias>.json gws gmail messages list --maxResults=5
```

### Common Commands

**Gmail:**
```bash
# List recent messages
./scripts/gws-multi.sh gmail messages list --maxResults=10

# Read a specific message
./scripts/gws-multi.sh gmail messages get --id=<messageId> --format=full

# Search messages
./scripts/gws-multi.sh gmail messages list --q="from:someone@example.com is:unread"

# Send a message (requires base64-encoded RFC 2822 message)
./scripts/gws-multi.sh gmail messages send --raw=<base64-encoded-message>

# List labels
./scripts/gws-multi.sh gmail labels list
```

**Google Drive:**
```bash
# List files
./scripts/gws-multi.sh drive files list --q="name contains 'report'"

# Download a file
./scripts/gws-multi.sh drive files get --fileId=<id> --alt=media > output.pdf

# List files in a folder
./scripts/gws-multi.sh drive files list --q="'<folderId>' in parents"
```

**Account verification:**
```bash
./scripts/gws-multi.sh oauth2 userinfo.get
```

## Account Mapping

Account-to-project mappings are managed in the parent workspace's
`.gws-accounts.json`. To see the current mapping:

```bash
./scripts/gws-distribute-accounts.sh --list
```

## Credential Health

If gws calls fail, work through these checks in order:

1. **"client_secret source not found"** from the wrapper means the per-account
   or default `client_secret_*.json` file is missing. Run
   `./scripts/gws-auth-setup.sh <account>` from the parent workspace to capture it.
2. **403 about Service Usage Consumer** means either the account's `project_id`
   in `.gws-accounts.json` is wrong, the user lacks Service Usage Consumer in
   IAM on that GCP project, or the relevant API (Gmail, Drive, etc.) is not
   enabled in the project. The 403 message is misleading; check the project_id
   field first.
3. **`emailAddress` returned does not match the alias.** The per-account
   refresh token was captured against the wrong Google account. Re-run
   `./scripts/gws-auth-setup.sh <account>` and sign in as the right email.
4. **401 unauthorized** usually means the refresh token expired. Re-run
   `./scripts/gws-auth-setup.sh <account>` and then
   `./scripts/gws-distribute-accounts.sh` to push fresh credentials to children.

NEVER edit `~/.config/gws/client_secret.json` by hand. The wrapper materializes
it from the checked-in source on every call, so any manual edit gets overwritten
on the next invocation. Edit `.credentials/client_secret_default.json` (or the
per-account override) instead.

## Important Notes

- Credentials expire if unused for ~6 months or if revoked in Google settings
- Google allows max 50 refresh tokens per client ID per account
- The `gws-multi.sh` script must be available in the project's `scripts/` dir
  or at the parent workspace level
- Do NOT use built-in Gmail/Drive MCP connectors, use this skill for
  consistent multi-account credential management
- See `feedback_gws_403_quota_project.md` in parent auto-memory for the full
  architecture rationale and the list of dead-end debugging paths to avoid
