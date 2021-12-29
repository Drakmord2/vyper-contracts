# Locks an amount of Ether in the contract and
# get's it back on exercise.

value: public(uint256)
owner: public(address)

@external
@payable
def __init__():
    assert msg.value > 0

    self.value = msg.value
    self.owner = msg.sender

@external
def exercise():
    assert self.value > 0
    assert msg.sender == self.owner

    selfdestruct(self.owner)
