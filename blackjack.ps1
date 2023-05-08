Write-Host "Welcome to Blackjack in PowerShell!"

$numCards = 2..10
$faceCards = "J", "Q", "K", "A"
[System.Collections.ArrayList] $deck = $numCards * 4 + $faceCards * 4

Write-Host 'State your bet! Minimum is $2 and maximum is $100'
Read-Host "Enter your bet"

$dealerCards = (Deal-Card), (Deal-Card)
Write-Host $dealerCards

function Get-Card {
    $random = Get-Random -InputObject $deck
    $deck.Remove($random)
    return $random
}