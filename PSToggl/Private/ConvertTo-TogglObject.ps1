function ConvertTo-TogglObject {
    [CmdletBinding()]
    param(
        # A PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [System.Management.Automation.PSCustomObject]
        $input,

        # The Object's name
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            "Project",
            "Group",
            "Workspace",
            "ProjectUser",
            "Client"
        )]
        [String]
        $ObjectName,

        # The field configuration
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty]
        [hashtable[]]
        $fields
    )

    $object = @{}
    if ($item.GetType().Name -eq "HashTable") {
        $input = New-Object -TypeName psobject -Property $item
    } else {
        $input = $item
    }

    foreach ($field in $fields) {
        $inputField = $input.PSObject.Members[$field.name].Value
        if ($null -ne $inputField) {
            $object[$field.name] = $inputField
        } else {
            if ($null -ne $field.default) {
                $object[$field.name] = $field.default
            } elseif ($field.required) {
                throw "Property `"$($field.name)`" is required"
            }
        }
    }

    $result = New-Object -TypeName psobject -Property $object
    $result.PSObject.TypeNames.Insert(0, "PSToggl.$ObjectName")
    Write-Output $result
}
