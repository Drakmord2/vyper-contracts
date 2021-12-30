# @version 0.2.15

struct Guess:
    player: address
    value: uint256

owner: address
running: public(bool)
value: uint256
guesses: Guess[10]
guess_count: uint256

event Result:
    winners: address[10]
    share: uint256

@external
def __init__():
    self.owner = msg.sender
    self.running = True

@external
@payable
def bet(bet_value: uint256):
    assert self.running == True, "Betting is closed."
    assert self.guess_count < 10, "Maximum amount of players reached." 
    assert msg.value == 1000000000000000000, "The bet should be 1 ETH."

    self.guesses[self.guess_count] = Guess({player: msg.sender, value: bet_value})
    self.guess_count += 1


@external
def finish(actual_value: uint256):
    assert msg.sender == self.owner, "Only the admin can finish the betting round."
    assert self.running == True, "The challenge is over."
    assert self.guess_count > 0, "There are no bets yet."

    self.running = False
    self.value = actual_value

    winners: address[10] = empty(address[10])
    winner_count: uint256 = 0
    share: uint256 = self.balance

    for i in range(10):
        if self.guesses[i].player == ZERO_ADDRESS:
            continue

        if self.guesses[i].value == self.value:
            winners[winner_count] = self.guesses[i].player
            winner_count += 1

    if winner_count > 0:
        share /= winner_count

    for winner in winners:
        if winner == ZERO_ADDRESS:
            continue

        send(winner, share)

    log Result(winners, share)

    selfdestruct(self.owner)
