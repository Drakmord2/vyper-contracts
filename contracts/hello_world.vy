# Locks an amount of Ether in the contract and
# get's it back on exercise.

value: uint256
owner: address

event Status:
    owner: indexed(address)
    value: uint256
    info: String[20] 

@external
@payable
def __init__():
    assert msg.value > 0

    self.value = msg.value
    self.owner = msg.sender

    log Status(self.owner, self.value, "Contract created.")

@external
def exercise():
    assert self.value > 0
    assert msg.sender == self.owner

    log Status(self.owner, self.value, "Contract exercised.")
    selfdestruct(self.owner)
