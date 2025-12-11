param(
  [switch]$SkipFrontend
)

Write-Host "Running pre-commit tests..." -ForegroundColor Cyan

$ErrorActionPreference = 'Stop'

Push-Location "Back-end/SemScanBackEnd"
try {
  Write-Host "Backend: manage.py test" -ForegroundColor Yellow
  python manage.py test --verbosity=2
} catch {
  Write-Error "Backend tests failed"
  Pop-Location
  exit 1
}
Pop-Location

if (-not $SkipFrontend) {
  Push-Location "Front-end/SemScanFrontEnd"
  try {
    Write-Host "Frontend: flutter test" -ForegroundColor Yellow
    flutter test --coverage
  } catch {
    Write-Error "Frontend tests failed"
    Pop-Location
    exit 1
  }
  Pop-Location
}

Write-Host "All pre-commit tests passed" -ForegroundColor Green
exit 0
