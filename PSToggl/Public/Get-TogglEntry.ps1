function Get-TogglEntry() {
    <#
    .SYNOPSIS
        Gets Toggl Time Entries

    .DESCRIPTION
        This cmdlet queries the Toggl API for Time Entries (time_entries). It returns all Entries, of no parameter is given.
        You can search Entries by its name, id, project, tags..

        You can pipe any PSToggl object which belongs to a time entry to this cmdlet, like:
        * Workspace: Returns Time Entries for the given Workspace.
        * Project: Returns Time Entries whose pid matches the given project.
        * Client: Returns Time Entries for the given client.
        *(WIP) User (This is a special case, a user contains its time entries as array. If not, will query for it and return))

    .PARAMETER Current
        If set, only the currently running timer is returned. If no time entry is running, it returns nothing.

    .INPUTS
        PSToggl.Workspace
        PSToggl.Project
        PSToggl.Client
        ?PSToggl.User?

    .OUTPUTS
        PSToggl.Entry

    .EXAMPLE
        Get-TogglEntry -Name
        Get-TogglProjcet -Name "Antons Website" | Get-TogglEntry

    .EXAMPLE


    .NOTES
        Version:        1.0
        Author:         Clijsters
        Creation Date:  03.04.2017
        Purpose/Change: Initial script development
    #>
    [CmdletBinding()]
    [OutputType("PSToggl.Entry")]
    param(
        # Get currently running Entry
        [Parameter(Mandatory = $false)]
        [Switch] $Current
    )
    $suffix = if ($Current) {"/current"} else {""}
    $answer = Invoke-TogglMethod -UrlSuffix ("time_entries"+ $suffix)
    Write-Var answer
    return $answer | ConvertTo-TogglEntry
}