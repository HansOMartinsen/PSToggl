# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

#InModuleScope PSToggl {
Describe "ConvertTo-TogglGroup" {
    $sampleInput = @{
        name = "Test Group";
        wid = 123;
        at = [datetime]::Now;
    }
    $out = $sampleInput | ConvertTo-TogglGroup
    It "Converts a HashTable to a PSCustomObject" {
        $out.GetType().Name | Should Be "PSCustomObject"
    }

    It "Sets TypeName to PSToggl.Group" {
        $out.PSObject.TypeNames[0] | Should Be "PSToggl.Group"
    }

    foreach ($k in $sampleInput.Keys) {
        # TODO: Will convert property names in future
        It "Sets $($k.PadRight(8)) to $($sampleInput.Item($k))" {
            $out.PSObject.Members[$k].Value | Should Be $sampleInput.Item($k)
        }
    }

}
#}
