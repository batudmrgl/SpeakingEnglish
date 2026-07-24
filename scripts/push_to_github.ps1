param(
    [Parameter(Mandatory = $true)]
    [string]$Owner,

    [Parameter(Mandatory = $true)]
    [string]$Repo,

    [Parameter(Mandatory = $true)]
    [string]$Token,

    [string]$BaseBranch = "",
    [string]$SourceRoot = ".",
    [string]$CommitMessage = "Add EnglishCoach iOS prototype"
)

$ErrorActionPreference = "Stop"

function Invoke-GitHub {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Method,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [object]$Body = $null
    )

    $headers = @{
        Authorization = "Bearer $Token"
        Accept = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
        "User-Agent" = "EnglishCoach-Codex-Uploader"
    }

    $uri = "https://api.github.com$Path"
    if ($null -eq $Body) {
        return Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers
    }

    $json = $Body | ConvertTo-Json -Depth 20
    return Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers -Body $json -ContentType "application/json"
}

function Get-RelativeGitHubPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BasePath,

        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    $baseUri = [Uri]((Resolve-Path $BasePath).Path.TrimEnd("\") + "\")
    $fileUri = [Uri](Resolve-Path $FilePath).Path
    return $baseUri.MakeRelativeUri($fileUri).ToString()
}

function Escape-GitHubContentPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return [Uri]::EscapeDataString($Path).Replace("%2F", "/")
}

$root = (Resolve-Path $SourceRoot).Path
$branchName = "codex/ios-prototype-" + (Get-Date -Format "yyyyMMdd-HHmmss")

if ([string]::IsNullOrWhiteSpace($BaseBranch)) {
    Write-Host "Reading repository default branch"
    $repoInfo = Invoke-GitHub -Method Get -Path "/repos/$Owner/$Repo"
    $BaseBranch = $repoInfo.default_branch
}

Write-Host "Reading base branch $BaseBranch"
$repoIsEmpty = $false
$baseCommitSha = $null
$baseTreeSha = $null

try {
    $baseRef = Invoke-GitHub -Method Get -Path "/repos/$Owner/$Repo/git/ref/heads/$BaseBranch"
    $baseCommitSha = $baseRef.object.sha
    $baseCommit = Invoke-GitHub -Method Get -Path "/repos/$Owner/$Repo/git/commits/$baseCommitSha"
    $baseTreeSha = $baseCommit.tree.sha

    Write-Host "Creating branch $branchName"
    Invoke-GitHub -Method Post -Path "/repos/$Owner/$Repo/git/refs" -Body @{
        ref = "refs/heads/$branchName"
        sha = $baseCommitSha
    } | Out-Null
} catch {
    if ($_.Exception.Message -like "*409*" -or $_.ErrorDetails.Message -like "*Git Repository is empty*") {
        Write-Host "Repository is empty. Creating initial commit on $BaseBranch"
        $repoIsEmpty = $true
        $branchName = $BaseBranch
    } else {
        throw
    }
}

$excludedDirectories = @(
    ".git",
    ".agents",
    ".codex",
    "artifacts"
)

$files = Get-ChildItem -Path $root -Recurse -File | Where-Object {
    $relative = Get-RelativeGitHubPath -BasePath $root -FilePath $_.FullName
    $parts = $relative -split "/"
    -not ($excludedDirectories | Where-Object { $parts -contains $_ })
}

Write-Host "Creating blobs for $($files.Count) files"

if ($repoIsEmpty) {
    $index = 0
    foreach ($file in $files) {
        $index += 1
        $relativePath = Get-RelativeGitHubPath -BasePath $root -FilePath $file.FullName
        $escapedPath = Escape-GitHubContentPath -Path $relativePath
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $content = [Convert]::ToBase64String($bytes)

        Write-Host "Uploading $index/$($files.Count): $relativePath"
        Invoke-GitHub -Method Put -Path "/repos/$Owner/$Repo/contents/$escapedPath" -Body @{
            message = "$CommitMessage - $relativePath"
            content = $content
            branch = $BaseBranch
        } | Out-Null
    }

    Write-Host "Done"
    Write-Host "https://github.com/$Owner/$Repo"
    exit 0
}

$treeItems = @()
foreach ($file in $files) {
    $relativePath = Get-RelativeGitHubPath -BasePath $root -FilePath $file.FullName
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $content = [Convert]::ToBase64String($bytes)

    $blob = Invoke-GitHub -Method Post -Path "/repos/$Owner/$Repo/git/blobs" -Body @{
        content = $content
        encoding = "base64"
    }

    $treeItems += @{
        path = $relativePath
        mode = "100644"
        type = "blob"
        sha = $blob.sha
    }
}

Write-Host "Creating tree"
if ($repoIsEmpty) {
    $tree = Invoke-GitHub -Method Post -Path "/repos/$Owner/$Repo/git/trees" -Body @{
        tree = $treeItems
    }
} else {
    $tree = Invoke-GitHub -Method Post -Path "/repos/$Owner/$Repo/git/trees" -Body @{
        base_tree = $baseTreeSha
        tree = $treeItems
    }
}

Write-Host "Creating commit"
$commitBody = @{
    message = $CommitMessage
    tree = $tree.sha
}
if (-not $repoIsEmpty) {
    $commitBody.parents = @($baseCommitSha)
}
$commit = Invoke-GitHub -Method Post -Path "/repos/$Owner/$Repo/git/commits" -Body $commitBody

if ($repoIsEmpty) {
    Write-Host "Creating base branch ref"
    Invoke-GitHub -Method Post -Path "/repos/$Owner/$Repo/git/refs" -Body @{
        ref = "refs/heads/$BaseBranch"
        sha = $commit.sha
    } | Out-Null
} else {
    Write-Host "Updating branch ref"
    Invoke-GitHub -Method Patch -Path "/repos/$Owner/$Repo/git/refs/heads/$branchName" -Body @{
        sha = $commit.sha
        force = $false
    } | Out-Null
}

Write-Host "Done"
if ($repoIsEmpty) {
    Write-Host "https://github.com/$Owner/$Repo"
} else {
    Write-Host "Creating pull request"
    $pullRequest = Invoke-GitHub -Method Post -Path "/repos/$Owner/$Repo/pulls" -Body @{
        title = "Add EnglishCoach iOS prototype"
        head = $branchName
        base = $BaseBranch
        body = "Adds the SwiftUI iOS prototype, Supabase backend skeleton, Xcode project, and iOS CI workflow."
    }
    Write-Host $pullRequest.html_url
}
