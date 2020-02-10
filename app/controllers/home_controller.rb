class HomeController < ApplicationController

      def index
      	  wallet = AriesWallet.new("mywallet")
	  puts wallet
	  puts wallet.create
	  puts wallet.open
	  puts wallet.close
	  puts wallet.delete
	  pool = AriesPool.new("mypool")
	  puts pool
	  puts pool.create
	  puts pool.open
	  puts pool.close
	  puts pool.delete
      end

end
