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
    Number cards are worth their number, face cards are worth 10. This would return 7 + 10 + 2, or 19.

    Get-CardValue 5, "A"
    Aces are worth 11, unless the total would go over 21, in which case they are worth 1. 5 + 11 equals 16 which is not over 21, so this would return 16.

    Get-CardValue 8, "A", "A"
    One ace would be worth 11 and the other would be worth 1 as to not put the total over 21. This would return 8 + 11 + 1, or 20.

    Get-CardValue "J", 6, "A", "A", "A"
    Jack is worth 10, and each of the Aces are worth 1 because the total would go over 21 if any of them were 11. This would return 10 + 6 + 1 + 1 + 1, or 19.
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
        # if card is a number, just add that number
        if ($card.GetType().Name -eq "Int32") {
            $sum += $card
        }
        # otherwise, either an Ace or a face card
        else {
            if ($card -eq "A") {
                $numAces += 1
            }
            else {
                $sum += 10
            }
        }
    }

    # each Ace is worth at least 1, so add 1 to the sum for each Ace
    $sum += $numAces

    # now, if the sum won't go over 21, 
    # we can change an Ace from 1 to 11 by adding 10. 
    # note that we will never have two Aces being worth 11, 
    # because that would go over 21.
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
Write-Host "Type in a dollar amount below or hit Enter for default bet of `$5"

# read input from user to determine bet
do {
    $acceptableBet = $true

    try {
        $bet = Read-Host "Enter your bet"
        # user entered nothing, so default to 5
        if ($bet -eq "") {
            $bet = 5
        }
        # try to change input string into an int.
        # if player entered a string, this will error
        # and will be caught below.
        $bet = [int]$bet
    }
    catch {
        # player entered something other than a number
        $acceptableBet = $false
    }

    # player did not enter a bet in correct range
    if (($bet -lt 2) -or ($bet -gt $balance)) {
        $acceptableBet = $false
    }

    # make player try again
    if (!$acceptableBet) {
        Write-Host "Incorrect input, enter an integer between 2 and $balance"
    }
} until ($acceptableBet)

Write-Host "Starting round with a bet of `$$bet..."
Write-Host "---"

$playerCards = (Get-Card)
$dealerCards = (Get-Card)
Write-Host "Your first card is $playerCards, and the dealer's first card is $dealerCards"

$playerCards = $playerCards, (Get-Card)
$dealerCards = $dealerCards, (Get-Card)
Write-Host "Your second card is $($playerCards[1]), and the dealer's second card is face down"

Write-Host "---"
$playerValue = (Get-CardValue $playerCards)
Write-Host "Your hand is $($playerCards -join " and "); total value is $playerValue"


if ($playerValue -eq 21) {
    Write-Host "Blackjack!!"
    Write-Host "Let's check the dealer's hand..."
    $dealerValue = (Get-CardValue $dealerCards)
    Write-Host "The dealer has $($dealerCards -join " and "); total value is $dealerValue"
    if ($dealerValue -eq 21) {
        Write-Host "It's a stand-off!! Your bet is returned to you, and nobody wins"
        Write-Host "---"
        Write-Host "Balance is `$$balance"
    }
    else {
        Write-Host "You win!! You get 1.5 times your wager!"
        $balance += $bet * 1.5
        Write-Host "---"
        Write-Host "Balance is `$$balance"
    }
}
else {
    Write-Host "Your hand's value is $playerValue. Hit or stand?"
    Write-Host "Type 1, 'h', or 'hit' to hit, or type 2, 's', or 'stand' to stand"
    $acceptableChoice = $true

    do {
        try {
            $choice = Read-Host "Hit or stand"
            if 
        }
        catch {
            $acceptableChoice = $false
        }
    } until ($acceptableChoice)


}