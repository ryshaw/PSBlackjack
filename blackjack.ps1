Write-Host "-----"
Write-Host "Welcome to Blackjack in PowerShell!"
Write-Host "-----"
Write-Host 'Initializing starting balance of $100...'
Write-Host "-----"
$balance = 100

$numCards = 2..10
$faceCards = "J", "Q", "K", "A"
[System.Collections.ArrayList] $deck = $numCards * 4 + $faceCards * 4

Write-Host "State your bet! Minimum is `$2, maximum is `$$balance"
Write-Host "Type in your bet below or hit Enter for default bet of `$5"

do {
    try {
        $bet = Read-Host "Enter your bet"
        $bet.ToInt32()
        if ($bet -eq "") {
            $bet = 5
        }
        [int]$bet = Read-Host "Enter your bet"
    }
    catch {
        Write-Host "Unable to accept input, defaulting to bet of `$5"
    }
    Write-Host $bet
} until (($bet -ge 2) -and ($bet -le 100))

$dealerCards = (Get-Card), (Get-Card)
Write-Host $dealerCards

function Get-Card {
    $random = Get-Random -InputObject $deck
    $deck.Remove($random)
    return $random
}