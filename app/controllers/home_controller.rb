require 'securerandom'
class HomeController < ApplicationController

      def index
      end

      def create
      	  begin
		pool = AriesPool.new("POOLX1")
		pool.create
		pool.open
		rescue RuntimeError => e
		       @did = "cannot create at this time (pool error)"
		       @verkey = ""
		       return
	  end

	  begin
		wallet = AriesWallet.new(SecureRandom.hex)
		wallet.create
		wallet.open
		steward_did = AriesDID.new()
		seed = AriesJson.to_string('{"seed":"000000000000000000000000Steward1"}')
		steward_did.create(wallet,seed)
		rescue RuntimeError => e
		       pool.close
		       pool.delete
		       @did = "cannot create at this time (steward wallet error)"
		       @verkey = ""
		       return
	  end

	  begin
		trustee_did = AriesDID.new()
		trustee_did.create(wallet,"{}")
		puts trustee_did.get_verkey
		rescue RuntimeError => e
		       wallet.close
		       wallet.delete
		       pool.close
		       pool.delete
		       @did = "cannot create at this time (trustee DID error)"
		       @verkey = ""
		       return
	  end

	  begin
		otherWallet = AriesWallet.new(SecureRandom.hex)
		otherWallet.create
		otherWallet.open
		rescue RuntimeError => e
		       wallet.close
		       wallet.delete
		       pool.close
		       pool.delete
		       @did = "cannot create at this time (other wallet error)"
		       @verkey = ""
		       return
	  end

	  begin
		nym = AriesDID.build_nym(steward_did,trustee_did)
		puts nym
		ssresult = steward_did.sign_and_submit_request(pool,wallet,nym)
		puts ssresult
		rescue RuntimeError => e
		       wallet.close
		       wallet.delete
		       otherWallet.close
		       otherWallet.delete
		       pool.close
		       pool.delete
		       @did = "cannot create at this time (NYM error)"
		       @verkey = ""
		       return
	  end

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
	  @verkey = "NOT FOUND"

	  begin
		pool = AriesPool.new("POOLX1")
	  	pool.create
	  	pool.open
		rescue RuntimeError => e
		       @did = e.to_s
		       return
	  end

	  begin
		wallet = AriesWallet.new(SecureRandom.hex)
		wallet.create
		wallet.open
		rescue RuntimeError => e
		       pool.close
		       pool.delete
		       @did = e.to_s
		       return
	  end

	  begin
		@verkey = pool.key_for_did(wallet,@did)
		rescue RuntimeError => e
	  end

	  wallet.close
	  wallet.delete
	  pool.close
	  pool.delete
      end

end
