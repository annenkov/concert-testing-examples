Set Warnings "-extraction-inside-module".

From QuickChick Require Import QuickChick. Import QcNotation.
Require Import BinNat.
From ConCert Require Import Blockchain.
From ConCert.Execution.QCTests Require Import TraceGens TestUtils.
Require DexterSpec EIP20TokenSpec EscrowSpec iTokenBuggySpec.



(* DexterTests *)
Module Dexter.
Import DexterSpec.

QuickChick tokens_to_asset_correct.
(* *** Failed after 1 tests and 1 shrinks. (0 discards) *)
End Dexter.


Module EIP20Token.
Import EIP20TokenSpec.
Import TestInfo.

QuickChick (
  {{msg_is_transfer}}
  contract_addr
  {{post_transfer_correct}}
).
(* +++ Passed 10000 tests (0 discards) *)

QuickChick (forAllTokenChainTraces 5 (checker_get_state sum_balances_eq_init_supply)).
(* +++ Passed 10000 tests (0 discards) *)

QuickChick (sum_allowances_le_init_supply_P 5).
(* Fails as expected: *)
(* *** Failed after 21 tests and 8 shrinks. (0 discards) *)
(* 
Block 1 [
Action{act_from: 10%256, act_body: (act_deploy 0, transfer 10%256 100)}];
Block 3 [
Action{act_from: 14%256, act_body: (act_call 128%256, 0, approve 10%256 25)}];
Block 5 [
Action{act_from: 14%256, act_body: (act_call 128%256, 0, approve 13%256 86)}];|}
 *)
QuickChick (token_cb ~~> (person_has_tokens person_3 12)).
(* Success - found witness satisfying the predicate!
+++ Failed (as expected) after 1 tests and 0 shrinks. (0 discards) *)

(* Test doesn't work *)(*
QuickChick (chain_with_token_deployed ~~> (fun lc => isSome (person_has_tokens person_3 12 lc))).*)

(* Test doesn't work *)(*
QuickChick (chain_with_token_deployed ~~> person_has_tokens creator 0).*)

(* Test doesn't work *)(*
QuickChick (token_reachableFrom_implies_reachable
  chain_with_token_deployed
  (person_has_tokens creator 10)
  (person_has_tokens creator 0)
).*)

(* Test doesn't work *)(*
QuickChick (
  {
    chain_with_token_deployed
    ~~> (person_has_tokens creator 5 o next_lc_of_lcstep)
    ===> (fun _ _ post_trace => isSome (person_has_tokens creator 10 (last_state post_trace)))
  }
).*)

QuickChick reapprove_transfer_from_safe_P.
(* Fails as expected: *)
(* 
  Chain{| 
    Block 1 [
    Action{act_from: 10%256, act_body: (act_deploy 0, transfer 10%256 100)}];
    Block 3 [
    Action{act_from: 10%256, act_body: (act_call 128%256, 0, approve 14%256 36)}];
    Block 4 [
    Action{act_from: 14%256, act_body: (act_call 128%256, 0, transfer_from 10%256 10%256 27)};
    Action{act_from: 10%256, act_body: (act_call 128%256, 0, approve 14%256 24)}];
  |}

  14%256 spent 27 on behalf of 10%256 when they were only allowed to spend at most 24

  *** Failed after 1 tests and 5 shrinks. (510 discards)
*)

End EIP20Token.



Module Escrow.
Import EscrowSpec.
Import MG.

QuickChick (forAllEscrowChainBuilder gEscrowTrace 7 escrow_chain escrow_correct_P).
(* *** Gave up! Passed only 8529 tests
Discarded: 20000 *)

QuickChick (forAllEscrowChainBuilder gEscrowTraceBetter 7 escrow_chain escrow_correct_P).
(* +++ Passed 10000 tests (0 discards) *)

QuickChick escrow_valid_steps_P.
(* +++ Passed 10000 tests (0 discards) *)
End Escrow.

Module iTokenBuggy.
Import iTokenBuggySpec.

QuickChick token_supply_preserved.
(* Fails as expected: *)
(* *** Failed after 5 tests and 1000 shrinks. (0 discards) *)

(* different way of stating the same property *)
QuickChick (forAllTokenChainTraces 4 (checker_get_state sum_balances_eq_init_supply_checker)).
(* *** Failed after 1 tests and 7 shrinks. (0 discards) *)

(* different way of stating the same property *)
QuickChick (
  {{msg_is_not_mint_or_burn}}
  token_caddr
  {{sum_balances_unchanged}}
).
(* *** Failed after 3 tests and 8 shrinks. (0 discards) *)
(* 
Chain{| 
  Block 1 [
  Action{act_from: 10%256, act_body: (act_deploy 0, <FAILED DESERIALIZATION>)}];
  Block 2 [
  Action{act_from: 11%256, act_body: (act_call 128%256, 0, mint 2)}];
  Block 3 [
  Action{act_from: 11%256, act_body: (act_call 128%256, 0, approve 10%256 1)}];
  Block 4 [
  Action{act_from: 10%256, act_body: (act_call 128%256, 0, transfer_from 11%256 11%256 1)}];|}

  ChainState{env: Environment{chain: Chain{height: 4, current slot: 4, final height: 0}, contract states:...}, queue: Action{act_from: 10%256, act_body: (act_call 128%256, 0, transfer_from 11%256 11%256 1)}}
  On Msg: transfer_from 11%256 11%256 1
  *** Failed after 3 tests and 8 shrinks. (0 discards)
*)
End iTokenBuggy.
