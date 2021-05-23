class ProductController < ApplicationController
  def index
    if(session[:admin_id])
      redirect_to "/adminindex"
    else
  	  @products = Product.order(created_at: :desc).limit(8)
  	  @categories = Category.where.not(id: 1)
    end
  end
  def detail
  	@product = Product.find(params[:id])
  	@productDM = @product.category
  	@categories = Category.where.not(id: 1)
    @comments = @product.comments
    @users = @product.users
  end
  def comment_add
    comment = Comment.new
    comment.description = params[:description]
    comment.user_id = params[:user_id]
    comment.product_id = params[:product_id]
    comment.save
  end
  def sort
  	@categories = Category.where.not(id: 1)
  	@category = Category.find_by(slug:params[:slug])
  	@products = Product.all
  	@categoryproducts = @category.products
  end
  def arrange
    @categories = Category.where.not(id: 1)
    case params[:slug]
    when "highlow"
      @products = Product.order(priceSP: :desc)
      @title = "SẮP XẾP SẢN PHẨM TỪ GIÁ CAO ĐẾN THẤP"
    when "lowhigh"
      @products = Product.order(priceSP: :asc)
      @title = "SẮP XẾP SẢN PHẨM TỪ GIÁ THẤP ĐẾN CAO"
    when "az"
      @products = Product.order(nameSP: :asc)
      @title = "SẮP XẾP SẢN PHẨM THEO TÊN(A->Z)"
    when "za"
      @products = Product.order(nameSP: :desc)
      @title = "SẮP XẾP SẢN PHẨM THEO TÊN(Z->A)"
    else
      session['status'] = "Lỗi khi lọc sản phẩm!"
      redirect_to "/"
    end
  end
  def search
  	@categories = Category.where.not(id: 1)
    @vls = params[:vls]
    @searchproducts = Product.where("nameSP LIKE?","%"+params[:vls]+"%")
  end
  
end
