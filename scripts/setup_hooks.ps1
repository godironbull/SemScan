$hookPath = Join-Path (Resolve-Path ".").Path ".git/hooks/pre-commit"
$scriptPath = Join-Path (Resolve-Path ".").Path "scripts/pre_commit.ps1"

if (!(Test-Path (Split-Path $hookPath))) {
  Write-Error ".git directory not found. Initialize git before installing hooks."
  exit 1
}

Set-Content -Path $hookPath -Value "#!/usr/bin/env pwsh`n`n& '$scriptPath'`nexit $LASTEXITCODE" -NoNewline
Write-Host "Installed pre-commit hook -> $hookPath" -ForegroundColor Green
