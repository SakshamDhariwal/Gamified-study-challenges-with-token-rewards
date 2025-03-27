module MyModule::StudyChallenges {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a study challenge.
    struct Challenge has store, key {
        creator: address,
        reward: u64,
    }

    /// Function to submit a study challenge with a token reward.
    public fun submit_challenge(creator: &signer, reward: u64) {
        let creator_addr = signer::address_of(creator);
        let challenge = Challenge { creator: creator_addr, reward };
        move_to(creator, challenge);
    }

    /// Function to reward the winner of the challenge.
    public fun reward_winner(creator: &signer, winner: address) acquires Challenge {
        let challenge = borrow_global<Challenge>(signer::address_of(creator));
        let prize = coin::withdraw<AptosCoin>(creator, challenge.reward);
        coin::deposit<AptosCoin>(winner, prize);
    }
}

