class HomeController < ApplicationController

      def index
      end

      def create
      	  pool = AriesPool.new("POOLX1")
	  pool.create
	  pool.open

	  wallet = AriesWallet.new("WALLET_STEWARD")
	  wallet.create
	  wallet.open
	  steward_did = AriesDID.new()
	  seed = AriesJson.to_string('{"seed":"000000000000000000000000Steward1"}')
	  steward_did.create(wallet,seed)

	  trustee_did = AriesDID.new()
	  trustee_did.create(wallet,"{}")
	  puts trustee_did.get_verkey

	  otherWallet = AriesWallet.new("WALLETX1")
	  otherWallet.create
	  otherWallet.open

	  nym = AriesDID.build_nym(steward_did,trustee_did)
	  puts nym
	  ssresult = steward_did.sign_and_submit_request(pool,wallet,nym)
	  puts ssresult

	  @did = trustee_did.get_did
	  @verkey = trustee_did.get_verkey

	  wallet.close
	  wallet.delete
	  otherWallet.close
	  otherWallet.delete
	  pool.close
	  pool.delete
      end

      def lookup
      	  @did = params[:lookup][:did]

      	  pool = AriesPool.new("POOLX1")
	  pool.create
	  pool.open

	  wallet = AriesWallet.new("WALLETX2")
	  wallet.create
	  wallet.open

	  @verkey = pool.key_for_did(wallet,@did)

	  wallet.close
	  wallet.delete
	  pool.close
	  pool.delete
      end

end
