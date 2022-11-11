'reach 0.1';
'use strict';

export const main = Reach.App(() => {
  // Seller - saleable account from museum
  const A = Participant('Creator', {
    deployed: Fun([], Null),
    getSwap: Fun([], Tuple(Token, UInt, UInt, Token))
  });

  // Buyer - individual user
  const B = Participant('Buyer', {
    done: Fun([Bool], Null)
  });

  init(); //initialize smart contract

  A.publish();
  commit();
  A.interact.deployed();

  A.only(() => {
    const [nftTok, count, price, USDC] = declassify(interact.getSwap());
    assume(nftTok != USDC);
  })
  A.publish(nftTok, count, price, USDC); // get NFT micro, number of NFT micro, price of NFT micro and USDC asset

  commit();
  A.pay([ [count, nftTok] ]); // add number of NFT micro and NFT micro to smart contract by seller

  commit();
  B.pay([ [(count * price), USDC] ]); // add USDC amount to smart contract by buyer

  // Swap USDC and NFT micro
  transfer((count * price), USDC).to(A);
  transfer(count, nftTok).to(B);

  commit();
  B.interact.done(true); // Notify all operations finished

  A.publish();

  commit();
  exit(); // delete smart contract
});
