param (
    [Parameter(Mandatory=$true)][string]$SkillPath,
    [Parameter(Mandatory=$true)][string]$TargetFilePath,
    [string]$Model = "codellama"
)

# 1. Disable GPU usage to prevent the CUDA "Out of Memory" 500 Error
$env:OLLAMA_NUM_GPU=0

# 2. Verify files exist before running to prevent the "Cannot find path" error
if (-not (Test-Path $SkillPath)) {
    Write-Host "Error: The Skill configuration was not found at '$SkillPath'" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $TargetFilePath)) {
    Write-Host "Error: The target file was not found at '$TargetFilePath'" -ForegroundColor Red
    exit 1
}

# 3. Load the markdown skill instructions and target file securely into memory
$skillPrompt = Get-Content $SkillPath -Raw
$targetCode = Get-Content $TargetFilePath -Raw
$fullPrompt = "SYSTEM INSTRUCTION: $skillPrompt`n`nAPPLY THIS SKILL TO THE FOLLOWING INPUT:`n`n$targetCode"

# 4. Inform the user what is happening
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "🔧 Running Local Skill Agent" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "Model: $Model (Running on CPU to block VRAM errors)" -ForegroundColor Yellow
Write-Host "Skill: $SkillPath"
Write-Host "Input: $TargetFilePath"
Write-Host "Processing... (This might take a minute depending on your CPU speed)`n" -ForegroundColor DarkGray

# 5. Pipe the prompt securely into Ollama to avoid any syntax quoting bugs
$fullPrompt | ollama run $Model
