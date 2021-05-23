class AdminController < ApplicationController
	def index
		@products = Product.all
		@users = User.all
		@bills = Bill.all
		@billdts = BillDetail.all
		@dt = 0
		@billdts.each do |billdt|
			@dt+= billdt.priceHD.to_i * billdt.quantityHD.to_i
		end
	end
	def login
		reset_session
		@categories = Category.where.not(id: 1)
	end
	def find
		admin = Administrator.find_by(usernameAD:admin_params[:usernameAD])
		if Administrator.find_by(usernameAD:admin_params[:usernameAD]) == nil
			session['status'] = "Không có tài khoản"
			redirect_to '/admin'
		else
			if admin[:passwordAD] == admin_params[:passwordAD]
				session[:admin_id] = admin.id
				session[:admin_name] = admin.usernameAD
				session[:admin_pass] = admin.passwordAD
				session[:admin_imgAD] = admin.imgAD
				redirect_to '/adminindex'
			else 
				session['status'] = "Mật khẩu không đúng!"
				redirect_to '/admin'
			end
		end
	end
	def product_list
		@products = Product.all
	end
	def product_add
		
	end
	def product_add_xl
		product = Product.new()
		product.nameSP = product_params[:nameSP]
		product.quantitySP = 0
		product.priceSP = 0
		product.discount = 0
		product.imgSP = product_params[:imgSP]
		product.category_id = 1
		if product.save
			session['status'] = "Thêm sản phẩm thành công!"
			redirect_to "/product_list"
		else
			session['status'] = "Thêm sản phẩm thất bại"
			redirect_to "/product_add"
		end
	end
	def product_update
		@product = Product.find(params[:id])
		@categories = Category.all
	end
	def product_update_xl
		product = Product.find(params[:id])
		product.nameSP = params[:nameSP]
		product.quantitySP = params[:quantitySP]
		product.priceSP = params[:priceSP]
		product.discount = params[:discount]
		product.imgSP = params[:imgSP]
		product.category_id = params[:category_id]
		if product.save
			session['status'] = "Đã cập nhật!"
			redirect_to "/product_list"
		else
			session['status'] = "Cập nhật thất bại"
			redirect_to "/product_list"
		end
	end
	def product_delete
		if Product.find(params[:id]).destroy
			session['status'] = "Đã xóa sản phẩm!"
			redirect_to "/adminindex"
		else
			session['status'] = "Xóa sản phẩm thất bại!"
			redirect_to "/product_list"
		end
	end
	def category_list
		@categories = Category.where.not(id: 1)
	end
	def category_add
		
	end
	def category_add_xl
		category = Category.new()
		category.nameDM = category_params[:nameDM]
		category.slug = category_params[:slug]
		if category.save
			session['status'] = "Đã thêm danh mục!"
			redirect_to "/adminindex"
		else
			session['status'] = "Thêm thất bại!"
			redirect_to "/category_add"
		end
	end
	def category_update
		category = Category.find(params[:id])
		category.nameDM = params[:nameDM]
		category.slug = params[:slug]
		if category.save
			session['status'] = "Cập nhật thành công!"
			redirect_to "/adminindex"
		else
			session['status'] = "Cập nhật thất bại!"
			redirect_to "/category_list"
		end
	end
	def category_delete
		if Category.find(params[:id]).destroy
			session['status'] = "Đã xóa!"
			redirect_to "/adminindex"
		else
			session['status'] = "Xóa thất bại!"
			redirect_to "/product_list"
		end
	end
	def user_list
		@users = User.all
	end
	def user_view
		@user = User.find(params[:id])
		@bills = @user.bills
	end
	def bill_list
		@bills = Bill.all
		@bills.each do |bill|
			bill.define_singleton_method(:usernameUS) do
				User.find(bill.user_id).usernameUS
			end
		end
	end
	def bill_view
		@bill = Bill.find(params['id'])
		@user = User.find(@bill.user_id)
		@admin = Administrator.find(@bill.administrator_id)
		@billdts = BillDetail.where(bill_id:params['id'])
		@billdts.each do |billdt|
			billdt.define_singleton_method(:nameSP) do
				Product.find(billdt.product_id).nameSP
			end
		end
	end
	def bill_check
		@bill = Bill.find(params['id'])
		@bill.administrator_id = session['admin_id']
		@bill.check = 1
		@bill.datecheck = DateTime.now
		if @bill.save
			session['status'] = "Đã duyệt!"
			redirect_to "/bill_list"
		else
			session['status'] = "Duyệt thất bại!"
			redirect_to "/bill_list"
		end
	end
	def bill_delete
		Bill.find(params['id']).destroy
		BillDetail.where(bill_id:params['id']).destroy_all
		session['status'] = "Đã xóa!"
		redirect_to "/bill_list"
	end
	def info_admin
		@admin = Administrator.find(session['admin_id'])
	end
	def adinfo_xl
		admin = Administrator.find(session['admin_id'])
		admin.imgAD = params[:imgAD]
		if admin.save
			session['status'] = "Đã cập nhật!"
			redirect_to '/'
		else
			session['status'] = "Cập nhật thất bại!"
			redirect_to '/info_admin'
		end
	end
	def adchange_pass
		if params[:newpass] == params[:newpass2]
			admin = Administrator.find(session['admin_id'])
			if admin.passwordAD == params[:oldpass]
				admin.passwordAD = params[:newpass]
				admin.save
				session['status'] = "Đã cập nhật mât khẩu!"
				redirect_to '/'
			else
				session['status'] = "Mật khẩu cũ không đúng!"
				redirect_to '/info_admin'
			end
		else
			session['status'] = "Mật khẩu nhập lại không đúng!"
			redirect_to '/info_admin'
		end
	end
	private
		def admin_params
			params.require(:admin).permit(:usernameAD, :passwordAD)		
		end
		def product_params
			params.require(:sp).permit(:nameSP,:imgSP)		
		end	
		def category_params
			params.require(:dm).permit(:nameDM,:slug)		
		end	
end
