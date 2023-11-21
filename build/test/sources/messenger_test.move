#[test_only]
module test::messenger_test {
  use sui::test_scenario;
  use test::messenger::{Self, Messenger, Admin};

  #[test]
  fun test_create(){
    let owner = @0xA;
    let user1 = @0xB;
    let user2 = @0xC;

    let scenario_val = test_scenario::begin(owner);
    let scenario = &mut scenario_val;
    test_scenario::next_tx(scenario, owner);
    {
      messenger::init_for_testing(test_scenario::ctx(scenario));
    };

    test_scenario::next_tx(scenario, owner);
    {
      let admin = test_scenario::take_from_sender<Admin>(scenario);

      messenger::create_messenger(&admin, b"Simon", b"Sui rocks", user2, user1, test_scenario::ctx(scenario));
      assert!(!test_scenario::has_most_recent_for_sender<Messenger>(scenario), 0);

      test_scenario::return_to_sender(scenario,admin);
    };

    test_scenario::next_tx(scenario,user2);
    {
      assert!(test_scenario::has_most_recent_for_sender<Messenger>(scenario), 0);
    };

    test_scenario::end(scenario_val);

  }
}