class CartController < ApplicationController
	def index
		@categories = Category.where.not(id: 1)
		Cart.where(slSP: nil).destroy_all
		@carts = Cart.all
	end
	def cart_add
		if(Cart.find_by(idSP:params[:idSP]))
			item = Cart.find_by(idSP:params[:idSP])
			item.slSP = item.slSP.to_i + params[:slSP].to_i
			item.save
			redirect_to "/cart"
		else 
			item = Cart.new
			item.idSP = params[:idSP]
			item.tenSP = params[:tenSP]
			item.slSP = params[:slSP]
			item.tonkho = params[:tonkho]
			item.giaSP = params[:giaSP]
			item.giamSP = params[:giamSP]
			item.save
			redirect_to "/cart"
		end
	end
	def cart_update
		item = Cart.find(params[:id])
		item.slSP = params[:slSP]
		item.save
	end
	def cart_delete
		Cart.find(params[:id]).destroy
		redirect_to "/cart"
	end
	def bill
		if(!session['user_id'])
			session['status'] = "Vui lòng đăng nhập!"
			redirect_to "/"
		else
			bill = Bill.new
			bill.check = 0
			bill.datecheck = nil
			bill.address = params[:address]
			bill.administrator_id = 1
			bill.user_id = session['user_id']
			bill.save
			items = Cart.all
			items.each do |item|
				sp = Product.find(item.idSP)
				sp.quantitySP = sp.quantitySP.to_i - item.slSP.to_i
				sp.save
				billdt = BillDetail.new
				billdt.quantityHD = item.slSP
				billdt.priceHD = item.giaSP.to_i - item.giaSP.to_i*item.giamSP.to_i/100
				billdt.product_id = item.idSP
				billdt.bill_id = bill.id
				billdt.save
			end
			session['status'] = "Đã gửi đơn hàng!"
			redirect_to "/"
		end
	end
end
