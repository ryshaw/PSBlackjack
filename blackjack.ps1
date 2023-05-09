<#
.SYNOPSIS
    Removes a random card from the $deck variable and returns it.
.EXAMPLE
    Get-Card
    Returns the number 7, or string "K", or the number 2, etc.
#>
function Get-Card {
    [CmdletBinding()]
    $random = Get-Random -InputObject $deck
    $deck.Remove($random)
    return $random
}

<#
.SYNOPSIS
    Takes a list of cards and returns the total value of that hand.
.EXAMPLE
    Get-CardValue 7, "K", 2
    "K" equals 10 so returns 
#>
function Get-CardValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Cards
    )
    
    $sum = 0
    $numAces = 0
    foreach ($card in $Cards) {
        if ($card.GetType().Name -eq "Int32") {
            $sum += $card
        }
        else {
            if ($card -eq "A") {
                $numAces += 1
            }
            else {
                $sum += 10
            }
        }
    }

    $sum += $numAces
    if (($numAces -ge 1) -and ($sum -le 11)) {
        $sum += 10
    }

    return $sum
}

Write-Host "-----"
Write-Host "Welcome to Blackjack in PowerShell!"
Write-Host "-----"
Write-Host 'Your starting balance today is $100!'
Write-Host "-----"
$balance = 100

$numCards = 2..10
$faceCards = "J", "Q", "K", "A"
[System.Collections.ArrayList] $deck = $numCards * 4 + $faceCards * 4

Write-Host "State your bet! Minimum is `$2, maximum is `$$balance"
Write-Host "Type in your bet below or hit Enter for default bet of `$5"

do {
    $acceptableBet = $true

    try {
        $bet = Read-Host "Enter your bet"
        if ($bet -eq "") {
            $bet = 5
        }
        $bet = [int]$bet
    }
    catch {
        $acceptableBet = $false
    }

    if (($bet -lt 2) -or ($bet -gt 100)) {
        $acceptableBet = $false
    }

    if (!$acceptableBet) {
        Write-Host "Incorrect input, enter an integer between 2 and $balance"
    }
} until ($acceptableBet)


$dealerCards = (Get-Card), (Get-Card)

for ($i = 0; $i -lt 10; $i++) {
    $playerCards = (Get-Card), (Get-Card)
    Write-Host $playerCards
    Get-CardValue -Cards $playerCards
}
