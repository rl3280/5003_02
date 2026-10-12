param(
    [string]$OutputDirectory = (Join-Path $PSScriptRoot 'outputs'),
    [switch]$RequireCombined
)

$ErrorActionPreference = 'Stop'
$events = @('event-01', 'event-02', 'event-03', 'event-04', 'event-05')
$errors = New-Object 'System.Collections.Generic.List[string]'
$allOutputIds = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
$expectedCombinedIds = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
$checkedEvents = 0

function Get-JsonDocument {
    param([string]$Path)
    try {
        return (Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop)
    }
    catch {
        throw "Could not parse JSON in '$Path': $($_.Exception.Message)"
    }
}

function Get-FrameSeconds {
    param([string]$NodeId)
    if ($NodeId -match 'activity:(\d{4})$') {
        $timestamp = $Matches[1]
        return ([int]$timestamp.Substring(0, 2) * 60) + [int]$timestamp.Substring(2, 2)
    }
    return -1
}

foreach ($eventId in $events) {
    $inputPath = Join-Path $PSScriptRoot ('inputs\' + $eventId + '_concrete.json')
    $outputPath = Join-Path $OutputDirectory ($eventId + '.jsonld')

    if (-not (Test-Path -LiteralPath $inputPath)) {
        $errors.Add("Missing concrete input bundle: $inputPath")
        continue
    }
    if (-not (Test-Path -LiteralPath $outputPath)) {
        $errors.Add("Missing synthesized event output: $outputPath")
        continue
    }

    try {
        $sourceGraphs = @(Get-JsonDocument -Path $inputPath)
        $document = Get-JsonDocument -Path $outputPath
    }
    catch {
        $errors.Add($_.Exception.Message)
        continue
    }

    $graph = @($document.'@graph')
    if ($null -eq $document.'@context' -or
        $document.'@context'.crm -ne 'http://www.cidoc-crm.org/cidoc-crm/' -or
        $document.'@context'.cro -ne 'https://dlnarratives.eu/ontology#') {
        $errors.Add("$eventId has a missing or unexpected crm/cro context")
    }
    if ($graph.Count -eq 0) {
        $errors.Add("$eventId has an empty @graph")
        continue
    }

    $nodeById = @{}
    foreach ($node in $graph) {
        $nodeId = [string]$node.'@id'
        if ([string]::IsNullOrWhiteSpace($nodeId)) {
            $errors.Add("$eventId contains a node without @id")
            continue
        }
        if ($nodeById.ContainsKey($nodeId)) {
            $errors.Add("$eventId contains duplicate @id '$nodeId'")
        }
        else {
            $nodeById[$nodeId] = $node
        }
        [void]$allOutputIds.Add($nodeId)
        [void]$expectedCombinedIds.Add($nodeId)
    }

    $rootId = 'urn:5003:hammering:schema:' + $eventId
    $roots = @($graph | Where-Object {
        $_.'@id' -eq $rootId -and $_.'@type' -eq 'crm:E29_Design_or_Procedure'
    })
    if ($roots.Count -ne 1) {
        $errors.Add("$eventId must have exactly one crm:E29_Design_or_Procedure root at '$rootId'")
        continue
    }

    $schemaStepIds = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
    foreach ($reference in @($roots[0].'cro:hasSubStep')) {
        $stepId = [string]$reference.'@id'
        if ([string]::IsNullOrWhiteSpace($stepId) -or -not $nodeById.ContainsKey($stepId)) {
            $errors.Add("$eventId root has a cro:hasSubStep reference that does not resolve")
            continue
        }
        if ($nodeById[$stepId].'@type' -ne 'crm:E29_Design_or_Procedure') {
            $errors.Add("$eventId cro:hasSubStep '$stepId' is not crm:E29_Design_or_Procedure")
            continue
        }
        if (-not $stepId.StartsWith("urn:5003:hammering:schema:${eventId}:step:", [StringComparison]::Ordinal)) {
            $errors.Add("$eventId contains a schema step from another event: '$stepId'")
        }
        [void]$schemaStepIds.Add($stepId)
    }
    if ($schemaStepIds.Count -eq 0) {
        $errors.Add("$eventId has no E29 schema steps under its root")
    }
    foreach ($schemaNode in @($graph | Where-Object { $_.'@type' -eq 'crm:E29_Design_or_Procedure' })) {
        $schemaNodeId = [string]$schemaNode.'@id'
        if ($schemaNodeId -ne $rootId -and -not $schemaStepIds.Contains($schemaNodeId)) {
            $errors.Add("$eventId has an E29 schema node not listed under its root: '$schemaNodeId'")
        }
    }

    $controlFlowProperties = @(
        'cro:hasSubStep',
        'cro:correspondsTo',
        'cro:transistsFrom',
        'cro:transistsTo',
        'cro:branchesFrom',
        'cro:hasAlternative',
        'cro:hasAlternativeDestination',
        'cro:forksFrom',
        'cro:forksTo',
        'cro:joinsFrom',
        'cro:joinsTo',
        'cro:mergesFrom',
        'cro:mergesTo'
    )
    $eventSchemaPrefix = "urn:5003:hammering:schema:${eventId}"
    foreach ($node in $graph) {
        foreach ($propertyName in $controlFlowProperties) {
            $property = $node.PSObject.Properties[$propertyName]
            if ($null -eq $property) {
                continue
            }
            foreach ($reference in @($property.Value)) {
                $referenceId = [string]$reference.'@id'
                if ($referenceId.StartsWith('urn:5003:hammering:schema:event-', [StringComparison]::Ordinal) -and
                    -not $referenceId.StartsWith($eventSchemaPrefix, [StringComparison]::Ordinal)) {
                    $errors.Add("$eventId has a cross-event $propertyName reference to '$referenceId'")
                }
            }
        }
    }

    $sourceActivityIds = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
    foreach ($sourceGraph in $sourceGraphs) {
        foreach ($activity in @($sourceGraph.'@graph' | Where-Object { $_.'@type' -eq 'crm:E7_Activity' })) {
            [void]$sourceActivityIds.Add([string]$activity.'@id')
        }
    }

    $mappedActivityIds = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
    foreach ($activity in @($graph | Where-Object { $_.'@type' -eq 'crm:E7_Activity' })) {
        $activityId = [string]$activity.'@id'
        if (-not $sourceActivityIds.Contains($activityId)) {
            $errors.Add("$eventId contains an E7 activity not found in its concrete input: '$activityId'")
        }
        [void]$mappedActivityIds.Add($activityId)
        $links = @($activity.'cro:correspondsTo')
        if ($links.Count -ne 1) {
            $errors.Add("$eventId activity '$activityId' must have exactly one cro:correspondsTo")
            continue
        }
        $stepId = [string]$links[0].'@id'
        if (-not $schemaStepIds.Contains($stepId)) {
            $errors.Add("$eventId activity '$activityId' corresponds to a missing or non-child schema step")
        }
    }
    foreach ($sourceActivityId in $sourceActivityIds) {
        if (-not $mappedActivityIds.Contains($sourceActivityId)) {
            $errors.Add("$eventId is missing correspondence for concrete activity '$sourceActivityId'")
        }
    }

    foreach ($transition in @($graph | Where-Object { $_.'@type' -eq 'cro:Transition' })) {
        $from = @($transition.'cro:transistsFrom')
        $to = @($transition.'cro:transistsTo')
        if ($from.Count -ne 1 -or $to.Count -ne 1) {
            $errors.Add("$eventId transition '$($transition.'@id')' must have one transistsFrom and one transistsTo")
            continue
        }
        $fromId = [string]$from[0].'@id'
        $toId = [string]$to[0].'@id'
        if (-not $schemaStepIds.Contains($fromId) -or -not $schemaStepIds.Contains($toId)) {
            $errors.Add("$eventId transition '$($transition.'@id')' points outside this event's schema steps")
        }
        if ($eventId -eq 'event-04') {
            $fromFrames = @($graph | Where-Object {
                $_.'@type' -eq 'crm:E7_Activity' -and $_.'cro:correspondsTo'.'@id' -eq $fromId
            } | ForEach-Object { Get-FrameSeconds -NodeId ([string]$_.'@id') })
            $toFrames = @($graph | Where-Object {
                $_.'@type' -eq 'crm:E7_Activity' -and $_.'cro:correspondsTo'.'@id' -eq $toId
            } | ForEach-Object { Get-FrameSeconds -NodeId ([string]$_.'@id') })
            if (($fromFrames | Where-Object { $_ -lt 360 } | Measure-Object -Maximum).Maximum -ge 0 -and
                ($toFrames | Where-Object { $_ -ge 420 } | Measure-Object -Minimum).Minimum -ge 420) {
                $errors.Add("Event 4 transition '$($transition.'@id')' bridges the 06:00-06:59 privacy gap")
            }
            if (($fromFrames | Where-Object { $_ -ge 420 } | Measure-Object -Minimum).Minimum -ge 420 -and
                ($toFrames | Where-Object { $_ -lt 360 } | Measure-Object -Maximum).Maximum -ge 0) {
                $errors.Add("Event 4 transition '$($transition.'@id')' bridges the 06:00-06:59 privacy gap")
            }
        }
    }

    $checkedEvents++
    Write-Output ("PASS {0}: {1} source activities, {2} schema steps" -f $eventId, $sourceActivityIds.Count, $schemaStepIds.Count)
}

$combinedPath = Join-Path $OutputDirectory 'hammering-workflow.jsonld'
if (Test-Path -LiteralPath $combinedPath) {
    try {
        $combined = Get-JsonDocument -Path $combinedPath
        $combinedGraph = @($combined.'@graph')
        $combinedIds = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
        foreach ($node in $combinedGraph) {
            $nodeId = [string]$node.'@id'
            if (-not $combinedIds.Add($nodeId)) {
                $errors.Add("Combined output contains duplicate @id '$nodeId'")
            }
        }
        foreach ($nodeId in $expectedCombinedIds) {
            if (-not $combinedIds.Contains($nodeId)) {
                $errors.Add("Combined output is missing node '$nodeId'")
            }
        }
        foreach ($nodeId in $combinedIds) {
            if (-not $expectedCombinedIds.Contains($nodeId)) {
                $errors.Add("Combined output contains unexpected node '$nodeId'")
            }
        }
        $combinedRoots = @($combinedGraph | Where-Object {
            $_.'@type' -eq 'crm:E29_Design_or_Procedure' -and
            $_.'@id' -match '^urn:5003:hammering:schema:event-0[1-5]$'
        })
        if ($combinedRoots.Count -ne 5) {
            $errors.Add("Combined output must contain exactly five event schema roots")
        }
        else {
            Write-Output 'PASS combined output: all five disconnected event graphs are present'
        }
    }
    catch {
        $errors.Add($_.Exception.Message)
    }
}
elseif ($RequireCombined) {
    $errors.Add("Missing combined output: $combinedPath")
}
else {
    Write-Output 'Combined output not found; per-event files were checked only.'
}

if ($errors.Count -gt 0) {
    Write-Error ("Validation failed with {0} issue(s):`n - {1}" -f $errors.Count, ($errors -join "`n - "))
    exit 1
}

if ($checkedEvents -ne 5) {
    Write-Error "Only $checkedEvents of 5 event outputs were checked."
    exit 1
}

Write-Output 'All state-machine checks passed.'
