class_name RandLogic extends Node
## A static class script of all random events in the game.

## Private Function: Rolls based on the probabilities
## given in a dictionary. Uses a subtractive method
## on from getting the value.
##
## The format of the "probabilities" variable must follow
## this format:
## 		{[
##			"PROBABILITY_1": NUM_1,
##			"PROBABILITY_2": NUM_2,
##			...
##			"PROBABILITY_N": NUM_N,
##		]} 
##
## @returns: probabilities.key if a number is picked. "NOTHING" otherwise
## @throws: if the sum of the values of the probabilities is greater than
## 			the given total.
static func _roll(
		probabilities: Dictionary[StringName, int],
		total: int,
		) -> StringName:
	var test_sum = probabilities.values().reduce(func (a, b): return a + b, 0)
	if test_sum > total:
		push_error("Roll Error: ranges exceed total.")
		return "ERROR"
		
	var n: int = randi_range(1, total)
	for effect in probabilities:
		if n <= probabilities[effect]:
			return effect
		n -= probabilities[effect]
	return "NOTHING"

## Probabilities when the Player parries.
static func roll_effect() -> StringName:
	return _roll({
		"LOSE": 20,
		"NEGATIVE": 9_989,
		"POSITIVE": 9_989,
		"WIN": 2,
	}, 20_000)


## Probabilities when the Players spends 100 coins.
## Note that this function does not remove the coins.
static func roll_money() -> StringName:
	return _roll({
		"NEGATIVE": 1,
		"POSITIVE": 1,
	}, 2)


## Probabilities when the Player loses.
static func roll_loss() -> StringName:
	return _roll({
		"NEGATIVE": 80,
		"POSITIVE": 19,
		"WIN": 1
	}, 100)
