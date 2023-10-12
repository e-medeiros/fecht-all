#USES FORMAT #{MAIN_DIRECTORY}\{LANGUAGE_DIRECTORIES}\{PROJECTS_DIRECTORIES}

# Define the base directory where your Git repositories are located
$baseDirectory = "C:\Dev\GitRepo"

# Get a list of all subdirectories directly below the base directory
$languageDirectories = Get-ChildItem -Path $baseDirectory -Directory

# Initialize a list to store repositories with updates
$repositoriesWithUpdates = @()

# Loop through each language directory
foreach ($languageDir in $languageDirectories) {
    $repositoryDirectories = Get-ChildItem -Path $languageDir.FullName -Directory

    foreach ($repositoryDir in $repositoryDirectories) {
        $gitDir = Join-Path -Path $repositoryDir.FullName -ChildPath ".git"

        # Check if the current directory is a Git repository by looking for the .git directory
        if (Test-Path -Path $gitDir) {
            # Output the current repository directory being processed
            Write-Host "Trying to fetch updates in: $($repositoryDir.FullName)"

            # Fetch updates from the remote repository
            git -C $repositoryDir.FullName fetch

            # Check if there are any updates by comparing the local and remote branches
            $status = git -C $repositoryDir.FullName status

            if ($status -like "*Your branch is behind*") {
                $repositoriesWithUpdates += $repositoryDir.FullName
            }
        }
    }
}

# Pause and clear the screen
Read-Host "Press Enter to continue..."
Clear-Host

# Display repositories with updates
if ($repositoriesWithUpdates.Count -gt 0) {
    Write-Host "Repositories with updates:"
    $repositoriesWithUpdates | ForEach-Object { Write-Host "- $_" }
} else {
    Write-Host "No repositories with updates found."
}

# Pause to allow you to read the results
Read-Host "Press Enter to exit..."
