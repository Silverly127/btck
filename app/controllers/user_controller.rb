class UserController < ApplicationController
	def register
		@categories = Category.where.not(id: 1)
	end
	def create
		user = User.new(user_params)
		user.imgUS = "https://media.msufcu.org/publicsites/financial40/app
				lication_images/icons/msufcu/useravatar.png"
		if user.save
			session[:user_id] = user.id
			session[:user_name] = user.usernameUS
			session[:user_pass] = user.passwordUS
			session[:user_email] = user.email
			session[:user_imgUS] = user.imgUS
			session['status'] = "Đăng ký thành công!"
			redirect_to '/'
		else 
			session['status'] = "Đăng ký thất bại!"
			redirect_to '/registration'
		end
	end
	def find
		user = User.find_by(usernameUS:login_params[:usernameUS])
		if  User.find_by(usernameUS:login_params[:usernameUS]) == nil
			session['status'] = "Không có tài khoản!"
			redirect_to '/'
		else
			if user.passwordUS == login_params[:passwordUS]
				session[:user_id] = user.id
				session[:user_name] = user.usernameUS
				session[:user_pass] = user.passwordUS
				session[:user_email] = user.email
				session[:user_imgUS] = user.imgUS
				redirect_to '/'
			else 
				session['status'] = "Mật khẩu không đúng!"
				redirect_to '/'
			end
		end
	end
	def bill_history
		@categories = Category.where.not(id: 1)
		@user = User.find(session[:user_id])
		@bills = @user.bills
	end
	def bill_history_view
		@categories = Category.where.not(id: 1)
		@bill = Bill.find(params[:id])
		@billdts = BillDetail.where(bill_id: @bill.id)
		@billdts.each do |billdt|
			billdt.define_singleton_method(:nameSP) do
				Product.find(billdt.product_id).nameSP
			end
			billdt.define_singleton_method(:imgSP) do
				Product.find(billdt.product_id).imgSP
			end
		end
	end
	def info_user
		@categories = Category.where.not(id: 1)
		@user = User.find(session['user_id'])
	end
	def info_xl
		user = User.find(session['user_id'])
		user.email = params[:email]
		user.imgUS = params[:imgUS]
		if user.save
			session['status'] = "Đã cập nhật!"
			redirect_to '/'
		else
			session['status'] = "Cập nhật thất bại!"
			redirect_to '/info_user'
		end
	end
	def change_pass
		if params[:newpass] == params[:newpass2]
			user = User.find(session['user_id'])
			if user.passwordUS == params[:oldpass]
				user.passwordUS = params[:newpass]
				user.save
				session['status'] = "Đã cập nhật mât khẩu!"
				redirect_to '/'
			else
				session['status'] = "Mật khẩu cũ không đúng!"
				redirect_to '/info_user'
			end
		else
			session['status'] = "Mật khẩu nhập lại không đúng!"
			redirect_to '/info_user'
		end
	end
	def exit
		reset_session
		Cart.destroy_all
		redirect_to '/'
	end
	private
		def user_params
			params.require(:user).permit(:usernameUS, :passwordUS, :email)		
		end	
		def login_params
			params.require(:login).permit(:usernameUS,:passwordUS)
		end
end
